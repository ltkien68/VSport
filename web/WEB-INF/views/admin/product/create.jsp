<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="admin-product-popup-overlay" id="addProductPopupOverlay"></div>

<div class="admin-product-popup" id="addProductPopup">
    <div class="admin-product-popup-header">
        <h2>Thêm sản phẩm mới</h2>
            <button type="button" class="admin-product-popup-close" id="closeAddProductPopup">×</button>
    </div>

    <form id="addProductWithCapitalForm"
          class="admin-product-popup-form"
          action="${pageContext.request.contextPath}/admin/san-pham/them-co-von"
          method="post">

        <div class="admin-popup-grid">
            <div class="admin-form-group">
                <label>Tên sản phẩm</label>
                <input type="text" name="tenSanPham" required>
            </div>

            <div class="admin-form-group">
                <label>Slug</label>
                <input type="text" name="slug" required>
            </div>

            <div class="admin-form-group">
                <label>Danh mục</label>
                <select name="maDanhMuc" required>
                    <c:forEach var="dm" items="${dsDanhMuc}">
                        <option value="${dm.maDanhMuc}">${dm.tenDanhMuc}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="admin-form-group">
                <label>Thương hiệu</label>
                <select name="maThuongHieu">
                    <option value="">-- Chọn --</option>
                    <c:forEach var="th" items="${dsThuongHieu}">
                        <option value="${th.maThuongHieu}">${th.tenThuongHieu}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="admin-form-group">
                <label>Đội bóng</label>
                <select name="maDoiBong">
                    <option value="">-- Chọn --</option>
                    <c:forEach var="db" items="${dsDoiBong}">
                        <option value="${db.maDoiBong}">${db.tenDoiBong}</option>
                    </c:forEach>
                </select>
            </div>
                    
                    <div class="admin-form-group">
                <label>Nhóm sản phẩm</label>
                <input type="number" name="nhomSanPham" placeholder="1 / 2..." required>
            </div>

            <div class="admin-form-group">
                <label>Loại sản phẩm</label>
                <input type="text" name="loaiSanPham" placeholder="ao-san-nha / giay-da-bong..." required>
            </div>

            <div class="admin-form-group">
                <label>Giá niêm yết bán</label>
                <input type="number" name="giaNiemYet" min="0" step="1000" required>
            </div>

            <div class="admin-form-group">
                <label>Giá khuyến mãi</label>
                <input type="number" name="giaKhuyenMai" min="0" value="0" step="1000">
            </div>

            <div class="admin-form-group">
                <label>Giá nhập gốc / 1 sản phẩm</label>
                <input type="number" name="giaNhapGoc" min="0" step="1000" required>
            </div>

            <div class="admin-form-group">
                <label>Ảnh chính</label>
                <input type="text" name="anhChinh" placeholder="/assets/images/...">
            </div>

            <div class="admin-form-group admin-form-group-full">
                <label>Mô tả ngắn</label>
                <input type="text" name="moTaNgan">
            </div>

            <div class="admin-form-group admin-form-group-full">
                <label>Mô tả chi tiết</label>
                <textarea name="moTaChiTiet" rows="4"></textarea>
            </div>
        </div>

        <div class="admin-subsection">
            <h3>Chi tiết sản phẩm</h3>
            <div class="admin-popup-grid">
                <div class="admin-form-group">
                    <label>Thuộc tính 1</label>
                    <input type="text" name="thuocTinh1" placeholder="Chất liệu">
                </div>
                <div class="admin-form-group">
                    <label>Giá trị 1</label>
                    <input type="text" name="giaTri1" placeholder="Polyester">
                </div>
                <div class="admin-form-group">
                    <label>Thuộc tính 2</label>
                    <input type="text" name="thuocTinh2">
                </div>
                <div class="admin-form-group">
                    <label>Giá trị 2</label>
                    <input type="text" name="giaTri2">
                </div>
                <div class="admin-form-group">
                    <label>Thuộc tính 3</label>
                    <input type="text" name="thuocTinh3">
                </div>
                <div class="admin-form-group">
                    <label>Giá trị 3</label>
                    <input type="text" name="giaTri3">
                </div>
            </div>
        </div>

        <div class="admin-subsection">
            <h3>Biến thể size và số lượng</h3>
            <div id="variantRows">
                <div class="admin-variant-row">
                    <select name="maSize" required>
                        <c:forEach var="size" items="${dsSize}">
                            <option value="${size.maSize}">${size.tenSize}</option>
                        </c:forEach>
                    </select>
                    <input type="number" name="soLuongTon" min="0" placeholder="Số lượng" required>
                    <input type="number" name="giaRieng" min="0" step="1000" placeholder="Giá riêng size (nếu có)">
                    <button type="button" class="remove-variant-btn">Xóa</button>
                </div>
            </div>

            <button type="button" class="add-variant-btn" id="addVariantRowBtn">+ Thêm size</button>
        </div>

        <div class="admin-subsection">
            <h3>Ảnh phụ</h3>
            <div id="subImageRows">
                <div class="admin-sub-image-row">
                    <input type="text" name="anhPhu" placeholder="/assets/images/...">
                    <button type="button" class="remove-sub-image-btn">Xóa</button>
                </div>
            </div>
            <button type="button" class="add-sub-image-btn" id="addSubImageBtn">+ Thêm ảnh phụ</button>
        </div>

        <div class="admin-capital-preview" id="capitalPreviewBox">
            <p>Tổng số lượng nhập: <strong id="previewTongSoLuong">0</strong></p>
            <p>% giảm nhập: <strong id="previewPhanTramGiam">0%</strong></p>
            <p>Đơn giá nhập thực tế: <strong id="previewGiaNhapThucTe">0</strong></p>
            <p>Tổng tiền sẽ trừ vốn: <strong id="previewTongTienNhap">0</strong></p>

            <hr style="grid-column: 1 / -1; border: none; height: 1px; background: rgba(255,255,255,0.2); margin: 10px 0;">

            <p>Vốn hiện tại:
                <strong id="previewVonHienTai">
                    <c:choose>
                        <c:when test="${vonHienTai != null}">
                            <fmt:formatNumber value="${vonHienTai}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                        </c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </strong>
            </p>
            <p>Vốn sau khi nhập:
                <strong id="previewVonSau">0</strong>
            </p>
        </div>

        <div class="admin-popup-actions">
            <button type="button" class="admin-btn-cancel" id="cancelAddProductPopup">Hủy</button>
            <button type="submit" class="admin-btn-submit">Lưu sản phẩm</button>
        </div>
    </form>
</div>