document.addEventListener("DOMContentLoaded", function () {
    const track = document.getElementById("heroTrack");
    const slides = document.querySelectorAll(".hero-slide");
    const dots = document.querySelectorAll(".hero-dot");
    const prevBtn = document.getElementById("prevSlide");
    const nextBtn = document.getElementById("nextSlide");

    if (!track || slides.length === 0) return;

    let currentIndex = 0;
    let autoSlide;

    function updateSlider(index) {
        track.style.transform = `translateX(-${index * 100}%)`;

        dots.forEach(dot => dot.classList.remove("active"));
        if (dots[index]) {
            dots[index].classList.add("active");
        }
    }

    function nextSlide() {
        currentIndex = (currentIndex + 1) % slides.length;
        updateSlider(currentIndex);
    }

    function prevSlide() {
        currentIndex = (currentIndex - 1 + slides.length) % slides.length;
        updateSlider(currentIndex);
    }

    function startAutoSlide() {
        autoSlide = setInterval(nextSlide, 10000);
    }

    function resetAutoSlide() {
        clearInterval(autoSlide);
        startAutoSlide();
    }

    if (nextBtn) {
        nextBtn.addEventListener("click", function () {
            nextSlide();
            resetAutoSlide();
        });
    }

    if (prevBtn) {
        prevBtn.addEventListener("click", function () {
            prevSlide();
            resetAutoSlide();
        });
    }

    dots.forEach(dot => {
        dot.addEventListener("click", function () {
            currentIndex = parseInt(this.getAttribute("data-index"));
            updateSlider(currentIndex);
            resetAutoSlide();
        });
    });

    updateSlider(currentIndex);
    startAutoSlide();
});

document.addEventListener("DOMContentLoaded", () => {

    const bannerPath = document
        .getElementById("heroBannerPath")
        .dataset.path;

    const images = [
        "messi.jpg",
        "lewy-banner.webp",
        "football-banner.jpg",
        "gym.webp",
        "volley.jpg",
        "tennis.webp"
    ];

    // shuffle
    const shuffled = [...images].sort(() => Math.random() - 0.5);

    const slides = document.querySelectorAll(".hero-slide");

    slides.forEach((slide, index) => {

        const img = slide.querySelector("img");

        img.src = bannerPath + shuffled[index];

    });

});