##
# Juila VM Warmup experiments
#
# @version 0.1

.PHONY: all binary-trees

all: binary-trees

binary-trees:
	julia -L binary-trees/bench.jl -e 'run_iter(1)'

# end
