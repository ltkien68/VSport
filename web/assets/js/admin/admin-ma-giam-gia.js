document.addEventListener("DOMContentLoaded", function () {

    const overlay = document.getElementById("voucherModalOverlay");

    const voucherModal = document.getElementById("voucherModal");
    const deleteModal = document.getElementById("deleteVoucherModal");

    const openAddBtn = document.getElementById("openVoucherModal");

    const closeVoucherBtn = document.getElementById("closeVoucherModal");
    const cancelVoucherBtn = document.getElementById("cancelVoucherModal");

    const closeDeleteBtn = document.getElementById("closeDeleteVoucherModal");
    const cancelDeleteBtn = document.getElementById("cancelDeleteVoucherModal");

    const modalTitle = document.getElementById("voucherModalTitle");
    const modalLabel = document.getElementById("voucherModalLabel");

    const voucherAction = document.getElementById("voucherAction");

    const voucherId = document.getElementById("voucherId");
    const voucherCode = document.getElementById("voucherCode");
    const voucherName = document.getElementById("voucherName");

    const voucherType = document.getElementById("voucherType");
    const voucherValue = document.getElementById("voucherValue");

    const voucherMin = document.getElementById("voucherMin");
    const voucherMax = document.getElementById("voucherMax");

    const voucherStart = document.getElementById("voucherStart");
    const voucherEnd = document.getElementById("voucherEnd");

    const voucherQuantity = document.getElementById("voucherQuantity");
    const voucherStatus = document.getElementById("voucherStatus");

    const voucherXu = document.getElementById("voucherXu");
    const voucherShowXu = document.getElementById("voucherShowXu");

    const deleteVoucherId = document.getElementById("deleteVoucherId");
    const deleteVoucherCode = document.getElementById("deleteVoucherCode");

    const searchInput = document.getElementById("voucherSearchInput");
    const tableBody = document.getElementById("voucherTableBody");

    // =========================
    // OVERLAY
    // =========================

    function showOverlay() {

        if (overlay) {
            overlay.classList.add("show");
        }
    }

    function hideOverlay() {

        if (overlay) {
            overlay.classList.remove("show");
        }
    }

    // =========================
    // MODAL
    // =========================

    function openModal(modal) {

        showOverlay();

        modal.classList.add("show");

        document.body.style.overflow = "hidden";

        if (window.lucide) {
            lucide.createIcons();
        }
    }

    function closeAllModals() {

        hideOverlay();

        if (voucherModal) {
            voucherModal.classList.remove("show");
        }

        if (deleteModal) {
            deleteModal.classList.remove("show");
        }

        document.body.style.overflow = "";
    }

    // =========================
    // RESET FORM
    // =========================

    function resetVoucherForm() {

        voucherAction.value = "add";

        voucherId.value = "";

        voucherCode.value = "";
        voucherName.value = "";

        voucherType.value = "tien";
        voucherValue.value = "";

        voucherMin.value = "";
        voucherMax.value = "";

        voucherStart.value = "";
        voucherEnd.value = "";

        voucherQuantity.value = "";

        voucherStatus.value = "hoat_dong";

        voucherXu.value = "";

        voucherShowXu.checked = false;

        modalLabel.textContent = "Mã giảm giá";
        modalTitle.textContent = "Thêm mã giảm giá";
    }

    // =========================
    // FORMAT DATETIME
    // =========================

    function formatDateTime(dateString) {

        if (!dateString) {
            return "";
        }

        try {

            const date = new Date(dateString);

            const year = date.getFullYear();

            const month = String(date.getMonth() + 1)
                .padStart(2, "0");

            const day = String(date.getDate())
                .padStart(2, "0");

            const hours = String(date.getHours())
                .padStart(2, "0");

            const minutes = String(date.getMinutes())
                .padStart(2, "0");

            return `${year}-${month}-${day}T${hours}:${minutes}`;

        } catch (e) {

            return "";
        }
    }

    // =========================
    // OPEN ADD
    // =========================

    if (openAddBtn) {

        openAddBtn.addEventListener("click", function () {

            resetVoucherForm();

            openModal(voucherModal);
        });
    }

    // =========================
    // EDIT
    // =========================

    document.querySelectorAll(".voucher-action-btn.edit")
        .forEach(function (btn) {

            btn.addEventListener("click", function () {

                voucherAction.value = "update";

                voucherId.value = btn.dataset.id || "";

                voucherCode.value = btn.dataset.code || "";
                voucherName.value = btn.dataset.name || "";

                voucherType.value = btn.dataset.type || "tien";

                voucherValue.value = btn.dataset.value || "";

                voucherMin.value = btn.dataset.min || "";
                voucherMax.value = btn.dataset.max || "";

                voucherStart.value = formatDateTime(
                    btn.dataset.start
                );

                voucherEnd.value = formatDateTime(
                    btn.dataset.end
                );

                voucherQuantity.value = btn.dataset.quantity || "";

                voucherStatus.value = btn.dataset.status || "hoat_dong";

                voucherXu.value = btn.dataset.xu || "";

                voucherShowXu.checked =
                    btn.dataset.showxu === "true";

                modalLabel.textContent = "Cập nhật";
                modalTitle.textContent = "Sửa mã giảm giá";

                openModal(voucherModal);
            });
        });

    // =========================
    // DELETE
    // =========================

    document.querySelectorAll(".voucher-action-btn.delete")
        .forEach(function (btn) {

            btn.addEventListener("click", function () {

                deleteVoucherId.value = btn.dataset.id || "";

                deleteVoucherCode.textContent =
                    btn.dataset.code || "";

                openModal(deleteModal);
            });
        });

    // =========================
    // CLOSE MODAL
    // =========================

    if (overlay) {
        overlay.addEventListener("click", closeAllModals);
    }

    if (closeVoucherBtn) {
        closeVoucherBtn.addEventListener("click", closeAllModals);
    }

    if (cancelVoucherBtn) {
        cancelVoucherBtn.addEventListener("click", closeAllModals);
    }

    if (closeDeleteBtn) {
        closeDeleteBtn.addEventListener("click", closeAllModals);
    }

    if (cancelDeleteBtn) {
        cancelDeleteBtn.addEventListener("click", closeAllModals);
    }

    // =========================
    // ESC CLOSE
    // =========================

    document.addEventListener("keydown", function (e) {

        if (e.key === "Escape") {
            closeAllModals();
        }
    });

    // =========================
    // SEARCH
    // =========================

    if (searchInput && tableBody) {

        searchInput.addEventListener("input", function () {

            const keyword = searchInput.value
                .toLowerCase()
                .trim();

            const rows = tableBody.querySelectorAll("tr");

            rows.forEach(function (row) {

                const text = row.textContent.toLowerCase();

                row.style.display =
                    text.includes(keyword)
                        ? ""
                        : "none";
            });
        });
    }

    // =========================
    // AUTO HIDE TOAST
    // =========================

    setTimeout(function () {

        const toast = document.querySelector(".admin-voucher-toast");

        if (toast) {

            toast.style.opacity = "0";

            toast.style.transform = "translateY(-6px)";

            setTimeout(function () {

                toast.remove();

            }, 250);
        }

    }, 2500);

});