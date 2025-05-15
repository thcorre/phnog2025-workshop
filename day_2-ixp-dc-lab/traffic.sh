#!/bin/bash
# Copyright 2020 Nokia
# Licensed under the BSD 3-Clause License.
# SPDX-License-Identifier: BSD-3-Clause


set -eu

startTraffic1-2() {
    echo "starting traffic between clab-dc-${GROUP_ID}-clients 1 and 2"
    docker exec clab-dc-${GROUP_ID}-client2 bash /config/iperf.sh
}

startTraffic1-3() {
    echo "starting traffic between clab-dc-${GROUP_ID}-clients 1 and 3"
    docker exec clab-dc-${GROUP_ID}-client3 bash /config/iperf.sh
}

startTraffic4-6() {
    echo "starting traffic between clab-dc-${GROUP_ID}-clients 4 and 6"
    docker exec clab-dc-${GROUP_ID}-client4 bash /config/iperf.sh
}

startTraffic5-6() {
    echo "starting traffic between clab-dc-${GROUP_ID}-clients 5 and 6"
    docker exec clab-dc-${GROUP_ID}-client5 bash /config/iperf.sh
}

startAll() {
    echo "starting traffic on all clab-dc-${GROUP_ID}-clients"
    docker exec clab-dc-${GROUP_ID}-client2 bash /config/iperf.sh
    docker exec clab-dc-${GROUP_ID}-client3 bash /config/iperf.sh
    docker exec clab-dc-${GROUP_ID}-client4 bash /config/iperf.sh
    docker exec clab-dc-${GROUP_ID}-client5 bash /config/iperf.sh
}

stopTraffic1-2() {
    echo "stopping traffic between clab-dc-${GROUP_ID}-clients 1 and 2"
    docker exec clab-dc-${GROUP_ID}-client2 pkill iperf3
}

stopTraffic1-3() {
    echo "stopping traffic between clab-dc-${GROUP_ID}-clients 1 and 3"
    docker exec clab-dc-${GROUP_ID}-client3 pkill iperf3
}

stopTraffic4-6() {
    echo "stopping traffic between clab-dc-${GROUP_ID}-clients 6 and 4"
    docker exec clab-dc-${GROUP_ID}-client4 pkill iperf3
}

stopTraffic5-6() {
    echo "stopping traffic between clab-dc-${GROUP_ID}-clients 6 and 5"
    docker exec clab-dc-${GROUP_ID}-client5 pkill iperf3
}

stopAll() {
    echo "stopping all traffic"
    docker exec clab-dc-${GROUP_ID}-client2 pkill iperf3
    docker exec clab-dc-${GROUP_ID}-client3 pkill iperf3
    docker exec clab-dc-${GROUP_ID}-client4 pkill iperf3
    docker exec clab-dc-${GROUP_ID}-client5 pkill iperf3    
}

# start traffic
if [ $1 == "start" ]; then
    if [ $2 == "1-2" ]; then
        startTraffic1-2
    fi
    if [ $2 == "1-3" ]; then
        startTraffic1-3
    fi
    if [ $2 == "4-6" ]; then
        startTraffic4-6
    fi  
    if [ $2 == "5-6" ]; then
        startTraffic5-6
    fi       
    if [ $2 == "all" ]; then
        startAll
    fi
fi

if [ $1 == "stop" ]; then
    if [ $2 == "1-2" ]; then
        stopTraffic1-2
    fi
    if [ $2 == "1-3" ]; then
        stopTraffic1-3
    fi
    if [ $2 == "4-6" ]; then
        stopTraffic4-6
    fi  
    if [ $2 == "5-6" ]; then
        stopTraffic5-6
    fi 
    if [ $2 == "all" ]; then
        stopAll
    fi
fi