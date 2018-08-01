#!/usr/bin/env julia

# Converts data in MAT files (created using raw2mat.jl) to png
# e.g. mat2png.jl Sv38 ./
# e.g. mat2png.jl ntheta120 *.mat

using EchogramImages
using ColorSchemes
using FileIO
using MAT

function readvar(filename, varname)
    file = matopen(filename)
    v = read(file, varname)
    close(file)
    return v
end

function main(args)

    if isempty(args)
        info("mat2png.jl <varname> <matfiles>")
        exit(1)
    end
               
    varname = args[1] # The variable name, e.g. Sv38
    
    filenames = args[2:end]
    
    if length(filenames) == 1
        dir = filenames[1]
        if isdir(dir)
            filenames =  filter(x->endswith(x,".mat"), readdir(dir))
            filenames = [joinpath(dir,x) for x in filenames]
        end
    end

    for filename in filenames

        out ="$(splitext(basename(filename))[1])-$varname.png"

        if isfile(out)
            info("Skipping $out")
        else
            try
                info("Processing $filename ...")

                d = readvar(filename, varname)

                if startswith(varname,"Sv")
                    img = imagesc(d, vmin=-95, vmax = -40, size=nothing)
                else
                    img = imagesc(d, size = nothing)
                end
        
                info("Writing $out ...")
                save(out, img)
            catch ex
                warn(ex)
            end
        end
    end
end

main(ARGS)
