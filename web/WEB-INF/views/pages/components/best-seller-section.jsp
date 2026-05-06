<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<section class="best-seller-section best-seller-reveal-section" id="bestSellerSection">
    <div class="best-seller-container">
        <div class="best-seller-head best-seller-reveal-title">
            <p class="best-seller-kicker">Top Picks</p>
            <h2 class="best-seller-title">SẢN PHẨM BÁN CHẠY</h2>
            <span class="best-seller-line"></span>
        </div>

        <c:choose>
            <c:when test="${not empty dsSanPhamBanChay}">
                <div class="best-seller-slider-wrap">
                    <button type="button"
                            class="best-seller-nav best-seller-prev"
                            aria-label="Sản phẩm trước">
                        &#10094;
                    </button>

                    <div class="best-seller-viewport">
                        <div class="best-seller-reveal-wrapper">
                            <div class="best-seller-track" id="bestSellerTrack">
                                <c:forEach var="sp" items="${dsSanPhamBanChay}">
                                    <div class="best-seller-slide">
                                        <a class="best-seller-card"
                                           href="${pageContext.request.contextPath}/chi-tiet-san-pham/${sp.maSanPham}">

                                            <div class="best-seller-image-wrap">
                                                <img src="${pageContext.request.contextPath}/${sp.anhChinh}"
                                                     alt="${sp.tenSanPham}"
                                                     class="best-seller-image" />

                                                
                                            </div>

                                            <div class="best-seller-info">
                                                <div class="best-seller-price">
                                                    <c:choose>
                                                        <c:when test="${sp.giaKhuyenMai > 0}">
                                                            <span class="best-seller-old-price">
                                                                <fmt:formatNumber value="${sp.giaNiemYet}" type="number"/>đ
                                                            </span>
                                                            <span class="best-seller-sale-price">
                                                                <fmt:formatNumber value="${sp.giaSanPham}" type="number"/>đ
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="best-seller-normal-price">
                                                                <fmt:formatNumber value="${sp.giaSanPham}" type="number"/>đ
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <h3 class="best-seller-card-title">${sp.tenSanPham}</h3>

                                                <p class="best-seller-card-desc">
                                                    <c:choose>
                                                        <c:when test="${not empty sp.moTaNgan}">
                                                            ${sp.moTaNgan}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Sản phẩm nổi bật được nhiều khách hàng lựa chọn.
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </a>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <button type="button"
                            class="best-seller-nav best-seller-next"
                            aria-label="Sản phẩm tiếp theo">
                        &#10095;
                    </button>
                </div>

                <div class="best-seller-dots" id="bestSellerDots"></div>
            </c:when>

            <c:otherwise>
                <div class="best-seller-empty">
                    Chưa có dữ liệu sản phẩm bán chạy.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>