<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kho Coupon Của Bạn .LKsport</title>
    
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
<div class="voucher-page">
    <div class="voucher-container">

        <div class="voucher-topbar">
            <div>
                <span class="voucher-topbar-label">TRUNG TÂM MÃ GIẢM GIÁ</span>
                <h1>MÃ GIẢM GIÁ CỦA BẠN</h1>
                <p>Nơi mã ngon trú ngụ, nơi xu hóa thành lợi thế.</p>
            </div>

            <div class="voucher-xu-box">
                <span class="voucher-xu-title">Số xu hiện có</span>
                <div class="voucher-xu-value">◉ ${tongXu}</div>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="voucher-alert success">${successMessage}</div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="voucher-alert error">${errorMessage}</div>
        </c:if>

        <!-- VÙNG 1 -->
        <section class="voucher-section">
            <div class="voucher-section-head">
                <div>
                    <h2>VOUCHER CỦA BẠN</h2>
                </div>
            </div>

            <div class="voucher-grid">
                <c:choose>
                    <c:when test="${not empty dsMaSoHuu}">
                        <c:forEach var="item" items="${dsMaSoHuu}">
                            <div class="voucher-card tilt-card owned ${item.trangThaiSoHuu}">
                                <div class="voucher-card-top">
                                    <span class="voucher-code">${item.maCode}</span>
                                    <span class="voucher-status
                                        ${item.trangThaiSoHuu == 'chua_dung' ? 'ready' : ''}
                                        ${item.trangThaiSoHuu == 'da_dung' ? 'used' : ''}
                                        ${item.trangThaiSoHuu == 'het_han' ? 'expired' : ''}">
                                        <c:choose>
                                            <c:when test="${item.trangThaiSoHuu == 'chua_dung'}">Chưa dùng</c:when>
                                            <c:when test="${item.trangThaiSoHuu == 'da_dung'}">Đã dùng</c:when>
                                            <c:otherwise>Hết hạn</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <h3>${item.tenMa}</h3>

                                <div class="voucher-value">
                                    <c:choose>
                                        <c:when test="${item.loaiGiam == 'phan_tram'}">
                                            Giảm <fmt:formatNumber value="${item.giaTriGiam}" maxFractionDigits="0"/>%
                                        </c:when>
                                        <c:otherwise>
                                            Giảm <fmt:formatNumber value="${item.giaTriGiam}" type="number" groupingUsed="true"/>đ
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <ul class="voucher-meta">
                                    <li>Đơn tối thiểu:
                                        <fmt:formatNumber value="${item.dieuKienToiThieu}" type="number" groupingUsed="true"/>đ
                                    </li>
                                    <li>
                                        Đã đổi bằng: ${item.soXuDaDoi} xu
                                    </li>
                                    <li>
                                        Ngày nhận:
                                        <fmt:formatDate value="${item.ngayDoi}" pattern="dd/MM/yyyy HH:mm"/>
                                    </li>
                                    <li>
                                        Hạn dùng:
                                        <c:choose>
                                            <c:when test="${not empty item.ngayKetThuc}">
                                                <fmt:formatDate value="${item.ngayKetThuc}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>Không giới hạn</c:otherwise>
                                        </c:choose>
                                    </li>
                                </ul>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="voucher-empty">
                            Bạn chưa sở hữu mã nào. Túi mã hiện đang trống như ví sau đợt sale 12/12.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- VÙNG 2 -->
        <section class="voucher-section">
            <div class="voucher-section-head">
                <div>
                    <h2>CỬA HÀNG VOUCHER</h2>
                </div>
            </div>

            <div class="voucher-grid">
                <c:choose>
                    <c:when test="${not empty dsMaCoTheDoi}">
                        <c:forEach var="item" items="${dsMaCoTheDoi}">
                            <div class="voucher-card exchange">
                                <div class="voucher-card-top">
                                    <span class="voucher-code">${item.maCode}</span>
                                    <span class="voucher-stock">Còn ${item.soLuong}</span>
                                </div>

                                <h3>${item.tenMa}</h3>

                                <div class="voucher-value">
                                    <c:choose>
                                        <c:when test="${item.loaiGiam == 'phan_tram'}">
                                            Giảm <fmt:formatNumber value="${item.giaTriGiam}" maxFractionDigits="0"/>%
                                            <c:if test="${item.giamToiDa != null}">
                                                <span class="voucher-sub">Tối đa <fmt:formatNumber value="${item.giamToiDa}" type="number" groupingUsed="true"/>đ</span>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            Giảm <fmt:formatNumber value="${item.giaTriGiam}" type="number" groupingUsed="true"/>đ
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <ul class="voucher-meta">
                                    <li>Đơn tối thiểu: <fmt:formatNumber value="${item.dieuKienToiThieu}" type="number" groupingUsed="true"/>đ</li>
                                    <li>Cần đổi: ${item.soXuCan} xu</li>
                                    <li>
                                        Hạn:
                                        <c:choose>
                                            <c:when test="${not empty item.ngayKetThuc}">
                                                <fmt:formatDate value="${item.ngayKetThuc}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>Không giới hạn</c:otherwise>
                                        </c:choose>
                                    </li>
                                </ul>

                                <form action="${pageContext.request.contextPath}/ma_giam_gia/doi" method="post">
                                    <input type="hidden" name="maGiamGia" value="${item.maGiamGia}">
                                    <button type="submit"
                                            class="voucher-btn ${tongXu < item.soXuCan ? 'disabled' : ''}"
                                            ${tongXu < item.soXuCan ? 'disabled' : ''}>
                                        <c:choose>
                                            <c:when test="${tongXu < item.soXuCan}">
                                                Không đủ xu
                                            </c:when>
                                            <c:otherwise>
                                                Đổi ngay bằng ${item.soXuCan} xu
                                            </c:otherwise>
                                        </c:choose>
                                    </button>
                                </form>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="voucher-empty">
                            Hiện chưa có mã nào mở đổi bằng xu.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- VÙNG 3 -->
        <section class="voucher-section">
            <div class="voucher-section-head">
                <div>
                    <h2>LỊCH SỬ DÙNG VÀ NHẬN VOUCHER</h2>
                </div>
            </div>

            <div class="voucher-history">
                <c:choose>
                    <c:when test="${not empty dsLichSuMa}">
                        <c:forEach var="item" items="${dsLichSuMa}">
                            <div class="voucher-history-item">
                                <div class="voucher-history-left">
                                    <div class="voucher-history-icon
                                        ${item.loaiLichSu == 'nhan_ma' ? 'receive' :
                                          (item.loaiLichSu == 'hoan_ma' ? 'refund' : 'use')}">

                                        <c:choose>
                                            <c:when test="${item.loaiLichSu == 'nhan_ma'}">+</c:when>
                                            <c:when test="${item.loaiLichSu == 'hoan_ma'}">↺</c:when>
                                            <c:otherwise>✓</c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="voucher-history-info">
                                        <div class="voucher-history-title">
                                            <c:choose>
                                                <c:when test="${item.loaiLichSu == 'nhan_ma'}">
                                                    Nhận mã ${item.maCode}
                                                </c:when>
                                                <c:when test="${item.loaiLichSu == 'hoan_ma'}">
                                                    Hoàn mã ${item.maCode}
                                                </c:when>
                                                <c:otherwise>
                                                    Dùng mã ${item.maCode}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="voucher-history-sub">
                                            ${item.tenMa} · ${item.moTa}
                                        </div>

                                        <div class="voucher-history-time">
                                            <fmt:formatDate value="${item.thoiGian}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                </div>

                                <div class="voucher-history-right">
                                    <c:choose>
                                        <c:when test="${item.loaiLichSu == 'nhan_ma'}">
                                            <span class="history-xu-minus">-${item.thayDoiXu} xu</span>
                                        </c:when>

                                        <c:when test="${item.loaiLichSu == 'hoan_ma'}">
                                            <span class="history-refund-label">Đã hoàn</span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="history-used-label">Đã dùng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="voucher-empty">
                            Chưa có lịch sử mã nào cả.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
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
<script src="${pageContext.request.contextPath}/assets/js/pages/ma-giam-gia.js"></script>


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