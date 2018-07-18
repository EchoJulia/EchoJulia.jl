#!/usr/bin/env julia

using EchoJulia
using MAT

# Finds raw files and converts them to MATLAB files optionally using
# an Echoview calibration supplement for correction.

function main(args)

    ecs_filename = nothing
    
    if args[1] == "-c" # Echoview calibration supplement
        ecs_filename = args[2]
        filenames = args[3:end]
    else
        filenames = args
    end
    
        
    if length(filenames) == 1
        dir = filenames[1]
        if isdir(dir)
            filenames =  filter(x->endswith(x,".raw"), readdir(dir))
            filenames = ["$(dir)$(x)" for x in filenames]
        end
    end

    for filename in filenames
        out ="$(basename(filename)).mat"

        if isfile(out)
            info("Skipping $out.")
            continue
        end

        try
            info("Processing $filename ...")
            dict = loadraw(filename, ecs_filename)
        
            info("Writing $out ...")
            matwrite(out, dict)
        catch ex
            warn(ex)
        end

    end
    
    
end

main(ARGS)
