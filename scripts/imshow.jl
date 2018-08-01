#!/usr/bin/env julia

using Images, ImageView, Gtk.ShortNames
using FileIO

function main(args)
    img = load(args[1])

    guidict = imshow(img);

    #If we are not in a REPL
    if (!isinteractive())

        # Create a condition object
        c = Condition()

        # Get the window
        win = guidict["gui"]["window"]

        # Notify the condition object when the window closes
        signal_connect(win, :destroy) do widget
            notify(c)
        end

        # Wait for the notification before proceeding ...
        wait(c)
    end
end

main(ARGS)
