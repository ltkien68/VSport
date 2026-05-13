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


                                                <h3 class="best-seller-card-title">
                                                    <span class="best-title-wrap">
                                                        <span class="best-arrow">
                                                            <i data-lucide="arrow-right"></i>
                                                        </span>
                                                        <span class="best-text">
                                                            ${sp.tenSanPham}
                                                        </span>
                                                    </span>
                                                </h3>


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