<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.YeuThich" %>

<%
    List<YeuThich> dsYeuThich = (List<YeuThich>) request.getAttribute("dsYeuThich");
    if (dsYeuThich == null) {
        dsYeuThich = new java.util.ArrayList<>();
    }
%>

<section class="home-favorite-section home-favorite-reveal-section" id="favoriteSection">
    <div class="home-favorite-container">

        <!-- TITLE -->
        <div class="home-favorite-head home-favorite-reveal-title">
            <p class="home-favorite-kicker">Your Wishlist</p>
            <h2 class="home-favorite-title">SẢN PHẨM CỦA BẠN</h2>
            <span class="home-favorite-line"></span>
        </div>

        <% if (dsYeuThich.isEmpty()) { %>
            <div class="home-favorite-empty">
                Chưa có sản phẩm yêu thích nào.
            </div>
        <% } else { %>

            <div class="home-favorite-slider-wrap" id="favoriteSlider">

                <button type="button"
                        class="home-favorite-arrow home-favorite-arrow-left"
                        id="favoritePrevBtn">
                    &#10094;
                </button>

                <div class="home-favorite-viewport" id="favoriteViewport">

                    <!-- WRAPPER để animate -->
                    <div class="home-favorite-reveal-wrapper">

                        <div class="home-favorite-track" id="favoriteTrack">

                            <% for (YeuThich item : dsYeuThich) { %>

                                <div class="home-favorite-slide">
                                    <a class="home-favorite-card"
                                       href="<%= request.getContextPath() %>/chi-tiet-san-pham/<%= item.getMaSanPham() %>">

                                        <div class="home-favorite-image-wrap">
                                            <img
                                                src="<%= request.getContextPath() + "/" + item.getAnhChinh() %>"
                                                alt="<%= item.getTenSanPham() %>"
                                                class="home-favorite-image"
                                            />
                                        </div>

                                        <div class="home-favorite-info">
                                            <div class="home-favorite-price-wrap">
                                                <% if (item.getGiaNiemYet() > 0 && item.getGiaKhuyenMai() > 0 && item.getGiaKhuyenMai() < item.getGiaNiemYet()) { %>
                                                    <span class="home-favorite-old-price">
                                                        <%= String.format("%,.0fđ", item.getGiaNiemYet()) %>
                                                    </span>
                                                    <span class="home-favorite-sale-price">
                                                        <%= String.format("%,.0fđ", item.getGiaSanPham()) %>
                                                    </span>
                                                <% } else { %>
                                                    <span class="home-favorite-normal-price">
                                                        <%= String.format("%,.0fđ", item.getGiaSanPham()) %>
                                                    </span>
                                                <% } %>
                                            </div>

                                            <h3 class="home-favorite-name">
                                                <%= item.getTenSanPham() %>
                                            </h3>

                                            <p class="home-favorite-desc">
                                                <%= item.getMoTaNgan() != null ? item.getMoTaNgan() : "" %>
                                            </p>
                                        </div>
                                    </a>
                                </div>

                            <% } %>

                        </div>
                    </div>
                </div>

                <button type="button"
                        class="home-favorite-arrow home-favorite-arrow-right"
                        id="favoriteNextBtn">
                    &#10095;
                </button>
            </div>

            <div class="home-favorite-dots" id="favoriteDots"></div>

        <% } %>
    </div>
</section>