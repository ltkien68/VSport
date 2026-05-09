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