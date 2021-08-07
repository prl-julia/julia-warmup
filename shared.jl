#
# Generic runner of a Julia benchmark
#
# Interface:
#   Every benchmark (X/bench.jl) should define the inner_iter macro that runs one
#   iteration of the benchmark
#

# Run N iterations of the inner_iter defined in the including file
# and print timings as a line of CSV to stdout
run_iter(n) = begin
    ms = Vector{Float64}(undef, n)
    for i in 1:n
        t = time_ns()
        @inner_iter()
        elapsed = (time_ns() - t) / 1e9
        ms[i] = elapsed
    end

    print("$id, $bench_name")
    for m in ms
        @printf ", %.5f" m
    end
    println()
end

#
# Main
#

id = parse(Int, ARGS[1])
iters = parse(Int, ARGS[2])

# print process run entry prefix (id, bench name), mind commas
run_iter(iters)

