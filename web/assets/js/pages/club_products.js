document.addEventListener("DOMContentLoaded", function () {
    const wrapper = document.getElementById("clubLinksWrapper");
    const leftBtn = document.getElementById("clubScrollLeft");
    const rightBtn = document.getElementById("clubScrollRight");

    if (wrapper && leftBtn && rightBtn) {
        leftBtn.addEventListener("click", function () {
            wrapper.scrollBy({
                left: -300,
                behavior: "smooth"
            });
        });

        rightBtn.addEventListener("click", function () {
            wrapper.scrollBy({
                left: 300,
                behavior: "smooth"
            });
        });
    }
});


document.addEventListener("DOMContentLoaded", function () {
    const favoriteButtons = document.querySelectorAll(".club-favorite-btn");

    favoriteButtons.forEach(button => {
        button.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();

            const maSanPham = this.dataset.productId;
            const currentButton = this;

            fetch(window.contextPath + "/yeu_thich/toggle", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: "maSanPham=" + encodeURIComponent(maSanPham)
            })
            .then(response => response.json())
            .then(data => {
                if (!data.success) {
                    if (data.needLogin) {
                        openLoginPopup();
                        return;
                    }

                    alert(data.message || "Có lỗi xảy ra");
                    return;
                }

                if (data.action === "added") {
                    currentButton.classList.add("active");
                    currentButton.textContent = "♥";
                } else if (data.action === "removed") {
                    currentButton.classList.remove("active");
                    currentButton.textContent = "♡";
                }
            })
            .catch(error => {
                console.error("Lỗi yêu thích:", error);
                alert("Không thể xử lý yêu thích lúc này");
            });
        });
    });

    function openLoginPopup() {
        const loginOverlay = document.getElementById("loginPopupOverlay");
        const loginPopup = document.getElementById("loginPopupOverlay");

        if (loginOverlay) {
            loginOverlay.classList.add("show");
            document.body.classList.add("login-lock");
        }

        if (loginPopup) {
            loginPopup.classList.add("show");
        }
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const titleEl = document.querySelector('.club-title');
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

document.addEventListener('DOMContentLoaded', function() {
  const tiltCards = document.querySelectorAll('.tilt-card');

  tiltCards.forEach(function(card) {
    // Khi di chuyển chuột bên trong thẻ
    card.addEventListener('mousemove', function(e) {
      const rect = card.getBoundingClientRect();

      // Vị trí chuột tính theo tỉ lệ 0 -> 1 trong card
      const x = (e.clientX - rect.left) / rect.width;
      const y = (e.clientY - rect.top) / rect.height;

      // Góc nghiêng tối đa ±15 độ, đảo chiều Y để tự nhiên
      const rotateY = (x - 0.5) * 30;   // -15deg đến 15deg
      const rotateX = (0.5 - y) * 30;   // 15deg đến -15deg (nghiêng lên/xuống)

      // Áp dụng transform 3D
      card.style.transform = `
        perspective(1000px)
        rotateX(${rotateX}deg)
        rotateY(${rotateY}deg)
        translateZ(20px)
      `;

      // Cập nhật biến CSS cho vị trí shine
      card.style.setProperty('--mouse-x', (x * 100) + '%');
      card.style.setProperty('--mouse-y', (y * 100) + '%');
    });

    // Khi chuột rời khỏi thẻ – trả về trạng thái phẳng
    card.addEventListener('mouseleave', function() {
      card.style.transform = `
        perspective(1000px)
        rotateX(0deg)
        rotateY(0deg)
        translateZ(0px)
      `;
      // Không cần reset --mouse-x/y vì shine đã ẩn (opacity: 0)
    });
  });
});