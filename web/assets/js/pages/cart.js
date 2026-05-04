document.addEventListener("DOMContentLoaded", function () {
    const modal = document.getElementById("cartPrintModal");
    const closeBtn = document.getElementById("cartPrintClose");
    const saveBtn = document.getElementById("savePrintBtn");
    const removeBtn = document.getElementById("removePrintBtn");

    const editCartId = document.getElementById("editCartId");
    const editTenInAo = document.getElementById("editTenInAo");
    const editSoInAo = document.getElementById("editSoInAo");

    document.querySelectorAll(".cart-print-edit-btn").forEach(function (btn) {
        btn.addEventListener("click", function () {
            const box = btn.closest(".cart-print-info");

            editCartId.value = box.dataset.cartId || "";
            editTenInAo.value = box.dataset.tenIn || "";
            editSoInAo.value = box.dataset.soIn || "";

            modal.classList.add("active");
        });
    });

    closeBtn.addEventListener("click", function () {
        modal.classList.remove("active");
    });

    editTenInAo.addEventListener("input", function () {
        this.value = this.value
                .toUpperCase()
                .replace(/[^A-ZÀ-Ỹ\s]/gi, "")
                .slice(0, 20);
    });

    editSoInAo.addEventListener("input", function () {
        this.value = this.value
                .replace(/\D/g, "")
                .slice(0, 2);
    });

    saveBtn.addEventListener("click", async function () {
        await updatePrintInfo(editTenInAo.value.trim(), editSoInAo.value.trim());
    });

    removeBtn.addEventListener("click", async function () {
        await updatePrintInfo("", "");
    });

    async function updatePrintInfo(tenInAo, soInAo) {
        const formData = new URLSearchParams();
        formData.append("maGioHang", editCartId.value);
        formData.append("tenInAo", tenInAo);
        formData.append("soInAo", soInAo);





        const response = await fetch(`${window.contextPath}/gio_hang/cap-nhat-in-ao`, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: formData.toString()
        });

        if (!response.ok) {
            const text = await response.text();
            toastr.error(text || "Không thể cập nhật nội dung in.");
            return;
        }

        toastr.success("Đã cập nhật nội dung in áo.");
        location.reload();
    }

    document.querySelectorAll(".cart-qty-input").forEach(function (input) {
        input.addEventListener("change", async function () {
            let value = parseInt(input.value || "1", 10);

            if (isNaN(value) || value < 1)
                value = 1;
            if (value > 100)
                value = 100;

            input.value = value;

            const box = input.closest(".cart-qty-box");

            const formData = new URLSearchParams();
            formData.append("maGioHang", box.dataset.cartId);
            formData.append("soLuong", value);

            const response = await fetch(`${window.contextPath}/gio_hang/cap-nhat-so-luong`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: formData.toString()
            });

            if (!response.ok) {
                const text = await response.text();
                toastr.error(text || "Không thể cập nhật số lượng.");
                return;
            }

            toastr.success("Đã cập nhật số lượng.");

            // delay nhẹ để thấy toast rồi mới reload
            setTimeout(() => {
                location.reload();
            }, 600);

            location.reload();
        });
    });
});