##
# Juila VM Warmup experiments
#
# @version 0.1

.PHONY: all binary-trees

all: binary-trees

binary-trees:
	julia binary-trees/bench.jl 1 20

runner:
	./run.sh binary-trees
# end
