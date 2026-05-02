<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@page import="model.SanPham"%>
<%@ page import="model.DoiBong" %>
<%@ page import="model.BienTheSanPham" %>

<%!
    public String renderStars(double rating) {
        StringBuilder html = new StringBuilder();

        int fullStars = (int) rating;
        double decimal = rating - fullStars;
        boolean hasHalf = decimal >= 0.5;

        int emptyStars = 5 - fullStars - (hasHalf ? 1 : 0);

        for (int i = 0; i < fullStars; i++) {
            html.append("<i data-lucide='star' class='pd-star-icon filled'></i>");
        }

        if (hasHalf) {
            html.append("<i data-lucide='star-half' class='pd-star-icon filled'></i>");
        }

        for (int i = 0; i < emptyStars; i++) {
            html.append("<i data-lucide='star' class='pd-star-icon empty'></i>");
        }

        return html.toString();
    }
%>

<%
    SanPham spInfo = (SanPham) request.getAttribute("sp");

    boolean isSale = spInfo.getGiaKhuyenMai() > 0;
    double percentSale = 0;
    if (isSale && spInfo.getGiaNiemYet() > 0) {
        percentSale = ((spInfo.getGiaNiemYet() - spInfo.getGiaKhuyenMai()) / spInfo.getGiaNiemYet()) * 100.0;
    }

    int vsXu = (int) Math.round(spInfo.getGiaSanPham() / 1000.0);

    List<BienTheSanPham> dsBienThe = (List<BienTheSanPham>) request.getAttribute("dsBienThe");
%>



<div class="pd-info">

    <div class="right-header">
        <div class="pd-category-line">
            Nam • <%= spInfo.getTenDanhMuc() != null ? spInfo.getTenDanhMuc() : "Bóng đá"%>
        </div>

        <div class="club-breadcrumb-detail">
            <div class="club-container">

                <div class="club-breadcrumb-detail">
                    <div class="club-container">
                        <a href="${backUrl}" class="club-detail-back-link">↩ Trở lại</a>
                        <span class="club-detail-breadcrumb-divider">/</span>
                        <a href="${pageContext.request.contextPath}/trang_chu" class="club-detail-breadcrumb-home">Trang Chủ</a>
                        <span class="club-detail-breadcrumb-divider">/</span>
                        <a href="${backUrl}" class="club-detail-breadcrumb-current">
                            ${breadcrumbLabel}
                        </a>
                    </div>
                </div>            
            </div>
        </div>
    </div>

    <div class="pd-badge-new">Mới</div>

    <div class="pd-rating-row">
        <span class="pd-rating-score">
            <%= String.format("%.1f", spInfo.getDiemTrungBinh())%>
        </span>

        <span class="pd-rating-stars">
            <%= renderStars(spInfo.getDiemTrungBinh())%>
        </span>

        <a href="#pd-reviews" class="pd-rating-count">
            (<%= spInfo.getSoLuongDanhGia()%>)
        </a>
    </div>

    <h1 class="pd-product-name"><%= spInfo.getTenSanPham()%></h1>

    <div class="pd-price-wrap">
        <% if (isSale) {%>
        <span class="pd-price-old"><%= String.format("%,.0f", spInfo.getGiaNiemYet())%>đ</span>
        <span class="pd-price-sale"><%= String.format("%,.0f", spInfo.getGiaSanPham())%>đ</span>
        <% } else {%>
        <span class="pd-price-normal"><%= String.format("%,.0f", spInfo.getGiaSanPham())%>đ</span>
        <% }%>
    </div>

    <div class="pd-sale-note <%= isSale ? "is-sale" : ""%>">
        <% if (isSale) {%>
        Sản phẩm được giảm <%= (int) Math.round(percentSale)%>% so với giá niêm yết.
        <% } else { %>
        Sản phẩm này không được hưởng bất kỳ giảm giá khuyến mại và ưu đãi nào.
        <% } %>
    </div>

    <div class="pd-size-block">
        <div class="pd-size-title">Kích cỡ</div>

        <div class="pd-size-grid">
            <% if (dsBienThe != null) {
                    for (BienTheSanPham bt : dsBienThe) {
                        String size = bt.getTenSize();
                        int tonKho = bt.getSoLuongTon();
                        boolean hetHang = tonKho <= 0;
            %>
            <button
                type="button"
                class="pd-size-btn <%= hetHang ? "out-of-stock" : ""%>"
                data-ma-bien-the="<%= bt.getMaBienThe()%>"
                data-ten-size="<%= size%>"
                data-ton-kho="<%= tonKho%>">
                <%= size%>
            </button>
            <%  }
        }%>
        </div>

        <div id="pd-size-guide" style="margin-top: 18px; font-size: 18px; font-weight: 700; font-family: 'Arial';">
            Hãy chọn kích cỡ phù hợp
        </div>

        <input type="hidden" id="maSanPham" value="<%= spInfo.getMaSanPham()%>">
        <input type="hidden" id="selectedVariantId" name="maBienThe" value="">
        <input type="hidden" id="pdQuantityInput" value="1">
    </div>

    <div class="pd-action-row">
        <button type="button" class="pd-add-cart-btn" id="pdAddCartBtn" disabled>
            <span style="font-family: var(--font-heading);">THÊM VÀO GIỎ HÀNG</span>
            <i data-lucide="shopping-basket" class="pd-cart-icon"></i>
        </button>

        <button type="button" class="pd-wishlist-btn">♡</button>
    </div>

    <div class="pd-member-box">
        <div class="pd-member-top">
            <span>Thành viên có thể nhận</span>
            <span class="pd-member-brand">Xu V<span style="color: #D4AF37">$</span></span>
        </div>

        <div class="pd-member-xu">
            <i data-lucide="circle-pound-sterling" class="pd-member-icon"></i>
            <span><%= vsXu%> Xu VS</span>
        </div>
    </div>

    <div class="pd-benefit-list">
        <div class="pd-benefit-item">
            <span>🚚 MIỄN PHÍ SHIP VỚI THÀNH VIÊN!</span>
            <span>›</span>
        </div>

        <div class="pd-benefit-item">
            <span>↩ HOÀN TRẢ DỄ DÀNG</span>
            <span>›</span>
        </div>
    </div>
</div>
