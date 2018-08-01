#!/usr/bin/env julia

using MAT
using AliasedSeabed

# Creates an aliased seabed mask for the given frequency,
# outputing a MAT file with a "mask" variable.
#
# E.g. ./asb.jl 38 myfile.mat
# Output is myfile-asb18.mat

function main(args)
    freq = args[1]
    
    filenames = args[2:end]

    for filename in filenames
        a = matread(filename)
        m = asbmask(a["Sv$freq"], a["ntheta$freq"], a["nphi$freq"])

        out ="$(splitext(basename(filename))[1])-asb$freq.mat"

        matwrite(out, Dict("mask" =>  convert(Array{Bool}, m)))
    end
end

main(ARGS)
