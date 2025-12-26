# 🤝 Contribution Guide

Welcome to the SciML Exploratory Showcase! We're excited that you want to contribute. This guide will help you add your own tutorials and improvements.

## 📋 Table of Contents

1. [Getting Started](#getting-started)
2. [Tutorial Structure](#tutorial-structure)
3. [Adding a New Tutorial](#adding-a-new-tutorial)
4. [Code Style Guidelines](#code-style-guidelines)
5. [Visualization Standards](#visualization-standards)
6. [Testing Your Tutorial](#testing-your-tutorial)
7. [Submitting a Pull Request](#submitting-a-pull-request)

## 🚀 Getting Started

### Prerequisites

- Julia 1.10 or higher
- Git for version control
- A GitHub account
- Familiarity with DifferentialEquations.jl (for most tutorials)

### Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR-USERNAME/SciMLTutorials.jl.git
cd SciMLTutorials.jl
```

### Set Up Development Environment

```julia
using Pkg
Pkg.activate("tutorials/exploratory_showcase")
Pkg.instantiate()
```

## 📝 Tutorial Structure

Each tutorial should follow this template:

```julia
#===
# 📊 Tutorial Title
**Brief Subtitle**

📝 **Description**: One-line description of what this tutorial covers
⏱️ **Duration**: Estimated time in minutes
📚 **Prerequisites**: What learners should know beforehand
🎯 **Learning Outcomes**:
- First thing learners will achieve
- Second outcome
- Third outcome
===#

using DifferentialEquations
using Plots
# ... other dependencies

#===
## Section 1: Introduction

Explain the concept or problem being addressed.
Use clear, accessible language.
===#

# Code goes here
println("✓ Section complete!")

#===
## Section 2: Implementation

Show the implementation step by step.
===#

# More code

#===
## Section 3: Visualization

Always include beautiful visualizations!
===#

plot(...)  # Create your visualization
savefig("../../visualizations/gallery_images/your_tutorial_name.png")

#===
## Summary

- Key takeaway 1
- Key takeaway 2
- Links to related tutorials
===#
```

## ➕ Adding a New Tutorial

### 1. Choose the Right Category

Place your tutorial in the appropriate folder:

- `01_the_sciml_journey/` - Introductory content
- `02_visual_cookbook/` - Visualization-focused examples
- `03_interactive_stories/` - Narrative tutorials
- `04_technique_deep_dives/` - Advanced techniques
- `05_neural_sciml_gallery/` - ML + physics content
- `06_performance_art/` - Performance optimization
- `08_creative_explorations/` - Art, music, games
- `10_community_hub/` - Community contributions

### 2. Create Your Tutorial File

```bash
cd tutorials/exploratory_showcase/YOUR_CATEGORY
touch your_tutorial_name.jl
```

### 3. Add Dependencies to Project.toml

If your tutorial needs new packages:

```bash
cd tutorials/exploratory_showcase/YOUR_CATEGORY
julia --project=. -e 'using Pkg; Pkg.add("NewPackage")'
```

### 4. Write Your Tutorial

Follow the template above. Key points:

- **Start simple**, build complexity gradually
- **Explain why**, not just how
- **Visualize** everything you can
- **Include timings** for long computations
- **Add comments** explaining non-obvious code
- **Link** to related tutorials

## 🎨 Code Style Guidelines

### Julia Style

Follow the [SciML Style Guide](https://github.com/SciML/SciMLStyle):

```julia
# Good: descriptive names, clear structure
function solve_epidemic_model(β, γ, N, initial_infected)
    # Implementation
end

# Bad: unclear names
function f(x, y, z, w)
    # Implementation
end
```

### Documentation

Always include:

```julia
#===
Clear explanation of what this code block does.

Can include:
- Mathematical equations: dS/dt = -βSI/N
- References to papers or resources
- Warnings about common pitfalls
===#
```

### Progress Indicators

For long-running code:

```julia
println("🔄 Running expensive computation...")
@time result = expensive_function()
println("✓ Complete! Result: $result")
```

## 📊 Visualization Standards

### Plot Requirements

- **Resolution**: Minimum 1920×1080 for key figures
- **Color Scheme**: Use Julia colors or accessible palettes
- **Labels**: Always label axes, include units
- **Legend**: Include when multiple series
- **Title**: Descriptive and informative

### Example

```julia
plot(sol, 
     title="SEIR Epidemic Model",
     xlabel="Time (days)",
     ylabel="Population",
     labels=["Susceptible" "Exposed" "Infected" "Recovered"],
     lw=3,
     size=(1200, 800),
     dpi=300)
     
savefig("../../visualizations/gallery_images/seir_model.png")
```

### Color Palette

Use Julia theme colors:

```julia
:julia_purple  # #9558B2
:julia_green   # #389826
:julia_red     # #CB3C33
:julia_blue    # #4063D8
```

Or accessible scientific palettes:

```julia
:viridis   # Default, colorblind-friendly
:plasma
:twilight
:RdYlBu
```

## 🧪 Testing Your Tutorial

### 1. Run Locally

```julia
include("tutorials/exploratory_showcase/YOUR_CATEGORY/your_tutorial.jl")
```

Verify:
- ✅ No errors
- ✅ Visualizations generate correctly
- ✅ Output is clear and helpful
- ✅ Timing is reasonable (< 5 minutes for most tutorials)

### 2. Check Outputs

Verify that visualizations are saved:

```bash
ls -lh tutorials/exploratory_showcase/visualizations/gallery_images/
```

### 3. Test on Fresh Environment

```julia
using Pkg
Pkg.activate("tutorials/exploratory_showcase/YOUR_CATEGORY")
Pkg.instantiate()
include("your_tutorial.jl")
```

## 📤 Submitting a Pull Request

### 1. Create a Branch

```bash
git checkout -b add-tutorial-your-name
```

### 2. Commit Your Changes

```bash
git add tutorials/exploratory_showcase/YOUR_CATEGORY/your_tutorial.jl
git add tutorials/exploratory_showcase/YOUR_CATEGORY/Project.toml
git commit -m "Add tutorial: Your Tutorial Name

- Brief description of what the tutorial covers
- Key features or techniques demonstrated
"
```

### 3. Push and Open PR

```bash
git push origin add-tutorial-your-name
```

Then open a pull request on GitHub with:

**Title**: `Add tutorial: Your Tutorial Name`

**Description**:
```markdown
## Summary
Brief description of the tutorial and what it teaches.

## Category
Which category/folder it belongs in.

## Learning Outcomes
- Outcome 1
- Outcome 2

## Checklist
- [ ] Tutorial runs without errors
- [ ] Follows code style guidelines
- [ ] Includes visualizations
- [ ] Has clear documentation
- [ ] Project.toml updated
- [ ] Tested in fresh environment

## Preview
[Optional: Include a screenshot or plot]
```

## 💡 Tips for Great Tutorials

### Do's ✅

- **Tell a story**: Make it engaging and narrative
- **Show, don't tell**: Visualize concepts
- **Build gradually**: Start simple, add complexity
- **Link concepts**: Connect to other tutorials
- **Be encouraging**: Celebrate small wins with println("✓")
- **Cite sources**: Reference papers, packages, techniques

### Don'ts ❌

- **Don't assume knowledge**: Explain prerequisites
- **Don't skip steps**: Show intermediate results
- **Don't use jargon**: Define technical terms
- **Don't make it too long**: Break into multiple tutorials if needed
- **Don't forget error handling**: Show what can go wrong

## 📚 Resources

- [SciML Documentation](https://docs.sciml.ai/)
- [DifferentialEquations.jl Docs](https://docs.sciml.ai/DiffEqDocs/stable/)
- [Plots.jl Documentation](https://docs.juliaplots.org/)
- [Julia Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/)

## 🤝 Getting Help

- **Questions**: [Julia Discourse](https://discourse.julialang.org/)
- **Real-time help**: [Zulip Chat](https://julialang.zulipchat.com/)
- **Issues**: [GitHub Issues](https://github.com/AYUSHMIT/SciMLTutorials.jl/issues)

## 🎉 Thank You!

Your contributions make SciML better for everyone. We appreciate your time and effort!

---

**Happy Contributing! 🚀**
