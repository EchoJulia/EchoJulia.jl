#!/usr/bin/env julia

using Images
using FileIO

# Image resize
# imresize.jl 640 480 file.png

function main(args)
    width = parse(Int, args[1])
    height = parse(Int, args[2])

    for filename in args[3:end]
        img = load(filename)
        img = imresize(img, (height, width))

        out ="$(splitext(basename(filename))[1])-$(width)x$(height).png"

        save(out, img)
    end
end

main(ARGS)
