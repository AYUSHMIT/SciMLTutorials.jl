#===
# 🦠 Epidemics in Motion: A SEIR Modeling Story
**From Basic Models to Policy Analysis**

📝 **Description**: Narrative-driven exploration of epidemic modeling using the SEIR framework  
⏱️ **Duration**: 45 minutes  
📚 **Prerequisites**: Basic ODE knowledge, understanding of epidemiology concepts  
🎯 **Learning Outcomes**:
- Build and solve SEIR epidemic models
- Estimate parameters from noisy data
- Implement policy interventions with callbacks
- Quantify uncertainty with ensemble simulations
===#

using DifferentialEquations
using Plots
using Optimization
using OptimizationOptimJL
using Statistics
using Random

#===
## Chapter 1: Building the Basic SEIR Model

The SEIR model divides the population into four compartments:
- **S**: Susceptible - can catch the disease
- **E**: Exposed - infected but not yet infectious
- **I**: Infected - can transmit the disease
- **R**: Recovered - immune to reinfection

The dynamics are governed by:
```
dS/dt = -β * S * I / N
dE/dt = β * S * I / N - σ * E
dI/dt = σ * E - γ * I
dR/dt = γ * I
```

Where:
- β: transmission rate (contacts × probability of transmission)
- σ: progression rate (1/incubation period)
- γ: recovery rate (1/infectious period)
- N: total population
===#

function seir!(du, u, p, t)
    S, E, I, R = u
    β, σ, γ, N = p
    
    # Force of infection
    λ = β * I / N
    
    # SEIR dynamics
    du[1] = -λ * S           # Susceptible → Exposed
    du[2] = λ * S - σ * E    # Exposed → Infected
    du[3] = σ * E - γ * I    # Infected → Recovered
    du[4] = γ * I            # Recovered
end

# Parameters for a COVID-19-like disease
N = 1_000_000              # Population size
β = 0.5                    # Transmission rate (per day)
σ = 1/5.1                  # Incubation rate (5.1 day incubation)
γ = 1/14                   # Recovery rate (14 day infectious period)

# Calculate R₀ (basic reproduction number)
R₀ = β / γ
println("📊 Model Parameters:")
println("   Population: $(Int(N)) people")
println("   R₀ (Basic Reproduction Number): $(round(R₀, digits=2))")
println("   Incubation period: $(round(1/σ, digits=1)) days")
println("   Infectious period: $(round(1/γ, digits=1)) days")

# Initial conditions: 100 exposed, 10 infected
u₀ = [N - 110.0, 100.0, 10.0, 0.0]  # [S, E, I, R]
tspan = (0.0, 365.0)  # One year
p = [β, σ, γ, N]

# Solve the model
prob = ODEProblem(seir!, u₀, tspan, p)
sol = solve(prob, Tsit5())

println("\n✓ Model solved successfully!")
println("   Peak infections: $(Int(maximum(sol[3,:]))) people")
println("   Day of peak: $(round(sol.t[argmax(sol[3,:])], digits=1))")
println("   Final recovered: $(round(sol[4,end]/N*100, digits=1))% of population")

# Visualize the epidemic curve
plot(sol, 
     labels=["Susceptible" "Exposed" "Infected" "Recovered"],
     title="SEIR Model: Uncontrolled Epidemic",
     xlabel="Days",
     ylabel="Number of People",
     lw=3,
     linecolor=[:blue :purple :red :green],
     size=(1000, 600),
     legend=:right)

savefig("../../visualizations/gallery_images/seir_basic.png")

#===
## Chapter 2: Parameter Estimation from Noisy Data

In reality, we don't know β, σ, γ precisely. We must estimate them from data!

Let's simulate some noisy observations and recover the parameters.
===#

println("\n" * "="^60)
println("Chapter 2: Estimating Parameters from Data")
println("="^60)

# Generate synthetic "observed" data with noise
Random.seed!(42)
times_obs = 0:7:365  # Weekly observations
sol_true = solve(prob, Tsit5(), saveat=times_obs)

# Add 10% noise to infected counts
I_observed = sol_true[3,:] .* (1 .+ 0.1 * randn(length(times_obs)))
I_observed = max.(I_observed, 0.0)  # Ensure non-negative

# Define loss function for optimization
function loss(p_opt, data)
    β_opt, σ_opt, γ_opt = p_opt
    
    # Ensure parameters are positive
    if any(p_opt .<= 0)
        return Inf
    end
    
    # Solve with candidate parameters
    prob_opt = remake(prob, p=[β_opt, σ_opt, γ_opt, N])
    sol_opt = solve(prob_opt, Tsit5(), saveat=times_obs, 
                    sensealg=ForwardDiffSensitivity())
    
    # Return Inf if solver failed
    if sol_opt.retcode != :Success
        return Inf
    end
    
    # Mean squared error on infected counts
    I_predicted = sol_opt[3,:]
    return sum((I_predicted .- I_observed).^2) / length(I_observed)
end

# Initial guess (deliberately wrong)
p_init = [0.3, 1/7.0, 1/10.0]  # β, σ, γ

println("\n🔍 Starting parameter estimation...")
println("   Initial guess: β=$(p_init[1]), σ=$(p_init[2]), γ=$(p_init[3])")
println("   True values:   β=$(β), σ=$(σ), γ=$(γ)")

# Optimize to find best parameters
opt_prob = OptimizationProblem(loss, p_init, I_observed)
opt_sol = solve(opt_prob, NelderMead())

β_est, σ_est, γ_est = opt_sol.u

println("\n✓ Parameter estimation complete!")
println("   Estimated: β=$(round(β_est, digits=3)), σ=$(round(σ_est, digits=4)), γ=$(round(γ_est, digits=4))")
println("   Relative errors:")
println("      β: $(round(abs(β_est - β)/β * 100, digits=1))%")
println("      σ: $(round(abs(σ_est - σ)/σ * 100, digits=1))%")
println("      γ: $(round(abs(γ_est - γ)/γ * 100, digits=1))%")

# Compare true vs estimated
prob_est = remake(prob, p=[β_est, σ_est, γ_est, N])
sol_est = solve(prob_est, Tsit5())

p1 = plot(sol, vars=3, label="True Model", lw=3, color=:red)
scatter!(times_obs, I_observed, label="Observations", color=:black, ms=4)
plot!(sol_est, vars=3, label="Estimated Model", lw=3, ls=:dash, color=:blue)
title!("Parameter Recovery from Noisy Data")
xlabel!("Days")
ylabel!("Infected")

savefig(p1, "../../visualizations/gallery_images/seir_parameter_estimation.png")

#===
## Chapter 3: Policy Interventions with Callbacks

What if we implement a lockdown when infections reach 10,000?
We can use callbacks to modify parameters mid-simulation!
===#

println("\n" * "="^60)
println("Chapter 3: Simulating Policy Interventions")
println("="^60)

# Callback: When I > 10,000, reduce β by 70% (lockdown)
function intervention_condition(u, t, integrator)
    u[3] > 10_000  # Trigger when Infected > 10,000
end

function intervention_affect!(integrator)
    # Reduce transmission rate by 70%
    integrator.p[1] *= 0.3
    println("   🔒 Lockdown implemented at day $(round(integrator.t, digits=1))")
    println("      New transmission rate: $(round(integrator.p[1], digits=3))")
end

cb_intervention = DiscreteCallback(intervention_condition, intervention_affect!)

# Solve with intervention
prob_intervention = remake(prob, p=[β, σ, γ, N])
sol_intervention = solve(prob_intervention, Tsit5(), callback=cb_intervention)

println("\n✓ Intervention simulation complete!")
println("   Without intervention - Peak: $(Int(maximum(sol[3,:])))")
println("   With intervention    - Peak: $(Int(maximum(sol_intervention[3,:])))")
println("   Lives potentially saved: $(Int(maximum(sol[3,:]) - maximum(sol_intervention[3,:])))")

# Compare scenarios
p2 = plot(sol, vars=3, label="No Intervention", lw=3, color=:red)
plot!(sol_intervention, vars=3, label="With Lockdown", lw=3, color=:green)
hline!([10_000], label="Intervention Threshold", ls=:dash, color=:black)
title!("Impact of Policy Intervention")
xlabel!("Days")
ylabel!("Infected")
ylims!(0, maximum(sol[3,:]) * 1.1)

savefig(p2, "../../visualizations/gallery_images/seir_intervention.png")

#===
## Chapter 4: Uncertainty Quantification with Ensembles

Parameters aren't exact - there's uncertainty! 
Let's run an ensemble to see the range of possibilities.
===#

println("\n" * "="^60)
println("Chapter 4: Quantifying Uncertainty")
println("="^60)

# Function to generate parameter perturbations
function prob_func(prob, i, repeat)
    # Add ±20% noise to parameters
    β_pert = β * (1 + 0.2 * (2*rand() - 1))
    σ_pert = σ * (1 + 0.2 * (2*rand() - 1))
    γ_pert = γ * (1 + 0.2 * (2*rand() - 1))
    
    remake(prob, p=[β_pert, σ_pert, γ_pert, N])
end

# Create ensemble problem
ensemble_prob = EnsembleProblem(prob, prob_func=prob_func)

println("\n🔄 Running ensemble of 100 simulations...")
ensemble_sol = solve(ensemble_prob, Tsit5(), EnsembleThreads(), trajectories=100)

# Extract infected trajectories
I_trajectories = [sol[3,:] for sol in ensemble_sol]

# Calculate statistics
I_mean = mean(I_trajectories)
I_std = std(I_trajectories)
I_lower = I_mean .- 2*I_std
I_upper = I_mean .+ 2*I_std

println("✓ Ensemble complete!")
println("   Mean peak infections: $(Int(maximum(I_mean)))")
println("   Range: $(Int(maximum(I_lower))) - $(Int(maximum(I_upper)))")

# Plot uncertainty bands
times = ensemble_sol[1].t
p3 = plot(times, I_mean, ribbon=(I_mean .- I_lower, I_upper .- I_mean),
         fillalpha=0.3,
         label="Mean ± 2σ",
         lw=3,
         color=:red,
         title="Epidemic Forecast with Uncertainty",
         xlabel="Days",
         ylabel="Infected",
         size=(1000, 600))

savefig(p3, "../../visualizations/gallery_images/seir_uncertainty.png")

#===
## Epilogue: Interactive Web Simulator

Want to explore more scenarios interactively?

Open `interactive_seir.html` in your browser to:
- Adjust β, σ, γ with sliders
- See real-time plot updates
- Try different intervention timings
- Export your scenarios to CSV

No Julia installation needed - it's pure JavaScript!
===#

println("\n" * "="^60)
println("🎉 Congratulations! Story Complete!")
println("="^60)
println("\n📊 Key Insights:")
println("   1. SEIR models capture epidemic dynamics with 4 compartments")
println("   2. Parameters can be estimated from real data")
println("   3. Interventions dramatically change outcomes")
println("   4. Uncertainty quantification is crucial for policy")
println("\n🌐 Next Steps:")
println("   • Open 'interactive_seir.html' for hands-on exploration")
println("   • Try 'policy_simulator.jl' for more intervention strategies")
println("   • Explore '03_interactive_stories/climate_chronicles/' next!")
println("\n" * "="^60)

# Create final summary visualization
p_summary = plot(p1, p2, p3, layout=(3,1), size=(1000, 1200))
savefig(p_summary, "../../visualizations/gallery_images/seir_complete_story.png")
println("\n✓ All visualizations saved to visualizations/gallery_images/")
