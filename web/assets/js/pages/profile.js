document.addEventListener("DOMContentLoaded", function () {
    const popup = document.getElementById("profilePopup");
    const overlay = document.getElementById("profilePopupOverlay");
    const profilePageData = document.getElementById("profilePageData");

    const openButtons = [
        "openProfileFormTop",
        "openProfileFormAvatar",
        "openProfileFormProgress",
        "openProfileFormInfo",
        "openProfileFormBottom"
    ];

    const closeButton = document.getElementById("closeProfilePopup");
    const cancelButton = document.getElementById("cancelProfilePopup");

    function openPopup() {
        if (popup) popup.classList.add("show");
        if (overlay) overlay.classList.add("show");
        document.body.classList.add("profile-popup-open");
    }

    function closePopup() {
        if (popup) popup.classList.remove("show");
        if (overlay) overlay.classList.remove("show");
        document.body.classList.remove("profile-popup-open");
    }

    openButtons.forEach(function (id) {
        const btn = document.getElementById(id);
        if (btn) {
            btn.addEventListener("click", openPopup);
        }
    });

    if (closeButton) closeButton.addEventListener("click", closePopup);
    if (cancelButton) cancelButton.addEventListener("click", closePopup);
    if (overlay) overlay.addEventListener("click", closePopup);

    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape") {
            closePopup();
        }
    });

    if (profilePageData) {
    const toastSuccess = (profilePageData.dataset.toastSuccess || "").trim();
    const toastError = (profilePageData.dataset.toastError || "").trim();

    if (toastSuccess && window.toastr) {
        toastr.success(toastSuccess);
    }

    if (toastError && window.toastr) {
        toastr.error(toastError);
    }

    if (profilePageData.dataset.openPopup === "true") {
        openPopup();
    }
}
});