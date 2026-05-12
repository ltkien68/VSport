const giftPopup = document.getElementById("giftPopup");

const openGiftPopupBtn = document.getElementById("openGiftPopupBtn");

const closeGiftPopupBtn = document.getElementById("closeGiftPopupBtn");

const cancelGiftPopupBtn = document.getElementById("cancelGiftPopupBtn");

/* OPEN */
openGiftPopupBtn.addEventListener("click", () => {
    giftPopup.classList.add("active");
});

/* CLOSE */
function closeGiftPopup() {
    giftPopup.classList.remove("active");
}

closeGiftPopupBtn.addEventListener("click", closeGiftPopup);

cancelGiftPopupBtn.addEventListener("click", closeGiftPopup);

/* CLICK OUTSIDE */
giftPopup.addEventListener("click", (e) => {

    if (e.target === giftPopup) {
        closeGiftPopup();
    }
});

// Lắng nghe sự kiện khi chọn sản phẩm quà tặng
const giftProductSelect = document.getElementById("giftProductSelect");
const giftVariantSelect = document.getElementById("giftVariantSelect");

giftProductSelect.addEventListener("change", function () {

    const maSanPham = this.value;

    giftVariantSelect.innerHTML = "";

    if (!maSanPham) {

        giftVariantSelect.disabled = true;

        giftVariantSelect.innerHTML =
                '<option value="0">Chọn quà trước</option>';

        return;
    }

    giftVariantSelect.disabled = false;

    const danhSachBienThe = bienTheMap[maSanPham];

    console.log("maSanPham =", maSanPham);
    console.log("bienTheMap[maSanPham] =", bienTheMap[maSanPham]);

    // không có biến thể
    if (!danhSachBienThe || danhSachBienThe.length === 0) {

        giftVariantSelect.innerHTML =
                '<option value="0">Không có size</option>';

        return;
    }

    giftVariantSelect.innerHTML =
            '<option value="">-- Chọn biến thể --</option>';

    danhSachBienThe.forEach(bt => {

        const option = document.createElement("option");

        option.value = bt.maBienThe;



        option.textContent =
                `Size ${bt.tenSize} (tồn: ${bt.soLuongTon})`;

        if (bt.soLuongTon <= 0) {
            option.disabled = true;
            option.textContent += " - Hết hàng";
        }

        giftVariantSelect.appendChild(option);
    });
});

function toggleGift(id) {
    const row = document.getElementById("gift-" + id);
    const parent = row.previousElementSibling;

    const isOpen = parent.classList.contains("active");

    // đóng tất cả
    document.querySelectorAll(".gift-child").forEach(r => {
        r.classList.remove("show");
    });

    document.querySelectorAll(".gift-parent").forEach(r => {
        r.classList.remove("active");
    });

    // toggle lại cái được click
    if (!isOpen) {
        row.classList.add("show");
        parent.classList.add("active");
    }
}