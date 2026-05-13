document.addEventListener("DOMContentLoaded", function () {
    const track = document.getElementById("favoriteTrack");
    const viewport = document.getElementById("favoriteViewport");
    const prevBtn = document.getElementById("favoritePrevBtn");
    const nextBtn = document.getElementById("favoriteNextBtn");
    const dotsWrap = document.getElementById("favoriteDots");

    if (!track || !viewport || !prevBtn || !nextBtn || !dotsWrap) {
        return;
    }

    const slides = Array.from(track.querySelectorAll(".home-favorite-slide"));
    if (slides.length === 0) {
        return;
    }

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

        renderDots();
        updateButtons();
    }

    function updateButtons() {
        prevBtn.disabled = currentPage === 0;
        nextBtn.disabled = currentPage >= totalPages - 1;
    }

    function renderDots() {
        dotsWrap.innerHTML = "";

        for (let i = 0; i < totalPages; i++) {
            const dot = document.createElement("button");
            dot.type = "button";
            dot.className = "home-favorite-dot" + (i === currentPage ? " active" : "");
            dot.setAttribute("aria-label", "Trang " + (i + 1));

            dot.addEventListener("click", function () {
                currentPage = i;
                updateSlider();
            });

            dotsWrap.appendChild(dot);
        }
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
    const favoriteSection = document.getElementById("favoriteSection");
    if (!favoriteSection) return;

    favoriteSection.classList.add("is-hidden");

    const observer = new IntersectionObserver(
        function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    favoriteSection.classList.add("is-visible");
                    favoriteSection.classList.remove("is-hidden");
                } else {
                    favoriteSection.classList.remove("is-visible");
                    favoriteSection.classList.add("is-hidden");
                }
            });
        },
        {
            threshold: 0.16,
            root: null,
            rootMargin: "0px 0px -8% 0px"
        }
    );

    observer.observe(favoriteSection);
});

document.addEventListener('DOMContentLoaded', () => {
    const titleEl = document.querySelector('.home-favorite-title');
    if (!titleEl) return;

    const fullText = titleEl.innerText;                 // "SẢN PHẨM CỦA BẠN"
    let currentText = '';
    let isAnimating = false;
    let timeouts = [];

    function clearTimeouts() {
        timeouts.forEach(t => clearTimeout(t));
        timeouts = [];
    }

    function stopAll() {
        clearTimeouts();
        isAnimating = false;
    }

    // Hiệu ứng gõ từng chữ, có thể gây lỗi tại vị trí chỉ định
    function startTypewriterWithMistake() {
        stopAll();
        titleEl.innerText = '';
        currentText = '';
        let i = 0;
        let mistakeTriggered = false;

        function typeNext() {
            if (i >= fullText.length) {
                isAnimating = false;
                return;
            }

            // Chọn vị trí gây lỗi (ví dụ: sau khi gõ được 5 chữ thì gõ sai)
            if (!mistakeTriggered && i === 5) {
                // Gõ sai: thay vì 'P' thì gõ 'X'
                const wrongChar = 'X';
                currentText += wrongChar;
                titleEl.innerText = currentText;
                i++;  // vẫn tăng i nhưng ký tự bị sai
                mistakeTriggered = true;

                // Sau 500ms, xóa ký tự sai
                const t1 = setTimeout(() => {
                    currentText = currentText.slice(0, -1);
                    titleEl.innerText = currentText;
                    i--; // lùi lại để gõ lại đúng

                    // Sau 150ms, gõ đúng ký tự
                    const t2 = setTimeout(() => {
                        const correctChar = fullText.charAt(i);
                        currentText += correctChar;
                        titleEl.innerText = currentText;
                        i++;
                        // Tiếp tục gõ các ký tự còn lại bình thường
                        typeNext();
                    }, 10);
                    timeouts.push(t2);
                }, 50);
                timeouts.push(t1);
                return;
            }

            // Gõ bình thường
            currentText += fullText.charAt(i);
            titleEl.innerText = currentText;
            i++;
            const t = setTimeout(typeNext, 20);
            timeouts.push(t);
        }

        isAnimating = true;
        typeNext();
    }

    // Hiệu ứng xóa chữ (từng ký tự)
    function startErase() {
        if (!isAnimating && titleEl.innerText === '') return;
        stopAll();
        let text = titleEl.innerText;
        if (text === '') return;

        function eraseNext() {
            if (text.length === 0) {
                titleEl.innerText = '';
                isAnimating = false;
                return;
            }
            text = text.slice(0, -1);
            titleEl.innerText = text;
            const t = setTimeout(eraseNext, 10);
            timeouts.push(t);
        }
        isAnimating = true;
        eraseNext();
    }

    // Intersection Observer
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Khi vào viewport: chạy hiệu ứng gõ (chỉ khi chưa có full text)
                if (titleEl.innerText !== fullText) {
                    startTypewriterWithMistake();
                }
            } else {
                // Khi ra khỏi viewport: xóa hết chữ
                if (titleEl.innerText.length > 0) {
                    startErase();
                } else {
                    stopAll();
                }
            }
        });
    }, { threshold: 0.4 });

    observer.observe(titleEl);
});

document.querySelectorAll(".home-favorite-card").forEach((card) => {
    const img = card.querySelector(".home-favorite-image");

    let raf;

    card.addEventListener("mousemove", (e) => {
        const rect = card.getBoundingClientRect();

        const x = (e.clientX - rect.left) / rect.width - 0.5;
        const y = (e.clientY - rect.top) / rect.height - 0.5;

        cancelAnimationFrame(raf);

        raf = requestAnimationFrame(() => {
            img.style.transform = `
                perspective(1200px)
                rotateX(${-y * 12}deg)
                rotateY(${x * 12}deg)
                scale(1.08)
                translateZ(30px)
            `;
        });
    });

    card.addEventListener("mouseleave", () => {
        img.style.transform = `
            perspective(1200px)
            rotateX(0deg)
            rotateY(0deg)
            scale(1)
            translateZ(0px)
        `;
    });
});

document.querySelectorAll(".home-favorite-card").forEach((card) => {
    const title = card.querySelector(".home-favorite-name");
    if (!title) return;

    const arrow = title.querySelector(".fav-arrow");
    const text = title.querySelector(".fav-text");

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