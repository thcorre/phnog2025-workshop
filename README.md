# Welcome at the Nokia workshop @ INNOG8!

This README is your starting point into the workshop, it should get you familiar with the lab environment provided by Nokia, and provide an overview of the suggested sample activities.

During those 3 days you will work in groups on the pre-provided lab activities.

As long as you have a laptop with the ability to SSH, you should be good to go. 

Also not mandatory, however use of VScode editor would also be of great value to ease up things through the new containerlab extension.   

Need help, not a problem, pop your hand in the air and we will be there to guide you. 

## Pre-requisites
A list of workshop modules. Each module is a self-contained guide that can be followed independently, but it is recommended to go through them in order if you are new to Containerlab.

Use the [official slide deck](https://gitlabe2.ext.net.nokia.com/thcorre/innog8/-/wikis/uploads/e805ff11f4e57183630ffdb6e50b7c7d/Containerlab_INNOG8_Workshop_v4.pdf) to follow along with the workshop.

1. [Containerlab Installation](05-install/README.md) guide
2. [Basics first](10-basics/README.md)
3. [Dealing with startup config](15-startup/README.md)
4. [VM-based nodes](20-vm/README.md)
5. [Container registry](30-registry/README.md)
6. [Packet capture](40-packet-capture/README.md)
7. [A lab that has it ~all](45-streaming-telemetry/README.md)

Did you love this workshop? Let us know in the comments of this [LinkedIn post](https://www.linkedin.com/posts/nokia-for-service-providers_visit-us-at-innog8-iispc-2025-activity-7325870778514575360-_lpa).

## Lab Environment
For this workshop each group of participants will receive their own dedicated directory running a copy of the lab topology.

If everything went according to plan, you should have received a physical piece of paper which contains:
- a group ID allocated to your group
- SSH credentials to a public cloud instance dedicated to your group. 
- HTTPS URL's towards this repo and access to a web based IDE in case you don't have one installed on your operating system.

> !!! Make sure to backup any code, config, ... <u> offline (e.g your laptop)</u>.
> The public cloud instances will be destroyed once the workshop is concluded.</p>

### Group ID

Please refer to the paper provided by the workshop session leaders. If nothing has been provided, not a problem, pop your hand in the air and an eager expert will be there to allocate one for you. 

### SSH

hostname: `refer to the paper provided `

username: `refer to the paper provided or the slide presented`

password: `refer to the paper provided or the slide presented`

[Optional] To enable password-less access to an instance, use `ssh-keygen -h` to generate a public/private key pair and then `ssh-copy-id` to copy it over.

### WiFi

Details provided in the session.


#### Pre-provided activities

Below you can find a table with links towards those pre-provided project which you can use as a baseline for the problem/project you might want to tackle or perform the tasks we've set up for you.

Each pre-provided lab comes with a README of it's own, please click the below for more information.

| Link to pre-provided labs | NOS | Difficulty |
| --- | --- | --- |
| [IXP Peering lab](./day_1-ixp-peering-lab) | SR OS, cEOS, FRR | Basic |
| [IXP DC lab](./day_2-ixp-dc-lab) | SR Linux, SR OS | Intermediate |
| [ISP SRv6 FlexAlgo lab](./day_3-isp-srv6-flexalgo-lab) | SR Linux, SR OS | Intermediate |

#### Topology

When accessing your group instance you'll see this repository has already been cloned for you and a fully configured network (powered by [containerlab](https://www.containerlab.dev)).

*Don't worry: This is your personal group network, you cannot impact any other groups.*

![topology](./../topology/innog8-topology.png)

The above topology contains a number of functional blocks to help you in area's you might want to focus on, it contains:

- IXP Peering lab:
  - SR-MPLS (Dual-Stack ISIS)
  - MP-BGP (SAFIs with IPv6 next-hop)
  - 5x P-nodes (FRR, cEOS)
  - 5x PE-nodes (SR OS)
  - 2x route-reflectors (cEOS)
  - a Transit/Peering setup with RPKI available on PE1
  - Linux clients are attached to both the GRT and VPRN services allowing a full mesh of traffic. 
- IXP DC lab:
  - a CLOS model:
    - 2x spines (spine1|spine2) and 3 leaf switches (leaf1|leaf2|leaf3)
  - IPv6 BGP unnumbered configured in the underlay
  - DCGW Integration in the DC (dcgw1|dcgw2)
  - a fully working telemetry stack (gNMIc/prometheus/grafana)
  - Linux clients are attached to both the GRT and VPRN services allowing a full mesh of traffic. 
- ISP SRv6 FlexAlgo lab:

### Help! I've bricked my lab, how do I redeploy? 

When accessing your workshop instance you'll see the innog8 directory is a git clone of this repository.
The labs covered in this workshops (powered by [containerlab](https://www.containerlab.dev)), are available for you to use.

If you have broken something and would like to restore the state without extensively troubleshooting, you can destroy and redeploy the command via following `make` commands:

> Note: we use containerlab under the hood, the Makefile is just a simple wrapper around it.

``` 
~$ cd $HOME/
~$ make destroy -C /home/nokia/innog8/clab/
~$ make deploy -C /home/nokia/innog8/clab/
```

### Credentials & Access

#### Accessing the lab from within the host

To access the lab nodes from within host, users should identify the names of the deployed nodes using the `sudo containerlab inspect` command:

```
sudo containerlab inspect -a
+----+--------------+-----------+---------------------------+--------------+------------------------------------+---------------+---------+----------------+--------------+
| #  |  Topo Path   | Lab Name  |           Name            | Container ID |               Image                |     Kind      |  State  |  IPv4 Address  | IPv6 Address |
+----+--------------+-----------+---------------------------+--------------+------------------------------------+---------------+---------+----------------+--------------+
|  1 | srx.clab.yml | innog8 | clab-innog8-agg1       | 674410c9af85 | ghcr.io/nokia/srlinux:24.7.1       | nokia_srlinux | running | 10.128.1.52/24 | N/A          |
|  2 |              |           | clab-innog8-client01   | 84d10798f3e1 | ghcr.io/srl-labs/network-multitool | linux         | running | 10.128.1.25/24 | N/A          |
|  3 |              |           | clab-innog8-client02   | 4097ff655bd0 | ghcr.io/srl-labs/network-multitool | linux         | running | 10.128.1.26/24 | N/A          |
|  4 |              |           | clab-innog8-client03   | 2b4bc0f5beda | ghcr.io/srl-labs/network-multitool | linux         | running | 10.128.1.27/24 | N/A          |
|  5 |              |           | clab-innog8-client04   | ad92d1770e8e | ghcr.io/srl-labs/network-multitool | linux         | running | 10.128.1.28/24 | N/A          |
|  6 |              |           | clab-innog8-client11   | 6c30905e24d7 | ghcr.io/srl-labs/network-multitool | linux         | running | 10.128.1.36/24 | N/A          |
|  7 |              |           | clab-innog8-client12   | e7c67b6243ad | ghcr.io/srl-labs/network-multitool | linux         | running | 10.128.1.37/24 | N/A          |
|  8 |              |           | clab-innog8-client13   | dd3e7de474fe | ghcr.io/srl-labs/network-multitool | linux         | running | 10.128.1.38/24 | N/A          |
|  9 |              |           | clab-innog8-client21   | b0aa7b04e83d | ghcr.io/srl-labs/network-multitool | linux         | running | 10.128.1.42/24 | N/A          |        |
| 11 |              |           | clab-innog8-gnmic      | 49fd00767f0a | ghcr.io/openconfig/gnmic:0.36.2    | linux         | running | 10.128.1.71/24 | N/A          |
| 12 |              |           | clab-innog8-grafana    | ae9792b4685a | grafana/grafana:10.3.5             | linux         | running | 10.128.1.73/24 | N/A          |
| 13 |              |           | clab-innog8-ixp1       | 8f2e2a34ec1d | ghcr.io/nokia/srlinux:24.7.1       | nokia_srlinux | running | 10.128.1.51/24 | N/A          |
| 14 |              |           | clab-innog8-leaf1     | ae40f8086951 | ghcr.io/nokia/srlinux:24.7.1       | nokia_srlinux | running | 10.128.1.33/24 | N/A          |
| 15 |              |           | clab-innog8-leaf2     | 5b8ef1f0851f | ghcr.io/nokia/srlinux:24.7.1       | nokia_srlinux | running | 10.128.1.34/24 | N/A          |
| 16 |              |           | clab-innog8-leaf3     | 0b6cdb0f1f74 | ghcr.io/nokia/srlinux:24.7.1       | nokia_srlinux | running | 10.128.1.35/24 | N/A          |        |      |
| 19 |              |           | clab-innog8-p1         | 9a7be92bc261 | vr-sros:24.7.R1                    | nokia_sros    | running | 10.128.1.11/24 | N/A          |
| 20 |              |           | clab-innog8-p2         | dcf131b23d80 | vr-sros:24.7.R1                    | nokia_sros    | running | 10.128.1.12/24 | N/A          |
| 21 |              |           | clab-innog8-pe1        | eb95be700e43 | vr-sros:24.7.R1                    | nokia_sros    | running | 10.128.1.21/24 | N/A          |
| 22 |              |           | clab-innog8-pe2        | 331942c949ee | vr-sros:24.7.R1                    | nokia_sros    | running | 10.128.1.22/24 | N/A          |
| 23 |              |           | clab-innog8-pe3        | b75dae1a645a | vr-sros:24.7.R1                    | nokia_sros    | running | 10.128.1.23/24 | N/A          |
| 24 |              |           | clab-innog8-pe4        | 35b7bb4c8a9e | vr-sros:24.7.R1                    | nokia_sros    | running | 10.128.1.24/24 | N/A          |
| 25 |              |           | clab-innog8-peering2   | 53d62d034b51 | ghcr.io/nokia/srlinux:24.7.1       | nokia_srlinux | running | 10.128.1.53/24 | N/A          |
| 26 |              |           | clab-innog8-prometheus | 6411ad6c5712 | prom/prometheus:v2.51.2            | linux         | running | 10.128.1.72/24 | N/A          |        |
| 29 |              |           | clab-innog8-rpki       | 2fed2c9c9306 | rpki/stayrtr                       | linux         | running | 10.128.1.55/24 | N/A          |
| 30 |              |           | clab-innog8-spine1    | 56298e38e060 | ghcr.io/nokia/srlinux:24.7.1       | nokia_srlinux | running | 10.128.1.31/24 | N/A          |
| 31 |              |           | clab-innog8-spine2    | ae95193f1764 | ghcr.io/nokia/srlinux:24.7.1       | nokia_srlinux | running | 10.128.1.32/24 | N/A          |       |
| 36 |              |           | clab-innog8-transit1   | 7836cd8cde2c | ghcr.io/srl-labs/network-multitool | linux         | running | 10.128.1.54/24 | N/A          |
+----+--------------+-----------+---------------------------+--------------+------------------------------------+---------------+---------+----------------+--------------+
```

Using the names from the above output, we can login to the a node using the following command:

For example to access node `clab-innog8-pe1` via ssh simply type:

```
ssh admin@clab-innog8-pe1
```

#### Accessing the lab via Internet

Each public cloud instance has a port-range (50000 - 51000) exposed towards the Internet, as lab nodes spin up, a public port is allocated by the docker daemon on the public cloud instance.
You can utilize those to access the lab services straight from your laptop via the Internet.

With the `show-ports` command executed on a VM you get a list of mappings between external and internal ports allocated for each node of a lab:

```
~$ show-ports
Name                       Forwarded Ports
clab-innog8-agg1        50052 -> 22, 50352 -> 57400
clab-innog8-client01    50025 -> 22
clab-innog8-client02    50026 -> 22
clab-innog8-client03    50027 -> 22
clab-innog8-client04    50028 -> 22
clab-innog8-client1     50036 -> 22
clab-innog8-client2     50037 -> 22
clab-innog8-client3     50038 -> 22
clab-innog8-grafana     3000 -> 3000
clab-innog8-ixp1        50051 -> 22, 50351 -> 57400
clab-innog8-leaf1       50033 -> 22, 50333 -> 57400
clab-innog8-leaf2       50034 -> 22, 50334 -> 57400
clab-innog8-leaf3       50035 -> 22, 50335 -> 57400
clab-innog8-p1          50011 -> 22, 50411 -> 830, 50311 -> 57400
clab-innog8-p2          50012 -> 22, 50412 -> 830, 50312 -> 57400
clab-innog8-pe1         50021 -> 22, 50421 -> 830, 50321 -> 57400
clab-innog8-pe2         50022 -> 22, 50422 -> 830, 50322 -> 57400
clab-innog8-pe3         50023 -> 22, 50423 -> 830, 50323 -> 57400
clab-innog8-pe4         50024 -> 22, 50424 -> 830, 50324 -> 57400
clab-innog8-peering2    50053 -> 22, 50353 -> 57400
clab-innog8-prometheus  9090 -> 9090
clab-innog8-spine11     50031 -> 22, 50331 -> 57400
clab-innog8-spine12     50032 -> 22, 50332 -> 57400
clab-innog8-transit1    50054 -> 22
```

Each service exposed on a lab node gets a unique external port number as per the table above. 
In the given case, Grafana's web interface is available on port 3000 of the VM which is mapped to Grafana's node internal port of 3000.

The following table shows common container internal ports and is meant to help you find the correct exposed port for the services.

| Service    | Internal Port number |
| ---------- | -------------------- |
| SSH        | 22                   |
| Netconf    | 830                  |
| gNMI       | 57400                |
| HTTP/HTTPS | 80/443               |
| Grafana    | 3000                 |

Subsequently you can access the lab node on the external port for your given instance using the DNS name of the group.

| Group ID | hostname instance |
| --- | --- |
| **X** | **X**.innog8.net |

In the example above, accessing `pe1` would be possible by: 

```
ssh admin@X.innog8.net -p 50021
```

In the example above, accessing grafana would be possible browsing towards **http://X.innog8.net:3000** (where X is the group ID you've been allocated)

[Optional] You can generate `ssh-config` using the `generate-ssh-config` command and store the output on your local laptop's SSH client, in order to connect directly to nodes.

#### Traffic generation: starting and stopping

In the generic topology, linux clients are attached to a number of routers:

- the PEs
- the leafs in data center
- in multiple VRFs: global routing table (grt) and vprn "dci" (vprn.dci)

One can start and/or stop traffic by connecting to the relevant client using SSH, and running `/traffic.sh`, for example:

```
ssh user@clab-innog8-client1

client11:~$ /traffic.sh [-a <start|stop>] [-d <dns hostname>]
```

The dns hostname is composed out of the client name and a domain suffix.

| SSH | Client | Global Routing Table suffix | VPRN "DCI" suffix |
| --- | --- | --- | --- |
| clab-innog8-client01 | client01 | .grt | .vprn.dci |
| clab-innog8-client02 | client02 | .grt | .vprn.dci |
| clab-innog8-client03 | client03 | .grt | .vprn.dci |
| clab-innog8-client04 | client04 | .grt | .vprn.dci |
| clab-innog8-client11 | client11 | .grt | .vprn.dci |
| clab-innog8-client12 | client12 | .grt | .vprn.dci |
| clab-innog8-client13 | client13 | .grt | .vprn.dci |
| clab-innog8-client14 | client21 | .grt | .vprn.dci |

For example, if you'd like to start a unidirectional traffic flow from `client11` to `client21` in the global routing table:
```
client11:~$ /traffic.sh -a start -d client21.grt
starting traffic to client21.grt, binding on client11.grt, saving logs to /tmp/client21.grt.log
```

Stopping the traffic flow would be achieved by:

```
client11:~$ /traffic.sh -a stop -d client21.grt
stopping traffic to client21.grt
```

However, if you'd like to start a full mesh of traffic between `client11` and the rest of the clients, this could be achieved by executing: 

```
client11:~$ /traffic.sh -a start -d all.grt
starting traffic to client01.grt, binding on client11.grt, saving logs to /tmp/client01.grt.log
starting traffic to client02.grt, binding on client11.grt, saving logs to /tmp/client02.grt.log
starting traffic to client03.grt, binding on client11.grt, saving logs to /tmp/client03.grt.log
starting traffic to client04.grt, binding on client11.grt, saving logs to /tmp/client04.grt.log
starting traffic to client12.grt, binding on client11.grt, saving logs to /tmp/client12.grt.log
starting traffic to client13.grt, binding on client11.grt, saving logs to /tmp/client13.grt.log
starting traffic to client21.grt, binding on client11.grt, saving logs to /tmp/client21.grt.log

client11:~$ /traffic.sh -a stop -d all.grt
stopping traffic to client01.grt
stopping traffic to client02.grt
stopping traffic to client03.grt
stopping traffic to client04.grt
stopping traffic to client12.grt
stopping traffic to client13.grt
stopping traffic to client21.grt
```

## Cloning this repository

If you would like to work locally on your personal device you should clone this repository. This can be done using one of the following commands.

HTTPS:
```
git clone https://github.com/nokia/innog8.git
```

SSH:
```
git clone git@github.com:nokia/innog8.git
```

GitHub CLI:
```
gh repo clone nokia/innog8
```

## Useful links

* [Network Developer Portal](https://network.developer.nokia.com/)
* [containerlab](https://containerlab.dev/)
* [gNMIc](https://gnmic.openconfig.net/)

### SR Linux

* [Learn SR Linux](https://learn.srlinux.dev/)
* [YANG Browser](https://yang.srlinux.dev/)
* [gNxI Browser](https://gnxi.srlinux.dev/)

### SR OS

* [SR OS Release 24.10](https://documentation.nokia.com/sr/24-10/index.html)
* [pySROS](https://network.developer.nokia.com/static/sr/learn/pysros/latest/index.html)

### Misc Tools/Software
#### Windows

* [WSL environment](https://learn.microsoft.com/en-us/windows/wsl/install)
* [Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701)
* [MobaXterm](https://mobaxterm.mobatek.net/download.html)
* [PuTTY Installer](https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.78-installer.msi)
* [PuTTY Binary](https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe)


#### MacOS

* [iTerm2](https://iterm2.com/downloads/stable/iTerm2-3_4_19.zip)
* [Warp](https://app.warp.dev/get_warp)
* [Hyper](https://hyper.is/)
* [Terminal](https://support.apple.com/en-gb/guide/terminal/apd5265185d-f365-44cb-8b09-71a064a42125/mac)

#### Linux

* [Gnome Console](https://apps.gnome.org/en/app/org.gnome.Console/)
* [Gnome Terminal](https://help.gnome.org/users/gnome-terminal/stable/)

#### IDEs

* [VS Code](https://code.visualstudio.com/Download)
* [VS Code Web](https://vscode.dev/)
* [Sublime Text](https://www.sublimetext.com/download)
* [IntelliJ IDEA](https://www.jetbrains.com/idea/download/)
* [Eclipse](https://www.eclipse.org/downloads/)
* [PyCharm](https://www.jetbrains.com/pycharm/download)
