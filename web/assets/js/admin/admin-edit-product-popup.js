document.addEventListener("DOMContentLoaded", function () {
    const popup = document.getElementById("editProductPopup");
    const overlay = document.getElementById("editProductPopupOverlay");
    const closeBtn = document.getElementById("closeEditProductPopup");
    const cancelBtn = document.getElementById("cancelEditProductPopup");
    const form = document.getElementById("editProductForm");

    const variantRows = document.getElementById("editVariantRows");
    const subImageRows = document.getElementById("editSubImageRows");
    const variantTemplate = document.getElementById("editVariantTemplate");
    const subImageTemplate = document.getElementById("editSubImageTemplate");
    const addVariantBtn = document.getElementById("addEditVariantRowBtn");
    const addSubImageBtn = document.getElementById("addEditSubImageBtn");
    const editGiaNiemYet = document.getElementById("editGiaNiemYet");
    
    const editGiaNhapThem = document.getElementById("editGiaNhapThem");
    const editPreviewSoLuongNhapThem = document.getElementById("editPreviewSoLuongNhapThem");
    const editPreviewGiaNhapThem = document.getElementById("editPreviewGiaNhapThem");
    const editPreviewTongTienNhapThem = document.getElementById("editPreviewTongTienNhapThem");
    const editPreviewVonHienTai = document.getElementById("editPreviewVonHienTai");
    const editPreviewVonSau = document.getElementById("editPreviewVonSau");

    const contextPath = window.APP_CONTEXT || "";

    if (!popup || !overlay || !form) {
        console.log("Edit popup elements not found");
        return;
    }

    function openPopup() {
        popup.classList.add("show");
        overlay.classList.add("show");
        document.body.classList.add("admin-popup-open");
    }

    function closePopup() {
        popup.classList.remove("show");
        overlay.classList.remove("show");
        document.body.classList.remove("admin-popup-open");
    }

    function createVariantRow(item = null) {
    const wrapper = document.createElement("div");
    wrapper.innerHTML = variantTemplate.innerHTML.trim();
    const row = wrapper.firstElementChild;

    row.dataset.oldStock = "0";

    if (item) {
        row.querySelector('input[name="maBienThe"]').value = item.maBienThe || "";
        row.querySelector('select[name="maSize"]').value = item.maSize || "";
        row.querySelector('input[name="soLuongTon"]').value = item.soLuongTon || "";
        row.querySelector('input[name="giaRieng"]').value = item.giaRieng ?? "";
        row.dataset.oldStock = item.soLuongTon || 0;
    }

    return row;
}
    
    function formatMoney(n) {
    return Number(n || 0).toLocaleString("vi-VN");
}

function parseMoneyText(text) {
    return Number(String(text || "").replace(/[^\d]/g, "")) || 0;
}

function getSoLuongCuTheoRow(row) {
    return Number(row.dataset.oldStock || 0);
}

function updateEditCapitalPreview() {
    if (!variantRows) return;

    const rows = variantRows.querySelectorAll(".admin-variant-row");
    const giaNiemYet = Number(editGiaNiemYet?.value || 0);
    const giaNhapThem = Math.max(giaNiemYet - 100000, 0);
    
    if (editPreviewGiaNhapThem) {
        editPreviewGiaNhapThem.innerText = formatMoney(giaNhapThem);
    }

    let tongSoLuongNhapThem = 0;

    rows.forEach(row => {
        const soLuongInput = row.querySelector('input[name="soLuongTon"]');
        const soLuongMoi = Number(soLuongInput?.value || 0);
        const soLuongCu = getSoLuongCuTheoRow(row);

        if (soLuongMoi > soLuongCu) {
            tongSoLuongNhapThem += (soLuongMoi - soLuongCu);
        }
    });

    const tongTienNhapThem = tongSoLuongNhapThem * giaNhapThem;
    const vonHienTai = parseMoneyText(editPreviewVonHienTai?.innerText);
    const vonSau = vonHienTai - tongTienNhapThem;

    if (editPreviewSoLuongNhapThem) {
        editPreviewSoLuongNhapThem.innerText = tongSoLuongNhapThem;
    }

    if (editPreviewGiaNhapThem) {
        editPreviewGiaNhapThem.innerText = formatMoney(giaNhapThem);
    }

    if (editPreviewTongTienNhapThem) {
        editPreviewTongTienNhapThem.innerText = formatMoney(tongTienNhapThem);
    }

    if (editPreviewVonSau) {
        editPreviewVonSau.innerText = formatMoney(vonSau);
    }
}

    function createSubImageRow(item = null) {
        const wrapper = document.createElement("div");
        wrapper.innerHTML = subImageTemplate.innerHTML.trim();
        const row = wrapper.firstElementChild;

        if (item) {
            row.querySelector('input[name="maAnh"]').value = item.maAnh || "";
            row.querySelector('input[name="anhPhu"]').value = item.duongDanAnh || "";
        }

        return row;
    }
    
    toastr.options = {
    closeButton: true,
    progressBar: true,
    positionClass: "toast-top-right",
    timeOut: "2500"
};

    document.querySelectorAll(".open-edit-product-btn").forEach(btn => {
        btn.addEventListener("click", async function () {
            const maSanPham = this.dataset.maSanPham;
            if (!maSanPham) return;

            try {
                const url = `${contextPath}/admin/san-pham/chi-tiet-json?maSanPham=${encodeURIComponent(maSanPham)}`;
                console.log("Fetching:", url);
                

                const response = await fetch(url, {
                    method: "GET",
                    headers: {
                        "Accept": "application/json"
                    }
                });

                if (!response.ok) {
                    const text = await response.text();
                    console.error("Response error:", response.status, text);
                    throw new Error("HTTP " + response.status);
                }

                const data = await response.json();
                console.log("Edit data:", data);

                if (!data.success) {
                    toastr.error(data.message || "Không lấy được sản phẩm.");
                    return;
                }

                const sp = data.sanPham;
                
                

                document.getElementById("editMaSanPham").value = sp.maSanPham || "";
                document.getElementById("editTenSanPham").value = sp.tenSanPham || "";
                document.getElementById("editMaDanhMuc").value = sp.maDanhMuc || "";
                document.getElementById("editMaThuongHieu").value = sp.maThuongHieu ?? "";
                document.getElementById("editMaDoiBong").value = sp.maDoiBong ?? "";
                document.getElementById("editMoTaNgan").value = sp.moTaNgan || "";
                document.getElementById("editMoTaChiTiet").value = sp.moTaChiTiet || "";
                document.getElementById("editGiaKhuyenMai").value = sp.giaKhuyenMai ?? "";
                document.getElementById("editTrangThai").value = sp.trangThai || "dang_ban";
                document.getElementById("editNhomSanPham").value = sp.nhomSanPham ?? "";
                document.getElementById("editMaBoSuuTap").value = sp.maBoSuuTap ?? "";
                document.getElementById("editGiaNiemYet").value = sp.giaNiemYet || "";

                variantRows.innerHTML = "";
                if (data.bienThe && data.bienThe.length > 0) {
                    data.bienThe.forEach(item => {
                        variantRows.appendChild(createVariantRow(item));
                    });
                } else {
                    variantRows.appendChild(createVariantRow());
                }

                subImageRows.innerHTML = "";
                if (data.anhPhu && data.anhPhu.length > 0) {
                    data.anhPhu.forEach(item => {
                        subImageRows.appendChild(createSubImageRow(item));
                    });
                } else {
                    subImageRows.appendChild(createSubImageRow());
                }

                openPopup();
            } catch (e) {
                console.error("Không thể load dữ liệu sản phẩm:", e);
                toastr.error("Không thể load dữ liệu sản phẩm.");
            }
        });
    });

    addVariantBtn?.addEventListener("click", function () {
        variantRows.appendChild(createVariantRow());
    });

    addSubImageBtn?.addEventListener("click", function () {
        subImageRows.appendChild(createSubImageRow());
    });

    variantRows?.addEventListener("click", function (e) {
        if (e.target.classList.contains("remove-variant-btn")) {
            const rows = variantRows.querySelectorAll(".admin-variant-row");
            if (rows.length > 1) {
                e.target.closest(".admin-variant-row").remove();
            }
        }
    });

    subImageRows?.addEventListener("click", function (e) {
        if (e.target.classList.contains("remove-sub-image-btn")) {
            const rows = subImageRows.querySelectorAll(".admin-sub-image-row");
            if (rows.length > 1) {
                e.target.closest(".admin-sub-image-row").remove();
            }
        }
    });

    form.addEventListener("submit", async function (e) {
    e.preventDefault();

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
            toastr.success(data.message || "Cập nhật thành công.");
            closePopup();
            window.location.reload();
        } else {
            toastr.error(data.message || "Có lỗi khi cập nhật.");
        }
    } catch (e) {
        console.error("Submit update error:", e);
        toastr.error("Không gửi được dữ liệu cập nhật.");
    }
});

    closeBtn?.addEventListener("click", closePopup);
    cancelBtn?.addEventListener("click", closePopup);
    overlay?.addEventListener("click", closePopup);
});