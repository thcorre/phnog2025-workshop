# Nokia SR OS as PE in an IXP infrastructure Configuration

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
/configure card 1 mda 1 mda-type me6-100gb-qsfp28
```

The state of the card and MDA can be viewed using the below show command:

```
A:admin@SR1# show card state

===============================================================================
Card State
===============================================================================
Slot/  Provisioned Type                  Admin Operational   Num   Num Comments
Id         Equipped Type (if different)  State State         Ports MDA
-------------------------------------------------------------------------------
1      iom-1:he                          up    up                  2
1/1    me6-100gb-qsfp28                  up    up            6
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
/configure port 1/1/c1/1 description "To Peering LAN"
 commit
```

The status of the port can be viewed using the below command:

```
A:admin@SR1# /show port

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
  /configure router "Base" interface "To-Peering-LAN" port 1/1/c1/1
  /configure router "Base" interface "To-Peering-LAN" ipv4 primary address 192.168.0.1 prefix-length 24
  /configure router "Base" interface "To-Peering-LAN" ipv6 address 2001:a8::4 prefix-length 124
```

The `system` interface is the router's loopback interface (like lo0 or loopback0). The name of this interface cannot be changed. If no explicit `router-id` is configured, the `system` interface IPv4 address is used as the router-id. The `system` interface should be assigned a /32 IP.

```
  /configure router "Base" interface "system" ipv4 primary address 10.0.0.1 prefix-length 32
  /configure router "Base" interface "system" ipv6 address 2001:1::101 prefix-length 128
```

The status of the interfaces can be seen using the below command:

```
A:admin@SR1# show router interface

===============================================================================
Interface Table (Router: Base)
===============================================================================
Interface-Name                   Adm       Opr(v4/v6)  Mode    Port/SapId
   IP-Address                                                  PfxState
-------------------------------------------------------------------------------
To-Peering-LAN                   Up        Up/Up       Network 1/1/c1/1
   192.168.0.1/24                                              n/a
   2001:a8::4/124                                              PREFERRED
   fe80::1668:ffff:fe00:0/64                                   PREFERRED
system                           Up        Up/Up       Network system
   10.0.0.1/32                                                 n/a
   2001:1::101/128                                             PREFERRED
-------------------------------------------------------------------------------
Interfaces : 2
===============================================================================

```
