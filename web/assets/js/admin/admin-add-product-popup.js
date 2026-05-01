document.addEventListener("DOMContentLoaded", function () {
    const popup = document.getElementById("addProductPopup");
    const overlay = document.getElementById("addProductPopupOverlay");
    const openBtn = document.getElementById("openAddProductPopup");
    const closeBtn = document.getElementById("closeAddProductPopup");
    const cancelBtn = document.getElementById("cancelAddProductPopup");
    const form = document.getElementById("addProductWithCapitalForm");

    const productNameInput = document.querySelector("input[name='tenSanPham']");
    const productSlugInput = document.querySelector("input[name='slug']");

    const addVariantBtn = document.getElementById("addVariantRowBtn");
    const variantRows = document.getElementById("variantRows");

    const addSubImageBtn = document.getElementById("addSubImageBtn");
    const subImageRows = document.getElementById("subImageRows");

    const previewTongSoLuong = document.getElementById("previewTongSoLuong");
    const previewPhanTramGiam = document.getElementById("previewPhanTramGiam");
    const previewGiaNhapThucTe = document.getElementById("previewGiaNhapThucTe");
    const previewTongTienNhap = document.getElementById("previewTongTienNhap");
    const previewVonHienTai = document.getElementById("previewVonHienTai");
    const previewVonSau = document.getElementById("previewVonSau");

    if (typeof toastr !== "undefined") {
        toastr.options = {
            closeButton: true,
            progressBar: true,
            newestOnTop: true,
            preventDuplicates: true,
            positionClass: "toast-top-right",
            timeOut: "2500",
            extendedTimeOut: "1200"
        };
    }

    if (!popup || !overlay || !openBtn || !form) {
        console.log("Popup elements not found");
        return;
    }

    function showSuccess(message) {
        if (typeof toastr !== "undefined") {
            toastr.success(message);
        } else {
            console.log(message);
        }
    }

    function showError(message) {
        if (typeof toastr !== "undefined") {
            toastr.error(message);
        } else {
            console.error(message);
        }
    }

    function showWarning(message) {
        if (typeof toastr !== "undefined") {
            toastr.warning(message);
        } else {
            console.warn(message);
        }
    }

    function makeSlug(text) {
        return String(text || "")
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .replace(/đ/g, "d")
            .replace(/Đ/g, "d")
            .replace(/[^a-z0-9\s-]/g, "")
            .trim()
            .replace(/\s+/g, "-")
            .replace(/-+/g, "-");
    }

    if (productNameInput && productSlugInput) {
        productNameInput.addEventListener("input", function () {
            productSlugInput.value = makeSlug(productNameInput.value);
        });

        productSlugInput.addEventListener("input", function () {
            productSlugInput.value = makeSlug(productSlugInput.value);
        });
    }

    function openPopup() {
        popup.classList.add("show");
        overlay.classList.add("show");
        document.body.classList.add("admin-popup-open");
        updateCapitalPreview();
    }

    function closePopup() {
        popup.classList.remove("show");
        overlay.classList.remove("show");
        document.body.classList.remove("admin-popup-open");
    }

    function formatMoney(n) {
        return Math.round(Number(n || 0)).toLocaleString("vi-VN");
    }

    function parseMoneyText(text) {
        return Number(String(text || "").replace(/[^\d]/g, "")) || 0;
    }

    function getNumberValue(selector) {
        return Number(document.querySelector(selector)?.value || 0);
    }

    function getTotalQuantity() {
        const qtyInputs = document.querySelectorAll("input[name='soLuongTon']");
        let totalQty = 0;

        qtyInputs.forEach(function (input) {
            const value = Number(input.value || 0);
            if (value > 0) {
                totalQty += value;
            }
        });

        return totalQty;
    }

    function calculateDiscountPercent(totalQty) {
        // 10 sp giảm 2%, 20 sp giảm 4%, ... tối đa 10%
        const discount = Math.floor(totalQty / 10) * 2;
        return Math.min(discount, 10);
    }

    function updateCapitalPreview() {
        const giaNhapGoc = getNumberValue("input[name='giaNhapGoc']");
        const totalQty = getTotalQuantity();

        const tongTienNhapGoc = giaNhapGoc * totalQty;
        const discountPercent = calculateDiscountPercent(totalQty);
        const tienGiam = tongTienNhapGoc * discountPercent / 100;
        const tongTienNhapSauGiam = tongTienNhapGoc - tienGiam;

        const giaNhapThucTe = totalQty > 0
            ? tongTienNhapSauGiam / totalQty
            : 0;

        const vonHienTai = parseMoneyText(previewVonHienTai?.innerText);
        const vonSau = vonHienTai - tongTienNhapSauGiam;

        if (previewTongSoLuong) {
            previewTongSoLuong.innerText = totalQty;
        }

        if (previewPhanTramGiam) {
            previewPhanTramGiam.innerText = discountPercent + "%";
        }

        if (previewGiaNhapThucTe) {
            previewGiaNhapThucTe.innerText = formatMoney(giaNhapThucTe);
        }

        if (previewTongTienNhap) {
            previewTongTienNhap.innerText = formatMoney(tongTienNhapSauGiam);
        }

        if (previewVonSau) {
            previewVonSau.innerText = formatMoney(vonSau);
            previewVonSau.classList.toggle("negative", vonSau < 0);
        }
    }

    openBtn.addEventListener("click", function (e) {
        e.preventDefault();
        openPopup();
    });

    closeBtn?.addEventListener("click", closePopup);
    cancelBtn?.addEventListener("click", closePopup);
    overlay.addEventListener("click", closePopup);

    if (addVariantBtn && variantRows) {
        addVariantBtn.addEventListener("click", function () {
            const firstRow = variantRows.querySelector(".admin-variant-row");
            if (!firstRow) return;

            const clone = firstRow.cloneNode(true);

            clone.querySelectorAll("input").forEach(function (input) {
                input.value = "";
            });

            const select = clone.querySelector("select[name='maSize']");
            if (select) {
                select.selectedIndex = 0;
            }

            variantRows.appendChild(clone);
            updateCapitalPreview();
        });

        variantRows.addEventListener("click", function (e) {
            if (e.target.classList.contains("remove-variant-btn")) {
                const rows = variantRows.querySelectorAll(".admin-variant-row");

                if (rows.length > 1) {
                    e.target.closest(".admin-variant-row").remove();
                    updateCapitalPreview();
                } else {
                    showWarning("Phải có ít nhất 1 biến thể sản phẩm.");
                }
            }
        });
    }

    if (addSubImageBtn && subImageRows) {
        addSubImageBtn.addEventListener("click", function () {
            const row = document.createElement("div");
            row.className = "admin-sub-image-row";
            row.innerHTML = `
                <input type="text" name="anhPhu" placeholder="/assets/images/...">
                <button type="button" class="remove-sub-image-btn">Xóa</button>
            `;
            subImageRows.appendChild(row);
        });

        subImageRows.addEventListener("click", function (e) {
            if (e.target.classList.contains("remove-sub-image-btn")) {
                const rows = subImageRows.querySelectorAll(".admin-sub-image-row");

                if (rows.length > 1) {
                    e.target.closest(".admin-sub-image-row").remove();
                } else {
                    showWarning("Phải giữ lại ít nhất 1 dòng ảnh phụ.");
                }
            }
        });
    }

    document.addEventListener("input", function (e) {
        if (
            e.target.name === "soLuongTon" ||
            e.target.name === "giaNhapGoc"
        ) {
            updateCapitalPreview();
        }
    });

    form.addEventListener("submit", async function (e) {
        e.preventDefault();
        e.stopImmediatePropagation();

        const totalQty = getTotalQuantity();
        const giaNhapGoc = getNumberValue("input[name='giaNhapGoc']");

        if (totalQty <= 0) {
            showError("Phải nhập ít nhất 1 biến thể có số lượng lớn hơn 0.");
            return;
        }

        if (giaNhapGoc <= 0) {
            showError("Giá nhập gốc phải lớn hơn 0.");
            return;
        }

        try {
            const formData = new FormData(form);
            const payload = new URLSearchParams();

            for (const [key, value] of formData.entries()) {
                payload.append(key, value);
            }

            const submitBtn = form.querySelector("button[type='submit']");
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.dataset.oldText = submitBtn.innerText;
                submitBtn.innerText = "Đang thêm...";
            }

            const response = await fetch(form.action, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                },
                body: payload.toString()
            });

            const text = await response.text();
            let data;

            try {
                data = JSON.parse(text);
            } catch (jsonError) {
                console.error("RAW RESPONSE:", text);
                throw new Error("Server trả về dữ liệu không hợp lệ.");
            }

            if (data.success) {
                showSuccess(data.message || "Thêm sản phẩm thành công.");
                closePopup();

                setTimeout(function () {
                    window.location.reload();
                }, 900);
            } else {
                showError(data.message || "Có lỗi xảy ra khi thêm sản phẩm.");
            }

        } catch (error) {
            console.error(error);
            showError(error.message || "Không gửi được dữ liệu.");
        } finally {
            const submitBtn = form.querySelector("button[type='submit']");
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerText = submitBtn.dataset.oldText || "Thêm sản phẩm";
            }
        }
    });

    updateCapitalPreview();
});