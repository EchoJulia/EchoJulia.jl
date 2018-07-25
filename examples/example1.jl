Pkg.add("EchoJulia")
using EchoJulia
raw = SimradRaw.load(EK60_SAMPLE)
cal = EchoviewEcs.load(ECS_SAMPLE)
data = transform(raw, calibration=cal)
eg(data["Sv120"], range = maximum(data["r120"]), cmap=EK500, vmin=-95, vmax=-50)
