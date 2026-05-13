document.addEventListener("DOMContentLoaded", function () {
    const track = document.getElementById("bestSellerTrack");
    const viewport = document.querySelector(".best-seller-viewport");
    const prevBtn = document.querySelector(".best-seller-prev");
    const nextBtn = document.querySelector(".best-seller-next");
    const dotsWrap = document.getElementById("bestSellerDots");

    if (!track || !viewport || !prevBtn || !nextBtn) return;

    const slides = Array.from(track.querySelectorAll(".best-seller-slide"));
    if (!slides.length) return;

    let currentPage = 0;
    let slidesPerPage = getSlidesPerPage();
    let totalPages = calculateTotalPages();

    function getSlidesPerPage() {
        const width = window.innerWidth;

        if (width <= 640) return 1;
        if (width <= 992) return 2;
        if (width <= 1200) return 3;
        return 4;
    }

    function calculateTotalPages() {
        return Math.ceil(slides.length / slidesPerPage);
    }

    function updateButtons() {
        prevBtn.classList.toggle("is-disabled", currentPage === 0);
        nextBtn.classList.toggle("is-disabled", currentPage >= totalPages - 1);
    }

    function renderDots() {
        if (!dotsWrap) return;

        dotsWrap.innerHTML = "";

        if (totalPages <= 1) return;

        for (let i = 0; i < totalPages; i++) {
            const dot = document.createElement("button");
            dot.type = "button";
            dot.className = "best-seller-dot" + (i === currentPage ? " active" : "");
            dot.setAttribute("aria-label", "Trang " + (i + 1));

            dot.addEventListener("click", function () {
                currentPage = i;
                updateSlider();
            });

            dotsWrap.appendChild(dot);
        }
    }

    function updateSlider() {
        slidesPerPage = getSlidesPerPage();
        totalPages = calculateTotalPages();

        if (currentPage >= totalPages) {
            currentPage = totalPages - 1;
        }

        if (currentPage < 0) {
            currentPage = 0;
        }

        const offset = currentPage * viewport.clientWidth;
        track.style.transform = "translateX(-" + offset + "px)";

        updateButtons();
        renderDots();
    }

    prevBtn.addEventListener("click", function () {
        if (currentPage > 0) {
            currentPage--;
            updateSlider();
        }
    });

    nextBtn.addEventListener("click", function () {
        if (currentPage < totalPages - 1) {
            currentPage++;
            updateSlider();
        }
    });

    let resizeTimer;
    window.addEventListener("resize", function () {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function () {
            updateSlider();
        }, 120);
    });

    updateSlider();
});

document.addEventListener("DOMContentLoaded", function () {
    const bestSellerSection = document.getElementById("bestSellerSection");
    if (!bestSellerSection) return;

    bestSellerSection.classList.add("is-hidden");

    const observer = new IntersectionObserver(
        function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    bestSellerSection.classList.add("is-visible");
                    bestSellerSection.classList.remove("is-hidden");
                } else {
                    bestSellerSection.classList.remove("is-visible");
                    bestSellerSection.classList.add("is-hidden");
                }
            });
        },
        {
            threshold: 0.16,
            root: null,
            rootMargin: "0px 0px -8% 0px"
        }
    );

    observer.observe(bestSellerSection);
});

document.querySelectorAll(".best-seller-card").forEach((card) => {
    const title = card.querySelector(".best-seller-card-title");
    if (!title) return;

    const arrow = title.querySelector(".best-arrow");
    const text = title.querySelector(".best-text");

    let target = 0;
    let current = 0;
    let velocity = 0;
    let raf;

    function animate() {
        const force = (target - current) * 0.2;
        velocity += force;
        velocity *= 0.78;
        current += velocity;

        // arrow chạy vào
        const arrowX = (-16 + current * 16);
        arrow.style.transform = `translateX(${arrowX}px)`;
        arrow.style.opacity = current;

        // text đẩy sang phải
        const textX = current * 18;
        text.style.transform = `translateX(${textX}px)`;

        if (Math.abs(velocity) > 0.01) {
            raf = requestAnimationFrame(animate);
        }
    }

    card.addEventListener("mouseenter", () => {
        target = 1;
        cancelAnimationFrame(raf);
        animate();
    });

    card.addEventListener("mouseleave", () => {
        target = 0;
        cancelAnimationFrame(raf);
        animate();
    });
});