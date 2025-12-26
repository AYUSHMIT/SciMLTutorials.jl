#===
# 🎨 Chaos Art Gallery: Strange Attractors
**Visualizing the Beauty of Chaos**

📝 **Description**: Generate stunning visualizations of chaotic dynamical systems  
⏱️ **Duration**: 20 minutes  
📚 **Prerequisites**: Basic ODE knowledge  
🎯 **Learning Outcomes**:
- Understand strange attractors and chaos
- Create publication-quality visualizations
- Explore different chaotic systems
- Generate art from mathematics
===#

using DifferentialEquations
using Plots
using ColorSchemes

#===
## The Lorenz Attractor

Perhaps the most famous strange attractor, discovered by Edward Lorenz in 1963
while studying atmospheric convection.

The butterfly effect: tiny changes in initial conditions lead to vastly
different trajectories!
===#

function lorenz!(du, u, p, t)
    σ, ρ, β = p
    du[1] = σ * (u[2] - u[1])
    du[2] = u[1] * (ρ - u[3]) - u[2]
    du[3] = u[1] * u[2] - β * u[3]
end

println("🌀 Generating Lorenz Attractor...")

# Solve with long integration time for detailed structure
u₀ = [1.0, 0.0, 0.0]
tspan = (0.0, 100.0)
p_lorenz = (10.0, 28.0, 8/3)

prob_lorenz = ODEProblem(lorenz!, u₀, tspan, p_lorenz)
sol_lorenz = solve(prob_lorenz, Tsit5(), saveat=0.01)

# Art Mode: Beautiful 3D visualization
p1 = plot(sol_lorenz, vars=(1,2,3),
         title="Lorenz Attractor",
         label="",
         lw=0.5,
         linecolor=:viridis,
         background_color=:black,
         foreground_color=:white,
         size=(1200, 900),
         camera=(30, 45),
         dpi=300)

savefig(p1, "../../visualizations/gallery_images/chaos_lorenz.png")
println("✓ Lorenz attractor saved")

#===
## The Rössler Attractor

A simpler chaotic system with a distinctive single-lobed structure,
discovered by Otto Rössler in 1976.
===#

function rossler!(du, u, p, t)
    a, b, c = p
    du[1] = -u[2] - u[3]
    du[2] = u[1] + a * u[2]
    du[3] = b + u[3] * (u[1] - c)
end

println("\n🔄 Generating Rössler Attractor...")

u₀ = [1.0, 1.0, 1.0]
p_rossler = (0.2, 0.2, 5.7)

prob_rossler = ODEProblem(rossler!, u₀, tspan, p_rossler)
sol_rossler = solve(prob_rossler, Tsit5(), saveat=0.01)

p2 = plot(sol_rossler, vars=(1,2,3),
         title="Rössler Attractor",
         label="",
         lw=0.5,
         linecolor=:plasma,
         background_color=:black,
         foreground_color=:white,
         size=(1200, 900),
         camera=(45, 30),
         dpi=300)

savefig(p2, "../../visualizations/gallery_images/chaos_rossler.png")
println("✓ Rössler attractor saved")

#===
## The Rabinovich-Fabrikant Attractor

A beautiful attractor arising from wave dynamics in plasma.
Features intricate folding patterns.
===#

function rabinovich_fabrikant!(du, u, p, t)
    α, γ = p
    du[1] = u[2] * (u[3] - 1 + u[1]^2) + γ * u[1]
    du[2] = u[1] * (3 * u[3] + 1 - u[1]^2) + γ * u[2]
    du[3] = -2 * u[3] * (α + u[1] * u[2])
end

println("\n✨ Generating Rabinovich-Fabrikant Attractor...")

u₀ = [-1.0, 0.0, 0.5]
p_rf = (0.14, 0.1)
tspan_rf = (0.0, 200.0)

prob_rf = ODEProblem(rabinovich_fabrikant!, u₀, tspan_rf, p_rf)
sol_rf = solve(prob_rf, Tsit5(), saveat=0.05)

p3 = plot(sol_rf, vars=(1,2,3),
         title="Rabinovich-Fabrikant Attractor",
         label="",
         lw=0.5,
         linecolor=:twilight,
         background_color=:black,
         foreground_color=:white,
         size=(1200, 900),
         camera=(60, 30),
         dpi=300)

savefig(p3, "../../visualizations/gallery_images/chaos_rabinovich_fabrikant.png")
println("✓ Rabinovich-Fabrikant attractor saved")

#===
## The Thomas Attractor

A dissipative system with time-reversal symmetry, creating
an elegant cyclic structure.
===#

function thomas!(du, u, p, t)
    b = p[1]
    du[1] = sin(u[2]) - b * u[1]
    du[2] = sin(u[3]) - b * u[2]
    du[3] = sin(u[1]) - b * u[3]
end

println("\n🔮 Generating Thomas Attractor...")

u₀ = [0.1, 0.0, 0.0]
p_thomas = [0.208186]
tspan_thomas = (0.0, 500.0)

prob_thomas = ODEProblem(thomas!, u₀, tspan_thomas, p_thomas)
sol_thomas = solve(prob_thomas, Tsit5(), saveat=0.1)

p4 = plot(sol_thomas, vars=(1,2,3),
         title="Thomas Attractor",
         label="",
         lw=0.5,
         linecolor=:inferno,
         background_color=:black,
         foreground_color=:white,
         size=(1200, 900),
         camera=(45, 45),
         dpi=300)

savefig(p4, "../../visualizations/gallery_images/chaos_thomas.png")
println("✓ Thomas attractor saved")

#===
## Gallery View: All Attractors Together
===#

println("\n🖼️  Creating gallery view...")

# Create a 2x2 gallery
p_gallery = plot(p1, p2, p3, p4, 
                layout=(2,2), 
                size=(2400, 1800),
                dpi=300)

savefig(p_gallery, "../../visualizations/gallery_images/chaos_gallery_complete.png")
println("✓ Complete gallery saved")

#===
## Time-Based Coloring: Visualize Evolution

Color the trajectory by time to see how the system evolves.
Earlier times in blue, later times in red.
===#

println("\n🌈 Creating time-evolution visualizations...")

# Lorenz with time coloring
times = sol_lorenz.t
colors = range(1, length(times), length=length(times))

p_time = scatter3d(sol_lorenz[1,:], sol_lorenz[2,:], sol_lorenz[3,:],
                  marker_z=colors,
                  markersize=1.5,
                  markerstrokewidth=0,
                  color=:RdYlBu,
                  title="Lorenz: Time Evolution",
                  label="",
                  background_color=:black,
                  foreground_color=:white,
                  colorbar_title="Time",
                  size=(1200, 900),
                  camera=(30, 45),
                  dpi=300)

savefig(p_time, "../../visualizations/gallery_images/chaos_lorenz_time.png")
println("✓ Time-evolution visualization saved")

#===
## Summary Statistics
===#

println("\n" * "="^60)
println("📊 Chaos Gallery Summary")
println("="^60)

println("\nLorenz Attractor:")
println("  Parameters: σ=$(p_lorenz[1]), ρ=$(p_lorenz[2]), β=$(p_lorenz[3])")
println("  Integration time: $(tspan[2]) time units")
println("  Points plotted: $(length(sol_lorenz.t))")

println("\nRössler Attractor:")
println("  Parameters: a=$(p_rossler[1]), b=$(p_rossler[2]), c=$(p_rossler[3])")
println("  Points plotted: $(length(sol_rossler.t))")

println("\nRabinovich-Fabrikant Attractor:")
println("  Parameters: α=$(p_rf[1]), γ=$(p_rf[2])")
println("  Points plotted: $(length(sol_rf.t))")

println("\nThomas Attractor:")
println("  Parameters: b=$(p_thomas[1])")
println("  Points plotted: $(length(sol_thomas.t))")

println("\n✨ All visualizations saved to:")
println("   visualizations/gallery_images/")

#===
## What Makes These "Strange"?

Strange attractors have three key properties:

1. **Fractal Structure**: They have non-integer dimensions
2. **Sensitivity**: Nearby trajectories diverge exponentially
3. **Boundedness**: All trajectories stay in a bounded region

These systems are:
- **Deterministic**: No randomness, equations are precise
- **Chaotic**: Long-term prediction is impossible
- **Beautiful**: The patterns are endlessly fascinating!

## Applications

Strange attractors appear in:
- Weather prediction (Lorenz's original motivation)
- Population dynamics
- Chemical reactions
- Electronic circuits
- Heart rhythms
- Turbulent fluid flow
- Climate models

## Further Exploration

Try modifying the parameters! Small changes can lead to:
- Different attractors
- Periodic orbits
- Escape to infinity
- Period-doubling cascades

Example modifications to try:
```julia
# Lorenz: Try ρ = 13, 15, 21, 24.06, 99.65
# Rössler: Try c = 2, 3, 4, 6
# Each gives a different behavior!
```

## Next Steps

- **08_creative_explorations/art_from_equations/reaction_diffusion_art.jl** - Turing patterns
- **08_creative_explorations/art_from_equations/generative_ode_art.jl** - AI + physics art
- **08_creative_explorations/music_of_differential_equations/** - Turn chaos into music!

🎨 **Happy creating!** 🎨
===#

println("\n" * "="^60)
println("🎉 Chaos Gallery Complete!")
println("="^60)
println("\n💡 Tips for Creating Your Own Chaos Art:")
println("   1. Try different parameter values")
println("   2. Use black backgrounds for dramatic effect")
println("   3. Experiment with color schemes (`:plasma`, `:viridis`, `:twilight`)")
println("   4. Adjust camera angles for best views")
println("   5. Use high DPI (300+) for print-quality images")
println("\n🌌 The universe is chaotic and beautiful! 🌌")
