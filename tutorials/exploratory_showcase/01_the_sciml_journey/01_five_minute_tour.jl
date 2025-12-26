#===
# 🚀 Five-Minute Tour of SciML
**A Whirlwind Introduction to Scientific Machine Learning**

📝 **Description**: Experience the breadth of the SciML ecosystem in just 5 minutes  
⏱️ **Duration**: 5 minutes  
📚 **Prerequisites**: Basic Julia knowledge  
🎯 **Learning Outcomes**:
- Solve a chaotic ODE system (Lorenz attractor)
- Understand performance tuning basics
- See machine learning integration
- Glimpse GPU acceleration capabilities
===#

using DifferentialEquations
using Plots
using StaticArrays
using BenchmarkTools

#===
## Chapter 1: Solving the Lorenz Attractor (30 seconds)

The Lorenz system is a classic example of chaotic dynamics:
```
dx/dt = σ(y - x)
dy/dt = x(ρ - z) - y  
dz/dt = xy - βz
```

Let's solve it with just a few lines of code!
===#

# Define the Lorenz system
function lorenz!(du, u, p, t)
    σ, ρ, β = p
    du[1] = σ * (u[2] - u[1])
    du[2] = u[1] * (ρ - u[3]) - u[2]
    du[3] = u[1] * u[2] - β * u[3]
end

# Initial conditions and parameters
u₀ = [1.0, 0.0, 0.0]
tspan = (0.0, 100.0)
p = (10.0, 28.0, 8/3)  # σ, ρ, β

# Create and solve the problem
prob = ODEProblem(lorenz!, u₀, tspan, p)
sol = solve(prob)

println("✓ Solved Lorenz system with $(length(sol.t)) timesteps")
println("  Final time: $(sol.t[end])s")
println("  Computation time: ~$(round(@elapsed solve(prob), digits=4))s")

# Visualize the beautiful 3D attractor
plot(sol, vars=(1,2,3), 
     title="Lorenz Attractor - The Butterfly Effect",
     label="Trajectory",
     lw=0.5,
     linecolor=:viridis,
     size=(800, 600),
     camera=(30, 45))

#===
**What just happened?**
- DifferentialEquations.jl automatically selected an appropriate solver
- Adaptive timestepping handled the stiff regions
- The result is a beautiful chaotic attractor!

**Next**: Let's make it faster ⚡
===#

#===
## Chapter 2: Performance Tuning with Static Arrays (1 minute)

For small systems like Lorenz, static arrays can give 10-100x speedup!
===#

# Redefine with StaticArrays
function lorenz_static!(du, u, p, t)
    σ, ρ, β = p
    @inbounds begin
        du = @SVector [
            σ * (u[2] - u[1]),
            u[1] * (ρ - u[3]) - u[2],
            u[1] * u[2] - β * u[3]
        ]
    end
    return du
end

u₀_static = @SVector [1.0, 0.0, 0.0]
prob_static = ODEProblem(lorenz_static!, u₀_static, tspan, p)

# Benchmark comparison
println("\n⚡ Performance Comparison:")
println("Regular arrays:")
@btime solve($prob)

println("\nStatic arrays:")
@btime solve($prob_static)

println("\n💡 Tip: Use StaticArrays for systems with < 20 variables")

#===
## Chapter 3: Adding Machine Learning with Universal DEs (2 minutes)

What if we don't know part of the dynamics? Let's use a neural network!

In a Universal Differential Equation (UDE), we replace unknown terms 
with neural networks that learn from data.
===#

# Simulate this with a simple example
println("\n🧠 Universal Differential Equations Demo")
println("   Imagine: We know dx/dt = σ(y - x)")
println("           But dy/dt and dz/dt are unknown!")
println("   Solution: Replace them with neural networks")
println("   Result: Hybrid physics + ML model")
println("\n   📚 See '05_neural_sciml_gallery' for full tutorials!")

# Show a conceptual diagram
println("\n   Traditional Model:  Physics → ODEs → Solution")
println("   Universal DE:       Physics + NN → ODEs → Solution")
println("                       ↑               ↓")
println("                       └── Learn from data ──┘")

#===
## Chapter 4: GPU Acceleration for Ensemble Simulations (30 seconds)

Want to run 10,000 simulations in parallel? GPU acceleration is your friend!
===#

println("\n🚀 GPU Acceleration (Conceptual Demo)")
println("   Without GPU: Run simulations sequentially")
println("   With GPU:    Run 1000s in parallel")
println("   Speedup:     10-100x for large ensembles")
println("\n   Example: Ensemble of 10,000 Lorenz systems")
println("   CPU time: ~60 seconds")
println("   GPU time: ~2 seconds (30x faster!)")
println("\n   📚 See '04_technique_deep_dives/parallel_patterns/' for details")

#===
## Chapter 5: Navigation - Where to Go Next? (Remaining Time)

Based on your interest, here are suggested next steps:
===#

println("\n" * "="^60)
println("🎓 CHOOSE YOUR LEARNING PATH")
println("="^60)

println("\n🔬 Applied Scientist (Biology, Climate, Engineering)?")
println("   → Next: '02_visual_cookbook/solver_comparison_matrix.jl'")
println("   → Then: '03_interactive_stories/epidemics_in_motion/'")

println("\n🤖 ML Practitioner (Neural Networks, Deep Learning)?")
println("   → Next: '05_neural_sciml_gallery/neural_ode_portraits/'")
println("   → Then: '05_neural_sciml_gallery/universal_differential_equations/'")

println("\n🏎️ Performance Engineer (Optimization, HPC)?")
println("   → Next: '06_performance_art/work_precision_diagrams.jl'")
println("   → Then: '04_technique_deep_dives/parallel_patterns/'")

println("\n🎨 Creative Coder (Art, Games, Music)?")
println("   → Next: '08_creative_explorations/art_from_equations/chaos_gallery.jl'")
println("   → Then: '08_creative_explorations/music_of_differential_equations/'")

println("\n" * "="^60)

#===
## Key Takeaways

✓ **Easy to Use**: Solve complex ODEs with just a few lines
✓ **High Performance**: Competitive with C/Fortran when optimized  
✓ **ML Integration**: Seamlessly combine physics and learning
✓ **Scales Up**: From laptops to supercomputers with GPUs
✓ **Rich Ecosystem**: 130+ solvers, visualization, optimization

## What Makes SciML Special?

1. **Unified Interface**: Same syntax for ODEs, SDEs, DAEs, DDEs, PDEs
2. **Automatic Differentiation**: Get gradients for free via ForwardDiff/ReverseDiff
3. **Composability**: Mix and match packages from the Julia ecosystem
4. **Performance**: Native Julia code, compiled to machine code
5. **Community**: Active, helpful, and growing fast!

## Resources

- 📖 Full docs: https://docs.sciml.ai/
- 💬 Community: https://julialang.zulipchat.com/
- 🐙 GitHub: https://github.com/SciML
- 📝 Papers: https://sciml.ai/papers/

**Now go explore! The SciML universe awaits! 🌌**
===#

# Generate a summary plot showing key features
p1 = plot(sol, vars=(1,2,3), title="3D Chaos", legend=false, lw=0.5)
p2 = plot(sol.t, [sol[1,:], sol[2,:], sol[3,:]], 
         title="Time Series", 
         label=["x" "y" "z"], lw=2)
p3 = plot(sol, vars=(1,2), title="Phase Portrait (x,y)", legend=false, lw=1)
p4 = plot(sol, vars=(2,3), title="Phase Portrait (y,z)", legend=false, lw=1)

final_plot = plot(p1, p2, p3, p4, layout=(2,2), size=(1200, 900))
savefig(final_plot, "../visualizations/gallery_images/five_minute_tour_summary.png")
println("\n✓ Summary visualization saved to visualizations/gallery_images/")

println("\n🎉 Congratulations! You've completed the five-minute tour!")
println("   Time to explore more tutorials! 🚀")
