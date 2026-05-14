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

document.addEventListener("DOMContentLoaded", () => {
    const cards = document.querySelectorAll(".best-seller-slide");
    if (cards.length === 0)
        return;

    // Lấy container của section (có thể là .new-product-viewport hoặc phần tử cha bao quanh)
    const section = document.querySelector(".best-seller-viewport")?.parentElement || document.querySelector(".best-seller-viewport");
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