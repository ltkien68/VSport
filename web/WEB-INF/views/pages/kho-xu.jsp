<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kho Xu Của Bạn .LKsport</title>
        
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo-header.png">
    <jsp:include page="/WEB-INF/views/common/head.jsp" />
    
    <script>
    (function () {
        try {
            const theme = localStorage.getItem("theme");
            if (theme === "dark") {
                document.documentElement.classList.add("dark-mode");
            } else {
                document.documentElement.classList.remove("dark-mode");
            }
        } catch (e) {}
    })();
    </script>
</head>
<body class="inner">

<div class="header-shell">
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
            <%@ include file="/WEB-INF/views/common/navbar.jsp" %>
        </div>

<div class="xu-page">
    <div class="xu-container">

        <div class="xu-topbar">
            <div class="xu-topbar-left">
                <span class="xu-topbar-label">TỔNG XU HIỆN CÓ</span>
                <div class="xu-total-wrap">
                    <span class="xu-coin-icon">◉</span>
                    <span class="xu-total">${khoXuInfo.tongXu}</span>
                </div>
            </div>
        </div>

        <div class="xu-grid">
            <!-- LEFT -->
            <div class="xu-checkin-card">
                <div class="xu-card-badge">KHO XU</div>
                <h2 class="xu-card-title">Đăng nhập nhận xu mỗi ngày</h2>
                <p class="xu-card-subtitle">
                    Mỗi lần ghé qua là một lần ví xu nở hoa. Hôm nay nhận ngay
                    <strong>${khoXuInfo.mucThuongHomNay} xu</strong>.
                </p>

                <div class="xu-7days">
                    <c:forEach var="item" items="${khoXuInfo.trangThai7Ngay}" varStatus="loop">
                        <div class="xu-day-box ${item ? 'claimed' : ''} ${(!khoXuInfo.daNhanHomNay && loop.index + 1 == khoXuInfo.ngayThu) ? 'today-target' : ''}">
                            <span class="xu-day-plus">+${khoXuInfo.mucThuongHomNay}</span>
                            <span class="xu-day-coin">◉</span>
                            <span class="xu-day-label">
                                Ngày ${loop.index + 1}
                            </span>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${not empty successMessage}">
                    <div class="xu-alert success">${successMessage}</div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="xu-alert error">${errorMessage}</div>
                </c:if>

                <c:choose>
                    <c:when test="${khoXuInfo.daNhanHomNay}">
                        <button class="xu-btn disabled" disabled>
                            Hôm nay đã nhận xu
                        </button>
                        <p class="xu-note">
                            Quay lại vào ngày mai để tiếp tục điểm danh.
                        </p>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/kho_xu/nhan_xu" method="post">
                            <button type="submit" class="xu-btn">
                                Nhận ${khoXuInfo.mucThuongHomNay} xu hôm nay
                            </button>
                        </form>
                        <p class="xu-note">
                            Bấm một phát, xu về tài khoản, đời bớt khô.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- RIGHT -->
            <div class="xu-history-card">
                <div class="xu-history-head">
                    <div>
                        <span class="xu-history-label">LỊCH SỬ GIAO DỊCH XU</span>
                        <h3>Lịch sử nhận và tiêu xu</h3>
                    </div>
                </div>

                <div class="xu-history-list">
                    <c:choose>
                        <c:when test="${not empty dsLichSuXu}">
                            <c:forEach var="ls" items="${dsLichSuXu}">
                                <div class="xu-history-item">
                                    <div class="xu-history-left">
                                        <div class="xu-history-type ${ls.loaiGiaoDich == 'cong' ? 'plus' : 'minus'}">
                                            ${ls.loaiGiaoDich == 'cong' ? '+' : '-'}
                                        </div>
                                        <div class="xu-history-info">
                                            <div class="xu-history-title">
                                                <c:choose>
                                                    <c:when test="${not empty ls.moTa}">
                                                        ${ls.moTa}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Giao dịch xu
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="xu-history-meta">
                                                Nguồn: ${ls.nguonXu}
                                                ·
                                                <fmt:formatDate value="${ls.ngayTao}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="xu-history-right ${ls.loaiGiaoDich == 'cong' ? 'plus' : 'minus'}">
                                        ${ls.loaiGiaoDich == 'cong' ? '+' : '-'}${ls.soXu} xu
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="xu-empty">
                                Chưa có giao dịch xu nào. Ví đang yên bình như mặt hồ lúc 5 giờ sáng.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script src="https://unpkg.com/lucide@latest"></script>
<script>
    lucide.createIcons();
</script>
<script>
            window.contextPath = "${pageContext.request.contextPath}";
        </script>
<script src="${pageContext.request.contextPath}/assets/js/common/scroll-reveal.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/components/login-popup.js"></script>

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