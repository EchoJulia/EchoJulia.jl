# __precompile__()
module EchoJulia

using Reexport

export transform

@reexport using SimradRaw
@reexport using SimradEK60
@reexport using EchogramPyPlot
@reexport using EchogramImages
@reexport using EchoviewEvr
@reexport using EchoviewEcs
@reexport using SimradEK60TestData


function between(p, starttime, endtime)

    if starttime == nothing
        starttime = p.filetime
    end

    if endtime == nothing
        endtime = p.filetime
    end

    starttime <= p.filetime <= endtime
    
end

function transform(datagrams::Vector{SimradRaw.Datagram}; calibration=nothing, starttime=nothing, endtime=nothing)
    ps = collect(pings(datagrams))
    transform(ps, calibration=calibration, starttime=nothing, endtime=nothing)
end

function transform(ps::Vector{SimradEK60.EK60Ping}; calibration=nothing, starttime=nothing, endtime=nothing)

    transducers= []
    if calibration != nothing
        transducers = calibration
    end

    ps = [p for p in ps if between(p, starttime, endtime)]
    
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
        dict["r$fr"] = R(psf, soundvelocity=soundvelocity)
        dict["t$fr"] = SimradEK60.filetime(psf) # timestamps

        if gain != nothing
            dict["gain$fr"] = gain
        else
            dict["gain$fr"] = [x.gain for x in psf]
        end
        if equivalentbeamangle != nothing
            dict["equivalentbeamangle$fr"]= equivalentbeamangle
        else
            dict["equivalentbeamangle$fr"]= [x.equivalentbeamangle for x in psf]
        end
        if soundvelocity != nothing
            dict["soundvelocity$fr"]= soundvelocity
        else
            dict["soundvelocity$fr"]=  [x.soundvelocity for x in psf]
        end
        if absorptioncoefficient != nothing
            dict["absorptioncoefficient$fr"] = absorptioncoefficient
        else
            dict["absorptioncoefficient$fr"] = [x.absorptioncoefficient for x in psf]
        end
        if transmitpower != nothing
            dict["transmitpower$fr"] = transmitpower
        else
            dict["transmitpower$fr"] = [x.transmitpower for x in psf]
        end
        if pulselength != nothing
            dict["pulselength$fr"] = pulselength
        else
            dict["pulselength$fr"] = [x.pulselength for x in psf]
        end
        if sacorrection != nothing
            dict["sacorrection$fr"] = sacorrection
        else
            dict["sacorrection$fr"] =[x.sacorrection for x in psf]
        end

        dict["sampleinterval$fr"] =[x.sampleinterval for x in psf]
        
        index +=1
    end

    dict["DESCR"] = "Converted by EchoJulia."

    return dict
end



end # module
