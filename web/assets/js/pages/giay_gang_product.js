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
        btn.addEventListener("click", async function (e) {
            e.preventDefault();
            e.stopPropagation();

            const maSanPham = btn.dataset.maSanPham;

            try {
                const response = await fetch(`${window.APP_CONTEXT || ""}/yeu_thich/toggle`, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                    },
                    body: `maSanPham=${encodeURIComponent(maSanPham)}`
                });

                const data = await response.json();

                if (data.success) {
                    btn.classList.toggle("active", data.yeuThich);

                    if (typeof lucide !== "undefined") {
                        lucide.createIcons();
                    }

                    if (typeof toastr !== "undefined") {
                        toastr.success(data.message || "Đã cập nhật yêu thích.");
                    }
                } else {
                    if (typeof toastr !== "undefined") {
                        toastr.warning(data.message || "Vui lòng đăng nhập để yêu thích sản phẩm.");
                    } else {
                        console.warn(data.message);
                    }
                }
            } catch (error) {
                console.error(error);

                if (typeof toastr !== "undefined") {
                    toastr.error("Không thể cập nhật yêu thích.");
                }
            }
        });
    });
});