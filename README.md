# EchoJulia

Meta package that loads all the EchoJulia related packages for a
"batteries included" hydroacoustic processing and analysis
environment.

## Example

    using EchoJulia
    filename = EK60_SAMPLE
    ps = pings(filename)
    ps38 = [p for p in ps if p.frequency == 38000]
    Sv38 = Sv(ps38)
    img = imagesc(Sv38)
