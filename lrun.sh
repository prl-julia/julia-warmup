#!/usr/bin/env bash
set -euo pipefail

#
# Run under user with sudo privileges (to stop various daemons)
# Accepts 1 argument: the name of the benchmark to run (e.g. binary-trees)
#

bench=$1

runs=10
iters=2000
out="out.csv"

# Process management
sudo systemctl stop docker.socket
sudo systemctl stop docker
sudo systemctl stop systemd-timesyncd
sudo ifconfig enp0s31f6 down
sync

make_header="println(\"process_exec_idx, bench_name, \" * join(map(string, 1:${iters}), \", \"))"
julia -e "$make_header" > out.csv

for (( r=1; r<=$runs; ++r)); do
    sleep 10
    run_output=$(julia "$bench/bench.jl" $r $iters)
    echo "$run_output" >> out.csv
done
