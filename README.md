# EchoJulia

[![Build Status](https://travis-ci.org/EchoJulia/EchoJulia.jl.svg?branch=master)](https://travis-ci.org/EchoJulia/EchoJulia.jl)

[![Coverage Status](https://coveralls.io/repos/EchoJulia/EchoJulia.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/EchoJulia/EchoJulia.jl?branch=master)

[![codecov.io](http://codecov.io/github/EchoJulia/EchoJulia.jl/coverage.svg?branch=master)](http://codecov.io/github/EchoJulia/EchoJulia.jl?branch=master)


Meta package that loads all the EchoJulia related packages for a
"batteries included" hydroacoustic processing and analysis
environment in Julia.

We assume that you have a working Julia system, See
https://julialang.org/.

## Example

A quick example showing how easy it is to load and explore a Simrad
EK60 echo sounder file.


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
	
## Next Steps

EchoJulia includes many other packages for calibration, region files
and hydroacoustic processing.

For more information contact Rob Blackwell at roback28@bas.ac.uk
