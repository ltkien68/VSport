document.addEventListener("DOMContentLoaded", function () {
    const openBtn = document.getElementById("openCheckoutPopupBtn");
    const popupRoot = document.getElementById("checkoutPopupRoot");
    const contextPath = window.contextPath || "";

    if (!openBtn || !popupRoot) return;

    openBtn.addEventListener("click", function () {
        loadCheckoutPopup();
    });

    async function loadCheckoutPopup(extraParams = {}) {
        try {
            const params = new URLSearchParams();

            Object.keys(extraParams).forEach(function (key) {
                const value = extraParams[key];
                if (value !== undefined && value !== null && value !== "") {
                    params.append(key, value);
                }
            });

            const url =
                contextPath +
                "/hoan-tat-don-hang" +
                (params.toString() ? ("?" + params.toString()) : "");

            const res = await fetch(url, {
                headers: {
                    "X-Requested-With": "XMLHttpRequest"
                }
            });

            if (!res.ok) {
                const errorText = await res.text();
                console.error("Lỗi tải popup checkout:", errorText);
                toastr.error("Không thể mở popup thanh toán.");
                return;
            }

            const html = await res.text();
            popupRoot.innerHTML = html;

            bindPopupEvents();
            document.body.classList.add("search-lock");
        } catch (error) {
            console.error("Lỗi fetch popup checkout:", error);
            toastr.error("Có lỗi khi tải popup thanh toán.");
        }
    }

    function bindPopupEvents() {
        const overlay = document.getElementById("checkoutPopupOverlay");
        const closeBtn = document.getElementById("closeCheckoutPopup");

        const applyCouponBtn = document.getElementById("applyCouponBtn");
        const voucherSelect = document.getElementById("maGiamGiaSelect");

        const shippingInputs = document.querySelectorAll("input[name='shippingPreview']");
        const shippingHidden = document.getElementById("phiVanChuyenInput");
        const maPtvcInput = document.getElementById("maPtvcInput");

        if (closeBtn) {
            closeBtn.addEventListener("click", closePopup);
        }

        if (overlay) {
            overlay.addEventListener("click", function (e) {
                if (e.target === overlay) {
                    closePopup();
                }
            });
        }

        function getSelectedShipping() {
            const checkedShipping = document.querySelector("input[name='shippingPreview']:checked");

            return {
                phiVanChuyen: checkedShipping ? checkedShipping.value : "0",
                maPtvc: checkedShipping ? (checkedShipping.dataset.maPtvc || "0") : "0"
            };
        }

        

        function formatTien(value) {
            const number = Number(value);
            if (isNaN(number)) return "0";
            return number.toLocaleString("vi-VN");
        }

        function dieuKienKhac0(value) {
            const number = Number(value);
            return !isNaN(number) && number !== 0;
        }

        function giamToDaKhac0(value) {
            const number = Number(value);
            return !isNaN(number) && number !== 0;
        }

        

        if (shippingInputs.length && shippingHidden && maPtvcInput) {
            shippingInputs.forEach(function (radio) {
                radio.addEventListener("change", function () {
                    const phiVanChuyen = this.value || "0";
                    const maPtvc = this.dataset.maPtvc || "0";
                    const maGiamGia = voucherSelect ? voucherSelect.value : "";

                    shippingHidden.value = phiVanChuyen;
                    maPtvcInput.value = maPtvc;

                    loadCheckoutPopup({
                        maGiamGia: maGiamGia,
                        phiVanChuyen: phiVanChuyen,
                        maPtvc: maPtvc
                    });
                });
            });
        }

        if (applyCouponBtn) {
    applyCouponBtn.addEventListener("click", function () {
        const shipping = getSelectedShipping();
        const maGiamGia = voucherSelect ? voucherSelect.value : "";
        const maGiamGiaApplied = document.getElementById("maGiamGiaApplied");

        if (!maGiamGia) {
            toastr.error("Vui lòng chọn mã giảm giá.");
            return;
        }

        if (shippingHidden) {
            shippingHidden.value = shipping.phiVanChuyen;
        }

        if (maPtvcInput) {
            maPtvcInput.value = shipping.maPtvc;
        }

        if (maGiamGiaApplied) {
            maGiamGiaApplied.value = maGiamGia;
        }

        loadCheckoutPopup({
            maGiamGia: maGiamGia,
            phiVanChuyen: shipping.phiVanChuyen,
            maPtvc: shipping.maPtvc
        });
    });
}
    }

    function closePopup() {
        popupRoot.innerHTML = "";
        document.body.classList.remove("search-lock");
    }
});
