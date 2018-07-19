#!/usr/bin/env julia

const STYLE="""
<style>
h1   {font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
	font-size: 16pt;}
h2   {font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
	font-size: 14pt;}
p    {font-family: "Times New Roman", Times, serif; font-size: 12pt;}
figure {
    text-align: center;
    display: inline-block;
}
table {
width: 100%;
}
tr:nth-child(even) {background-color: #f2f2f2;}

</style>
"""

function figure(src, caption)
"""
<figure>
<a href="$src"><img width=1024 src="$src"></a>
<figcaption>$caption</figcaption>
</figure>
"""
end

function link(src)
"""
<a href="$src">$src</a>
"""
end

function makelink(filename)
    if isimagefile(filename)
        figure(basename(filename), basename(filename))
    else
        link(basename(filename))
    end
end

function isimagefile(f)
    f = lowercase(f)
    endswith(f, ".png") || endswith(f, ".jpg") || endswith(f,".jpeg")
end


function mybasename(x)
    y =basename(x)
    i = first(search(y,"."))
    y[1:i-1]
end


function relatedfiles(f)
    b = mybasename(f)
    filenames =  filter(x->startswith(x,b), readdir("."))
end

# Make webpages to allow navigation of results

function makehtml(filenames)

    n = length(filenames)
    
    for i in 1:n
        filename = filenames[i]
        info("filename $filename")
        name, ext = splitext(mybasename(filename))
        out =  "$name.html"

        info("Writing $out ...")

        open(out, "w") do f
            write(f, """
<html>
<head>
$STYLE
</head>
<body>
""")



            if i > 1
                x, ext = splitext(mybasename(filenames[i-1]))
                write(f, "<a href=\"$x.html\">previous</a>\n")
            end
            if i < n
                x, ext = splitext(mybasename(filenames[i+1]))
                write(f, "<a href=\"$x.html\">next</a>\n")
            end
            write(f, "<h1>$name</h1>\n")

            for rf in relatedfiles(filename)
                write(f, makelink(rf))
                write(f,"<br/>")
            end

            write(f, "</body></html>\n")
        end
    end
end


function makeindex(filenames)
    out = "index.html"
    info("Writing $out ...")

    open(out, "w") do f

        write(f, "<html><head>$STYLE</head><body>\n")

        for filename in filenames
            #name, ext = splitext(basename(filename))
            name = mybasename(filename)
            out2=  "$name.html"
            write(f, "<p><a href=\"$name.html\">$name</a></p>\n")
        end
        write(f, "</body></html>\n")
    end
end

function main(args)

    info("Writing HTML ...")

    filenames = args

    makehtml(filenames)
    makeindex(filenames)

    info("Done")

end

main(ARGS)
