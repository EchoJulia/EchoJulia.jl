using EchoJulia

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

x = transform(SimradRaw.load(EK60_SAMPLE))

@test length(x["t38"]) == 572

x = transform(SimradRaw.load(EK60_SAMPLE), starttime = 129053535177200000)

@test length(x["t38"]) == 391
