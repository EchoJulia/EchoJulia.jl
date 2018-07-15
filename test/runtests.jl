using EchoJulia

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

Pkg.test("SimradRaw")
Pkg.test("SimradEK60")
Pkg.test("EchoviewEvr")
Pkg.test("EchoviewEcs")
