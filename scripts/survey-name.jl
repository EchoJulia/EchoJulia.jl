#!/usr/bin/env julia

using SimradRaw

# Prints the survey name for one or more RAW files.

function main(args)
    for arg in args
        for datagram in datagrams(arg)
            if isa(datagram, SimradRaw.ConfigurationDatagram)
                println(datagram.configurationheader.surveyname)
                break
            end
        end
    end
        
end

main(ARGS)
