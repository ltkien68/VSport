<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Vốn Shop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/fonts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-capital.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-dashboard.css">
</head>
<body>
<div class="admin-shell">
    <%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

    <main class="admin-main">
        <div class="admin-capital-top">
            <div class="admin-capital-hero">
                <p class="admin-capital-hero-label">Tổng vốn hiện tại</p>
                <h1 class="admin-capital-hero-value">
                    <fmt:formatNumber value="${quyVon.soDuHienTai}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                </h1>
                <div class="admin-capital-hero-meta">
                    <span>Cộng mỗi ngày:
                        <strong>
                            <fmt:formatNumber value="${quyVon.soTienCongMoiNgay}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                        </strong>
                    </span>
                    <span>Ngày cộng gần nhất:
                        <strong>${quyVon.ngayCapNhatCongCuoi}</strong>
                    </span>
                </div>
            </div>
        </div>

        <section class="admin-capital-history-section">
            <div class="admin-capital-section-header">
                <h2>Lịch sử biến động vốn</h2>
            </div>

            <div class="admin-capital-history-table-wrap">
                <table class="admin-capital-history-table">
                    <thead>
                        <tr>
                            <th>Thời gian</th>
                            <th>Loại</th>
                            <th>Số tiền</th>
                            <th>Số dư trước</th>
                            <th>Số dư sau</th>
                            <th>Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty dsLichSuVon}">
                            <c:forEach var="ls" items="${dsLichSuVon}">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${ls.ngayTao}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${ls.loaiBienDong == 'cong_von_ngay'}">
                                                <span class="capital-badge capital-badge-plus">Cộng từ đơn hàng</span>
                                            </c:when>
                                            <c:when test="${ls.loaiBienDong == 'cong_hoan_von'}">
                                                <span class="capital-badge capital-badge-plus">Cộng / hoàn vốn</span>
                                            </c:when>
                                            <c:when test="${ls.loaiBienDong == 'tru_von_nhap_hang'}">
                                                <span class="capital-badge capital-badge-minus">Trừ nhập hàng</span>
                                            </c:when>
                                            <c:when test="${ls.loaiBienDong == 'dieu_chinh_tay'}">
                                                <span class="capital-badge capital-badge-adjust">Điều chỉnh tay</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="capital-badge">${ls.loaiBienDong}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="${ls.loaiBienDong == 'cong_von_ngay' || ls.loaiBienDong == 'cong_hoan_von' ? 'capital-money-plus' : 'capital-money-minus'}">
                                        <c:choose>
                                            <c:when test="${ls.loaiBienDong == 'cong_von_ngay' || ls.loaiBienDong == 'cong_hoan_von'}">+</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                        <fmt:formatNumber value="${ls.soTienBienDong}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                    </td>

                                    <td>
                                        <fmt:formatNumber value="${ls.soDuTruoc}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                    </td>

                                    <td>
                                        <fmt:formatNumber value="${ls.soDuSau}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                    </td>

                                    <td>
                                        <c:out value="${ls.ghiChu}"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="admin-capital-empty">
                                    Chưa có lịch sử biến động vốn.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
    
</div>
                    <script>
                        window.APP_CONTEXT = "${pageContext.request.contextPath}";
                    </script>
                    <script src="${pageContext.request.contextPath}/assets/js/admin/admin-dashboard.js"></script>
                    
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
        positionClass: "toast-top-right",
        timeOut: "2500",
        extendedTimeOut: "1000",
        showDuration: "250",
        hideDuration: "250",
        showMethod: "fadeIn",
        hideMethod: "fadeOut"
    };
</script>
                    
</body>
</html>