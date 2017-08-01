import modelA

module Testing

using modelA
using PyPlot
ion()

W_0 = 0.50      # Derivative constant
a2 = -1.0       # Second order constant
a4 = 1.0        # Fourth order constant
M = 1.0         # Mobility
kbT = 0.4       # Temperature (for noise)

dx = 0.8        # Lattice spacing
dt = 0.1        # Time step size

# Initial Conditions
N = 500
ϕ = 0.5*randn(500, 500)


mod = model(W_0, a2, a4, M, kbT)
par = parameters(dx, dt)

c = imshow(ϕ)
plt[:colorbar]()

for x in 1:1000
    step!(ϕ, mod, par)
    c[:set_data](ϕ)
    draw()
    println(x)
end


end
