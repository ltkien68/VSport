<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.NguoiDung" %>

<%
    NguoiDung nguoiDungPopup = (NguoiDung) request.getAttribute("nguoiDung");
    if (nguoiDungPopup == null) {
        nguoiDungPopup = (NguoiDung) session.getAttribute("nguoiDung");
    }
%>

<div class="profile-popup-overlay" id="profilePopupOverlay"></div>

<div class="profile-popup" id="profilePopup"
     >
    <div class="profile-popup-header">
        <h3>CẬP NHẬT THÔNG TIN CÁ NHÂN</h3>
        <button type="button" class="profile-popup-close" id="closeProfilePopup">×</button>
    </div>

    <form class="profile-popup-form"
          action="${pageContext.request.contextPath}/cap_nhat_thong_tin_ca_nhan"
          method="post"
          enctype="multipart/form-data">

        <div class="profile-popup-grid">
            <div class="profile-popup-field full">
                <label>Ảnh đại diện từ máy</label>
                <input type="file" name="avatarFile" accept="image/*">
                <small>Hỗ trợ jpg, jpeg, png, gif, webp, bmp, svg, avif.</small>
            </div>

            <div class="profile-popup-field full">
                <label>Hoặc nhập link ảnh / đường dẫn ảnh</label>
                <input type="text" name="avatarUrl"
                       value="<%= nguoiDungPopup != null && nguoiDungPopup.getAvatar() != null ? nguoiDungPopup.getAvatar() : "" %>"
                       placeholder="https://... hoặc /assets/images/...">
            </div>

            <div class="profile-popup-field">
                <label>Họ và tên</label>
                <input type="text" name="hoTen"
                       value="<%= nguoiDungPopup != null && nguoiDungPopup.getHoTen() != null ? nguoiDungPopup.getHoTen() : "" %>"
                       placeholder="Nhập họ và tên">
            </div>

            <div class="profile-popup-field">
                <label>Email</label>
                <input type="email" name="email"
                       value="<%= nguoiDungPopup != null && nguoiDungPopup.getEmail() != null ? nguoiDungPopup.getEmail() : "" %>"
                       placeholder="Nhập email">
            </div>

            <div class="profile-popup-field">
                <label>Số điện thoại</label>
                <input type="text" name="soDienThoai"
                       value="<%= nguoiDungPopup != null && nguoiDungPopup.getSoDienThoai() != null ? nguoiDungPopup.getSoDienThoai() : "" %>"
                       placeholder="Nhập số điện thoại">
            </div>

            <div class="profile-popup-field">
                <label>Ngày sinh</label>
                <input type="date" name="ngaySinh"
                       value="<%= nguoiDungPopup != null && nguoiDungPopup.getNgaySinh() != null ? nguoiDungPopup.getNgaySinh().toString() : "" %>">
            </div>

            <div class="profile-popup-field full">
                <label>Địa chỉ</label>
                <textarea name="diaChi" rows="4" placeholder="Nhập địa chỉ đầy đủ"><%= nguoiDungPopup != null && nguoiDungPopup.getDiaChi() != null ? nguoiDungPopup.getDiaChi() : "" %></textarea>
            </div>
        </div>

        <div class="profile-popup-actions">
            <button type="button" class="profile-cancel-btn" id="cancelProfilePopup">HỦY</button>
            <button type="submit" class="profile-submit-btn">LƯU THÔNG TIN</button>
        </div>
    </form>
</div>