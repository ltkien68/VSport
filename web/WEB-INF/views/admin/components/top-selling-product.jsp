<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="admin-dashboard-scroll-box">
    <c:choose>
        <c:when test="${not empty dsSanPhamBanChay}">
            <div class="admin-dashboard-simple-list">
                <c:forEach var="sp" items="${dsSanPhamBanChay}">
                    <div class="admin-dashboard-product-item">
                        <div class="admin-dashboard-product-thumb">
                            <img src="${pageContext.request.contextPath}/${sp.anhChinh}" alt="${sp.tenSanPham}">
                        </div>

                        <div class="admin-dashboard-product-info">
                            <div class="admin-dashboard-product-name">
                                <c:out value="${sp.tenSanPham}"/>
                            </div>

                            <div class="admin-dashboard-product-meta">
                                <span>
                                    <fmt:formatNumber value="${sp.giaSanPham}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                </span>
                                <span>•</span>
                                <span style="font-family: var(--font-heading); color: var(--color-red)">Đã bán: <c:out value="${sp.daBan}"/></span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="admin-dashboard-empty">
                Chưa có sản phẩm bán chạy.
            </div>
        </c:otherwise>
    </c:choose>
</div>