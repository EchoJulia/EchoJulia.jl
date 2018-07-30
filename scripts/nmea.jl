#!/usr/bin/env julia

using SimradRaw

# Prints the NMEA strings for one or more RAW files.

function nmeas(datagrams)
    function _it(chn1)
        for datagram in datagrams
            if typeof(datagram) == SimradRaw.TextDatagram && datagram.dgheader.datagramtype == "NME0"
                put!(chn1, datagram.text)
            end
        end
    end

    return Channel(_it, ctype=String)
end
    
function main(args)
    for nmea in nmeas(datagrams(args))
        println(nmea)
    end
end

main(ARGS)
