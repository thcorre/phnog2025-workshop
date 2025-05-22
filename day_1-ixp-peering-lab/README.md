# Nokia SR OS as PE in an IXP infrastructure - Configuration

This page provides the basic step-by-step configuration required to set up a Nokia 7750 Service Router as a PE in a modern IXP environment. All the required feature sets for a peering router are covered here with configuration and show examples. Most sections also provide links to Nokia documentation for further reading.

All configurations are in MD-CLI flat format. Reference chassis is 7750 SR-1 and software version is SR OS 23.10R2. Use `show system info` command to verify your router's chassis model and software version.

# Topology

In this topology, the 7750 SR routers are connected to a FRR peers (simulating CE i.e. peering routers from IXP perspective) and 2 Route servers - OpenBGPd and BIRD.

![image](/topology.png)

# Hardware Configuration

Assuming this is a brand new router, the cards should be configured before we proceed with the configuration. If this is already done, you can skip this section.

The card and mda types depend on the variant of the 7750 SR in use. The equipped card and mda types can be seen using the `show card state` command In this example, we are using a 7750 SR-1 with 1 MDA.

```
/configure card 1 card-type iom-1
/configure card 1 level he
/configure card 1 mda 1 mda-type me12-100gb-qsfp28
```

The state of the card and MDA can be viewed using the below show command:

```
A:admin@pe1# show card state

===============================================================================
Card State
===============================================================================
Slot/  Provisioned Type                  Admin Operational   Num   Num Comments
Id         Equipped Type (if different)  State State         Ports MDA
-------------------------------------------------------------------------------
1      iom-1:he                          up    up                  2
1/1    me12-100gb-qsfp28                 up    up            12
A      cpm-1                             up    up                      Active
===============================================================================
```

# Ports and Interfaces

Physical port is configured first following by an interface with an IPv4 or IPv6 address.

Each port is considered as a ‘connector’ and supports breakout. The breakout type used on the connector should be configured first which then unlocks the individual ports in the breakout for configuration.

Port MTU is 9212 by default.

In this example, we are configuring the connector to use a 1x100G breakout.

```
/configure port 1/1/c1 admin-state enable
/configure port 1/1/c1 connector breakout c1-100g
/configure port 1/1/c1/1 admin-state enable
/configure port 1/1/c1/1 description "to-P1"
 commit
```

The status of the port can be viewed using the below command:

```
A:admin@pe1# /show port

===============================================================================
Ports on Slot 1
===============================================================================
Port          Admin Link Port    Cfg  Oper LAG/ Port Port Port   C/QS/S/XFP/
Id            State      State   MTU  MTU  Bndl Mode Encp Type   MDIMDX
-------------------------------------------------------------------------------
1/1/c1        Up         Link Up                          conn   100GBASE-LR4*
1/1/c1/1      Up    Yes  Up      9212 9212    - netw null cgige
```

The interface is given a name, IP and associated to a physical port.

```
  /configure router "Base" interface "to-P1" port 1/1/c1/1
  /configure router "Base" interface "to-P1" ipv4 primary address 192.168.111.2 prefix-length 30
  /configure router "Base" interface "to-P1" ipv6 address 2001:db8:111::2 prefix-length 64
```

The `system` interface is the router's loopback interface (like lo0 or loopback0). The name of this interface cannot be changed. If no explicit `router-id` is configured, the `system` interface IPv4 address is used as the router-id. The `system` interface should be assigned a /32 IP.

```
  /configure router "Base" interface "system" ipv4 primary address 10.10.10.1 prefix-length 32
  /configure router "Base" interface "system" ipv6 address 2001:db8::1 prefix-length 128
```

The status of the interfaces can be seen using the below command:

```
A:admin@pe1# show router interface

===============================================================================
Interface Table (Router: Base)
===============================================================================
Interface-Name                   Adm       Opr(v4/v6)  Mode    Port/SapId
   IP-Address                                                  PfxState
-------------------------------------------------------------------------------
to-P1                            Up        Up/Up       Network 1/1/c1/1
   192.168.111.2/30                                            n/a
   2001:db8:111::2/64                                          PREFERRED
   fe80::e00:21ff:fe68:1f01/64                                 PREFERRED
system                           Up        Up/Up       Network system
   10.10.10.1/32                                               n/a
   2001:db8::1/128                                             PREFERRED
-------------------------------------------------------------------------------
Interfaces : 2
===============================================================================

```

# IGP - IS-IS

IS-IS or OSPF will be required to connect with other routers within the same AS and provide loopbacks reachability. In this example, we are configuring the router to be in IS-IS Level 2 and also enabled IPv6 native routing (the other option is MT). Port and interface configuration is similar to what is shown in previous section.

For more details on IS-IS configuration, visit [SR OS IS-IS Documentation](https://documentation.nokia.com/sr/23-10-2/books/unicast-routing-protocols/is-is-unicast-routing-protocols.html).

```
/configure router "Base" isis 0 admin-state enable
/configure router "Base" isis 0 advertise-router-capability area
/configure router "Base" isis 0 ipv6-routing native
/configure router "Base" isis 0 level-capability 2
/configure router "Base" isis 0 traffic-engineering true
/configure router "Base" isis 0 area-address [49.0000]
/configure router "Base" isis 0 interface "to-P1" interface-type point-to-point
```

IS-IS adjacency status can be seen using the below command:

```
A:admin@pe1# show router isis adjacency 

===============================================================================
Rtr Base ISIS Instance 0 Adjacency 
===============================================================================
System ID                Usage State Hold Interface                     MT-ID
-------------------------------------------------------------------------------
p1                       L2    Up    23   to-P1                         0
-------------------------------------------------------------------------------
Adjacencies : 1
===============================================================================
```

# SR-ISIS (Segment Routing MPLS)

tbd

# BGP

In this example, we are peering with all other PEs in the IXP network (no RR). AS on the SR OS nodes is 64400.

For more details on BGP configuration, visit [SR OS BGP Documentation](https://documentation.nokia.com/sr/23-10-2/books/unicast-routing-protocols/bgp-unicast-routing-protocols.html).

```
/configure router "Base" autonomous-system 64400
/configure router "Base" bgp router-id 10.0.0.1
/configure router "Base" bgp rapid-withdrawal true
/configure router "Base" bgp rapid-update evpn true
/configure router "Base" bgp group "iBGP-Peering" type internal
/configure router "Base" bgp group "iBGP-Peering" family evpn true
/configure router "Base" bgp neighbor "10.10.10.2" group "iBGP-Peering"
/configure router "Base" bgp neighbor "10.10.10.3" group "iBGP-Peering"
/configure router "Base" bgp neighbor "10.10.10.4" group "iBGP-Peering"
/configure router "Base" bgp neighbor "10.10.10.5" group "iBGP-Peering"
```

BGP neighbor status can be seen using the below command.

```
A:admin@pe1# show router bgp summary 
===============================================================================
 BGP Router ID:10.10.10.1       AS:64400       Local AS:64400      
===============================================================================
BGP Admin State         : Up          BGP Oper State              : Up
Total Peer Groups       : 1           Total Peers                 : 4         
Total VPN Peer Groups   : 0           Total VPN Peers             : 0         
Current Internal Groups : 1           Max Internal Groups         : 1         
Total BGP Paths         : 67          Total Path Memory           : 25112     
 
-- snip --    

===============================================================================
BGP Summary
===============================================================================
Legend : D - Dynamic Neighbor
===============================================================================
Neighbor
Description
                   AS PktRcvd InQ  Up/Down   State|Rcv/Act/Sent (Addr Family)
                      PktSent OutQ
-------------------------------------------------------------------------------
10.10.10.2
                64400      42    0 00h17m31s 4/4/4 (Evpn)
                           42    0           
10.10.10.3
                64400      42    0 00h17m31s 4/4/4 (Evpn)
                           42    0           
10.10.10.4
                64400      42    0 00h17m31s 4/4/4 (Evpn)
                           42    0           
10.10.10.5
                64400      42    0 00h17m32s 4/4/4 (Evpn)
                           42    0           
-------------------------------------------------------------------------------
```

To list the received routes from a neighbor, use the below command:

```
A:admin@pe1# show router bgp neighbor "10.10.10.3" received-routes evpn 
===============================================================================
 BGP Router ID:10.10.10.1       AS:64400       Local AS:64400      
===============================================================================
 Legend -
 Status codes  : u - used, s - suppressed, h - history, d - decayed, * - valid
                 l - leaked, x - stale, > - best, b - backup, p - purge
 Origin codes  : i - IGP, e - EGP, ? - incomplete

===============================================================================
BGP EVPN Auto-Disc Routes
===============================================================================
Flag  Route Dist.         ESI                           NextHop
      Tag                                               Label
-------------------------------------------------------------------------------
No Matching Entries Found.
===============================================================================

===============================================================================
BGP EVPN MAC Routes
===============================================================================
Flag  Route Dist.         MacAddr           ESI
      Tag                 Mac Mobility      Label1
                          Ip Address        
                          NextHop           
-------------------------------------------------------------------------------
u*>i  10.10.10.3:100      0c:00:26:ca:f0:3a ESI-0
      0                   Static            LABEL 524287
                          n/a
                          10.10.10.3

u*>i  10.10.10.3:100      aa:c1:ab:07:fa:0c ESI-0
      0                   Seq:0             LABEL 524287
                          n/a
                          10.10.10.3

u*>i  10.10.10.3:100      aa:c1:ab:07:fa:0c ESI-0
      0                   Seq:0             LABEL 524287
                          192.168.0.1
                          10.10.10.3

-------------------------------------------------------------------------------
Routes : 3
===============================================================================

===============================================================================
BGP EVPN Inclusive-Mcast Routes
===============================================================================
Flag  Route Dist.         OrigAddr
      Tag                 NextHop
-------------------------------------------------------------------------------
u*>i  10.10.10.3:100      10.10.10.3
      0                   10.10.10.3

-------------------------------------------------------------------------------
Routes : 1
===============================================================================
```

To monitor the number of routes installed per line card, use the below command:

```
A:admin@pe1# show router fib 1 summary ipv4

===============================================================================
FIB Summary
===============================================================================
                              Active
-------------------------------------------------------------------------------
Static                        0
Direct                        3
Host                          0
BGP                           0
BGP VPN                       0
--snip---
VPN Leak                      0
-------------------------------------------------------------------------------
Total Installed               4
-------------------------------------------------------------------------------
Current Occupancy             1%
Overflow Count                0
Suppressed by Selective FIB   0
Occupancy Threshold Alerts
    Alert Raised 0 Times;
===============================================================================
```
