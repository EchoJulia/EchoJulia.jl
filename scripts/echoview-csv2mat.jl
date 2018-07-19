#!/usr/bin/env julia

using CSVFiles
using DataFrames
using MAT

function load_echoview_matrix(filename)

    df = CSVFiles.load(filename, header_exists=false,
                       skiplines_begin=1) |> DataFrame

    info("Transposing ..")
    A = transpose(convert(Array,df[:, 14:end]))

    info("Converting ..")
    A= Float64.(A)
end

function main(args)
    filenames = args
        
    if length(filenames) == 1
        dir = filenames[1]
        if isdir(dir)
            filenames =  filter(x->endswith(x,".csv"), readdir(dir))
            filenames = ["$(dir)$(x)" for x in filenames]
        end
    end

    for filename in filenames
        out ="$(basename(filename)).mat"

        if isfile(out)
            info("Skipping $out")
            continue
        end

        try
            info("Loading $filename ...")
            a = load_echoview_matrix(filename)

            dict = Dict()
            dict["data"] = a
            dict["DESCR"] = "Converted from $(basename(filename)) by EchoJulia."

            
            info("Writing $out ...")
            matwrite(out, dict)
        catch ex
            info("$ex")
        end
    end

end

main(ARGS)
