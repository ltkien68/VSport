<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="model.SanPham" %>
<%@ page import="model.YeuThich" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    List<SanPham> danhSachSanPham = (List<SanPham>) request.getAttribute("danhSachSanPham");

    List<YeuThich> dsYeuThich = (List<YeuThich>) request.getAttribute("dsYeuThich");
    if (dsYeuThich == null) {
        dsYeuThich = new java.util.ArrayList<>();
    }

    Set<Integer> sanPhamDaThich = new HashSet<>();
    for (YeuThich yt : dsYeuThich) {
        sanPhamDaThich.add(yt.getMaSanPham());
    }

    String pageTitle = request.getAttribute("pageTitle") != null
            ? String.valueOf(request.getAttribute("pageTitle"))
            : "GIÀY · GĂNG · BÓNG ĐÁ";
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/giay_gang_product.css">
    <jsp:include page="/WEB-INF/views/common/head.jsp" />
</head>
<body>

<main class="club-products-page">

    <section class="club-hero club-hero-simple">
        <div class="club-container">
            <h1 class="club-title"><%= pageTitle %></h1>
        </div>
        <div class="club-hero-bottom-strip"></div>
    </section>

    <%@ include file="/WEB-INF/views/common/giay_gang_product_nav.jsp" %>

    <section class="club-products-section">
        <div class="club-container">
            <div class="club-products-grid">

                <%
                    if (danhSachSanPham != null) {
                        for (int i = 0; i < danhSachSanPham.size(); i++) {
                            SanPham sp = danhSachSanPham.get(i);
                            boolean daThich = sanPhamDaThich.contains(sp.getMaSanPham());
                %>

                <div class="club-product-card <%= (sp.getGiaKhuyenMai() > 0 && sp.getGiaKhuyenMai() > 0) ? "has-sale" : "" %>">
                    <a href="${pageContext.request.contextPath}/chi-tiet-san-pham/<%= sp.getMaSanPham() %>" class="club-product-image-link">
                        <div class="club-product-image-wrap">

                            <img src="${pageContext.request.contextPath}/<%= sp.getAnhChinh() %>"
                                 alt="<%= sp.getTenSanPham() %>"
                                 class="club-product-image club-product-image-primary">

                            <img src="${pageContext.request.contextPath}/<%= sp.getAnhChinh() != null ? sp.getAnhChinh().replace("1.avif", "2.avif") : "" %>"
                                 alt="<%= sp.getTenSanPham() %>"
                                 class="club-product-image club-product-image-secondary">

                            <button
                                class="club-favorite-btn <%= daThich ? "active" : "" %>"
                                type="button"
                                data-product-id="<%= sp.getMaSanPham() %>">
                                <%= daThich ? "♥" : "♡" %>
                            </button>
                        </div>
                    </a>

                    <div class="club-product-info">
                        <p class="club-product-price <%= (sp.getGiaKhuyenMai() > 0 && sp.getGiaKhuyenMai() > 0) ? "is-sale" : "" %>">

                            <% if (sp.getGiaKhuyenMai() > 0 && sp.getGiaKhuyenMai() > 0) { %>
                                <span class="club-product-price-old">
                                    <%= String.format("%,.0f", sp.getGiaNiemYet()) %>đ
                                </span>

                                <span class="club-product-price-sale">
                                    <%= String.format("%,.0f", sp.getGiaSanPham()) %>đ
                                </span>
                            <% } else { %>
                                <span class="club-product-price-normal">
                                    <%= String.format("%,.0f", sp.getGiaSanPham()) %>đ
                                </span>
                            <% } %>
                        </p>

                        <h3 class="club-product-name"><%= sp.getTenSanPham() %></h3>

                        <p class="club-product-desc">
                            <%= sp.getMoTaNgan() != null ? sp.getMoTaNgan() : "" %>
                        </p>
                    </div>
                </div>

                <%
                            if ((i == 5 || i == 9 || i == 17) && (i + 1) < danhSachSanPham.size()) {
                %>
                    <div class="club-inline-banner">
                        <div class="club-inline-banner-inner">
                            <span>🔥 PERFORMANCE FOOTBALL GEAR</span>
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



</body>
</html>