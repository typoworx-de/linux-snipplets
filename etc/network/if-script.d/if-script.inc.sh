#!/bin/bash
network_status=$(basename $(dirname $0) | grep -Eo "if-(up|down|post-down|pre-up)");
