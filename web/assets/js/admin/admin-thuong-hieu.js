document.addEventListener("DOMContentLoaded", function () {
    const overlay = document.getElementById("brandModalOverlay");

    const brandModal = document.getElementById("brandModal");
    const deleteModal = document.getElementById("deleteBrandModal");

    const openAddBtn = document.getElementById("openAddBrandModal");
    const closeBrandBtn = document.getElementById("closeBrandModal");
    const cancelBrandBtn = document.getElementById("cancelBrandModal");

    const closeDeleteBtn = document.getElementById("closeDeleteBrandModal");
    const cancelDeleteBtn = document.getElementById("cancelDeleteBrandModal");

    const modalTitle = document.getElementById("brandModalTitle");
    const modalLabel = document.getElementById("brandModalLabel");

    const brandAction = document.getElementById("brandAction");
    const brandId = document.getElementById("brandId");
    const brandName = document.getElementById("brandName");
    const brandSlug = document.getElementById("brandSlug");

    const deleteBrandId = document.getElementById("deleteBrandId");
    const deleteBrandName = document.getElementById("deleteBrandName");

    const searchInput = document.getElementById("brandSearchInput");
    const tableBody = document.getElementById("brandTableBody");

    function showOverlay() {
        if (overlay) overlay.classList.add("show");
    }

    function hideOverlay() {
        if (overlay) overlay.classList.remove("show");
    }

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

        if (brandModal) brandModal.classList.remove("show");
        if (deleteModal) deleteModal.classList.remove("show");

        document.body.style.overflow = "";
    }

    function resetBrandForm() {
        brandAction.value = "add";
        brandId.value = "";
        brandName.value = "";
        brandSlug.value = "";

        modalLabel.textContent = "Thương hiệu";
        modalTitle.textContent = "Thêm thương hiệu";
    }

    function makeSlug(text) {
        return text
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

    if (openAddBtn) {
        openAddBtn.addEventListener("click", function () {
            resetBrandForm();
            openModal(brandModal);
        });
    }

    document.querySelectorAll(".brand-action-btn.edit").forEach(function (btn) {
        btn.addEventListener("click", function () {
            brandAction.value = "update";
            brandId.value = btn.dataset.id || "";
            brandName.value = btn.dataset.name || "";
            brandSlug.value = btn.dataset.slug || "";

            modalLabel.textContent = "Cập nhật";
            modalTitle.textContent = "Sửa thương hiệu";

            openModal(brandModal);
        });
    });

    document.querySelectorAll(".brand-action-btn.delete").forEach(function (btn) {
        btn.addEventListener("click", function () {
            deleteBrandId.value = btn.dataset.id || "";
            deleteBrandName.textContent = btn.dataset.name || "";

            openModal(deleteModal);
        });
    });

    if (brandName && brandSlug) {
        brandName.addEventListener("input", function () {
            if (brandAction.value === "add") {
                brandSlug.value = makeSlug(brandName.value);
            }
        });
    }

    if (brandSlug) {
        brandSlug.addEventListener("input", function () {
            brandSlug.value = makeSlug(brandSlug.value);
        });
    }

    if (overlay) {
        overlay.addEventListener("click", closeAllModals);
    }

    if (closeBrandBtn) {
        closeBrandBtn.addEventListener("click", closeAllModals);
    }

    if (cancelBrandBtn) {
        cancelBrandBtn.addEventListener("click", closeAllModals);
    }

    if (closeDeleteBtn) {
        closeDeleteBtn.addEventListener("click", closeAllModals);
    }

    if (cancelDeleteBtn) {
        cancelDeleteBtn.addEventListener("click", closeAllModals);
    }

    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape") {
            closeAllModals();
        }
    });

    if (searchInput && tableBody) {
        searchInput.addEventListener("input", function () {
            const keyword = searchInput.value.toLowerCase().trim();
            const rows = tableBody.querySelectorAll("tr");

            rows.forEach(function (row) {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(keyword) ? "" : "none";
            });
        });
    }

    setTimeout(function () {
        const toast = document.querySelector(".admin-brand-toast");

        if (toast) {
            toast.style.opacity = "0";
            toast.style.transform = "translateY(-6px)";

            setTimeout(function () {
                toast.remove();
            }, 250);
        }
    }, 2500);
});