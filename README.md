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
  - 3x P-nodes (cEOS)
  - 5x PE-nodes (SR OS) using EVPN as the IXP L2 network
  - 2x Route Servers (BIRD, OpenBGPd) connected to PE1 and PE2
  - 3x CE clients (FRR) which connect to their respective PEs and peer with the 2 Route Servers.
  - Optional: a RPKI validator (Routinator) available through PE1

- IXP DC lab:
  - a CLOS model:
    - 2x spines (spine1|spine2) and 3 leaf switches (leaf1|leaf2|leaf3)
  - IPv6 BGP unnumbered configured in the underlay
  - DCGW Integration in the DC (dcgw1|dcgw2)
  - a fully working telemetry stack (gNMIc/prometheus/grafana)
  - Linux clients are attached to both the GRT and VPRN services allowing a full mesh of traffic. 

- ISP SRv6 FlexAlgo lab:

### Help! I've bricked my lab, how do I redeploy? 

When accessing your workshop Bare Metal you'll see the innog8 directory is a git clone of this repository.
The labs covered in this workshops (powered by [containerlab](https://www.containerlab.dev)), are available for you to use.

If you have broken something and would like to restore the state without extensively troubleshooting, you can destroy and redeploy the command via following `clab` commands:

``` 
~$ cd $HOME/
~$ clab destroy innog8-workshop/day_1-ixp-peering-lab/peering.innog8.clab.yml --cleanup
~$ clab deploy innog8-workshop/day_1-ixp-peering-lab/peering.innog8.clab.yml --reconfigure
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
