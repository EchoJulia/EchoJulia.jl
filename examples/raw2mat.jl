#!/usr/bin/env julia

using EchoJulia
using MAT

# Finds raw files and converts them to MATLAB files optionally using
# an Echoview calibration supplement for correction.

function main(args)

    transducers= []
   
    if args[1] == "-c" # Echoview calibration supplement
        filename = args[2]
        transducers = load(filename)
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
        info("Processing $filename ...")
        ps = collect(pings(filename))

        frequencies = unique([p.frequency for p in ps])
  
        dict = Dict()

        index = 1
        for f in frequencies
            fr = trunc(Int,f / 1000)
            psf = [p for p in ps if p.frequency == f]

            gain = nothing
            equivalentbeamangle = nothing
            soundvelocity =  nothing
            absorptioncoefficient = nothing
            transmitpower = nothing
            pulselength = nothing
            sacorrection = nothing

            if length(transducers) >= index
                transducer = transducers[index]
                gain = get(transducer, "Ek60TransducerGain", nothing)
                equivalentbeamangle = get(transducer,"TwoWayBeamAngle", nothing)
                soundvelocity=  get(transducer,"SoundSpeed", nothing)
                absorptioncoefficient= get(transducer,"AbsorptionCoefficient", nothing)
                transmitpower= get(transducer,"TransmittedPower", nothing)
                pulselength= get(transducer,"TransmittedPulseLength", nothing)
                sacorrection= get(transducer,"EK60SaCorrection", nothing)
                if pulselength != nothing
                    pulselength = pulselength / 1000
                end
            end
            

            dict["Sv$fr"] = SimradEK60.Sv(psf,
                                   gain=gain,
                                   equivalentbeamangle=equivalentbeamangle,
                                   soundvelocity=soundvelocity,
                                   absorptioncoefficient=absorptioncoefficient,
                                   transmitpower=transmitpower,
                                   pulselength=pulselength,
                                   sacorrection=sacorrection);


            dict["ntheta$fr"] = alongshipangle(psf)
            dict["nphi$fr"] = athwartshipangle(psf)
            dict["R$fr"] = R(psf, soundvelocity=soundvelocity)
            dict["t$fr"] = SimradEK60.filetime(psf) # timestamps

            if gain != nothing
                dict["gain$fr"] = gain
            end
            if equivalentbeamangle != nothing
                dict["equivalentbeamangle$fr"]= equivalentbeamangle
            end
            if soundvelocity != nothing
                dict["soundvelocity$fr"]= soundvelocity
            end
            if absorptioncoefficient != nothing
                dict["absorptioncoefficient$fr"] = absorptioncoefficient
            end
            if transmitpower != nothing
                dict["transmitpower$fr"] = transmitpower
            end
            if pulselength != nothing
                dict["pulselength$fr"] = pulselength
            end
            if sacorrection != nothing
                dict["sacorrection$fr"] = sacorrection
            end

            index +=1
        end

        dict["DESCR"] = "Converted from $filename by EchoJulia."

        out ="$(basename(filename)).mat"
        info("Writing $out ...")
        matwrite(out, dict)

    end
    
    
end

main(ARGS)
