document.addEventListener("DOMContentLoaded", function () {
    const sizeButtons = document.querySelectorAll(".pd-size-btn");
    const addCartBtn = document.getElementById("pdAddCartBtn");
    const selectedVariantInput = document.getElementById("selectedVariantId");
    const sizeGuide = document.getElementById("pd-size-guide");
    const popupRoot = document.getElementById("cart-popup-root");

    const accordionHeaders = document.querySelectorAll(".pd-accordion-header");

    let escHandlerBound = null;

    function setCartButtonEnabled(enabled) {
        if (!addCartBtn)
            return;

        addCartBtn.disabled = !enabled;
        addCartBtn.style.opacity = enabled ? "1" : "0.6";
        addCartBtn.style.cursor = enabled ? "pointer" : "not-allowed";
    }

    function handleSizeSelection(button) {
        if (!selectedVariantInput || !sizeGuide)
            return;

        sizeButtons.forEach(function (btn) {
            btn.classList.remove("active");
        });

        const tenSize = button.dataset.tenSize || "";
        const tonKho = parseInt(button.dataset.tonKho || "0", 10);
        const maBienThe = button.dataset.maBienThe || "";

        if (!maBienThe || tonKho <= 0) {
            selectedVariantInput.value = "";
            sizeGuide.textContent = "Sản phẩm hết size " + tenSize + ".";
            setCartButtonEnabled(false);
            return;
        }

        button.classList.add("active");
        selectedVariantInput.value = maBienThe;
        sizeGuide.textContent = "Sản phẩm có sẵn " + tonKho + " sản phẩm với size " + tenSize + ".";
        setCartButtonEnabled(true);
    }

    function bindSizeEvents() {
        if (!sizeButtons.length)
            return;

        setCartButtonEnabled(false);

        sizeButtons.forEach(function (button) {
            button.addEventListener("click", function () {
                handleSizeSelection(button);
            });
        });
    }

    function bindAccordionEvents() {
        if (!accordionHeaders.length)
            return;

        accordionHeaders.forEach(function (header) {
            header.addEventListener("click", function () {
                const body = this.nextElementSibling;
                const isOpen = this.classList.contains("active");

                accordionHeaders.forEach(function (otherHeader) {
                    otherHeader.classList.remove("active");
                    if (otherHeader.nextElementSibling) {
                        otherHeader.nextElementSibling.classList.remove("show");
                    }
                });

                if (!isOpen) {
                    this.classList.add("active");
                    if (body) {
                        body.classList.add("show");
                    }
                }
            });
        });
    }

    function closePopup() {
        if (popupRoot) {
            popupRoot.innerHTML = "";
        }

        document.body.classList.remove("cart-popup-open");

        if (escHandlerBound) {
            document.removeEventListener("keydown", escHandlerBound);
            escHandlerBound = null;
        }
    }

    function bindPopupEvents() {
        const overlay = document.getElementById("cartPopupOverlay");
        const closeBtn = document.getElementById("cartPopupClose");

        if (!overlay || !closeBtn)
            return;

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

    function bindAddToCartEvent() {
        if (!addCartBtn || !popupRoot)
            return;

        addCartBtn.addEventListener("click", async function () {
            const maSanPhamInput = document.getElementById("maSanPham");
            const maBienTheInput = document.getElementById("selectedVariantId");
            const soLuongInput = document.getElementById("pdQuantityInput");

            const maSanPham = maSanPhamInput ? maSanPhamInput.value.trim() : "";
            const maBienThe = maBienTheInput ? maBienTheInput.value.trim() : "";
            const soLuong = soLuongInput ? soLuongInput.value.trim() : "1";

            if (!maSanPham) {
                toastr.warning("Thiếu mã sản phẩm.");
                return;
            }

            if (!maBienThe) {
                toastr.warning("Vui lòng chọn kích cỡ trước.");
                return;
            }

            const printData = window.getPrintShirtData ? window.getPrintShirtData() : {
                tenInAo: "",
                soInAo: ""
            };

            if (printData === null) {
                return;
            }

            const formData = new URLSearchParams();
            formData.append("maSanPham", maSanPham);
            formData.append("maBienThe", maBienThe);
            formData.append("soLuong", soLuong || "1");
            formData.append("tenInAo", printData.tenInAo);
            formData.append("soInAo", printData.soInAo);


            console.log("PRINT DATA:", printData);

            try {
                const response = await fetch(`${window.contextPath}/gio-hang/them`, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: formData.toString()
                });

                if (response.status === 401) {
                    toastr.warning("Bạn cần đăng nhập để thêm giỏ hàng.");
                    return;
                }

                if (!response.ok) {
                    const text = await response.text();
                    console.error("Add to cart failed:", text);

                    toastr.error(text || "Không thể thêm vào giỏ hàng.");

                    return;
                }

                const html = await response.text();
                popupRoot.innerHTML = html;
                document.body.classList.add("cart-popup-open");

                bindPopupEvents();

                if (window.lucide) {
                    lucide.createIcons();
                }
            } catch (error) {
                console.error("Lỗi thêm giỏ hàng:", error);
                toastr.error("Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng.");
            }
        });
    }

    bindSizeEvents();
    bindAccordionEvents();
    bindAddToCartEvent();

    if (window.lucide) {
        lucide.createIcons();
    }
});

document.addEventListener("DOMContentLoaded", function () {
    const printCheckbox = document.getElementById("printShirtCheckbox");
    const printFields = document.getElementById("printShirtFields");
    const tenInAoInput = document.getElementById("tenInAo");
    const soInAoInput = document.getElementById("soInAo");

    if (!printCheckbox || !printFields || !tenInAoInput || !soInAoInput)
        return;

    printCheckbox.addEventListener("change", function () {
        const checked = this.checked;

        printFields.classList.toggle("active", checked);

        if (!checked) {
            tenInAoInput.value = "";
            soInAoInput.value = "";
        }
    });

    tenInAoInput.addEventListener("input", function () {
        this.value = this.value
                .toUpperCase()
                .replace(/[^A-ZÀ-Ỹ\s]/gi, "")
                .slice(0, 20);
    });

    soInAoInput.addEventListener("input", function () {
        this.value = this.value
                .replace(/\D/g, "")
                .slice(0, 2);
    });

    window.getPrintShirtData = function () {
        if (!printCheckbox.checked) {
            return {
                tenInAo: "",
                soInAo: ""
            };
        }

        const tenInAo = tenInAoInput.value.trim();
        const soInAo = soInAoInput.value.trim();

        if (tenInAo.length === 0) {
            toastr.error("Vui lòng nhập tên muốn in trên áo.");
            tenInAoInput.focus();
            return null;
        }

        if (tenInAo.length > 20) {
            toastr.error("Tên in áo tối đa 20 ký tự.");
            tenInAoInput.focus();
            return null;
        }

        if (soInAo.length === 0) {
            toastr.error("Vui lòng nhập số áo muốn in.");
            soInAoInput.focus();
            return null;
        }

        if (soInAo.length > 2) {
            toastr.error("Số áo tối đa 2 ký tự.");
            soInAoInput.focus();
            return null;
        }

        return {
            tenInAo: tenInAo,
            soInAo: soInAo
        };
    };
});

document.addEventListener("DOMContentLoaded", function () {

    const randomSection =
            document.getElementById("pdRandomSection");

    if (!randomSection) {
        return;
    }

    randomSection.classList.add("is-hidden");

    const observer = new IntersectionObserver(
            function (entries) {

                entries.forEach(function (entry) {

                    if (entry.isIntersecting) {

                        randomSection.classList.add("is-visible");

                        randomSection.classList.remove("is-hidden");

                    } else {

                        randomSection.classList.remove("is-visible");

                        randomSection.classList.add("is-hidden");
                    }

                });

            },
            {
                threshold: 0.12,
                root: null,
                rootMargin: "0px 0px -8% 0px"
            }
    );

    observer.observe(randomSection);

});

