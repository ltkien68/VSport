<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    request.setAttribute("activePage", "dashboard");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-layout-start.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>
<%@ include file="/WEB-INF/views/profile/profile-edit-popup.jsp" %>

<main class="admin-main">
    <%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>

    <section class="admin-dashboard-content">

        <section class="admin-stats-grid">

            <div class="admin-stat-card admin-stat-card--highlight stat-clickable" data-type="don_hang">
                <div class="admin-stat-top">
                    <span>Tổng Đơn Hàng</span>
                    <span class="admin-stat-trend-icon ${phanTramDonHang >= 0 ? 'positive' : 'negative'}">
                        <i data-lucide="${phanTramDonHang >= 0 ? 'trending-up' : 'trending-down'}"></i>
                    </span>
                </div>

                <h3>
                    <fmt:formatNumber value="${tongDonHang}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                </h3>

                <div class="admin-stat-change ${phanTramDonHang >= 0 ? 'positive' : 'negative'}">
                    <i data-lucide="${phanTramDonHang >= 0 ? 'arrow-up-right' : 'arrow-down-right'}"></i>
                    <fmt:formatNumber value="${phanTramDonHang}" type="number" minFractionDigits="0" maxFractionDigits="1"/>%
                    <span>So Với Tuần Trước</span>
                </div>
            </div>

            <div class="admin-stat-card stat-clickable" data-type="doanh_thu">
                <div class="admin-stat-top ">
                    <span>Tổng Doanh Thu</span>
                    <span class="admin-stat-trend-icon ${phanTramDoanhThu >= 0 ? 'positive' : 'negative'}">
                        <i data-lucide="${phanTramDoanhThu >= 0 ? 'trending-up' : 'trending-down'}"></i>
                    </span>
                </div>

                <h3>
                    <fmt:formatNumber value="${tongDoanhThu}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                </h3>

                <div class="admin-stat-change ${phanTramDoanhThu >= 0 ? 'positive' : 'negative'}">
                    <i data-lucide="${phanTramDoanhThu >= 0 ? 'arrow-up-right' : 'arrow-down-right'}"></i>
                    <fmt:formatNumber value="${phanTramDoanhThu}" type="number" minFractionDigits="0" maxFractionDigits="1"/>%
                    <span>So Với Tuần Trước</span>
                </div>
            </div>

            <div class="admin-stat-card stat-clickable" data-type="loi_nhuan">
                <div class="admin-stat-top">
                    <span>Tổng Lợi Nhuận</span>
                    <span class="admin-stat-trend-icon ${loaiBienDongLoiNhuan}">
                        <i data-lucide="${loaiBienDongLoiNhuan == 'negative' ? 'trending-down' : loaiBienDongLoiNhuan == 'neutral' ? 'minus' : 'trending-up'}"></i>
                    </span>
                </div>

                <h3 class="${tongLoiNhuan >= 0 ? 'profit-positive' : 'profit-negative'}">
                    <fmt:formatNumber value="${tongLoiNhuan}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                </h3>

                <div class="admin-stat-change ${loaiBienDongLoiNhuan}">
                    <i data-lucide="${loaiBienDongLoiNhuan == 'negative' ? 'arrow-down-right' : loaiBienDongLoiNhuan == 'neutral' ? 'minus' : 'arrow-up-right'}"></i>
                    <fmt:formatNumber value="${phanTramLoiNhuan}" type="number" minFractionDigits="0" maxFractionDigits="1"/>%
                    <span>${moTaLoiNhuan}</span>
                </div>
            </div>

            <div class="admin-stat-card stat-clickable" data-type="thanh_vien">
                <div class="admin-stat-top">
                    <span>Số Thành Viên</span>
                    <span class="admin-stat-trend-icon ${phanTramThanhVien >= 0 ? 'positive' : 'negative'}">
                        <i data-lucide="${phanTramThanhVien >= 0 ? 'trending-up' : 'trending-down'}"></i>
                    </span>
                </div>

                <h3>
                    <fmt:formatNumber value="${tongThanhVien}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                </h3>

                <div class="admin-stat-change ${phanTramThanhVien >= 0 ? 'positive' : 'negative'}">
                    <i data-lucide="${phanTramThanhVien >= 0 ? 'arrow-up-right' : 'arrow-down-right'}"></i>
                    <fmt:formatNumber value="${phanTramThanhVien}" type="number" minFractionDigits="0" maxFractionDigits="1"/>%
                    <span>So Với Tuần Trước</span>
                </div>
            </div>

        </section>

        <section class="admin-chart-grid">
            <div class="admin-panel">
                <div class="admin-panel-head">
                    <div>
                        <h3>Total Sales</h3>
                        <p><fmt:formatNumber value="${tongDoanhThu}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ</p>
                    </div>
                    <div class="admin-legend">
                        <span><i class="dot current"></i>Hiện Tại</span>
                        <span><i class="dot last"></i>Tuần Trước</span>
                    </div>
                </div>

                <div class="admin-placeholder-box">
                    <div class="admin-placeholder-title">chart-sales.jsp</div>
                    <div class="admin-placeholder-sub">Khu biểu đồ line chart sẽ include sau</div>
                </div>
            </div>

            <div class="admin-panel">
                <div class="admin-panel-head">
                    <div>
                        <h3>Total Visitors</h3>
                        <p><fmt:formatNumber value="${tongThanhVien}" type="number" groupingUsed="true" maxFractionDigits="0"/></p>
                    </div>
                    <div class="admin-legend">
                        <span><i class="dot current"></i>Hiện Tại</span>
                        <span><i class="dot last"></i>Tuần Trước</span>
                    </div>
                </div>

                <div class="admin-placeholder-box">
                    <div class="admin-placeholder-title">chart-visitors.jsp</div>
                    <div class="admin-placeholder-sub">Khu biểu đồ bar chart sẽ include sau</div>
                </div>
            </div>

            <div class="admin-panel">
                <div class="admin-panel-head">
                    <div>
                        <h3>Earning Growth</h3>
                        <p><fmt:formatNumber value="${tongLoiNhuan}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ</p>
                    </div>
                    <div class="admin-legend">
                        <span><i class="dot current"></i>Hiện Tại</span>
                        <span><i class="dot last"></i>Tuần Trước</span>
                    </div>
                </div>

                <div class="admin-placeholder-box">
                    <div class="admin-placeholder-title">chart-earning.jsp</div>
                    <div class="admin-placeholder-sub">Khu biểu đồ tăng trưởng sẽ include sau</div>
                </div>
            </div>
        </section>

        <section class="admin-bottom-grid">
            <div class="admin-panel">
                <div class="admin-panel-head admin-panel-head--space">
                    <h3>Đơn Hàng Gần Đây</h3>
                    <a href="${pageContext.request.contextPath}/admin/don-hang" class="admin-panel-link">Xem Chi Tiết</a>
                </div>

                <%@ include file="/WEB-INF/views/admin/components/recent-transaction.jsp" %>
            </div>

            <div class="admin-panel">
                <div class="admin-panel-head admin-panel-head--space">
                    <h3>Sản Phẩm Bán Chạy</h3>
                    <a href="${pageContext.request.contextPath}/admin/san-pham" class="admin-panel-link">Xem Chi Tiết</a>
                </div>

                <%@ include file="/WEB-INF/views/admin/components/top-selling-product.jsp" %>
            </div>
        </section>

    </section>
</main>

</div>

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>

<jsp:include page="/WEB-INF/views/admin/components/weekly-stats-popup.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/admin/admin-dashboard.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/weekly-stat-popup.js"></script>
<script src="https://unpkg.com/lucide@latest"></script>
<script>
    lucide.createIcons();
</script>

<%-- jQuery bắt buộc cho Toastr --%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<%-- Toastr JS --%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<script>
    toastr.options = {
        closeButton: true,
        progressBar: true,
        newestOnTop: true,
        preventDuplicates: true,
        positionClass: "toast-bottom-right",
        timeOut: "1000",
        extendedTimeOut: "1000",
        showDuration: "250",
        hideDuration: "250",
        showMethod: "fadeIn",
        hideMethod: "fadeOut"
    };
</script>
</body>
</html>