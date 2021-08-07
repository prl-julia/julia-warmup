#
# Accepts 2 parameters: id of the process run, number of iterations, e.g.
#
#   julia binary-trees/bench.jl 5 20
#
# Prints out a line of CSV following the warmup_stats format
# (https://github.com/softdevteam/warmup_stats/)
#

using Printf

MIN_DEPTH = 4
MAX_DEPTH = 12
EXPECT_CKSUM = -10914

using Printf

abstract type BTree end

mutable struct Empty <: BTree
end

mutable struct Node <: BTree
    left::BTree
    right::BTree
    item ::Int
end

function make(i, d)
    if d == 0
        Node(Empty(), Empty(), i)
    else
        Node(make(2*i-1, d-1), make(2*i, d-1), i)
    end
end

check(t::Empty) = 0
check(t::Node) = t.item + check(t.left) - check(t.right)

function loop_depths(d, min_depth, max_depth)
end

function inner_iter(min_depth, max_depth)
    stretch_depth = max_depth + 1
    chk :: Int32 = 0

    # create and check stretch tree
    chk += check(make(0, stretch_depth))

    long_lived_tree = make(0, max_depth)

    niter = 1 << max_depth
    for d = min_depth:2:max_depth
        for i = 1:niter
            chk += check(make(i, d)) + check(make(-i, d))
        end
        niter >>= 2
    end

    chk += check(long_lived_tree)

    if (chk != EXPECT_CKSUM)
        println("bad check: $chk vs $EXPECT_CKSUM");
        exit(1);
    end
end

macro inner_iter()
  :(inner_iter(MIN_DEPTH, MAX_DEPTH))
end

bench_name="binary trees"
include("../shared.jl")

