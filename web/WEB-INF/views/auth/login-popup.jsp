<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.NguoiDung" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    NguoiDung nguoiDungPopup = (NguoiDung) session.getAttribute("nguoiDung");

    String loginError = (String) session.getAttribute("loginError");
    Boolean openLoginPopup = (Boolean) session.getAttribute("openLoginPopup");
    Boolean loginSuccess = (Boolean) session.getAttribute("loginSuccess");

    String thongBao = (String) session.getAttribute("thongBao");

    String registerError = (String) session.getAttribute("registerError");
    Boolean openRegisterPopup = (Boolean) session.getAttribute("openRegisterPopup");

    String registerHoTen = (String) session.getAttribute("registerHoTen");
    String registerEmail = (String) session.getAttribute("registerEmail");
    String registerSoDienThoai = (String) session.getAttribute("registerSoDienThoai");

    String toastSuccess = (String) session.getAttribute("toastSuccess");
    String toastError = (String) session.getAttribute("toastError");

    if (loginSuccess != null && loginSuccess) {
        request.setAttribute("loginSuccess", true);
        session.removeAttribute("loginSuccess");
    }

    if (loginError != null) {
        request.setAttribute("loginError", loginError);
        session.removeAttribute("loginError");
    }

    if (openLoginPopup != null && openLoginPopup) {
        request.setAttribute("openLoginPopup", true);
        session.removeAttribute("openLoginPopup");
    }

    if (thongBao != null) {
        request.setAttribute("thongBao", thongBao);
        session.removeAttribute("thongBao");
    }

    if (registerError != null) {
        request.setAttribute("registerError", registerError);
        session.removeAttribute("registerError");
    }

    if (openRegisterPopup != null && openRegisterPopup) {
        request.setAttribute("openRegisterPopup", true);
        session.removeAttribute("openRegisterPopup");
    }

    if (registerHoTen != null) {
        request.setAttribute("registerHoTen", registerHoTen);
        session.removeAttribute("registerHoTen");
    }

    if (registerEmail != null) {
        request.setAttribute("registerEmail", registerEmail);
        session.removeAttribute("registerEmail");
    }

    if (registerSoDienThoai != null) {
        request.setAttribute("registerSoDienThoai", registerSoDienThoai);
        session.removeAttribute("registerSoDienThoai");
    }

    if (toastSuccess != null) {
        request.setAttribute("toastSuccess", toastSuccess);
        session.removeAttribute("toastSuccess");
    }

    if (toastError != null) {
        request.setAttribute("toastError", toastError);
        session.removeAttribute("toastError");
    }
%>

<c:if test="${not empty toastSuccess}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            if (window.toastr) {
                toastr.success("${toastSuccess}");
            }
        });
    </script>
</c:if>

<c:if test="${not empty toastError}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            if (window.toastr) {
                toastr.error("${toastError}");
            }
        });
    </script>
</c:if>

<% if (nguoiDungPopup == null) { %>

<div
    id="loginPopupOverlay"
    class="login-popup-overlay"
    data-open="${openLoginPopup ? 'true' : 'false'}"
    data-register-open="${openRegisterPopup ? 'true' : 'false'}"
    data-login-error="${loginError != null ? loginError : ''}"
    data-login-success="${loginSuccess ? 'true' : 'false'}"
    data-register-error="${registerError != null ? registerError : ''}"
    data-register-success-message="${thongBao != null ? thongBao : ''}"
>
    <div class="login-popup-panel">
        <button type="button" class="login-popup-close" id="closeLoginPopup" aria-label="Đóng">
            x
        </button>

        <div class="login-popup-inner">
            <div class="login-logo">
                <img src="${pageContext.request.contextPath}/assets/images/logos/logo.png" alt="logo"/>
            </div>

            <h2 class="login-popup-title" id="authPopupTitle">CHÀO MỪNG TRỞ LẠI</h2>

            <p class="login-popup-subtitle" id="authPopupSubtitle">
                Đăng nhập để không bỏ lỡ bất kỳ sản phẩm và ưu đãi nào.
            </p>

            <p class="login-popup-note" id="authPopupNote">
                Nhập thông tin tài khoản của bạn để tiếp tục mua sắm cùng
                <span style="font-weight: bold">
                    <span style="color: var(--color-red)">V</span>$PORT
                </span>
            </p>

            <div id="loginFormWrap" class="auth-form-wrap active">
                <div class="login-popup-switch">
                    <button type="button" class="login-switch-btn active" data-type="email">
                        E-MAIL
                    </button>
                    <button type="button" class="login-switch-btn" data-type="phone">
                        SỐ ĐIỆN THOẠI
                    </button>
                </div>

                <form action="${pageContext.request.contextPath}/auth_login"
                      method="post"
                      class="login-popup-form"
                      id="loginPopupForm">

                    <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/trang_chu">

                    <div class="login-popup-field">
                        <label for="popupDangNhap" id="loginLabel" class="login-popup-label">E-MAIL</label>
                        <input
                            type="text"
                            id="popupDangNhap"
                            name="dangNhap"
                            class="login-popup-input"
                            placeholder="E-mail"
                            required
                        >
                    </div>

                    <div class="login-popup-field">
                        <label for="popupPassword" class="login-popup-label">MẬT KHẨU</label>

                        <div class="login-popup-password-wrap">
                            <input
                                type="password"
                                id="popupPassword"
                                name="matKhau"
                                class="login-popup-input login-popup-input-password"
                                placeholder="Password"
                                required
                            >

                            <button type="button"
                                    class="login-popup-password-toggle"
                                    id="togglePopupPassword"
                                    aria-label="Hiện mật khẩu">
                                <i data-lucide="eye-off"></i>
                            </button>
                        </div>
                    </div>

                    <div class="login-popup-forgot-wrap">
                        <a href="${pageContext.request.contextPath}/quen_mat_khau" class="login-popup-forgot">
                            Bạn quên mật khẩu?
                        </a>
                    </div>

                    <button type="submit" class="login-popup-submit">ĐĂNG NHẬP</button>

                    <p class="login-popup-submit-error ${not empty loginError ? 'show' : ''}" id="loginPopupSubmitError">
                        ${loginError}
                    </p>

                    <div class="login-popup-register" id="loginSwitchBox">
                        <span>Bạn chưa có tài khoản?</span>
                        <a href="#" id="showRegisterForm">Đăng ký ngay!</a>
                    </div>
                </form>
            </div>

            <div id="registerFormWrap" class="auth-form-wrap">
                <form action="${pageContext.request.contextPath}/dang_ky"
                      method="post"
                      class="login-popup-form"
                      id="registerPopupForm">

                    <div class="login-popup-field">
                        <label for="registerHoTen" class="login-popup-label">HỌ VÀ TÊN</label>
                        <input
                            type="text"
                            id="registerHoTen"
                            name="hoTen"
                            class="login-popup-input"
                            placeholder="Họ và tên"
                            value="${registerHoTen}"
                            required
                        >
                    </div>

                    <div class="login-popup-field">
                        <label for="registerEmail" class="login-popup-label">E-MAIL</label>
                        <input
                            type="email"
                            id="registerEmail"
                            name="email"
                            class="login-popup-input"
                            placeholder="E-mail"
                            value="${registerEmail}"
                            required
                        >
                    </div>

                    <div class="login-popup-field">
                        <label for="registerPhone" class="login-popup-label">SỐ ĐIỆN THOẠI</label>
                        <input
                            type="text"
                            id="registerPhone"
                            name="soDienThoai"
                            class="login-popup-input"
                            placeholder="Số điện thoại"
                            value="${registerSoDienThoai}"
                            required
                        >
                    </div>

                    <div class="login-popup-field">
                        <label for="registerPassword" class="login-popup-label">MẬT KHẨU</label>

                        <div class="login-popup-password-wrap">
                            <input
                                type="password"
                                id="registerPassword"
                                name="matKhau"
                                class="login-popup-input login-popup-input-password"
                                placeholder="Mật khẩu"
                                required
                            >

                            <button type="button"
                                    class="login-popup-password-toggle register-password-toggle"
                                    aria-label="Hiện mật khẩu">
                                <i data-lucide="eye-off"></i>
                            </button>
                        </div>
                    </div>

                    <div class="login-popup-field">
                        <label for="registerConfirmPassword" class="login-popup-label">XÁC NHẬN MẬT KHẨU</label>

                        <div class="login-popup-password-wrap">
                            <input
                                type="password"
                                id="registerConfirmPassword"
                                name="xacNhanMatKhau"
                                class="login-popup-input login-popup-input-password"
                                placeholder="Nhập lại mật khẩu"
                                required
                            >

                            <button type="button"
                                    class="login-popup-password-toggle register-password-toggle"
                                    aria-label="Hiện mật khẩu">
                                <i data-lucide="eye-off"></i>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="login-popup-submit">ĐĂNG KÝ</button>

                    <div class="login-popup-register" id="registerSwitchBox" style="margin-top: 20px">
                        <span>Bạn đã có tài khoản?</span>
                        <a href="#" id="showLoginForm">Đăng nhập ngay!</a>
                    </div>
                </form>
            </div>

            <p class="login-popup-submit-error ${not empty registerError ? 'show' : ''}" id="registerPopupSubmitError">
                ${registerError}
            </p>
        </div>
    </div>
</div>

<% } %>