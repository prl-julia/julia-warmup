using Printf

SPECTRAL_N  = 1000
EXPECT_CKSUM = 1.2742241481294835914184204739285632967948913574218750

A(i,j) = 1.0 / ((i+j)*(i+j+1.0)/2.0+i+1.0)

function Au(u,w)
    n = length(u)
    for i = 1:n, j = 1:n
        j == 1 && (w[i] = 0)
        w[i] += A(i-1,j-1) * u[j]
    end
end

function Atu(w,v)
    n = length(w)
    for i = 1:n, j = 1:n
        j == 1 && (v[i] = 0)
        v[i] += A(j-1,i-1) * w[j]
    end
end

function inner_iter(n::Int)
    u = ones(Float64,n)
    v = zeros(Float64,n)
    w = zeros(Float64,n)
    vv = vBv = 0
    for i = 1:10
        Au(u,w)
        Atu(w,v)
        Au(v,w)
        Atu(w,u)
    end
    for i = 1:n
        vBv += u[i]*v[i]
        vv += v[i]*v[i]
    end
    chk = sqrt(vBv/vv)
    if (chk != EXPECT_CKSUM)
        println("bad check: $chk vs $EXPECT_CKSUM");
        exit(1);
    end
    return chk
end

macro inner_iter()
  :(inner_iter(SPECTRAL_N))
end

bench_name="spectralnorm"
include("../shared.jl")

