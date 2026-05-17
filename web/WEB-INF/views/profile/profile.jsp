<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.NguoiDung" %>

<%
    NguoiDung nguoiDungProfile = (NguoiDung) session.getAttribute("nguoiDung");

    if (nguoiDungProfile == null) {
        response.sendRedirect(request.getContextPath() + "/trang_chu");
        return;
    }

    String avatar = nguoiDungProfile.getAvatar();
    String hoTen = nguoiDungProfile.getHoTen();
    String email = nguoiDungProfile.getEmail();
    String soDienThoai = nguoiDungProfile.getSoDienThoai();
    String diaChi = nguoiDungProfile.getDiaChi();
    Date ngaySinh = nguoiDungProfile.getNgaySinh();

    boolean thieuAvatar = (avatar == null || avatar.trim().isEmpty());
    boolean thieuDiaChi = (diaChi == null || diaChi.trim().isEmpty());
    boolean thieuSoDienThoai = (soDienThoai == null || soDienThoai.trim().isEmpty());
    boolean thieuNgaySinh = (ngaySinh == null);

    boolean chuaHoanThienHoSo = thieuAvatar || thieuDiaChi || thieuNgaySinh || thieuSoDienThoai;

    boolean duAvatar = (avatar != null && !avatar.trim().isEmpty());
    boolean duSDT = (soDienThoai != null && !soDienThoai.trim().isEmpty());
    boolean duDiaChi = (diaChi != null && !diaChi.trim().isEmpty());
    boolean duNgaySinh = (ngaySinh != null);

    boolean daHoanThien = duAvatar && duSDT && duDiaChi && duNgaySinh;

    int tongThongTinBatBuoc = 4;
    int daCo = 0;
    if (!thieuAvatar) {
        daCo++;
    }
    if (!thieuDiaChi) {
        daCo++;
    }
    if (!thieuNgaySinh) {
        daCo++;
    }
    if (!thieuSoDienThoai) {
        daCo++;
    }

    int phanTramHoanThien = (daCo * 100) / tongThongTinBatBuoc;

    boolean coAvatar = (avatar != null && !avatar.trim().isEmpty());

    String kyTuDau = "U"; // default
    if (hoTen != null && !hoTen.isEmpty()) {
        kyTuDau = hoTen.substring(0, 1).toUpperCase();
    }

    // tạo màu random dựa theo user id (để không bị đổi mỗi lần load)
    String[] mauNen = {
        "#FF6B6B", "#4ECDC4", "#556270", "#C7F464",
        "#C44D58", "#6A0572", "#F67280", "#355C7D",
        "#00ADB5", "#F8B500"
    };

    int indexMau = nguoiDungProfile.getMaNguoiDung() % mauNen.length;
    String mauAvatar = mauNen[indexMau];

    String[] tachTen = (hoTen != null) ? hoTen.trim().split("\\s+") : new String[0];
    String ten = "";
    String ho = "";

    if (tachTen.length == 1) {
        ten = tachTen[0];
    } else if (tachTen.length > 1) {
        ten = tachTen[tachTen.length - 1];
        StringBuilder sbHo = new StringBuilder();
        for (int i = 0; i < tachTen.length - 1; i++) {
            sbHo.append(tachTen[i]);
            if (i < tachTen.length - 2) {
                sbHo.append(" ");
            }
        }
        ho = sbHo.toString();
    }

    String maThanhVien = "VS" + String.format("%06d", nguoiDungProfile.getMaNguoiDung());
    String maHoSo = "HS" + String.format("%010d", nguoiDungProfile.getMaNguoiDung());

    request.setAttribute("nguoiDung", nguoiDungProfile);
%>

<%
    String toastSuccess = (String) session.getAttribute("toastSuccess");
    String toastError = (String) session.getAttribute("toastError");

    if (toastSuccess != null) {
        session.removeAttribute("toastSuccess");
    }
    if (toastError != null)
        session.removeAttribute("toastError");
%>

<%
    String avatarSrc = "";

    if (avatar != null && !avatar.trim().isEmpty()) {
        String avatarTrim = avatar.trim();

        if (avatarTrim.startsWith("http://") || avatarTrim.startsWith("https://")) {
            avatarSrc = avatarTrim;
        } else if (avatarTrim.startsWith("/")) {
            avatarSrc = request.getContextPath() + avatarTrim;
        } else {
            avatarSrc = request.getContextPath() + "/" + avatarTrim;
        }
    }
%>





<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thông Tin Cá Nhân  F.LKsport</title>

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo.png">

        <script>
            (function () {
                try {
                    const theme = localStorage.getItem("theme");
                    if (theme === "dark") {
                        document.documentElement.classList.add("dark-mode");
                    } else {
                        document.documentElement.classList.remove("dark-mode");
                    }
                } catch (e) {
                }
            })();
        </script>

    </head>
    <body class="profile-page">
        <jsp:include page="/WEB-INF/views/common/head.jsp" />
        <div class="header-shell">
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
            <%@ include file="/WEB-INF/views/common/navbar.jsp" %>
        </div>

        <section class="profile-hero">
            <video class="profile-hero-bg" autoplay muted loop playsinline>
                <source src="${pageContext.request.contextPath}/assets/images/users/banner.mp4" type="video/mp4">
            </video>
            <div class="profile-hero-overlay"></div>

            <div class="profile-hero-container">
                <div class="profile-hero-left">
                    <p class="profile-hero-subtitle">I'm <%= ten != null ? ten.toUpperCase() : "BẠN"%></p>
                    <h1 class="profile-hero-title">ĐÂY LÀ <span style="font-family: var(--font-display)">LK<span style="color: #D4AF37">$</span>PROFILE</span></h1>
                    <h2 class="profile-hero-title-2">CỦA TÔI</h2>
                </div>

                <div class="profile-hero-right">
                    <div class="profile-welcome-block">
                        <h2>CHÀO MỪNG<br><%= ten != null && !ten.isEmpty() ? ten.toUpperCase() : "BẠN"%>!</h2>
                        <p>Ngôi nhà của đam mê bóng đá, nơi từng cú chạm đều mang nhịp tim sân cỏ.</p>
                        <a href="javascript:void(0)" class="profile-help-link" id="openProfileFormTop">
                            <%= chuaHoanThienHoSo ? "CẦN HOÀN THIỆN?" : "HỒ SƠ ĐÃ HOÀN THIỆN"%>
                        </a>
                    </div>

                    <div class="profile-avatar-box">
                        <% if (coAvatar) {%>
                        <img src="<%= avatarSrc%>" alt="Avatar">
                        <% } else {%>
                        <div class="avatar-text" style="background: <%= mauAvatar%>;">
                            <%= kyTuDau%>
                        </div>
                        <% } %>
                        <button type="button" class="profile-avatar-edit-btn" id="openProfileFormAvatar">
                            <i data-lucide="camera"></i>
                        </button>
                    </div>
                </div>

                <% if (chuaHoanThienHoSo) {%>
                <div class="profile-progress-wrap">
                    <div class="profile-progress-left">
                        <span class="profile-progress-percent"><%= phanTramHoanThien%>%</span>
                        <span class="profile-progress-title">HOÀN THIỆN HỒ SƠ CỦA BẠN</span>
                    </div>

                    <div class="profile-progress-bottom">
                        <p class="profile-progress-desc">
                            Hãy bổ sung avatar, địa chỉ, ngày sinh và số điện thoại để hoàn thiện tài khoản của bạn.
                        </p>

                        <button type="button" class="profile-complete-btn" id="openProfileFormProgress">
                            HOÀN THIỆN HỒ SƠ
                        </button>
                    </div>

                    <div class="profile-progress-bar">
                        <div class="profile-progress-fill" style="width: <%= phanTramHoanThien%>%"></div>
                    </div>
                </div>
                <% } else { %>
                <div class="profile-progress-wrap">
                    <div class="profile-progress-left">
                        <span class="profile-progress-percent">100%</span>
                        <span class="profile-progress-title">HỒ SƠ ĐÃ HOÀN THIỆN</span>
                    </div>

                    <div class="profile-progress-bottom">
                        <p class="profile-progress-desc">
                            Đã đủ thông tin, bắt đầu hành trình mua sắm của bạn tại V$port.
                        </p>

                        <a href="${pageContext.request.contextPath}/bong_da"
                           class="profile-complete-btn profile-complete-btn-done">
                            MUA SẮM NGAY
                        </a>
                    </div>

                    <div class="profile-progress-bar">
                        <div class="profile-progress-fill" style="width: 100%"></div>
                    </div>
                </div>
                <% }%>
            </div>
        </section>

        <section class="profile-main">
            <div class="profile-main-container">


                <div class="profile-card-grid">
                    <a href="${pageContext.request.contextPath}/thong_tin_ca_nhan" class="profile-mini-card">
                        <div class="profile-mini-card-overlay"></div>
                        <h3>THÔNG TIN<br>CÁ NHÂN</h3>
                    </a>

                    <a href="${pageContext.request.contextPath}/gio_hang" class="profile-mini-card">
                        <div class="profile-mini-card-overlay"></div>
                        <h3>GIỎ HÀNG</h3>
                    </a>

                    <a href="${pageContext.request.contextPath}/kho_xu" class="profile-mini-card">
                        <div class="profile-mini-card-overlay"></div>
                        <h3>KHO XU<br>CỦA BẠN</h3>
                    </a>

                    <a href="${pageContext.request.contextPath}/ma_giam_gia" class="profile-mini-card">
                        <div class="profile-mini-card-overlay"></div>
                        <h3>KHO MÃ<br>GIẢM GIÁ</h3>
                    </a>
                </div>


            </div>
        </section>

        <div id="profilePageData"
             data-open-popup="<%= toastError != null ? "true" : "false"%>"
             data-toast-success="<%= toastSuccess != null ? toastSuccess : ""%>"
             data-toast-error="<%= toastError != null ? toastError : ""%>">
        </div>

        <jsp:include page="/WEB-INF/views/profile/profile-edit-popup.jsp" />

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />

        <script src="https://unpkg.com/lucide@latest"></script>
        <script>
            lucide.createIcons();
        </script>

        <script>
            window.contextPath = "${pageContext.request.contextPath}";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/common/scroll-reveal.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/pages/profile.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>

        <%-- jQuery bắt buộc cho Toastr --%>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <%-- Toastr JS --%>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

        <script>
            toastr.options = {
                closeButton: true,
                progressBar: true,
                newestOnTop: true,
                preventDuplicates: true,
                positionClass: "toast-bottom-right",
                timeOut: "1000",
                extendedTimeOut: "1000",
                showDuration: "250",
                hideDuration: "250",
                showMethod: "fadeIn",
                hideMethod: "fadeOut"
            };
        </script>



    </body>
</html>