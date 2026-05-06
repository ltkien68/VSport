<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="admin-delete-popup-overlay" id="deleteProductPopupOverlay"></div>

<div class="admin-delete-popup" id="deleteProductPopup">
    <div class="admin-delete-popup-header">
        <h2>Xóa sản phẩm</h2>
        <button type="button" class="admin-delete-popup-close" id="closeDeleteProductPopup">×</button>
    </div>

    <div class="admin-delete-popup-body">
        <p class="admin-delete-popup-name" id="deleteProductName"></p>
        <p class="admin-delete-popup-note">
            Hành động này sẽ xóa biến thể, ảnh phụ và dữ liệu liên quan của sản phẩm này.
        </p>
    </div>

    <form id="deleteProductForm"
          action="${pageContext.request.contextPath}/admin/san-pham/xoa"
          method="post">
        <input type="hidden" name="maSanPham" id="deleteMaSanPham">

        <div class="admin-delete-popup-actions">
            <button type="button" class="admin-btn-cancel" id="cancelDeleteProductPopup">Hủy</button>
            <button type="submit" class="admin-btn-delete">Xóa sản phẩm</button>
        </div>
    </form>
</div>