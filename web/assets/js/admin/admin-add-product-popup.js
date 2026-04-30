

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

    if (!popup || !overlay || !openBtn || !form) {
        console.log("Popup elements not found");
        return;
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
        return Number(n || 0).toLocaleString("vi-VN");
    }

    function parseMoneyText(text) {
        return Number(String(text || "").replace(/[^\d]/g, "")) || 0;
    }

    function updateCapitalPreview() {
        const qtyInputs = document.querySelectorAll("input[name='soLuongTon']");
        const giaNhap = Number(document.querySelector("input[name='giaNhapGoc']")?.value || 0);

        let totalQty = 0;
        qtyInputs.forEach(input => {
            totalQty += Number(input.value || 0);
        });

        const discountPercent = Math.floor(totalQty / 5);
        const realPrice = giaNhap * (1 - discountPercent / 100);
        const totalCost = realPrice * totalQty;

        const vonHienTai = parseMoneyText(previewVonHienTai?.innerText);
        const vonSau = vonHienTai - totalCost;

        if (previewTongSoLuong) previewTongSoLuong.innerText = totalQty;
        if (previewPhanTramGiam) previewPhanTramGiam.innerText = discountPercent + "%";
        if (previewGiaNhapThucTe) previewGiaNhapThucTe.innerText = formatMoney(realPrice);
        if (previewTongTienNhap) previewTongTienNhap.innerText = formatMoney(totalCost);
        if (previewVonSau) previewVonSau.innerText = formatMoney(vonSau);
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

            clone.querySelectorAll("input").forEach(input => {
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
                }
            }
        });
    }

    document.addEventListener("input", function (e) {
        if (e.target.name === "soLuongTon" || e.target.name === "giaNhapGoc") {
            updateCapitalPreview();
        }
    });

    form.addEventListener("submit", async function (e) {
    e.preventDefault();
    e.stopImmediatePropagation();

    try {
        const formData = new FormData(form);
        const payload = new URLSearchParams();

        for (const [key, value] of formData.entries()) {
            payload.append(key, value);
            console.log(key, "=", value);
        }

        const response = await fetch(form.action, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: payload.toString()
        });

        const text = await response.text();
        console.log("RAW RESPONSE:", text);

        const data = JSON.parse(text);

        if (data.success) {
            closePopup();
            window.location.reload();
        } else {
            console.error(data.message || "Có lỗi xảy ra.");
        }
    } catch (error) {
        console.error("Không gửi được dữ liệu.");
    }
});

    updateCapitalPreview();
});