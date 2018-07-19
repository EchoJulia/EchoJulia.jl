#!/usr/bin/env julia

# Lists the temporal extents of give RAW or EVR files

using SimradRaw
using EchoviewEvr
using Filetimes
using Base.Iterators

function rawstartend(rawfilename)
    starttime = 0
    endtime = 0
    open(rawfilename, "r") do f
        while !eof(f)
            dgheader= nothing
            body = nothing
            try
                dgheader, body = readencapsulateddatagram(f, datagramreader=readdatagramheader)
            catch ex
                warn("$ex on $f")
                break
            end
            t = SimradRaw.filetime(dgheader.datetime)
            if starttime == 0
                starttime = t
            end
            endtime = t
        end
    end
    return starttime, endtime
end

function evrstartend(evrfilename)
    ps = polygons(evrfilename)

    xs = flatten([x for (x,y) in ps])

    return minimum(xs), maximum(xs)
end


function main(args)

    if length(args) == 0
        x = now()
        println("$x\t$(Filetimes.filetime(x))")
    else
        for arg in args
            if endswith(uppercase(arg), ".RAW")
                starttime, endtime = rawstartend(arg)
                println("$arg\t$starttime\t$endtime\t$(datetime(starttime))\t$(datetime(endtime))")
                continue
            end
            if endswith(uppercase(arg), ".EVR")
                starttime, endtime = evrstartend(arg)
                println("$arg\t$starttime\t$endtime\t$(datetime(starttime))\t$(datetime(endtime))")
                continue
            end

            y = tryparse(Int64,arg)
            if isnull(y)
                println("$arg\t$(Filetimes.filetime(arg))")
            else
                println("$(datetime(get(y)))\t$arg")
            end
        end
    end
        
end

main(ARGS)
