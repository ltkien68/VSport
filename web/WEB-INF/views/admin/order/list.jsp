<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý đơn hàng | Admin</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo.png">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/reset.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/fonts.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-order-management.css">
    </head>
    <body>

        <div class="admin-shell">
            <%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

            <main class="admin-main">
                <div class="admin-order-page">
                    <div class="admin-order-shell">

                        <div class="admin-order-topbar">
                            <div class="admin-order-topbar-left">
                                <h1 class="admin-order-title">Quản Lý Đơn Hàng</h1>
                                <p class="admin-order-desc">
                                    Duyệt đơn, theo dõi tiến trình theo thời gian thực và kiểm soát lịch sử đơn hàng hoàn thành hoặc đã hủy.
                                </p>
                            </div>

                            <div class="admin-order-topbar-right">
                                <div class="admin-order-stat-card">
                                    <span>Đang xử lý</span>
                                    <strong>${soDonDangXuLy}</strong>
                                </div>
                                <div class="admin-order-stat-card">
                                    <span>Lịch sử</span>
                                    <strong>${not empty dsLichSuDonHang ? dsLichSuDonHang.size() : 0}</strong>
                                </div>
                            </div>
                        </div>

                        <section class="admin-order-section">
                            <div class="admin-order-section-head">
                                <div>
                                    <h2>Đơn hàng đang xử lý</h2>
                                    <p>Gồm chờ xác nhận, chờ lấy hàng và đang giao.</p>
                                </div>
                            </div>

                            <div class="admin-order-list">
                                <c:forEach var="donHang" items="${dsDonHang}">
                                    <c:if test="${donHang.trangThaiDonHang != 'da_giao' && donHang.trangThaiDonHang != 'da_huy' && donHang.trangThaiDonHang != 'tra_hang'}">
                                        <div class="admin-order-card"
                                             data-order-id="${donHang.maDonHang}"
                                             data-order-status="${donHang.trangThaiDonHang}"
                                             data-payment-status="${donHang.trangThaiThanhToan}"
                                             data-ngay-dat="${donHang.ngayDat != null ? donHang.ngayDat.time : 0}"
                                             data-ngay-xac-nhan="${donHang.ngayXacNhan != null ? donHang.ngayXacNhan.time : 0}"
                                             data-ngay-bat-dau-giao="${donHang.ngayBatDauGiao != null ? donHang.ngayBatDauGiao.time : 0}"
                                             data-ngay-da-giao="${donHang.ngayDaGiao != null ? donHang.ngayDaGiao.time : 0}">

                                            <div class="admin-order-card-top">
                                                <div class="admin-order-card-meta">
                                                    <span class="admin-order-code">#${donHang.maDonHang}</span>
                                                    <span class="admin-order-user">
                                                        ${empty donHang.tenNguoiDung ? donHang.hoTenNguoiNhan : donHang.tenNguoiDung}
                                                    </span>
                                                    <span class="admin-order-date">
                                                        <fmt:formatDate value="${donHang.ngayDat}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                    </span>
                                                </div>

                                                <div class="admin-order-badges">
                                                    <span class="admin-order-badge order-badge-${donHang.trangThaiDonHang}">
                                                        ${mapTrangThai[donHang.trangThaiDonHang]}
                                                    </span>
                                                    <span class="admin-order-badge payment-badge-${donHang.trangThaiThanhToan}">
                                                        ${mapThanhToan[donHang.trangThaiThanhToan]}
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="admin-order-card-body">
                                                <div class="admin-order-info-box">
                                                    <h3>Thông tin khách hàng</h3>
                                                    <p><strong>User:</strong> ${empty donHang.tenNguoiDung ? '-' : donHang.tenNguoiDung}</p>
                                                    <p><strong>Email:</strong> ${empty donHang.emailNguoiDung ? '-' : donHang.emailNguoiDung}</p>
                                                    <p><strong>Người nhận:</strong> ${donHang.hoTenNguoiNhan}</p>
                                                    <p><strong>SĐT:</strong> ${donHang.soDienThoaiNguoiNhan}</p>
                                                    <p><strong>Địa chỉ:</strong> ${donHang.diaChiGiaoHang}</p>
                                                </div>

                                                <div class="admin-order-timer-box">
                                                    <span class="admin-order-box-label">Theo dõi tiến trình</span>
                                                    <div class="admin-order-timer-value js-countdown">--</div>
                                                    <div class="admin-order-timer-sub js-countdown-sub">Đang tải dữ liệu thời gian...</div>
                                                </div>

                                                <div class="admin-order-summary-box">
                                                    <h3>Tổng quan đơn</h3>
                                                    <p><strong>Thanh toán:</strong> ${donHang.phuongThucThanhToan}</p>
                                                    <p><strong>Tổng tiền:</strong>
                                                        <span class="admin-order-money">
                                                            <fmt:formatNumber value="${donHang.tongThanhToan}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                                        </span>
                                                    </p>
                                                    <c:if test="${not empty donHang.maCode}">
                                                        <p><strong>Mã giảm:</strong> ${donHang.maCode}</p>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="admin-order-product-box">
                                                <h3>Sản phẩm trong đơn</h3>

                                                <div class="admin-order-product-list">
                                                    <c:forEach var="ct" items="${mapChiTiet[donHang.maDonHang]}">
                                                        <div class="admin-order-product-item">
                                                            <div class="admin-order-product-left">
                                                                <div class="admin-order-product-name">${ct.tenSanPham}</div>
                                                                <div class="admin-order-product-meta">
                                                                    <span>Size: ${empty ct.tenSize ? '-' : ct.tenSize}</span>

                                                                    <span>
                                                                        SL: ${ct.soLuong}
                                                                        <span class="admin-order-print-inline ${empty ct.tenInAo and empty ct.soInAo ? 'no-print' : 'has-print'}">
                                                                            <c:choose>
                                                                                <c:when test="${not empty ct.tenInAo or not empty ct.soInAo}">
                                                                                    (${ct.tenInAo}${not empty ct.soInAo ? ' - ' : ''}${ct.soInAo})
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    (Không in)
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </span>
                                                                    </span>

                                                                    <span>Đơn giá:
                                                                        <fmt:formatNumber value="${ct.giaMua}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                                                    </span>
                                                                </div>
                                                            </div>
                                                            <div class="admin-order-product-right">
                                                                <fmt:formatNumber value="${ct.thanhTien}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>

                                            <div class="admin-order-actions">
                                                <c:if test="${donHang.trangThaiDonHang == 'cho_xac_nhan'}">
                                                    <button type="button"
                                                            class="admin-order-btn admin-order-btn-primary btn-duyet-don"
                                                            data-ma-don-hang="${donHang.maDonHang}">
                                                        Duyệt đơn
                                                    </button>
                                                </c:if>

                                                <button type="button"
                                                        class="admin-order-btn admin-order-btn-dark btn-toggle-history-detail"
                                                        data-target="admin-detail-${donHang.maDonHang}">
                                                    Chi tiết mốc thời gian
                                                </button>
                                            </div>

                                            <div class="admin-order-detail-panel" id="admin-detail-${donHang.maDonHang}">
                                                <div class="admin-order-detail-grid">
                                                    <div class="admin-order-detail-item">
                                                        <span>Ngày đặt</span>
                                                        <strong>
                                                            <fmt:formatDate value="${donHang.ngayDat}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                        </strong>
                                                    </div>

                                                    <div class="admin-order-detail-item">
                                                        <span>Ngày xác nhận</span>
                                                        <strong>
                                                            <c:choose>
                                                                <c:when test="${not empty donHang.ngayXacNhan}">
                                                                    <fmt:formatDate value="${donHang.ngayXacNhan}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                                </c:when>
                                                                <c:otherwise>Chưa có</c:otherwise>
                                                            </c:choose>
                                                        </strong>
                                                    </div>

                                                    <div class="admin-order-detail-item">
                                                        <span>Bắt đầu giao</span>
                                                        <strong>
                                                            <c:choose>
                                                                <c:when test="${not empty donHang.ngayBatDauGiao}">
                                                                    <fmt:formatDate value="${donHang.ngayBatDauGiao}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                                </c:when>
                                                                <c:otherwise>Chưa có</c:otherwise>
                                                            </c:choose>
                                                        </strong>
                                                    </div>

                                                    <div class="admin-order-detail-item">
                                                        <span>Giao thành công</span>
                                                        <strong>
                                                            <c:choose>
                                                                <c:when test="${not empty donHang.ngayDaGiao}">
                                                                    <fmt:formatDate value="${donHang.ngayDaGiao}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                                </c:when>
                                                                <c:otherwise>Chưa có</c:otherwise>
                                                            </c:choose>
                                                        </strong>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </section>

                        <section class="admin-order-section admin-order-history-section">
                            <div class="admin-order-section-head">
                                <div>
                                    <h2>Lịch sử đơn hàng</h2>
                                    <p>Gồm đơn hoàn thành, đã hủy và trả hàng.</p>
                                </div>
                            </div>

                            <div class="admin-order-history-table-wrap">
                                <table class="admin-order-history-table">
                                    <thead>
                                        <tr>
                                            <th>Mã đơn</th>
                                            <th>Tên user</th>
                                            <th>Người nhận</th>
                                            <th>Trạng thái</th>
                                            <th>Thanh toán</th>
                                            <th>Tổng tiền</th>
                                            <th>Ngày đặt</th>
                                            <th>Ngày hoàn tất</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="donHang" items="${dsLichSuDonHang}">
                                        <tr class="history-row-toggle" data-target="history-detail-${donHang.maDonHang}">
                                            <td>#${donHang.maDonHang}</td>
                                            <td>${empty donHang.tenNguoiDung ? '-' : donHang.tenNguoiDung}</td>
                                            <td>${donHang.hoTenNguoiNhan}</td>
                                            <td>
                                                <span class="admin-order-badge order-badge-${donHang.trangThaiDonHang}">
                                                    ${mapTrangThai[donHang.trangThaiDonHang]}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="admin-order-badge payment-badge-${donHang.trangThaiThanhToan}">
                                                    ${mapThanhToan[donHang.trangThaiThanhToan]}
                                                </span>
                                            </td>
                                            <td>
                                        <fmt:formatNumber value="${donHang.tongThanhToan}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                        </td>
                                        <td>
                                        <fmt:formatDate value="${donHang.ngayDat}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                        </td>
                                        <td>
                                        <c:choose>
                                            <c:when test="${not empty donHang.ngayDaGiao}">
                                                <fmt:formatDate value="${donHang.ngayDaGiao}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                        </td>
                                        </tr>

                                        <tr class="history-detail-row" id="history-detail-${donHang.maDonHang}">
                                            <td colspan="8">
                                                <div class="history-detail-panel">
                                                    <div class="history-detail-user">
                                                        <p><strong>User:</strong> ${empty donHang.tenNguoiDung ? '-' : donHang.tenNguoiDung}</p>
                                                        <p><strong>Email:</strong> ${empty donHang.emailNguoiDung ? '-' : donHang.emailNguoiDung}</p>
                                                        <p><strong>Địa chỉ:</strong> ${donHang.diaChiGiaoHang}</p>
                                                    </div>

                                                    <div class="history-detail-products">
                                                        <c:forEach var="ct" items="${mapChiTietLichSu[donHang.maDonHang]}">
                                                            <div class="history-detail-product-item">
                                                                <span>${ct.tenSanPham}</span>

                                                                <span>Size: ${empty ct.tenSize ? '-' : ct.tenSize}</span>

                                                                <span>SL: ${ct.soLuong}</span>

                                                                <span>
                                                                    <c:choose>
                                                                        <c:when test="${not empty ct.tenInAo or not empty ct.soInAo}">
                                                                            ${ct.tenInAo}${not empty ct.soInAo ? ' - ' : ''}${ct.soInAo}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Không in
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>

                                                                <span>
                                                                    <fmt:formatNumber value="${ct.thanhTien}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                                                </span>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </section>

                    </div>
                </div>
            </main>
        </div>

        <script>
            window.contextPath = "${pageContext.request.contextPath}";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/admin/admin-order-management.js"></script>
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