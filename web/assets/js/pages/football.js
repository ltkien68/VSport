document.addEventListener("DOMContentLoaded", function () {
    const tabs = document.querySelectorAll(".football-team-tab");
    const sliderWrappers = document.querySelectorAll(".football-team-slider-wrapper");

    tabs.forEach(tab => {
        tab.addEventListener("click", function () {
            const targetId = this.getAttribute("data-target");

            tabs.forEach(item => item.classList.remove("active"));
            sliderWrappers.forEach(item => item.classList.remove("active"));

            this.classList.add("active");

            const targetWrapper = document.getElementById(targetId);
            if (targetWrapper) {
                targetWrapper.classList.add("active");
            }
        });
    });

    const sliderButtons = document.querySelectorAll(".football-slider-btn");

    sliderButtons.forEach(button => {
        button.addEventListener("click", function () {
            const targetId = this.getAttribute("data-scroll-target");
            const target = document.getElementById(targetId);

            if (!target)
                return;

            const scrollAmount = 320;

            if (this.classList.contains("football-slider-btn-left")) {
                target.scrollBy({
                    left: -scrollAmount,
                    behavior: "smooth"
                });
            } else {
                target.scrollBy({
                    left: scrollAmount,
                    behavior: "smooth"
                });
            }
        });
    });
});

document.addEventListener('DOMContentLoaded', () => {
    const titleEl = document.querySelector('.football-section-title');
    if (!titleEl)
        return;

    const fullText = titleEl.innerText;
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

            if (!mistakeTriggered && i === 5) {
                const wrongChar = 'X';
                currentText += wrongChar;
                titleEl.innerText = currentText;
                i++;
                mistakeTriggered = true;

                const t1 = setTimeout(() => {
                    currentText = currentText.slice(0, -1);
                    titleEl.innerText = currentText;
                    i--;

                    const t2 = setTimeout(() => {
                        const correctChar = fullText.charAt(i);
                        currentText += correctChar;
                        titleEl.innerText = currentText;
                        i++;
                        typeNext();
                    }, 10);
                    timeouts.push(t2);
                }, 50);
                timeouts.push(t1);
                return;
            }

            currentText += fullText.charAt(i);
            titleEl.innerText = currentText;
            i++;
            const t = setTimeout(typeNext, 20);
            timeouts.push(t);
        }

        isAnimating = true;
        typeNext();
    }

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

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                if (titleEl.innerText !== fullText) {
                    startTypewriterWithMistake();
                }
            } else {
                if (titleEl.innerText.length > 0) {
                    startErase();
                } else {
                    stopAll();
                }
            }
        });
    }, {threshold: 0.6});

    observer.observe(titleEl);

    // ✅ Kiểm tra ngay sau khi observer đã được gắn
    // Nếu phần tử đang hiển thị, kích hoạt luôn
    if (titleEl.getBoundingClientRect().top < window.innerHeight) {
        startTypewriterWithMistake();
    }
});

document.addEventListener("DOMContentLoaded", function () {
    const track = document.getElementById("national-team-track");
    if (!track)
        return;

    const cards = Array.from(track.querySelectorAll(".football-team-card"));
    if (cards.length === 0)
        return;

    // Đặt style ẩn ban đầu
    cards.forEach(card => {
        card.style.opacity = "0";
        card.style.transform = "translateX(-20px)";
        card.style.transition = "opacity 0.35s ease, transform 0.35s ease";
    });

    let timeoutIds = [];

    function clearTimeouts() {
        timeoutIds.forEach(id => clearTimeout(id));
        timeoutIds = [];
    }

    function revealCards() {
        clearTimeouts();
        cards.forEach((card, index) => {
            const timeout = setTimeout(() => {
                card.style.opacity = "1";
                card.style.transform = "translateX(0)";
            }, index * 60); // 60ms giữa các card, tạo hiệu ứng tuần tự
            timeoutIds.push(timeout);
        });
    }

    function hideCards() {
        clearTimeouts();
        cards.forEach(card => {
            card.style.opacity = "0";
            card.style.transform = "translateX(-20px)";
        });
    }

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                revealCards();      // vào viewport -> hiện dần
            } else {
                hideCards();        // ra khỏi viewport -> ẩn ngay
            }
        });
    }, {threshold: 0.2}); // 20% lộ ra thì kích hoạt

    observer.observe(track);
});

document.addEventListener("DOMContentLoaded", function () {
    const track = document.getElementById("club-team-track");
    if (!track)
        return;

    const cards = Array.from(track.querySelectorAll(".football-team-card"));
    if (cards.length === 0)
        return;

    // Đặt style ẩn ban đầu
    cards.forEach(card => {
        card.style.opacity = "0";
        card.style.transform = "translateX(-20px)";
        card.style.transition = "opacity 0.35s ease, transform 0.35s ease";
    });

    let timeoutIds = [];

    function clearTimeouts() {
        timeoutIds.forEach(id => clearTimeout(id));
        timeoutIds = [];
    }

    function revealCards() {
        clearTimeouts();
        cards.forEach((card, index) => {
            const timeout = setTimeout(() => {
                card.style.opacity = "1";
                card.style.transform = "translateX(0)";
            }, index * 60); // 60ms giữa các card, tạo hiệu ứng tuần tự
            timeoutIds.push(timeout);
        });
    }

    function hideCards() {
        clearTimeouts();
        cards.forEach(card => {
            card.style.opacity = "0";
            card.style.transform = "translateX(-20px)";
        });
    }

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                revealCards();      // vào viewport -> hiện dần
            } else {
                hideCards();        // ra khỏi viewport -> ẩn ngay
            }
        });
    }, {threshold: 0.2}); // 20% lộ ra thì kích hoạt

    observer.observe(track);
});

document.addEventListener('DOMContentLoaded', () => {
    const tabs = document.querySelectorAll('.football-team-tab');

    // Tạo keyframes animation nếu chưa tồn tại
    if (!document.querySelector('#bounceKeyframes')) {
        const style = document.createElement('style');
        style.id = 'bounceKeyframes';
        style.textContent = `
            @keyframes bounceChar {
                0% { transform: translateY(0); }
                30% { transform: translateY(-6px); }
                60% { transform: translateY(2px); }
                100% { transform: translateY(0); }
            }
        `;
        document.head.appendChild(style);
    }

    tabs.forEach(button => {
        let originalText = button.innerText;
        let animationTimeout = null;

        function startBounce() {
            // Lưu text gốc (phòng trường hợp đã bị thay đổi)
            originalText = button.innerText;
            const chars = originalText.split('');

            // Tạo wrapper để giữ các span
            const wrapper = document.createElement('span');
            wrapper.style.display = 'inline-block';
            wrapper.style.whiteSpace = 'nowrap';

            chars.forEach((char, idx) => {
                const span = document.createElement('span');
                // Giữ nguyên khoảng trắng (dùng &nbsp;)
                span.textContent = char === ' ' ? '\u00A0' : char;
                span.style.display = 'inline-block';
                span.style.animation = `bounceChar 0.3s ease forwards ${idx * 0.04}s`;
                span.style.willChange = 'transform';
                wrapper.appendChild(span);
            });

            // Thay thế nội dung button
            button.innerHTML = '';
            button.appendChild(wrapper);

            // Tính thời gian kết thúc animation dài nhất
            const maxDuration = chars.length * 0.04 + 0.3; // giây
            animationTimeout = setTimeout(() => {
                // Phục hồi text gốc sau khi animation kết thúc
                if (button) button.innerText = originalText;
                animationTimeout = null;
            }, maxDuration * 1000);
        }

        function cancelBounce() {
            if (animationTimeout) {
                clearTimeout(animationTimeout);
                animationTimeout = null;
            }
            // Phục hồi text gốc nếu đang trong hiệu ứng
            if (button.innerText !== originalText) {
                button.innerText = originalText;
            }
        }

        button.addEventListener('mouseenter', () => {
            cancelBounce();   // hủy hiệu ứng cũ nếu đang chạy
            startBounce();
        });

        button.addEventListener('mouseleave', () => {
            cancelBounce();
        });
    });
});