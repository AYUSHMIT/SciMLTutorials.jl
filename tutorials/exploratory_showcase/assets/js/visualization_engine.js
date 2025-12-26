// SciML Visualization Engine - Dynamic Plot Rendering
// Copyright (c) 2025 SciML

class VisualizationEngine {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    this.plotly = window.Plotly;
    this.currentPlot = null;
  }

  // Render a 3D Lorenz attractor
  renderLorenzAttractor(sigma = 10, rho = 28, beta = 8/3, dt = 0.01, steps = 10000) {
    const data = this.generateLorenzData(sigma, rho, beta, dt, steps);
    
    const trace = {
      x: data.x,
      y: data.y,
      z: data.z,
      mode: 'lines',
      type: 'scatter3d',
      line: {
        color: data.t,
        colorscale: 'Viridis',
        width: 2
      },
      name: 'Lorenz Attractor'
    };

    const layout = {
      title: 'Lorenz Attractor',
      scene: {
        xaxis: { title: 'X' },
        yaxis: { title: 'Y' },
        zaxis: { title: 'Z' },
        camera: {
          eye: { x: 1.5, y: 1.5, z: 1.5 }
        }
      },
      paper_bgcolor: 'rgba(0,0,0,0)',
      plot_bgcolor: 'rgba(0,0,0,0)',
      font: { color: '#2c3e50' }
    };

    if (this.plotly) {
      this.plotly.newPlot(this.container, [trace], layout, { responsive: true });
      this.currentPlot = 'lorenz';
    }
  }

  generateLorenzData(sigma, rho, beta, dt, steps) {
    const x = [1.0], y = [1.0], z = [1.0], t = [0];
    
    for (let i = 1; i < steps; i++) {
      const dx = sigma * (y[i-1] - x[i-1]);
      const dy = x[i-1] * (rho - z[i-1]) - y[i-1];
      const dz = x[i-1] * y[i-1] - beta * z[i-1];
      
      x.push(x[i-1] + dx * dt);
      y.push(y[i-1] + dy * dt);
      z.push(z[i-1] + dz * dt);
      t.push(i * dt);
    }
    
    return { x, y, z, t };
  }

  // Render SEIR epidemic curves
  renderSEIRModel(params) {
    const { beta, sigma, gamma, N, E0, I0, R0, days } = params;
    const data = this.solveSEIR(beta, sigma, gamma, N, E0, I0, R0, days);
    
    const traces = [
      {
        x: data.t,
        y: data.S,
        name: 'Susceptible',
        line: { color: '#4063D8', width: 3 }
      },
      {
        x: data.t,
        y: data.E,
        name: 'Exposed',
        line: { color: '#9558B2', width: 3 }
      },
      {
        x: data.t,
        y: data.I,
        name: 'Infected',
        line: { color: '#CB3C33', width: 3 }
      },
      {
        x: data.t,
        y: data.R,
        name: 'Recovered',
        line: { color: '#389826', width: 3 }
      }
    ];

    const layout = {
      title: 'SEIR Epidemic Model',
      xaxis: { title: 'Days' },
      yaxis: { title: 'Population' },
      paper_bgcolor: 'rgba(0,0,0,0)',
      plot_bgcolor: 'rgba(250,250,250,0.9)',
      font: { color: '#2c3e50' },
      hovermode: 'x unified'
    };

    if (this.plotly) {
      this.plotly.newPlot(this.container, traces, layout, { responsive: true });
      this.currentPlot = 'seir';
    }

    return data;
  }

  solveSEIR(beta, sigma, gamma, N, E0, I0, R0, days) {
    const dt = 0.1;
    const steps = Math.floor(days / dt);
    
    const S = [N - E0 - I0 - R0];
    const E = [E0];
    const I = [I0];
    const R = [R0];
    const t = [0];
    
    for (let i = 1; i < steps; i++) {
      const dS = -beta * S[i-1] * I[i-1] / N;
      const dE = beta * S[i-1] * I[i-1] / N - sigma * E[i-1];
      const dI = sigma * E[i-1] - gamma * I[i-1];
      const dR = gamma * I[i-1];
      
      S.push(Math.max(0, S[i-1] + dS * dt));
      E.push(Math.max(0, E[i-1] + dE * dt));
      I.push(Math.max(0, I[i-1] + dI * dt));
      R.push(Math.max(0, R[i-1] + dR * dt));
      t.push(i * dt);
    }
    
    return { S, E, I, R, t };
  }

  // Render work-precision diagram
  renderWorkPrecisionDiagram(data) {
    const traces = data.solvers.map(solver => ({
      x: solver.times,
      y: solver.errors,
      mode: 'lines+markers',
      name: solver.name,
      type: 'scatter',
      marker: { size: 8 }
    }));

    const layout = {
      title: 'Work-Precision Diagram',
      xaxis: { 
        title: 'Time (seconds)', 
        type: 'log',
        gridcolor: '#ddd'
      },
      yaxis: { 
        title: 'Error', 
        type: 'log',
        gridcolor: '#ddd'
      },
      paper_bgcolor: 'rgba(0,0,0,0)',
      plot_bgcolor: 'rgba(250,250,250,0.9)',
      font: { color: '#2c3e50' },
      hovermode: 'closest'
    };

    if (this.plotly) {
      this.plotly.newPlot(this.container, traces, layout, { responsive: true });
      this.currentPlot = 'wpd';
    }
  }

  // Render solver comparison heatmap
  renderSolverHeatmap(data) {
    const trace = {
      z: data.values,
      x: data.solvers,
      y: data.problems,
      type: 'heatmap',
      colorscale: [
        [0, '#CB3C33'],      // Red for slow
        [0.5, '#FFA500'],    // Orange for medium
        [1, '#389826']       // Green for fast
      ],
      text: data.labels,
      hovertemplate: 'Solver: %{x}<br>Problem: %{y}<br>Performance: %{z}<br>%{text}<extra></extra>'
    };

    const layout = {
      title: 'Solver Performance Comparison',
      xaxis: { 
        title: 'Solver', 
        tickangle: -45 
      },
      yaxis: { 
        title: 'Problem Type' 
      },
      paper_bgcolor: 'rgba(0,0,0,0)',
      plot_bgcolor: 'rgba(250,250,250,0.9)',
      font: { color: '#2c3e50' }
    };

    if (this.plotly) {
      this.plotly.newPlot(this.container, [trace], layout, { responsive: true });
      this.currentPlot = 'heatmap';
    }
  }

  // Render chaos attractor gallery
  renderChaosAttractor(type = 'lorenz', params = {}) {
    let data;
    
    switch(type) {
      case 'lorenz':
        data = this.generateLorenzData(
          params.sigma || 10, 
          params.rho || 28, 
          params.beta || 8/3, 
          0.01, 
          10000
        );
        break;
      case 'rossler':
        data = this.generateRosslerData(
          params.a || 0.2,
          params.b || 0.2,
          params.c || 5.7,
          0.01,
          10000
        );
        break;
      default:
        data = this.generateLorenzData(10, 28, 8/3, 0.01, 10000);
    }
    
    this.renderLorenzAttractor();
  }

  generateRosslerData(a, b, c, dt, steps) {
    const x = [1.0], y = [1.0], z = [1.0], t = [0];
    
    for (let i = 1; i < steps; i++) {
      const dx = -y[i-1] - z[i-1];
      const dy = x[i-1] + a * y[i-1];
      const dz = b + z[i-1] * (x[i-1] - c);
      
      x.push(x[i-1] + dx * dt);
      y.push(y[i-1] + dy * dt);
      z.push(z[i-1] + dz * dt);
      t.push(i * dt);
    }
    
    return { x, y, z, t };
  }

  // Export current plot as image
  exportPlot(filename = 'sciml_plot.png') {
    if (this.plotly && this.currentPlot) {
      this.plotly.downloadImage(this.container, {
        filename: filename,
        format: 'png',
        width: 1920,
        height: 1080
      });
    }
  }

  // Clear the current plot
  clear() {
    if (this.plotly) {
      this.plotly.purge(this.container);
      this.currentPlot = null;
    }
  }
}

// Utility function to create animation frames
function createAnimation(frames, duration = 3000) {
  return {
    frame: frames.map((frame, i) => ({
      data: frame.data,
      layout: frame.layout,
      name: `frame${i}`
    })),
    transition: {
      duration: duration / frames.length,
      easing: 'cubic-in-out'
    }
  };
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { VisualizationEngine, createAnimation };
}
