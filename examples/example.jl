using EchoJulia

filename = EK60_SAMPLE # or some EK60 RAW file name

ps = pings(filename) # Get the pings
ps38 = [p for p in ps if p.frequency == 38000] # Just 38 kHz pings
Sv38 = Sv(ps38) # Convert to a matrix of volume backscatter

# Show a quick echogram

eg(Sv38) 

# Full echogram, preserving resolution

egshow(Sv38)

# More like Echoview?

eg(Sv38,cmap=EK500, vmin=-95,vmax=-50)

# Show a histogram

eghist(Sv38) 

# Echogram as an RGB image for use with Images.jl and friends

img = imagesc(Sv38)

# Export to MATLAB format for further analysis

using MAT

matwrite("myfile.mat", Dict("Sv38" => Sv38))
