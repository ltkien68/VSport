<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.NguoiDung" %>
<%@page import="java.util.Date"%>

<%
    String activePage = (String) request.getAttribute("activePage");
    if (activePage == null) activePage = "dashboard";
%>

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
    if (!thieuAvatar) daCo++;
    if (!thieuDiaChi) daCo++;
    if (!thieuNgaySinh) daCo++;
    if (!thieuSoDienThoai) daCo++;

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
            if (i < tachTen.length - 2) sbHo.append(" ");
        }
        ho = sbHo.toString();
    }

    String maThanhVien = "VS" + String.format("%06d", nguoiDungProfile.getMaNguoiDung());
    String maHoSo = "HS" + String.format("%010d", nguoiDungProfile.getMaNguoiDung());

    request.setAttribute("nguoiDung", nguoiDungProfile);
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

<aside class="admin-sidebar">
    <div class="admin-sidebar-top">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-sidebar-brand">
            <div class="admin-sidebar-brand-icon"><img src="${pageContext.request.contextPath}/assets/images/logos/lk-logo.png" alt="alt"/></div>
            <div class="admin-sidebar-brand-text">
                <h2><span style="color: var(--text-highlight)">LK</span><span style="color: #D4AF37">$</span>PORT</h2>
                <span class="admin-sidebar-sub">Admin Panel</span>
            </div>
        </a>

        <div class="admin-sidebar-search">
            <span class="admin-sidebar-search-icon"><i data-lucide="search" size="18"></i></span>
            <input class="admin-sidebar-input" type="text" placeholder="Tìm kiếm...">
        </div>

        <nav class="admin-sidebar-nav">
            <a class="admin-sidebar-link <%= "dashboard".equals(activePage) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/admin/dashboard">
                <span class="admin-sidebar-link-icon"><i data-lucide="layout-dashboard" size="18"></i></span>
                <span>Tổng Quan</span>
            </a>

            <a class="admin-sidebar-link" href="javascript:void(0)">
                <span class="admin-sidebar-link-icon"><i data-lucide="trending-up-down"></i></span>
                <span>Hiệu Suất</span>
            </a>

            <a class="admin-sidebar-link" href="${pageContext.request.contextPath}/admin/von-shop">
                <span class="admin-sidebar-link-icon"><i data-lucide="wallet"></i></span>
                <span>Vốn Kho</span>
            </a>

            <a class="admin-sidebar-link <%= "product".equals(activePage) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/admin/san-pham">
                <span class="admin-sidebar-link-icon"><i data-lucide="warehouse"></i></span>
                <span>Kho Sản Phẩm</span>
            </a>

            <a class="admin-sidebar-link" href="${pageContext.request.contextPath}/admin/don-hang">
                <span class="admin-sidebar-link-icon"><i data-lucide="list-ordered"></i></span>
                <span>Đơn Hàng</span>
            </a>
            
            <a class="admin-sidebar-link" href="${pageContext.request.contextPath}/admin/don-hang">
                <span class="admin-sidebar-link-icon"><i data-lucide="list-ordered"></i></span>
                <span>Quản Lý</span>
            </a>
                
            <div class="admin-sidebar-submenu">
                <a class="admin-sidebar-sublink" href="${pageContext.request.contextPath}/admin/danh-muc">Danh Mục</a>
                <a class="admin-sidebar-sublink" href="${pageContext.request.contextPath}/admin/thuong-hieu">Thương Hiệu</a>
                <a class="admin-sidebar-sublink" href="javascript:void(0)">Đội Bóng</a>
                <a class="admin-sidebar-sublink" href="${pageContext.request.contextPath}/admin/qua-tang">Quà tặng</a>
                <a class="admin-sidebar-sublink" href="${pageContext.request.contextPath}/admin/ma-giam-gia">Mã giảm giá</a>
            </div>

            <a class="admin-sidebar-link" href="javascript:void(0)">
                <span class="admin-sidebar-link-icon"><i data-lucide="file-text"></i></span>
                <span>Tài Liệu</span>
            </a>

            <div class="admin-sidebar-submenu">
                <a class="admin-sidebar-sublink" href="javascript:void(0)">Hóa Đơn</a>
                <a class="admin-sidebar-sublink" href="javascript:void(0)">Phiếu Nhập / Xuất</a>
                <a class="admin-sidebar-sublink" href="javascript:void(0)">Báo Cáo</a>
            </div>
        </nav>
    </div>

    <div class="admin-sidebar-bottom">
        <div class="admin-sidebar-goal-card">
            <div class="admin-sidebar-goal-label">Mục Tiêu Tháng:</div>
            <div class="admin-sidebar-goal-value">
                $12,894.92 <span>/ $14,894.92</span>
            </div>

            <div class="admin-sidebar-goal-progress">
                <div class="admin-sidebar-goal-progress-bar"></div>
            </div>

            <a href="javascript:void(0)" class="admin-sidebar-goal-link">
                <span>See Details</span>
                <span>→</span>
            </a>
        </div>

        <div class="admin-sidebar-user-wrap">
            <div class="admin-sidebar-user-card" id="adminSidebarUserCard">
            <div class="admin-sidebar-user-avatar"><% if (coAvatar) { %>
                    <img src="<%= avatarSrc %>" alt="Avatar">
                <% } else { %>
                    <div class="avatar-text" style="background: <%= mauAvatar %>;">
                        <%= kyTuDau %>
                    </div>
                <% } %></div>
            <div class="admin-sidebar-user-info">
                <strong><%= nguoiDungProfile.getHoTen() != null ? nguoiDungProfile.getHoTen().toUpperCase() : "BẠN" %></strong>
                <span><%= nguoiDungProfile.getEmail() %></span>
            </div>
            <button type="button" class="admin-sidebar-user-more"><i data-lucide="chevron-down" id="adminSidebarUserMore"></i></button>
            </div>
                <div class="admin-sidebar-user-dropdown" id="adminSidebarUserDropdown">
            <div class="admin-sidebar-user-detail-row">
                <span class="label">Mã TV</span>
                <span class="value"><%= maThanhVien %></span>
            </div>

            <div class="admin-sidebar-user-detail-row">
                <span class="label">Mã hồ sơ</span>
                <span class="value"><%= maHoSo %></span>
            </div>

            <div class="admin-sidebar-user-detail-row">
                <span class="label">SĐT</span>
                <span class="value"><%= soDienThoai != null && !soDienThoai.trim().isEmpty() ? soDienThoai : "Chưa cập nhật" %></span>
            </div>

            <div class="admin-sidebar-user-detail-row">
                <span class="label">Địa chỉ</span>
                <span class="value"><%= diaChi != null && !diaChi.trim().isEmpty() ? diaChi : "Chưa cập nhật" %></span>
            </div>

            <div class="admin-sidebar-user-detail-row">
                <span class="label">Ngày sinh</span>
                <span class="value"><%= ngaySinh != null ? ngaySinh.toString() : "Chưa cập nhật" %></span>
            </div>

            <div class="admin-sidebar-user-detail-row admin-sidebar-user-detail-row--clickable"
                id="openProfilePopupFromSidebar">
               <span class="label">Hồ sơ</span>
               <button type="button"
                       class="admin-profile-progress-btn <%= daHoanThien ? "done" : "pending" %>">
                   <%= daHoanThien ? ("Hoàn thiện " + phanTramHoanThien + "%") : ("Hồ sơ " + phanTramHoanThien + "%") %>
               </button>
           </div>

            <div class="admin-sidebar-user-detail-row">
                <span class="label">Vai trò</span>
                <span class="value"><%= nguoiDungProfile.getVaiTro() %></span>
            </div>
        </div>
        </div>
        
    </div>
</aside>