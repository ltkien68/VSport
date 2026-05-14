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
    if (!favoriteSection)
        return;

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
    if (!titleEl)
        return;

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
        if (!isAnimating && titleEl.innerText === '')
            return;
        stopAll();
        let text = titleEl.innerText;
        if (text === '')
            return;

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
    }, {threshold: 0.4});

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
    if (!title)
        return;

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

document.addEventListener('DOMContentLoaded', function () {
    const title = document.querySelector('.best-seller-title');
    if (!title)
        return;

    // Tạo observer với ngưỡng 30% hiển thị
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Khi vào viewport: thêm class show
                title.classList.add('show');
            } else {
                // Khi ra khỏi viewport: xóa class show (để lần sau vào lại chạy)
                title.classList.remove('show');
            }
        });
    }, {threshold: 0.3}); // 30% phần tử lộ ra thì kích hoạt

    observer.observe(title);
});


document.addEventListener("DOMContentLoaded", () => {
    const cards = document.querySelectorAll(".home-favorite-slide");
    if (cards.length === 0)
        return;

    // Lấy container của section (có thể là .new-product-viewport hoặc phần tử cha bao quanh)
    const section = document.querySelector(".home-favorite-viewport")?.parentElement || document.querySelector(".home-favorite-viewport");
    if (!section)
        return;

    let ticking = false;
    let lastScrollY = window.scrollY;

    // Hàm giới hạn giá trị
    function clamp(value, min, max) {
        return Math.min(max, Math.max(min, value));
    }

    // Hàm chính xử lý hiệu ứng
    // Hàm chính xử lý hiệu ứng (thay thế hoàn toàn hàm updateEffects cũ)
    function updateEffects() {
        const scrollY = window.scrollY;
        const velocity = scrollY - lastScrollY;
        lastScrollY = scrollY;

        const sectionRect = section.getBoundingClientRect();
        const sectionHeight = sectionRect.height;
        const windowHeight = window.innerHeight;
        const sectionCenter = sectionRect.top + sectionHeight / 2;
        const windowCenter = windowHeight / 2;
        let distance = Math.abs(sectionCenter - windowCenter);
        const maxDistance = windowHeight / 2 + sectionHeight / 2;
        let progress = 1 - clamp(distance / maxDistance, 0, 1);
        const speedFactor = clamp(Math.abs(velocity) * 0.01, 0, 0.3);
        let factor = clamp(progress + speedFactor, 0, 1);
        const easeOutCubic = (x) => 1 - Math.pow(1 - x, 3);
        const t = easeOutCubic(factor);

        // ---- Phần quan trọng: xác định 2 card biên đang hiển thị ----
        // Lấy tất cả card
        // Trong updateEffects, sau khi tính được t
// Lấy danh sách card đang hiển thị và sắp xếp theo vị trí từ trái sang phải
        const allCards = Array.from(cards);
        const visibleCards = allCards.filter(card => {
            const rect = card.getBoundingClientRect();
            return rect.right > 0 && rect.left < window.innerWidth;
        }).sort((a, b) => a.getBoundingClientRect().left - b.getBoundingClientRect().left);

        if (visibleCards.length === 0)
            return;

// visibleCards bây giờ là mảng đã sắp xếp từ trái sang phải (tối đa 4 card)
        visibleCards.forEach((card, idx) => {
            let rotateY = 0;
            let translateX = 0;
            let rotateZ = 0;
            let scale = 1;

            let factor = 0;
            if (visibleCards.length === 4) {
                if (idx === 0)
                    factor = 1;       // trái cùng
                if (idx === 1)
                    factor = 0.7;     // thứ 2 (tăng từ 0.6 lên 0.7)
                if (idx === 2)
                    factor = 0.7;     // thứ 3
                if (idx === 3)
                    factor = 1;       // phải cùng
            } else {
                factor = (idx === 0 || idx === visibleCards.length - 1) ? 1 : 0.7;
            }

            const strength = (1 - t) * factor;

            // === TĂNG ĐỘ DỊCH & XOAY ===
            if (idx === 0) { // trái cùng
                rotateY = -55 * strength;      // tăng từ 35 lên 55 độ
                translateX = -90 * strength;   // tăng từ 40 lên 90px
                rotateZ = -8 * strength;       // tăng từ 5 lên 8 độ
                scale = 1 - 0.15 * strength;   // co nhẹ
            } else if (idx === 1) { // thứ 2
                rotateY = -70 * strength;      // tăng từ 15 lên 25
                translateX = -200 * strength;   // tăng từ 15 lên 35
                rotateZ = -4 * strength;

                scale = 1;
            } else if (idx === 2) { // thứ 3
                rotateY = 70 * strength;
                translateX = 200 * strength;
                rotateZ = 3 * strength;
                scale = 1;
            } else if (idx === 3) { // phải cùng
                rotateY = 55 * strength;
                translateX = 90 * strength;
                rotateZ = 8 * strength;
                scale = 1 - 0.15 * strength;
            }

            card.style.transform = `
        perspective(1000px)
        translateX(${translateX}px)
        rotateY(${rotateY}deg)
        rotateZ(${rotateZ}deg)
        scale(${scale})
    `;
            card.style.transition = "transform 0.08s linear";
        });

// Các card không hiển thị (nếu có) sẽ không bị ảnh hưởng, nhưng để an toàn, ta reset chúng
        allCards.forEach(card => {
            if (!visibleCards.includes(card)) {
                card.style.transform = "";
            }
        });

        ticking = false;
    }

    // Lắng nghe sự kiện scroll với requestAnimationFrame
    function onScroll() {
        if (!ticking) {
            requestAnimationFrame(() => {
                updateEffects();
                ticking = false;
            });
            ticking = true;
        }
    }

    window.addEventListener("scroll", onScroll);
    window.addEventListener("resize", () => {
        // Cập nhật lại khi thay đổi kích thước cửa sổ
        updateEffects();
    });
    // Gọi ngay một lần để set vị trí ban đầu
    updateEffects();
});