document.addEventListener("DOMContentLoaded", function () {
    const banner = document.getElementById("footballJerseyBanner");
    if (!banner) return;

    const slides = banner.querySelectorAll(".football-jersey-banner__slide");
    const dots = banner.querySelectorAll(".football-jersey-banner__dot");
    const prevBtn = document.getElementById("footballBannerPrev");
    const nextBtn = document.getElementById("footballBannerNext");
    const pauseBtn = document.getElementById("footballBannerPause");
    const pauseIcon = document.getElementById("footballBannerPauseIcon");
    const progressBar = document.getElementById("footballBannerProgress");

    const DURATION = 10000; // 10 giây
    const radius = 20;
    const circumference = 2 * Math.PI * radius;

    let currentIndex = 0;
    let isPaused = false;
    let startTime = null;
    let animationFrame = null;
    let timeoutId = null;

    progressBar.style.strokeDasharray = `${circumference}`;
    progressBar.style.strokeDashoffset = `0`;

    function showSlide(index) {
        slides.forEach((slide, i) => {
            slide.classList.toggle("active", i === index);
        });

        dots.forEach((dot, i) => {
            dot.classList.toggle("active", i === index);
        });

        currentIndex = index;
        restartAutoplay();
    }

    function nextSlide() {
        const nextIndex = (currentIndex + 1) % slides.length;
        showSlide(nextIndex);
    }

    function prevSlide() {
        const prevIndex = (currentIndex - 1 + slides.length) % slides.length;
        showSlide(prevIndex);
    }

    function updateProgress(timestamp) {
        if (isPaused) return;

        if (!startTime) startTime = timestamp;

        const elapsed = timestamp - startTime;
        const progress = Math.min(elapsed / DURATION, 1);
        const dashOffset = circumference * (1 - progress);

        progressBar.style.strokeDashoffset = dashOffset;

        if (progress < 1) {
            animationFrame = requestAnimationFrame(updateProgress);
        }
    }

    function startAutoplay() {
        clearTimeout(timeoutId);
        cancelAnimationFrame(animationFrame);

        if (isPaused) {
            progressBar.style.strokeDashoffset = circumference;
            return;
        }

        startTime = null;
        progressBar.style.strokeDashoffset = 0;
        animationFrame = requestAnimationFrame(updateProgress);

        timeoutId = setTimeout(() => {
            nextSlide();
        }, DURATION);
    }

    function restartAutoplay() {
        clearTimeout(timeoutId);
        cancelAnimationFrame(animationFrame);
        startAutoplay();
    }

    function togglePause() {
        isPaused = !isPaused;

        if (isPaused) {
            clearTimeout(timeoutId);
            cancelAnimationFrame(animationFrame);
            pauseIcon.textContent = "▶";
            progressBar.style.strokeDashoffset = circumference;
        } else {
            pauseIcon.textContent = "||";
            startAutoplay();
        }
    }

    dots.forEach((dot) => {
        dot.addEventListener("click", function () {
            const index = Number(this.getAttribute("data-index"));
            showSlide(index);
        });
    });

    nextBtn.addEventListener("click", nextSlide);
    prevBtn.addEventListener("click", prevSlide);
    pauseBtn.addEventListener("click", togglePause);

    banner.addEventListener("mouseenter", function () {
        if (!isPaused) {
            clearTimeout(timeoutId);
            cancelAnimationFrame(animationFrame);
        }
    });

    banner.addEventListener("mouseleave", function () {
        if (!isPaused) {
            startAutoplay();
        }
    });

    startAutoplay();
});

document.addEventListener("DOMContentLoaded", function () {

    const scrollSection =
            document.getElementById("footballBannerScroll");

    const banner =
            document.querySelector(".football-jersey-banner");

    if (!scrollSection || !banner)
        return;

    /*
     =========================
     EASING
     =========================
     */

    function easeOutCubic(t) {
        return 1 - Math.pow(1 - t, 3);
    }

    function updateBannerScale() {

        const rect =
                scrollSection.getBoundingClientRect();

        const total =
                scrollSection.offsetHeight - window.innerHeight;

        const current =
                Math.min(
                        Math.max(-rect.top, 0),
                        total
                        );

        /*
         =========================
         RAW PROGRESS
         =========================
         */

        const rawProgress =
                current / total;

        /*
         =========================
         SMOOTH PROGRESS
         =========================
         */

        const progress =
                easeOutCubic(rawProgress);

        /*
         =========================
         SCALE
         =========================
         */

        const startScale = 0.72;

        const scale =
                startScale +
                ((1 - startScale) * progress);

        

        /*
         =========================
         BORDER RADIUS
         =========================
         */

        const radius =
                32 * (1 - progress);

        /*
         =========================
         DEPTH EFFECT
         =========================
         */

        const brightness =
                0.82 + (0.18 * progress);

        const blur =
                8 * (1 - progress);

        banner.style.transform =
        `scale(${scale})`;

        banner.style.borderRadius =
                `${radius}px`;

        banner.style.filter =
                `
                brightness(${brightness})
                blur(${blur * 0.15}px)
            `;
    }

    updateBannerScale();

    window.addEventListener(
            "scroll",
            updateBannerScale,
            {passive: true}
    );

    window.addEventListener(
            "resize",
            updateBannerScale
    );
});