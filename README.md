# EchoJulia

[![Build Status](https://travis-ci.org/EchoJulia/EchoJulia.jl.svg?branch=master)](https://travis-ci.org/EchoJulia/EchoJulia.jl)

[![Coverage Status](https://coveralls.io/repos/EchoJulia/EchoJulia.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/EchoJulia/EchoJulia.jl?branch=master)

[![codecov.io](http://codecov.io/github/EchoJulia/EchoJulia.jl/coverage.svg?branch=master)](http://codecov.io/github/EchoJulia/EchoJulia.jl?branch=master)


Meta package that loads all the EchoJulia related packages for a
"batteries included" hydroacoustic data processing and analysis
environment in Julia.

We assume that you have a working Julia system, See
https://julialang.org/.

## Installation (COMING SOON)


	Pkg.add("EchoJulia")


## Simple Example

Some sample acoustics files are provided for demonstration and testing purposes. `EK60_SAMPLE` is a sample
RAW file recorded with a Simrad EK60 scientific echo sounder. `ECS_SAMPLE` is a calibration supplement file
containing calibration corrections. The following snippet loads the RAW file, applies calibration and plots
a simple echogram:


	using EchoJulia
	
	filename = EK60_SAMPLE # or some EK60 RAW file name
	ecs = ECS_SAMPLE # Or some other EchoView Calibration supplement file name
	
	data = loadraw(filename, ecs)
	
	Sv38 = data["Sv38"] # A matrix of 38 kHz volume backscatter
	depth = maximum(data["r38"]) # Maximum range in metres
	
	eg(Sv38,cmap=EK500, vmin=-95,vmax=-50,range=depth) # Plot a quick echogram
	

![Echogram](doc/media/images/example.png)

## Export to MATLAB

It is often desirable to export the data for further analysis. Note that the MATLAB MAT
file format is not a proprietary format, but a specialised HDF5 format.


	Pkg.add("MAT")
	
	using MAT
	matwrite("myfile.mat", data)

## Low level API

Although `loadraw` is convenient for exploratory data analysis, we
sometimes need access to the underlying EK60 datagrams, for example,
to access the survey name or NMEA data.


	data = collect(datagrams(EK60_SAMPLE))
	name = data[1].configurationheader.surveyname


If performance matters, you might choose to access the data ping by ping:

	filename = EK60_SAMPLE # or some EK60 RAW file name

	ps = pings(filename) # Get the pings
	ps38 = [p for p in ps if p.frequency == 38000] # Just 38 kHz pings
	Sv38 = Sv(ps38) # Convert to a matrix of volume backscatter

## Histograms

Show a histogram of volume backscatter.

	data = loadraw(EK60_SAMPLE)

	eghist(data["Sv38"]) 
	
![Histogram](doc/media/images/hist.png)

## Image processing

EchoJulia uses simple matrices and this allows interoperability with the wider
Julia scientific computing tools, especially `Images.jl`.

If you need an echogram image, the following can be useful:


	using Images
	img = imagesc(Sv38)
	Images.save("myfile.png",img)
	
	
## Next Steps

EchoJulia is a work in progress with more functionality coming soon.

For more information, please contact Rob Blackwell at roback28@bas.ac.uk
