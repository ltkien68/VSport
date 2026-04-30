
document.addEventListener("DOMContentLoaded", function () {
    const addCartBtn = document.querySelector(".pd-add-cart-btn");
    const popupRoot = document.getElementById("cart-popup-root");

    if (!addCartBtn || !popupRoot) return;

    let escHandlerBound = null;

    addCartBtn.addEventListener("click", async function () {
        const maSanPhamInput = document.getElementById("maSanPham");
        const maBienTheInput = document.getElementById("selectedVariantId");
        const soLuongInput = document.getElementById("pdQuantityInput");

        const maSanPham = maSanPhamInput ? maSanPhamInput.value.trim() : "";
        const maBienThe = maBienTheInput ? maBienTheInput.value.trim() : "";
        const soLuong = soLuongInput ? soLuongInput.value.trim() : "1";

        if (!maSanPham) {
            toastr.error("Thiếu mã sản phẩm.");
            return;
        }

        if (!maBienThe) {
            toastr.error("Vui lòng chọn kích cỡ trước.");
            return;
        }

        const formData = new URLSearchParams();
        formData.append("maSanPham", maSanPham);
        formData.append("maBienThe", maBienThe);
        formData.append("soLuong", soLuong || "1");

        try {
            const response = await fetch(`${window.appContextPath}/gio-hang/them`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: formData.toString()
            });

            if (response.status === 401) {
                toastr.error("Bạn cần đăng nhập để thêm giỏ hàng.");
                return;
            }

            if (!response.ok) {
                const text = await response.text();
                console.error("Add to cart failed:", text);
                throw new Error("Không thể thêm vào giỏ hàng");
            }

            const html = await response.text();
            popupRoot.innerHTML = html;
            document.body.classList.add("cart-popup-open");

            bindPopupEvents();
            toastr.success("Đã thêm vào giỏ hàng.");

        } catch (error) {
            console.error("Lỗi thêm giỏ hàng:", error);
            toastr.error("Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng.");
        }
    });

    function bindPopupEvents() {
        const overlay = document.getElementById("cartPopupOverlay");
        const closeBtn = document.getElementById("cartPopupClose");

        if (!overlay || !closeBtn) return;

        closeBtn.addEventListener("click", closePopup);

        overlay.addEventListener("click", function (e) {
            if (e.target === overlay) {
                closePopup();
            }
        });

        if (escHandlerBound) {
            document.removeEventListener("keydown", escHandlerBound);
        }

        escHandlerBound = function (e) {
            if (e.key === "Escape") {
                closePopup();
            }
        };

        document.addEventListener("keydown", escHandlerBound);
    }

    function closePopup() {
        popupRoot.innerHTML = "";
        document.body.classList.remove("cart-popup-open");

        if (escHandlerBound) {
            document.removeEventListener("keydown", escHandlerBound);
            escHandlerBound = null;
        }
    }
    
    
});