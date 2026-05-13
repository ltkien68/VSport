<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.SanPham" %>
<%@ page import="model.YeuThich" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>

<%
    List<SanPham> dsGoiY = (List<SanPham>) request.getAttribute("dsGoiY");

    if (dsGoiY == null) {
        dsGoiY = new java.util.ArrayList<>();
    }
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

<% if (dsGoiY != null && !dsGoiY.isEmpty()) { %>

<% for (SanPham sp : dsGoiY) { %>

<!-- card -->

<% } %>

<% } else { %>

<p style="text-align:center;">Không có sản phẩm gợi ý 😢</p>

<% } %>

<section class="pd-random-section pd-random-reveal-section" id="pdRandomSection">

    <div class="pd-random-container">

        <div class="pd-random-head pd-random-reveal-title">
            <p class="pd-random-kicker">Recommended</p>
            <h2 class="pd-random-title">CÓ THỂ BẠN SẼ THÍCH</h2>
            <span class="pd-random-line"></span>
        </div>

        <div class="pd-random-grid pd-random-reveal-grid" id="pdRandomGrid">

            <% for (SanPham sp : dsGoiY) {%>


            <a class="pd-random-card <%= sp.getGiaKhuyenMai() > 0 ? "has-sale" : ""%>"
               href="<%= request.getContextPath()%>/chi-tiet-san-pham/<%= sp.getMaSanPham()%>">

                <div class="pd-random-image-wrap">

                    <img src="<%= request.getContextPath()%>/<%= sp.getAnhChinh()%>" 
                         alt="<%= sp.getTenSanPham()%>" 
                         class="pd-random-image pd-random-image-primary">

                    <img src="<%= request.getContextPath()%>/<%= sp.getAnhChinh().replace("1.avif", "2.avif")%>" 
                         alt="<%= sp.getTenSanPham()%>" 
                         class="pd-random-image pd-random-image-secondary">

                    <%
                        boolean daThich = sanPhamDaThich != null
                                && sanPhamDaThich.contains(sp.getMaSanPham());
                    %>

                    <button 
                        class="pd-random-favorite-btn <%= daThich ? "active" : ""%>"
                        type="button"
                        data-product-id="<%= sp.getMaSanPham()%>">
                        <%= daThich ? "♥" : "♡"%>
                    </button>

                    <% if (sp.getGiaKhuyenMai() > 0) { %>
                    <span class="pd-random-badge">SALE</span>
                    <% }%>

                </div>

                <div class="pd-random-info">

                    <div class="pd-random-price-wrap <%= sp.getGiaKhuyenMai() > 0 ? "is-sale" : ""%>">

                        <% if (sp.getGiaKhuyenMai() > 0) {%>

                        <span class="pd-random-old-price">
                            <%= String.format("%,.0f", sp.getGiaNiemYet())%>đ
                        </span>

                        <span class="pd-random-sale-price">
                            <%= String.format("%,.0f", sp.getGiaSanPham())%>đ
                        </span>

                        <% } else {%>

                        <span class="pd-random-normal-price">
                            <%= String.format("%,.0f", sp.getGiaSanPham())%>đ
                        </span>

                        <% }%>

                    </div>

                    <h3 class="pd-random-name"><%= sp.getTenSanPham()%></h3>

                    <p class="pd-random-desc">
                        <%= sp.getMoTaNgan() != null ? sp.getMoTaNgan() : ""%>
                    </p>

                </div>

            </a>


            <% }%>

        </div>

        <div class="pd-random-footer">
            <button onclick="window.location.href='${pageContext.request.contextPath}/trang_chu'" class="pd-random-btn">
                Xem thêm
            </button>
        </div>

    </div>

</section>