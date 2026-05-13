document.addEventListener("DOMContentLoaded", function () {
    const track = document.getElementById("newProductTrack");
    const viewport = document.querySelector(".new-product-viewport");
    const prevBtn = document.querySelector(".new-product-prev");
    const nextBtn = document.querySelector(".new-product-next");
    const dotsWrap = document.getElementById("newProductDots");

    if (!track || !viewport || !prevBtn || !nextBtn)
        return;

    const slides = Array.from(track.querySelectorAll(".new-product-slide"));
    if (!slides.length)
        return;

    let currentPage = 0;
    let slidesPerPage = getSlidesPerPage();
    let totalPages = calculateTotalPages();

    function getSlidesPerPage() {
        const width = window.innerWidth;

        if (width <= 640)
            return 1;
        if (width <= 992)
            return 2;
        if (width <= 1200)
            return 3;
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
        if (!dotsWrap)
            return;

        dotsWrap.innerHTML = "";

        if (totalPages <= 1)
            return;

        for (let i = 0; i < totalPages; i++) {
            const dot = document.createElement("button");
            dot.type = "button";
            dot.className = "new-product-dot" + (i === currentPage ? " active" : "");
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
    const newProductSection = document.getElementById("newProductSection");
    if (!newProductSection)
        return;

    newProductSection.classList.add("is-hidden");

    const observer = new IntersectionObserver(
            function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        newProductSection.classList.add("is-visible");
                        newProductSection.classList.remove("is-hidden", "is-leaving");
                    } else {
                        newProductSection.classList.remove("is-visible", "is-hidden");
                        newProductSection.classList.add("is-leaving");
                    }
                });
            },
            {
                threshold: 0.16,
                root: null,
                rootMargin: "0px 0px -8% 0px"
            }
    );

    observer.observe(newProductSection);
});

const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&*+-/";

function randomChar() {
    return chars[Math.floor(Math.random() * chars.length)];
}

function scrambleText(el, duration = 600, delayStep = 18) {
    const originalText = el.textContent.trim();
    const letters = originalText.split("");

    el.innerHTML = "";

    const spans = letters.map((char) => {
        const span = document.createElement("span");
        span.textContent = char === " " ? " " : randomChar();
        span.dataset.final = char;
        el.appendChild(span);
        return span;
    });

    let start = null;

    function animate(timestamp) {
        if (!start)
            start = timestamp;
        const progress = timestamp - start;

        spans.forEach((span, i) => {
            if (span.dataset.final === " ")
                return;

            const revealTime = i * 10;

            if (progress > revealTime) {
                const remaining = duration - progress;

                if (remaining > 0) {
                    if (Math.random() > 0.5) {
                        span.textContent = randomChar();
                    }
                } else {
                    // final state
                    span.textContent = span.dataset.final;
                }
            }
        });

        if (progress < duration + letters.length * delayStep) {
            requestAnimationFrame(animate);
        } else {
            // đảm bảo reset chính xác
            spans.forEach((s) => (s.textContent = s.dataset.final));
        }
    }

    requestAnimationFrame(animate);
}

// Intersection Observer trigger
function initScrambleOnScroll() {
    const title = document.querySelector(".new-product-reveal-title h2");

    if (!title)
        return;

    const observer = new IntersectionObserver(
            (entries) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                scrambleText(title);
                observer.disconnect(); // chạy 1 lần cho “cinematic feel”
            }
        });
    },
            {
                threshold: 0.6,
            }
    );

    observer.observe(title);
}

document.addEventListener("DOMContentLoaded", initScrambleOnScroll);