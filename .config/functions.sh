#!/usr/bin/env bash

function ping-ts() {
    ping "$1" | xargs -L 1 -I '{}' date '+%H:%M:%S - {}'
}
