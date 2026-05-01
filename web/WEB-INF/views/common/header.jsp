<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dao.GioHangDAO" %>
<%@ page import="model.GioHangSum" %>
<%@ page import="model.NguoiDung" %>

<%
    int tongMatHang = 0;

    try {
        GioHangDAO gioHangDAO = new GioHangDAO();
        GioHangSum tongQuanHeader = null;

        Object userObj = session.getAttribute("nguoiDung");

        if (userObj != null) {
            NguoiDung nguoiDung = (NguoiDung) userObj;
            tongQuanHeader = gioHangDAO.getTongQuanGioHang(nguoiDung.getMaNguoiDung());

            if (tongQuanHeader != null) {
                tongMatHang = tongQuanHeader.getTongMatHang();
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        tongMatHang = 0;
    }
%>

<%
    Object userObj = session.getAttribute("nguoiDung");
    boolean isLogin = (userObj != null);
%>

<header class="site-header" id="siteHeader">
    <div class="header-container">
        <div class="header-left">
            <a href="${pageContext.request.contextPath}/trang_chu" class="logo-link">
                <img src="${pageContext.request.contextPath}/assets/images/logos/logo.png" alt="Logo" class="logo-img">
            </a>
        </div>

        <div class="header-center">
            <a href="${pageContext.request.contextPath}/trang_chu" class="store-title">
                <span>VIET<span style="color: #D4AF37">$</span>PORT</span> OFFICIAL ONLINE STORE
            </a>

            <div class="store-subtitle">
                <p class="subtitle-address">Nâng Tầm Cuộc Chơi</p>
            </div>
        </div>

        <div class="header-right">
            <div class="search-box">
                <button type="button" class="search-box" id="openSearchPopup">
                    <i data-lucide="search"></i>
                    <span>TÌM KIẾM</span>
                </button>   
            </div>

            <a href="${pageContext.request.contextPath}/gio_hang" class="header-icon cart-link">
                <i data-lucide="handbag"></i>
                <span class="cart-count"><%= tongMatHang %></span>
            </a>

            <div class="header-user">

    <% if (!isLogin) { %>
        <!-- CHƯA LOGIN -->
        <a href="javascript:void(0)"
           class="header-icon"
           id="openLoginPopup">
            <i data-lucide="user"></i>
        </a>
    <% } else { %>
        <!-- ĐÃ LOGIN -->
        <a href="javascript:void(0)"
           class="header-icon logged-in">
            <i data-lucide="user"></i>
        </a>

        <div class="user-dropdown">
            <a href="${pageContext.request.contextPath}/thong_tin_ca_nhan">Thông tin tài khoản</a>
            <a href="${pageContext.request.contextPath}/don-hang?tab=cho_xac_nhan">Lịch sử đơn hàng</a>
            <a href="${pageContext.request.contextPath}/dang_xuat">Đăng xuất</a>
        </div>
    <% } %>

</div>
    
    <div class="theme-toggle-wrap">
    <button type="button" class="theme-toggle-btn" id="themeToggleBtn" aria-label="Chuyển giao diện">
        <span class="theme-toggle-track">
            <i data-lucide="sun" class="theme-icon theme-icon-sun"></i>
            <i data-lucide="moon" class="theme-icon theme-icon-moon"></i>
            <span class="theme-toggle-thumb"></span>
        </span>
    </button>
</div>
        </div>
    </div>
                
    
    <script>
    (function () {
        try {
            const theme = localStorage.getItem("theme");
            if (theme === "dark") {
                document.documentElement.classList.add("dark-mode");
            } else {
                document.documentElement.classList.remove("dark-mode");
            }
        } catch (e) {}
    })();
    </script>
                
</header>
                
                <div class="search-overlay" id="searchOverlay">
    <div class="search-overlay-inner">
        <button type="button" class="search-close-btn" id="closeSearchPopup">×</button>

        <div class="search-box-wrap">
            <h2 class="search-title">TÌM KIẾM SẢN PHẨM</h2>
            <p class="search-subtitle">Bạn đang cần gì?</p>

            <div class="search-input-wrap">
                <i data-lucide="search" class="search-input-icon"></i>
                <input 
                    type="text" 
                    id="searchInputPopup" 
                    class="search-input-popup"
                    placeholder="VD: Áo Real 26,..."
                    autocomplete="off"
                />
                <button type="button" class="search-clear-btn" id="clearSearchBtn">×</button>
            </div>
        </div>

        <div class="search-results-wrap" id="searchResultsWrap">
            <div class="search-empty-state">
                <p>Gõ tên sản phẩm, đội bóng, thương hiệu, danh mục, size...</p>
            </div>
        </div>
    </div>
</div>