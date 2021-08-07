##
# Juila VM Warmup experiments
#
# @version 0.1

PHONY: all

all: run-binary-trees

lrun-%:
	./lrun.sh $*

run-%:
	julia $*/bench.jl 1 20

%-trace-comp:
	julia --trace-compile=stderr $*/bench.jl 1 20

# end
