<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<section id="newProductSection" class="new-product-section new-product-reveal-section">
    <div class="new-product-container">

        <div class="new-product-head new-product-reveal-title">
            <p class="new-product-kicker">New Arrival</p>
            <h2>Sản phẩm mới nhất</h2>
            <span class="new-product-line"></span>
        </div>

        <div class="new-product-reveal-wrapper">
            <div class="new-product-slider">

                <button type="button" class="new-product-arrow new-product-prev" aria-label="Sản phẩm trước">
                    <i data-lucide="chevron-left"></i>
                </button>

                <div class="new-product-viewport">
                    <div id="newProductTrack" class="new-product-track">

                        <c:forEach var="sp" items="${dsSanPhamMoiThem}">


                            <div class="new-product-slide">
                                <a href="${pageContext.request.contextPath}/chi-tiet-san-pham/${sp.maSanPham}"
                                   class="new-product-card hover-float">

                                    <div class="new-product-image-wrap">
                                        <img src="${pageContext.request.contextPath}/${sp.anhChinh}"
                                             alt="${sp.tenSanPham}"
                                             class="new-product-image">


                                    </div>

                                    <div class="new-product-info">


                                        <h3 class="new-product-card-title">
                                            <span class="title-wrap">
                                                <span class="arrow"><i data-lucide="arrow-right"></i></span>
                                                <span class="text">${sp.tenSanPham}</span>
                                            </span>
                                        </h3>


                                    </div>

                                </a>
                            </div>


                        </c:forEach>

                    </div>
                </div>

                <button type="button" class="new-product-arrow new-product-next" aria-label="Sản phẩm tiếp theo">
                    <i data-lucide="chevron-right"></i>
                </button>

            </div>

            <div id="newProductDots" class="new-product-dots"></div>
        </div>

    </div>
</section>