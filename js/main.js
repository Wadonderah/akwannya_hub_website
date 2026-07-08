/**
 * Cloud Build With Peers - Official Community Static Website
 * Client-Side Interactions and Dynamic Animations
 * Akwannya Hub Initiative
 */

document.addEventListener('DOMContentLoaded', () => {
  // --- 1. Sticky Navbar & Active States ---
  const header = document.getElementById('main-header');
  if (header) {
    // Set SaaS Landing style as persistent state
    header.classList.add('bg-white/95', 'shadow-sm', 'backdrop-blur-md', 'border-b', 'border-slate-200/80', 'py-4');
    header.classList.remove('bg-transparent', 'py-5');
    
    window.addEventListener('scroll', () => {
      if (window.scrollY > 20) {
        header.classList.add('shadow-md');
        header.classList.remove('shadow-sm');
      } else {
        header.classList.add('shadow-sm');
        header.classList.remove('shadow-md');
      }
    });
  }

  // Set active link in navbar based on current path
  const currentPath = window.location.pathname;
  const navLinks = document.querySelectorAll('.nav-link');
  navLinks.forEach(link => {
    const href = link.getAttribute('href');
    if (href && (currentPath.endsWith(href) || (href === 'index.html' && (currentPath.endsWith('/') || currentPath === '')))) {
      link.classList.add('text-accent', 'font-semibold');
      link.classList.remove('text-slate-600');
    }
  });

  // --- 2. Mobile Animated Hamburger Menu ---
  const menuBtn = document.getElementById('mobile-menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  const bar1 = document.getElementById('hamburger-bar-1');
  const bar2 = document.getElementById('hamburger-bar-2');
  const bar3 = document.getElementById('hamburger-bar-3');

  if (menuBtn && mobileMenu) {
    menuBtn.addEventListener('click', () => {
      const isOpen = mobileMenu.classList.contains('hidden');
      if (isOpen) {
        // Open menu
        mobileMenu.classList.remove('hidden');
        // Let it fade/slide in
        setTimeout(() => {
          mobileMenu.classList.remove('opacity-0', '-translate-y-4');
        }, 10);
        // Animate hamburger to X
        bar1?.classList.add('rotate-45', 'translate-y-2');
        bar2?.classList.add('opacity-0');
        bar3?.classList.add('-rotate-45', '-translate-y-2');
      } else {
        // Close menu with transition
        mobileMenu.classList.add('opacity-0', '-translate-y-4');
        const handleTransitionEnd = () => {
          mobileMenu.classList.add('hidden');
          mobileMenu.removeEventListener('transitionend', handleTransitionEnd);
        };
        mobileMenu.addEventListener('transitionend', handleTransitionEnd);
        // Reset hamburger bars
        bar1?.classList.remove('rotate-45', 'translate-y-2');
        bar2?.classList.remove('opacity-0');
        bar3?.classList.remove('-rotate-45', '-translate-y-2');
      }
    });
  }

  // --- 3. Scroll Reveal Animations (IntersectionObserver) ---
  const revealElements = document.querySelectorAll('.reveal');
  const revealObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('active');
        observer.unobserve(entry.target); // Reveal once
      }
    });
  }, {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  });

  revealElements.forEach(el => revealObserver.observe(el));

  // --- 4. Animated Counters ---
  const counterElements = document.querySelectorAll('.counter-val');
  
  const runCounter = (el) => {
    const target = parseInt(el.getAttribute('data-target'), 10);
    const suffix = el.getAttribute('data-suffix') || '';
    const duration = 2000; // 2 seconds animation
    const stepTime = Math.max(Math.floor(duration / target), 15);
    let current = 0;
    
    const timer = setInterval(() => {
      current += Math.ceil(target / (duration / stepTime));
      if (current >= target) {
        el.textContent = target.toLocaleString() + suffix;
        clearInterval(timer);
      } else {
        el.textContent = current.toLocaleString() + suffix;
      }
    }, stepTime);
  };

  const counterObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        runCounter(entry.target);
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.5 });

  counterElements.forEach(el => counterObserver.observe(el));

  // --- 5. Full-Width Premium Carousel (Homepage) ---
  const carouselContainer = document.getElementById('premium-carousel');
  if (carouselContainer) {
    const slides = carouselContainer.querySelectorAll('.carousel-slide');
    const prevBtn = document.getElementById('carousel-prev');
    const nextBtn = document.getElementById('carousel-next');
    const dotsContainer = document.getElementById('carousel-dots');
    
    let currentSlide = 0;
    const totalSlides = slides.length;
    let autoplayTimer = null;
    const autoplayInterval = 5000; // 5 seconds
    
    // Create pagination dots
    dotsContainer.innerHTML = '';
    for (let i = 0; i < totalSlides; i++) {
      const dot = document.createElement('button');
      dot.className = `w-3 h-3 rounded-full transition-all duration-300 ${i === 0 ? 'bg-secondary w-6' : 'bg-slate-300 hover:bg-slate-400'}`;
      dot.setAttribute('aria-label', `Go to slide ${i + 1}`);
      dot.addEventListener('click', () => {
        goToSlide(i);
      });
      dotsContainer.appendChild(dot);
    }
    const dots = dotsContainer.querySelectorAll('button');

    const updateCarouselUI = () => {
      slides.forEach((slide, idx) => {
        if (idx === currentSlide) {
          slide.classList.remove('hidden', 'opacity-0');
          slide.classList.add('block', 'opacity-100');
          // Add entrance animation for text content and artwork
          const animatedElements = slide.querySelectorAll('.carousel-animate');
          animatedElements.forEach((el, elIdx) => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(16px)';
            el.style.transition = `opacity 0.6s cubic-bezier(0.16, 1, 0.3, 1) ${elIdx * 0.1}s, transform 0.6s cubic-bezier(0.16, 1, 0.3, 1) ${elIdx * 0.1}s`;
            // Trigger animation in next frame
            requestAnimationFrame(() => {
              el.style.opacity = '1';
              el.style.transform = 'translateY(0)';
            });
          });
        } else {
          slide.classList.add('hidden', 'opacity-0');
          slide.classList.remove('block', 'opacity-100');
        }
      });

      // Update dots
      dots.forEach((dot, idx) => {
        if (idx === currentSlide) {
          dot.className = 'w-3 h-3 rounded-full transition-all duration-300 bg-secondary w-6';
        } else {
          dot.className = 'w-3 h-3 rounded-full transition-all duration-300 bg-slate-300 hover:bg-slate-400';
        }
      });
    };

    const goToSlide = (index) => {
      currentSlide = (index + totalSlides) % totalSlides;
      updateCarouselUI();
    };

    const nextSlide = () => {
      goToSlide(currentSlide + 1);
    };

    const prevSlide = () => {
      goToSlide(currentSlide - 1);
    };

    // Event listeners
    if (prevBtn) prevBtn.addEventListener('click', prevSlide);
    if (nextBtn) nextBtn.addEventListener('click', nextSlide);

    // Keyboard navigation
    document.addEventListener('keydown', (e) => {
      if (e.key === 'ArrowLeft') {
        prevSlide();
      } else if (e.key === 'ArrowRight') {
        nextSlide();
      }
    });

    // Touch Swipe Support
    let startX = 0;
    carouselContainer.addEventListener('touchstart', (e) => {
      startX = e.touches[0].clientX;
    }, { passive: true });

    carouselContainer.addEventListener('touchend', (e) => {
      const endX = e.changedTouches[0].clientX;
      const diff = startX - endX;
      if (Math.abs(diff) > 50) { // minimum threshold for swipe
        if (diff > 0) {
          nextSlide();
        } else {
          prevSlide();
        }
      }
    }, { passive: true });

    // Autoplay
    const startAutoplay = () => {
      if (!autoplayTimer) {
        autoplayTimer = setInterval(nextSlide, autoplayInterval);
      }
    };

    const stopAutoplay = () => {
      if (autoplayTimer) {
        clearInterval(autoplayTimer);
        autoplayTimer = null;
      }
    };

    carouselContainer.addEventListener('mouseenter', stopAutoplay);
    carouselContainer.addEventListener('mouseleave', startAutoplay);
    carouselContainer.addEventListener('focusin', stopAutoplay);
    carouselContainer.addEventListener('focusout', startAutoplay);

    // Initialize UI and start autoplay
    updateCarouselUI();
    startAutoplay();
  }

  // --- 6. Testimonials Slider ---
  const testimonialsContainer = document.getElementById('testimonials-slider');
  if (testimonialsContainer) {
    const slides = testimonialsContainer.querySelectorAll('.testimonial-slide');
    const prevBtn = document.getElementById('test-prev');
    const nextBtn = document.getElementById('test-next');
    let currentIdx = 0;

    const showTestimonial = (idx) => {
      slides.forEach((slide, i) => {
        if (i === idx) {
          slide.classList.remove('hidden', 'opacity-0');
          slide.classList.add('block', 'opacity-100');
        } else {
          slide.classList.add('hidden', 'opacity-0');
          slide.classList.remove('block', 'opacity-100');
        }
      });
    };

    if (prevBtn && nextBtn) {
      prevBtn.addEventListener('click', () => {
        currentIdx = (currentIdx - 1 + slides.length) % slides.length;
        showTestimonial(currentIdx);
      });
      nextBtn.addEventListener('click', () => {
        currentIdx = (currentIdx + 1) % slides.length;
        showTestimonial(currentIdx);
      });
    }

    showTestimonial(0);
  }

  // --- 7. Interactive Accordions (FAQ Page & Section) ---
  const accordionHeaders = document.querySelectorAll('.accordion-header');
  accordionHeaders.forEach(header => {
    header.addEventListener('click', () => {
      const targetId = header.getAttribute('data-target');
      const content = document.getElementById(targetId);
      const icon = header.querySelector('.accordion-icon');
      
      if (!content) return;

      const isExpanded = content.classList.contains('active-accordion');

      // Close all other accordions first for a clean behavior
      const activeAccordions = document.querySelectorAll('.accordion-content.active-accordion');
      activeAccordions.forEach(active => {
        if (active.id !== targetId) {
          active.classList.remove('active-accordion');
          active.style.maxHeight = null;
          const otherHeader = document.querySelector(`[data-target="${active.id}"]`);
          const otherIcon = otherHeader?.querySelector('.accordion-icon');
          otherIcon?.classList.remove('rotate-180');
          otherHeader?.classList.remove('bg-slate-50');
        }
      });

      if (isExpanded) {
        content.classList.remove('active-accordion');
        content.style.maxHeight = null;
        icon?.classList.remove('rotate-180');
        header.classList.remove('bg-slate-50');
      } else {
        content.classList.add('active-accordion');
        content.style.maxHeight = content.scrollHeight + "px";
        icon?.classList.add('rotate-180');
        header.classList.add('bg-slate-50');
      }
    });
  });

  // --- 8. Contact Form Success Showcase (UI-Only) ---
  const contactForm = document.getElementById('community-contact-form');
  if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const formContainer = contactForm.parentElement;
      if (formContainer) {
        const nameInput = document.getElementById('contact-name');
        const name = nameInput ? nameInput.value : 'friend';
        
        // Hide form with transition
        contactForm.style.opacity = '0';
        setTimeout(() => {
          formContainer.innerHTML = `
            <div class="text-center py-12 px-6 flex flex-col items-center animate-fade-in">
              <div class="w-16 h-16 bg-emerald-100 rounded-full flex items-center justify-center mb-6 text-emerald-600 animate-bounce">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7" />
                </svg>
              </div>
              <h3 class="text-2xl font-bold font-display text-primary mb-3">Thank you, ${name}!</h3>
              <p class="text-slate-600 max-w-md mb-8">
                Your message has been received. Our community success team will review your inquiry and get in touch with you within 24 to 48 hours.
              </p>
              <button onclick="window.location.reload()" class="bg-primary hover:bg-primary/95 text-white font-medium px-6 py-2.5 rounded-xl transition duration-300">
                Send another message
              </button>
            </div>
          `;
        }, 300);
      }
    });
  }

  // Handle Cohort Apply Form on contact.html
  const cohortForm = document.getElementById('cohort-apply-form');
  const successModal = document.getElementById('apply-success-modal');
  const resetBtn = document.getElementById('apply-reset-btn');

  // CV Upload Drag & Drop and File Selection Interactions
  const cvDropzone = document.getElementById('cv-dropzone');
  const cvInput = document.getElementById('app-cv');
  const cvPromptView = document.getElementById('cv-prompt-view');
  const cvSelectedView = document.getElementById('cv-selected-view');
  const cvFilename = document.getElementById('cv-filename');
  const cvFilesize = document.getElementById('cv-filesize');
  const cvRemoveBtn = document.getElementById('cv-remove-btn');

  if (cvDropzone && cvInput) {
    // Prevent default drag behaviors
    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
      cvDropzone.addEventListener(eventName, (e) => {
        e.preventDefault();
        e.stopPropagation();
      }, false);
    });

    // Add visual indicator when item is dragged over the zone
    ['dragenter', 'dragover'].forEach(eventName => {
      cvDropzone.addEventListener(eventName, () => {
        cvDropzone.classList.add('border-accent', 'bg-accent/5');
        cvDropzone.classList.remove('border-slate-200');
      }, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
      cvDropzone.addEventListener(eventName, () => {
        cvDropzone.classList.remove('border-accent', 'bg-accent/5');
        cvDropzone.classList.add('border-slate-200');
      }, false);
    });

    // Helper to format file size
    const formatBytes = (bytes, decimals = 1) => {
      if (bytes === 0) return '0 Bytes';
      const k = 1024;
      const dm = decimals < 0 ? 0 : decimals;
      const sizes = ['Bytes', 'KB', 'MB', 'GB'];
      const i = Math.floor(Math.log(bytes) / Math.log(k));
      return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    };

    // Handler when file is selected/dropped
    const handleFile = (file) => {
      if (!file) return;

      // Validate file extension
      const allowedExtensions = /(\.pdf|\.docx|\.doc)$/i;
      if (!allowedExtensions.exec(file.name)) {
        alert('Please upload a valid document format (.pdf, .doc, or .docx)');
        cvInput.value = '';
        return;
      }

      // Validate file size (10MB limit)
      const maxSizeInBytes = 10 * 1024 * 1024;
      if (file.size > maxSizeInBytes) {
        alert('File size exceeds the 10MB limit. Please upload a smaller file.');
        cvInput.value = '';
        return;
      }

      // Update UI with file details
      cvFilename.textContent = file.name;
      cvFilesize.textContent = formatBytes(file.size);

      // Toggle views
      cvPromptView.classList.add('hidden');
      cvSelectedView.classList.remove('hidden');
      
      cvInput.required = false; // Satisfied
    };

    // Listen for file changes (both clicked and dropped on the input)
    cvInput.addEventListener('change', (e) => {
      if (e.target.files && e.target.files.length > 0) {
        handleFile(e.target.files[0]);
      }
    });

    // Handle CV Removal
    if (cvRemoveBtn) {
      cvRemoveBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        cvInput.value = '';
        cvInput.required = true;
        cvPromptView.classList.remove('hidden');
        cvSelectedView.classList.add('hidden');
      });
    }
  }

  if (cohortForm && successModal) {
    cohortForm.addEventListener('submit', (e) => {
      e.preventDefault();
      successModal.classList.remove('hidden');
      successModal.classList.add('flex');
    });
  }

  if (resetBtn && successModal && cohortForm) {
    resetBtn.addEventListener('click', () => {
      successModal.classList.add('hidden');
      successModal.classList.remove('flex');
      cohortForm.reset();
      if (cvInput && cvPromptView && cvSelectedView) {
        cvInput.value = '';
        cvInput.required = true;
        cvPromptView.classList.remove('hidden');
        cvSelectedView.classList.add('hidden');
      }
    });
  }

  // --- 9. Dynamic Project Showcase Filtering ---
  const projectFiltersContainer = document.getElementById('project-filters');
  const projectCards = document.querySelectorAll('[data-category]');

  if (projectFiltersContainer) {
    const filterButtons = projectFiltersContainer.querySelectorAll('.filter-btn');

    filterButtons.forEach(button => {
      button.addEventListener('click', () => {
        const filterValue = button.getAttribute('data-filter');

        // Toggle active button style
        filterButtons.forEach(btn => {
          btn.classList.remove('bg-primary', 'text-white', 'shadow-md');
          btn.classList.add('bg-slate-50', 'text-slate-600', 'hover:bg-slate-100');
        });
        button.classList.remove('bg-slate-50', 'text-slate-600', 'hover:bg-slate-100');
        button.classList.add('bg-primary', 'text-white', 'shadow-md');

        // Filter cards with smooth transitions and safety clear-timers to prevent flickering
        projectCards.forEach(card => {
          if (card.dataset.transitionTimeout) {
            clearTimeout(parseInt(card.dataset.transitionTimeout, 10));
          }

          if (filterValue === 'all' || card.getAttribute('data-category') === filterValue) {
            card.style.display = 'flex';
            const tId = setTimeout(() => {
              card.style.opacity = '1';
              card.style.transform = 'translateY(0)';
            }, 10);
            card.dataset.transitionTimeout = tId;
          } else {
            card.style.opacity = '0';
            card.style.transform = 'translateY(8px)';
            const tId = setTimeout(() => {
              card.style.display = 'none';
            }, 200);
            card.dataset.transitionTimeout = tId;
          }
        });
      });
    });
  }

  // --- 10. Newsletter Form Submission Handling ---
  const newsletterForm = document.getElementById('newsletter-form');
  const newsletterEmail = document.getElementById('newsletter-email');
  const newsletterMessage = document.getElementById('newsletter-message');

  if (newsletterForm && newsletterEmail && newsletterMessage) {
    newsletterForm.addEventListener('submit', (e) => {
      e.preventDefault();
      
      const emailValue = newsletterEmail.value.trim();
      if (emailValue) {
        // Show success message and fade out/in elegantly
        newsletterMessage.classList.remove('hidden');
        newsletterMessage.style.opacity = '0';
        setTimeout(() => {
          newsletterMessage.style.transition = 'opacity 300ms ease';
          newsletterMessage.style.opacity = '1';
        }, 10);
        
        newsletterForm.reset();

        // Auto-hide success message after 5 seconds
        setTimeout(() => {
          newsletterMessage.style.opacity = '0';
          setTimeout(() => {
            newsletterMessage.classList.add('hidden');
          }, 300);
        }, 5000);
      }
    });
  }

});
