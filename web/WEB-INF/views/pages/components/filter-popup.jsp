<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.BoLoc" %>

<%
    List<BoLoc> dsLoaiSanPham = (List<BoLoc>) request.getAttribute("dsLoaiSanPham");
    List<BoLoc> dsThuongHieu = (List<BoLoc>) request.getAttribute("dsThuongHieu");
    List<BoLoc> dsKichCo = (List<BoLoc>) request.getAttribute("dsKichCo");

    Integer tongSanPhamLoc = (Integer) request.getAttribute("tongSanPhamLoc");
    if (tongSanPhamLoc == null) tongSanPhamLoc = 0;

    String[] loaiDaChon = request.getParameterValues("loai");
    String[] thuongHieuDaChon = request.getParameterValues("thuongHieu");
    String[] sizeDaChon = request.getParameterValues("size");

    String sort = request.getParameter("sort");
    if (sort == null || sort.trim().isEmpty()) sort = "price_asc";

    String giaMin = request.getParameter("giaMin") != null ? request.getParameter("giaMin") : "";
    String giaMax = request.getParameter("giaMax") != null ? request.getParameter("giaMax") : "";

    String doiSlug = request.getAttribute("doiSlug") != null ? String.valueOf(request.getAttribute("doiSlug")) : "";

    String currentUrl = request.getAttribute("currentFilterAction") != null
            ? String.valueOf(request.getAttribute("currentFilterAction"))
            : request.getRequestURI();
%>

<!-- OVERLAY -->
<div class="filter-overlay" id="filterOverlay"></div>

<!-- DRAWER -->
<aside class="filter-drawer" id="filterDrawer">

    <!-- HEADER -->
    <div class="filter-header">
        <h2>LỌC &amp; SẮP XẾP</h2>

        <div class="filter-header-right">
            <a href="<%= currentUrl %>" class="filter-clear-all">Xoá tất cả</a>
            <button type="button" class="filter-close-btn" id="closeFilterPopup">×</button>
        </div>
    </div>

    <!-- FORM -->
    <form action="<%= currentUrl %>" method="get" class="filter-form">

        <% if (doiSlug != null && !doiSlug.trim().isEmpty()) { %>
            <input type="hidden" name="doiSlug" value="<%= doiSlug %>">
        <% } %>

        <div class="filter-body">

            <!-- SORT -->
            <div class="filter-group">
                <div class="filter-group-head">
                    <span>Sắp xếp theo</span>
                </div>

                <div class="filter-group-content show">
                    <label class="filter-radio-row">
                        <input type="radio" name="sort" value="price_asc" <%= "price_asc".equals(sort) ? "checked" : "" %>>
                        <span>Giá (thấp - cao)</span>
                    </label>

                    <label class="filter-radio-row">
                        <input type="radio" name="sort" value="price_desc" <%= "price_desc".equals(sort) ? "checked" : "" %>>
                        <span>Giá (cao - thấp)</span>
                    </label>

                    <label class="filter-radio-row">
                        <input type="radio" name="sort" value="newest" <%= "newest".equals(sort) ? "checked" : "" %>>
                        <span>Mới nhất</span>
                    </label>

                    <label class="filter-radio-row">
                        <input type="radio" name="sort" value="best_selling" <%= "best_selling".equals(sort) ? "checked" : "" %>>
                        <span>Bán chạy</span>
                    </label>
                </div>
            </div>

            <!-- LOAI -->
            <div class="filter-group">
                <div class="filter-group-head">
                    <span>Loại sản phẩm</span>
                </div>

                <div class="filter-group-content show">
                    <% if (dsLoaiSanPham != null) {
                        for (BoLoc item : dsLoaiSanPham) {

                            boolean checked = false;
                            if (loaiDaChon != null) {
                                for (String s : loaiDaChon) {
                                    if (item.getValue().equals(s)) {
                                        checked = true;
                                        break;
                                    }
                                }
                            }
                    %>

                    <label class="filter-check-row">
                        <span class="filter-check-left">
                            <input type="checkbox" name="loai" value="<%= item.getValue() %>" <%= checked ? "checked" : "" %>>
                            <span class="fake-check"></span>
                            <span><%= item.getLabel() %></span>
                        </span>
                        <span>[<%= item.getCount() %>]</span>
                    </label>

                    <% } } %>
                </div>
            </div>

            <!-- THUONG HIEU -->
            <div class="filter-group">
                <div class="filter-group-head">
                    <span>Thương hiệu</span>
                </div>

                <div class="filter-group-content show">
                    <% if (dsThuongHieu != null) {
                        for (BoLoc item : dsThuongHieu) {

                            boolean checked = false;
                            if (thuongHieuDaChon != null) {
                                for (String s : thuongHieuDaChon) {
                                    if (item.getValue().equals(s)) {
                                        checked = true;
                                        break;
                                    }
                                }
                            }
                    %>

                    <label class="filter-check-row">
                        <span class="filter-check-left">
                            <input type="checkbox" name="thuongHieu" value="<%= item.getValue() %>" <%= checked ? "checked" : "" %>>
                            <span class="fake-check"></span>
                            <span><%= item.getLabel().toUpperCase() %></span>
                        </span>
                        <span>[<%= item.getCount() %>]</span>
                    </label>

                    <% } } %>
                </div>
            </div>

            <!-- SIZE -->
            <div class="filter-group">
                <div class="filter-group-head">
                    <span>Kích cỡ</span>
                </div>

                <div class="filter-group-content show">
                    <% if (dsKichCo != null) {
                        for (BoLoc item : dsKichCo) {

                            boolean checked = false;
                            if (sizeDaChon != null) {
                                for (String s : sizeDaChon) {
                                    if (item.getValue().equals(s)) {
                                        checked = true;
                                        break;
                                    }
                                }
                            }
                    %>

                    <label class="filter-check-row">
                        <span class="filter-check-left">
                            <input type="checkbox" name="size" value="<%= item.getValue() %>" <%= checked ? "checked" : "" %>>
                            <span class="fake-check"></span>
                            <span><%= item.getLabel() %></span>
                        </span>
                        <span>[<%= item.getCount() %>]</span>
                    </label>

                    <% } } %>
                </div>
            </div>

            <!-- PRICE -->
            <div class="filter-group">
                <div class="filter-group-head">
                    <span>Khoảng giá</span>
                </div>

                <div class="filter-price-item show">
                    <input type="number" name="giaMin" value="<%= giaMin %>" placeholder="Min">
                    <input type="number" name="giaMax" value="<%= giaMax %>" placeholder="Max">
                </div>
            </div>

        </div>

        <!-- FOOTER -->
        <div class="filter-footer">
            <div class="filter-found-text">Tìm thấy <span style="color: var(--text-highlight)"><%= tongSanPhamLoc %></span> sản phẩm</div>

            <button type="submit" class="filter-apply-btn">
                Áp dụng →
            </button>
        </div>

    </form>
</aside>