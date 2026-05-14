<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="review-popup" id="reviewPopup">

    <div class="review-popup-overlay"></div>

    <div class="review-popup-box">

        <button
            type="button"
            class="review-popup-close"
            >
            ×
        </button>

        <div class="review-popup-head">

            <h2>
                Đánh giá sản phẩm
            </h2>

            <p>
                Chia sẻ cảm nhận thật của bạn về sản phẩm này.
            </p>

        </div>

        <div class="review-popup-product">

            <img
                id="reviewProductImage"
                src=""
                alt=""
                >

            <div class="review-popup-product-info">

                <h3 id="reviewProductName"></h3>

            </div>

        </div>

        <form
            id="reviewForm"
            enctype="multipart/form-data"
            >

            <input
                type="hidden"
                name="maDonHang"
                id="reviewMaDonHang"
                >

            <input
                type="hidden"
                name="maSanPham"
                id="reviewMaSanPham"
                >

            <input
                type="hidden"
                name="maNguoiDung"
                id="reviewMaNguoiDung"
                >

            <input
                type="hidden"
                name="soSao"
                id="reviewSoSao"
                value="5"
                >

            <div class="review-stars">

                <i class="review-star active" data-value="1">★</i>
                <i class="review-star active" data-value="2">★</i>
                <i class="review-star active" data-value="3">★</i>
                <i class="review-star active" data-value="4">★</i>
                <i class="review-star active" data-value="5">★</i>

            </div>

            <textarea
                name="noiDung"
                class="review-textarea"
                placeholder="Hãy chia sẻ cảm nhận của bạn..."
                ></textarea>

            <div class="review-upload-wrap">

                <label class="review-upload-label">

                    <input
                        type="file"
                        name="anhDanhGia"
                        id="reviewImageInput"
                        accept="image/*"
                        hidden
                        >

                    <span>
                        Chọn ảnh đánh giá
                    </span>

                </label>

                <img
                    id="reviewPreviewImage"
                    class="review-preview-image"
                    src=""
                    alt=""
                    >

            </div>

            <button
                type="submit"
                class="review-submit-btn"
                >
                Gửi đánh giá
            </button>

        </form>

    </div>

</div>