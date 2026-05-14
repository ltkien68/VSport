<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.SanPham"%>
<%@page import="model.ChiTietSanPham"%>
<%@page import="model.DanhGiaSanPham"%>
<%@page import="java.util.List"%>


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
    SanPham spAcc = (SanPham) request.getAttribute("sp");
    ChiTietSanPham ct = spAcc.getChiTiet();
    List<DanhGiaSanPham> dsDanhGia = (List<DanhGiaSanPham>) request.getAttribute("dsDanhGia");
%>

<%!
    public String maskName(String fullName) {

        if (fullName == null || fullName.trim().isEmpty()) {
            return "Người dùng";
        }

        String[] words = fullName.trim().split("\\s+");

        StringBuilder result = new StringBuilder();

        for (String word : words) {

            if (word.length() <= 1) {

                result.append(word).append(" ");

            } else {

                result.append(word.charAt(0));

                for (int i = 1; i < word.length(); i++) {
                    result.append("*");
                }

                result.append(" ");
            }
        }

        return result.toString().trim();
    }
%>

<div class="pd-accordion-list">

    <div class="pd-accordion-item" id="pd-reviews">
        <button class="pd-accordion-header active" type="button">
            <span>Đánh giá (<%= spAcc.getSoLuongDanhGia()%>)</span>
            <span class="pd-accordion-right">
                <span class="pd-rating-stars">
                    <%= renderStars(spAcc.getDiemTrungBinh())%>
                    <span class="pd-rating-number"><%= String.format("%.1f", spAcc.getDiemTrungBinh())%></span>
                </span>
                <i data-lucide="chevron-down" class="pd-arrow"></i>
            </span>
        </button>
        <div class="pd-accordion-body show">
            <% if (dsDanhGia != null && !dsDanhGia.isEmpty()) { %>
            <% for (DanhGiaSanPham dg : dsDanhGia) {%>
            <div class="pd-review-item">
                <div class="pd-review-top">
                    <strong>
                        <%= maskName(dg.getTenNguoiDung())%>
                    </strong>
                    <span class="pd-review-stars-wrap">
                        <span class="pd-review-stars">
                            <%= renderStars(dg.getSoSao())%>
                        </span>
                        <span class="pd-review-score"><%= String.format("%.1f", dg.getSoSao())%></span>
                    </span>
                </div>
                <div class="pd-review-date"><%= dg.getNgayDanhGia()%></div>
                <div class="pd-review-content">
                    <%= dg.getNoiDung() != null ? dg.getNoiDung() : "Người dùng chưa để lại nội dung."%>
                </div>
            </div>
            <% } %>
            <% } else { %>
            <div class="pd-empty-content">Chưa có đánh giá nào. Hiện tại tạm mặc định sản phẩm đang đẹp trai 5 sao.</div>
            <% }%>
        </div>
    </div>

    <div class="pd-accordion-item">
        <button class="pd-accordion-header" type="button">
            <span>Kích cỡ và độ vừa vặn</span>
            <i data-lucide="chevron-down" class="pd-arrow"></i>
        </button>
        <div class="pd-accordion-body">
            <div class="pd-accordion-content">
                <%= (ct != null && ct.getThuocTinh1() != null && ct.getThuocTinh1().trim().equalsIgnoreCase("Kích cỡ và độ vừa vặn"))
                        ? (ct.getGiaTri1() != null ? ct.getGiaTri1() : "")
                        : "Thông tin đang được cập nhật."%>
            </div>
        </div>
    </div>

    <div class="pd-accordion-item">
        <button class="pd-accordion-header" type="button">
            <span>Mô tả</span>
            <i data-lucide="chevron-down" class="pd-arrow"></i>
        </button>
        <div class="pd-accordion-body">
            <div class="pd-accordion-content">
                <%= spAcc.getMoTaNgan() != null ? spAcc.getMoTaNgan() : "Chưa có mô tả."%>
            </div>
        </div>
    </div>

    <div class="pd-accordion-item">
        <button class="pd-accordion-header" type="button">
            <span>Thông tin chi tiết</span>
            <i data-lucide="chevron-down" class="pd-arrow"></i>
        </button>
        <div class="pd-accordion-body">
            <div class="pd-accordion-content">

                <%
                    boolean hasDetail = false;
                %>

                <% if (ct != null && ct.getThuocTinh1() != null && ct.getGiaTri1() != null) {
                        hasDetail = true;
                %>
                <p><strong><%= ct.getThuocTinh1()%>:</strong> <%= ct.getGiaTri1()%></p>
                <% } %>

                <% if (ct != null && ct.getThuocTinh2() != null && ct.getGiaTri2() != null) {
                        hasDetail = true;
                %>
                <p><strong><%= ct.getThuocTinh2()%>:</strong> <%= ct.getGiaTri2()%></p>
                <% } %>

                <% if (ct != null && ct.getThuocTinh3() != null && ct.getGiaTri3() != null) {
                        hasDetail = true;
                %>
                <p><strong><%= ct.getThuocTinh3()%>:</strong> <%= ct.getGiaTri3()%></p>
                <% } %>

                <% if (!hasDetail) {%>
                <%="Thông tin đang được cập nhật."%>
                <% }%>

                <%= spAcc.getMoTaChiTiet() != null ? spAcc.getMoTaChiTiet() : ""%>

            </div>
        </div>
    </div>

    <div class="pd-accordion-item">
        <button class="pd-accordion-header" type="button">
            <span>Chăm sóc</span>
            <i data-lucide="chevron-down" class="pd-arrow"></i>
        </button>
        <div class="pd-accordion-body">
            <div class="pd-accordion-content">
                <%= (ct != null && ct.getThuocTinh3() != null && ct.getThuocTinh3().trim().equalsIgnoreCase("Chăm sóc"))
                        ? (ct.getGiaTri3() != null ? ct.getGiaTri3() : "")
                        : "Giặt ở nhiệt độ thấp, không dùng chất tẩy mạnh, phơi nơi thoáng mát."%>
            </div>
        </div>
    </div>

</div>