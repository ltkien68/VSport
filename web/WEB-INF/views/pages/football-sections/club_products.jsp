<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.SanPham" %>
<%@ page import="model.YeuThich" %>
<%@ page import="model.DoiBong" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    List<SanPham> danhSachSanPham = (List<SanPham>) request.getAttribute("danhSachSanPham");
    List<DoiBong> danhSachDoiBong = (List<DoiBong>) request.getAttribute("danhSachDoiBong");
    DoiBong doiBongHienTai = (DoiBong) request.getAttribute("doiBongHienTai");
%>

<%
    Object userObj = session.getAttribute("nguoiDung");
    boolean daDangNhap = (userObj != null);
%>

<%
    List<YeuThich> dsYeuThich = (List<YeuThich>) request.getAttribute("dsYeuThich");
    if (dsYeuThich == null) {
        dsYeuThich = new java.util.ArrayList<>();
    }

    Set<Integer> sanPhamDaThich = new HashSet<>();
    for (YeuThich yt : dsYeuThich) {
        sanPhamDaThich.add(yt.getMaSanPham());
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">


        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/club_products.css">
        <jsp:include page="/WEB-INF/views/common/head.jsp" />

    </head>
    <body>


        <main class="club-products-page">

            <!-- BREADCRUMB -->

            <!-- HERO -->
            <section class="club-hero">
                <div class="club-container">
                    <h1 class="club-title">
                        <%= (doiBongHienTai != null && doiBongHienTai.getFanClub() != null)
                    ? doiBongHienTai.getFanClub().toUpperCase()
                    : "BÓNG ĐÁ"%> · ĐAM MÊ · BÓNG ĐÁ
                    </h1>

                    <div class="club-mini-categories-wrapper">
                        <div class="club-mini-categories">

                            <a class="club-mini-card"
                               href="${pageContext.request.contextPath}/bong_da/${doiBongHienTai.doiSlug}?loai=ao-san-nha">
                                <div class="club-mini-image">
                                    <img src="${pageContext.request.contextPath}/assets/images/banners/mini-banner/${doiBongHienTai.doiSlug}/mini-banner1.avif"
                                         alt="mini-banner-1"
                                         class="mini-banner">
                                </div>
                                <span>HOME KIT 25/26</span>
                            </a>

                            <a class="club-mini-card"
                               href="${pageContext.request.contextPath}/bong_da/${doiBongHienTai.doiSlug}?loai=ao-san-khach">
                                <div class="club-mini-image">
                                    <img src="${pageContext.request.contextPath}/assets/images/banners/mini-banner/${doiBongHienTai.doiSlug}/mini-banner2.avif"
                                         alt="mini-banner-2"
                                         class="mini-banner">
                                </div>
                                <span>AWAY KIT 25/26</span>
                            </a>

                            <a class="club-mini-card"
                               href="${pageContext.request.contextPath}/bong_da/${doiBongHienTai.doiSlug}?loai=ao-thu-ba">
                                <div class="club-mini-image">
                                    <img src="${pageContext.request.contextPath}/assets/images/banners/mini-banner/${doiBongHienTai.doiSlug}/mini-banner3.avif"
                                         alt="mini-banner-3"
                                         class="mini-banner">
                                </div>
                                <span>THIRD KIT 25/26</span>
                            </a>

                            <a class="club-mini-card"
                               href="${pageContext.request.contextPath}/bong_da/${doiBongHienTai.doiSlug}?loai=ao-ngoai-san-co">
                                <div class="club-mini-image">
                                    <img src="${pageContext.request.contextPath}/assets/images/banners/mini-banner/${doiBongHienTai.doiSlug}/mini-banner4.avif"
                                         alt="mini-banner-4"
                                         class="mini-banner">
                                </div>
                                <span>NGOÀI SÂN CỎ</span>
                            </a>

                            <a class="club-mini-card"
                               href="${pageContext.request.contextPath}/bong_da/${doiBongHienTai.doiSlug}?loai=ao-tap-luyen">
                                <div class="club-mini-image">
                                    <img src="${pageContext.request.contextPath}/assets/images/banners/mini-banner/${doiBongHienTai.doiSlug}/mini-banner5.avif"
                                         alt="mini-banner-5"
                                         class="mini-banner">
                                </div>
                                <span>TẬP LUYỆN</span>
                            </a>

                        </div>
                    </div>
                </div>

                <div class="club-hero-bottom-strip"></div>
            </section>

            <!-- FILTER BAR -->
            <%@ include file="/WEB-INF/views/common/club_product_nav.jsp" %>

            <!-- PRODUCT GRID -->
            <section class="club-products-section">
                <div class="club-container">
                    <div class="club-products-grid">

                        <%
                            if (danhSachSanPham != null) {
                                for (int i = 0; i < danhSachSanPham.size(); i++) {
                                    SanPham sp = danhSachSanPham.get(i);
                        %>

                        <div class="club-product-card  tilt-card <%= sp.getGiaKhuyenMai() > 0 ? "has-sale" : ""%>">
                            <a href="${pageContext.request.contextPath}/chi-tiet-san-pham/<%= sp.getMaSanPham()%>" class="club-product-image-link">
                                <div class="club-product-image-wrap">


                                    <img src="${pageContext.request.contextPath}/<%= sp.getAnhChinh()%>" 
                                         alt="<%= sp.getTenSanPham()%>" 
                                         class="club-product-image club-product-image-primary">

                                    <img src="${pageContext.request.contextPath}/<%= sp.getAnhChinh().replace("1.avif", "2.avif")%>" 
                                         alt="<%= sp.getTenSanPham()%>" 
                                         class="club-product-image club-product-image-secondary">

                                    <%
                                        boolean daThich = sanPhamDaThich.contains(sp.getMaSanPham());
                                    %>

                                    <button 
                                        class="club-favorite-btn <%= daThich ? "active" : ""%>"
                                        type="button"
                                        data-product-id="<%= sp.getMaSanPham()%>">
                                        <%= daThich ? "♥" : "♡"%>
                                    </button>
                                </div>
                            </a>

                            <div class="club-product-info">
                                <p class="club-product-price <%=sp.getGiaKhuyenMai() > 0 ? "is-sale" : ""%>">

                                    <% if (sp.getGiaKhuyenMai() > 0) {%>

                                    <!-- Giá gốc -->
                                    <span class="club-product-price-old">
                                        <%= String.format("%,.0f", sp.getGiaNiemYet())%>đ
                                    </span>

                                    <!-- Giá cuối (đã xử lý logic) -->
                                    <span class="club-product-price-sale">
                                        <%= String.format("%,.0f", sp.getGiaSanPham())%>đ
                                    </span>

                                    <% } else {%>

                                    <!-- Không sale → dùng luôn giá cuối -->
                                    <span class="club-product-price-normal">
                                        <%= String.format("%,.0f", sp.getGiaSanPham())%>đ
                                    </span>

                                    <% }%>

                                </p>

                                <h3 class="club-product-name"><%= sp.getTenSanPham()%></h3>

                                <p class="club-product-desc">
                                    <%= sp.getMoTaNgan() != null ? sp.getMoTaNgan() : ""%>
                                </p>
                            </div>
                        </div>

                        <%
                            // Cứ 12 sản phẩm (3 hàng x 4 cột) chèn 1 banner
                            if ((i == 5 || i == 9 || i == 17)
                                    && (i + 1) < danhSachSanPham.size()) {
                        %>
                        <div class="club-inline-banner">
                            <div class="club-inline-banner-inner">
                                <span>🔥 SALE UP TO 50%</span>
                            </div>
                        </div>
                        <%
                                    }
                                }
                            }
                        %>

                    </div>
                </div>
            </section>

        </main>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />

        <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>

        <script src="${pageContext.request.contextPath}/assets/js/pages/club_products.js"></script>
    </body>
</html>