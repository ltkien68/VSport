document.addEventListener("DOMContentLoaded", function () {
    const wrapper = document.getElementById("giayGangLinksWrapper");
    const btnLeft = document.getElementById("giayGangScrollLeft");
    const btnRight = document.getElementById("giayGangScrollRight");

    if (!wrapper || !btnLeft || !btnRight) return;

    const scrollAmount = 320;

    function updateButtonState() {
        const maxScrollLeft = wrapper.scrollWidth - wrapper.clientWidth;

        btnLeft.style.pointerEvents = wrapper.scrollLeft > 8 ? "auto" : "none";
        btnLeft.style.opacity = wrapper.scrollLeft > 8 ? "1" : "0.35";

        btnRight.style.pointerEvents = wrapper.scrollLeft < maxScrollLeft - 8 ? "auto" : "none";
        btnRight.style.opacity = wrapper.scrollLeft < maxScrollLeft - 8 ? "1" : "0.35";
    }

    btnLeft.addEventListener("click", function () {
        wrapper.scrollBy({
            left: -scrollAmount,
            behavior: "smooth"
        });
    });

    btnRight.addEventListener("click", function () {
        wrapper.scrollBy({
            left: scrollAmount,
            behavior: "smooth"
        });
    });

    wrapper.addEventListener("scroll", updateButtonState);
    window.addEventListener("resize", updateButtonState);

    updateButtonState();
});

document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".favorite-btn").forEach(function (btn) {
        btn.addEventListener("click", function (e) {
            e.preventDefault();
            e.stopPropagation();

            const maSanPham = btn.dataset.maSanPham;
            const currentButton = btn;

            fetch(`${window.APP_CONTEXT || window.contextPath || ""}/yeu_thich/toggle`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: "maSanPham=" + encodeURIComponent(maSanPham)
            })
            .then(function (response) {
                return response.json();
            })
            .then(function (data) {
                if (!data.success) {
                    if (data.needLogin) {
                        if (typeof openLoginPopup === "function") {
                            openLoginPopup();
                        }

                        if (typeof toastr !== "undefined") {
                            toastr.warning(data.message || "Vui lòng đăng nhập để yêu thích sản phẩm.");
                        }

                        return;
                    }

                    if (typeof toastr !== "undefined") {
                        toastr.error(data.message || "Có lỗi xảy ra.");
                    } else {
                        console.error(data.message || "Có lỗi xảy ra.");
                    }

                    return;
                }

                if (data.action === "added" || data.yeuThich === true) {
                    currentButton.classList.add("active");
                    currentButton.textContent = "♥";

                    if (typeof toastr !== "undefined") {
                        toastr.success(data.message || "Đã thêm vào yêu thích.");
                    }
                } else if (data.action === "removed" || data.yeuThich === false) {
                    currentButton.classList.remove("active");
                    currentButton.textContent = "♡";

                    if (typeof toastr !== "undefined") {
                        toastr.success(data.message || "Đã bỏ khỏi yêu thích.");
                    }
                }
            })
            .catch(function (error) {
                console.error("Lỗi yêu thích:", error);

                if (typeof toastr !== "undefined") {
                    toastr.error("Không thể xử lý yêu thích lúc này.");
                } else {
                    console.error("Không thể xử lý yêu thích lúc này.");
                }
            });
        });
    });
});