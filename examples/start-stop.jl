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

    filenames = args
 
    for filename in filenames
        if endswith(uppercase(filename), ".RAW")
            starttime, endtime = rawstartend(filename)
            println("$filename\t$starttime\t$endtime\t$(datetime(starttime))\t$(datetime(endtime))")
        end
        if endswith(uppercase(filename), ".EVR")
            starttime, endtime = evrstartend(filename)
            println("$filename\t$starttime\t$endtime\t$(datetime(starttime))\t$(datetime(endtime))")
        end
        
    end
       
end

main(ARGS)
