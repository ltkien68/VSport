document.addEventListener("DOMContentLoaded", function () {

    const reviewPopup =
            document.getElementById("reviewPopup");

    const openButtons =
            document.querySelectorAll(".open-review-popup");

    const closeButton =
            document.querySelector(".review-popup-close");

    const overlay =
            document.querySelector(".review-popup-overlay");

    const stars =
            document.querySelectorAll(".review-star");

    const reviewSoSao =
            document.getElementById("reviewSoSao");

    openButtons.forEach(button => {

        button.addEventListener("click", function () {

            reviewPopup.classList.add("active");

            document.getElementById("reviewMaDonHang").value =
                    this.dataset.maDonHang;

            document.getElementById("reviewMaSanPham").value =
                    this.dataset.maSanPham;

            document.getElementById("reviewMaNguoiDung").value =
                    this.dataset.maNguoiDung;

            document.getElementById("reviewProductName").innerText =
                    this.dataset.tenSanPham;

            document.getElementById("reviewProductImage").src =
                    window.contextPath + "/" + this.dataset.anh;
        });
    });

    function closeReviewPopup() {
        reviewPopup.classList.remove("active");
    }

    closeButton.addEventListener("click", closeReviewPopup);

    overlay.addEventListener("click", closeReviewPopup);

    stars.forEach(star => {

        star.addEventListener("click", function () {

            const value =
                    parseInt(this.dataset.value);

            reviewSoSao.value = value;

            stars.forEach(s => {

                if (parseInt(s.dataset.value) <= value) {
                    s.classList.add("active");
                } else {
                    s.classList.remove("active");
                }
            });
        });
    });

    const reviewImageInput =
            document.getElementById("reviewImageInput");

    const reviewPreviewImage =
            document.getElementById("reviewPreviewImage");

    reviewImageInput.addEventListener("change", function () {

        const file =
                this.files[0];

        if (!file)
            return;

        const reader =
                new FileReader();

        reader.onload = function (e) {

            reviewPreviewImage.src =
                    e.target.result;

            reviewPreviewImage.style.display =
                    "block";
        };

        reader.readAsDataURL(file);
    });

    document.getElementById("reviewForm")
            .addEventListener("submit", async function (e) {

                e.preventDefault();

                const formData =
                        new FormData(this);

                try {

                    const response =
                            await fetch(
                                    window.contextPath + "/danh-gia",
                                    {
                                        method: "POST",
                                        body: formData
                                    }
                            );

                    const result =
                            await response.json();

                    if (result.success) {

                        toastr.success(result.message);

                        closeReviewPopup();

                        setTimeout(() => {
                            location.reload();
                        }, 1000);

                    } else {

                        toastr.error(result.message);
                    }

                } catch (error) {

                    console.log(error);

                    toastr.error("Có lỗi xảy ra");
                }
            });
});