// SciML Tutorial Explorer - Interactive Navigation & Filtering
// Copyright (c) 2025 SciML

class TutorialExplorer {
  constructor() {
    this.tutorials = [];
    this.filters = {
      difficulty: 'all',
      category: 'all',
      duration: 'all',
      search: ''
    };
    this.init();
  }

  init() {
    this.loadTutorials();
    this.setupEventListeners();
    this.renderTutorials();
  }

  loadTutorials() {
    // Tutorial metadata - in a real implementation, this would be loaded from JSON
    this.tutorials = [
      {
        id: 'five-minute-tour',
        title: 'Five-Minute Tour',
        category: 'sciml_journey',
        difficulty: 'beginner',
        duration: 5,
        description: 'Rapid ecosystem overview with Lorenz attractor visualization',
        path: '01_the_sciml_journey/01_five_minute_tour.jl',
        tags: ['intro', 'ode', 'visualization'],
        icon: '🚀'
      },
      {
        id: 'epidemics-story',
        title: 'Epidemics in Motion',
        category: 'interactive_stories',
        difficulty: 'intermediate',
        duration: 45,
        description: 'SEIR modeling with policy interventions and uncertainty quantification',
        path: '03_interactive_stories/epidemics_in_motion/story.jl',
        tags: ['biology', 'optimization', 'callbacks'],
        icon: '🦠'
      },
      {
        id: 'solver-comparison',
        title: 'Solver Comparison Matrix',
        category: 'visual_cookbook',
        difficulty: 'intermediate',
        duration: 30,
        description: 'Comprehensive benchmarking across 130+ solvers',
        path: '02_visual_cookbook/solver_comparison_matrix.jl',
        tags: ['performance', 'benchmarking', 'solvers'],
        icon: '📊'
      },
      {
        id: 'chaos-gallery',
        title: 'Chaos Art Gallery',
        category: 'creative',
        difficulty: 'beginner',
        duration: 20,
        description: 'Beautiful visualizations of strange attractors',
        path: '08_creative_explorations/art_from_equations/chaos_gallery.jl',
        tags: ['art', 'visualization', 'chaos'],
        icon: '🎨'
      },
      {
        id: 'work-precision',
        title: 'Work-Precision Diagrams',
        category: 'performance',
        difficulty: 'advanced',
        duration: 25,
        description: 'Publication-quality performance analysis',
        path: '06_performance_art/work_precision_diagrams.jl',
        tags: ['performance', 'benchmarking', 'publication'],
        icon: '⚡'
      }
    ];
  }

  setupEventListeners() {
    // Search functionality
    const searchInput = document.getElementById('tutorial-search');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        this.filters.search = e.target.value.toLowerCase();
        this.renderTutorials();
      });
    }

    // Filter dropdowns
    const difficultyFilter = document.getElementById('difficulty-filter');
    if (difficultyFilter) {
      difficultyFilter.addEventListener('change', (e) => {
        this.filters.difficulty = e.target.value;
        this.renderTutorials();
      });
    }

    const categoryFilter = document.getElementById('category-filter');
    if (categoryFilter) {
      categoryFilter.addEventListener('change', (e) => {
        this.filters.category = e.target.value;
        this.renderTutorials();
      });
    }

    const durationFilter = document.getElementById('duration-filter');
    if (durationFilter) {
      durationFilter.addEventListener('change', (e) => {
        this.filters.duration = e.target.value;
        this.renderTutorials();
      });
    }

    // Scroll reveal animation
    this.setupScrollReveal();
  }

  filterTutorials() {
    return this.tutorials.filter(tutorial => {
      // Search filter
      if (this.filters.search) {
        const searchMatch = 
          tutorial.title.toLowerCase().includes(this.filters.search) ||
          tutorial.description.toLowerCase().includes(this.filters.search) ||
          tutorial.tags.some(tag => tag.includes(this.filters.search));
        if (!searchMatch) return false;
      }

      // Difficulty filter
      if (this.filters.difficulty !== 'all' && 
          tutorial.difficulty !== this.filters.difficulty) {
        return false;
      }

      // Category filter
      if (this.filters.category !== 'all' && 
          tutorial.category !== this.filters.category) {
        return false;
      }

      // Duration filter
      if (this.filters.duration !== 'all') {
        const duration = parseInt(this.filters.duration);
        if (duration === 10 && tutorial.duration > 10) return false;
        if (duration === 30 && (tutorial.duration <= 10 || tutorial.duration > 30)) return false;
        if (duration === 60 && tutorial.duration <= 30) return false;
      }

      return true;
    });
  }

  renderTutorials() {
    const container = document.getElementById('tutorials-container');
    if (!container) return;

    const filteredTutorials = this.filterTutorials();
    
    if (filteredTutorials.length === 0) {
      container.innerHTML = `
        <div class="no-results">
          <p>No tutorials found matching your criteria.</p>
          <button class="btn btn-primary" onclick="explorer.resetFilters()">Reset Filters</button>
        </div>
      `;
      return;
    }

    container.innerHTML = filteredTutorials.map(tutorial => `
      <div class="tutorial-card fade-in" data-tutorial-id="${tutorial.id}">
        <div class="card-icon">${tutorial.icon}</div>
        <h3 class="card-title">${tutorial.title}</h3>
        <p class="card-description">${tutorial.description}</p>
        <div class="card-meta">
          <span class="badge badge-difficulty-${tutorial.difficulty}">${tutorial.difficulty}</span>
          <span class="badge badge-time">⏱️ ${tutorial.duration}min</span>
        </div>
        <div class="card-tags" style="margin-top: 1rem;">
          ${tutorial.tags.map(tag => `<span class="badge" style="background: #95a5a6;">${tag}</span>`).join('')}
        </div>
        <button class="btn btn-primary" style="margin-top: 1rem; width: 100%;" 
                onclick="explorer.openTutorial('${tutorial.path}')">
          Start Tutorial →
        </button>
      </div>
    `).join('');
  }

  resetFilters() {
    this.filters = {
      difficulty: 'all',
      category: 'all',
      duration: 'all',
      search: ''
    };
    
    // Reset form elements
    const searchInput = document.getElementById('tutorial-search');
    if (searchInput) searchInput.value = '';
    
    const selects = document.querySelectorAll('select');
    selects.forEach(select => select.value = 'all');
    
    this.renderTutorials();
  }

  openTutorial(path) {
    // In a real implementation, this would navigate to the tutorial
    console.log(`Opening tutorial: ${path}`);
    alert(`Tutorial: ${path}\n\nIn a full implementation, this would open the tutorial file or rendered output.`);
  }

  setupScrollReveal() {
    const revealElements = document.querySelectorAll('.reveal');
    
    const revealOnScroll = () => {
      revealElements.forEach(element => {
        const elementTop = element.getBoundingClientRect().top;
        const windowHeight = window.innerHeight;
        
        if (elementTop < windowHeight - 100) {
          element.classList.add('active');
        }
      });
    };

    window.addEventListener('scroll', revealOnScroll);
    revealOnScroll(); // Initial check
  }

  getStats() {
    return {
      total: this.tutorials.length,
      beginner: this.tutorials.filter(t => t.difficulty === 'beginner').length,
      intermediate: this.tutorials.filter(t => t.difficulty === 'intermediate').length,
      advanced: this.tutorials.filter(t => t.difficulty === 'advanced').length,
      avgDuration: Math.round(
        this.tutorials.reduce((sum, t) => sum + t.duration, 0) / this.tutorials.length
      )
    };
  }
}

// Copy code functionality
function copyCode(button) {
  const codeBlock = button.closest('.code-snippet').querySelector('code');
  const text = codeBlock.textContent;
  
  navigator.clipboard.writeText(text).then(() => {
    const originalText = button.textContent;
    button.textContent = '✓ Copied!';
    button.style.backgroundColor = '#389826';
    
    setTimeout(() => {
      button.textContent = originalText;
      button.style.backgroundColor = '';
    }, 2000);
  }).catch(err => {
    console.error('Failed to copy:', err);
    alert('Failed to copy code to clipboard');
  });
}

// Smooth scrolling for anchor links
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
});

// Initialize explorer
let explorer;
document.addEventListener('DOMContentLoaded', () => {
  explorer = new TutorialExplorer();
});

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { TutorialExplorer, copyCode };
}
