<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="model.NguoiDung" %>

<%
    NguoiDung nguoiDungProfile = (NguoiDung) session.getAttribute("nguoiDung");
    String ten = "BẠN";

    if (nguoiDungProfile != null && nguoiDungProfile.getHoTen() != null) {
        String hoTen = nguoiDungProfile.getHoTen().trim();
        String[] tachTen = hoTen.split("\\s+");
        if (tachTen.length > 0) {
            ten = tachTen[tachTen.length - 1].toUpperCase();
        }
    }

    String tab = request.getParameter("tab");
    if (tab == null || tab.trim().isEmpty()) {
        tab = "tat_ca";
    }
    request.setAttribute("activeTab", tab);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đơn hàng của tôi | VSport</title>

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo.png">
        <jsp:include page="/WEB-INF/views/common/head.jsp" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/order-history.css">
    </head>
    <body class="inner">

        <div class="header-shell">
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
            <%@ include file="/WEB-INF/views/common/navbar.jsp" %>
        </div>

        <section class="order-history-page">
            <div class="order-history-container">
                <div class="order-history-heading">

                    <h1 class="order-history-title">

                        ĐƠN HÀNG CỦA
                        <span style="font-family: var(--font-display)">
                            <%= ten != null && !ten.isEmpty() ? ten.toUpperCase() : "BẠN" %>
                        </span>
                    </h1>
                    <p class="order-history-desc">
                        Theo dõi mọi nhịp chuyển động của đơn hàng, từ lúc đặt đến khi về tay.
                    </p>
                </div>

                <div class="order-tabs">
                    <a href="${pageContext.request.contextPath}/don-hang?tab=tat_ca"
                       class="order-tab ${activeTab == 'tat_ca' ? 'active' : ''}">
                        Tất cả
                    </a>
                    <a href="${pageContext.request.contextPath}/don-hang?tab=cho_xac_nhan"
                       class="order-tab ${activeTab == 'cho_xac_nhan' ? 'active' : ''}">
                        Chờ xác nhận
                    </a>
                    <a href="${pageContext.request.contextPath}/don-hang?tab=cho_lay_hang"
                       class="order-tab ${activeTab == 'cho_lay_hang' ? 'active' : ''}">
                        Chờ lấy hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/don-hang?tab=dang_giao"
                       class="order-tab ${activeTab == 'dang_giao' ? 'active' : ''}">
                        Vận chuyển
                    </a>
                    <a href="${pageContext.request.contextPath}/don-hang?tab=da_giao"
                       class="order-tab ${activeTab == 'da_giao' ? 'active' : ''}">
                        Hoàn thành
                    </a>
                    <a href="${pageContext.request.contextPath}/don-hang?tab=da_huy"
                       class="order-tab ${activeTab == 'da_huy' ? 'active' : ''}">
                        Đã hủy
                    </a>
                    <a href="${pageContext.request.contextPath}/don-hang?tab=tra_hang"
                       class="order-tab ${activeTab == 'tra_hang' ? 'active' : ''}">
                        Trả hàng/Hoàn tiền
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty dsDonHang}">
                        <div class="order-history-list">
                            <c:forEach var="donHang" items="${dsDonHang}">
                                <c:set var="showCard"
                                       value="${activeTab == 'tat_ca'
                                                || (activeTab == 'cho_thanh_toan' && donHang.trangThaiThanhToan == 'chua_thanh_toan')
                                                || (activeTab == 'cho_xac_nhan' && donHang.trangThaiDonHang == 'cho_xac_nhan')
                                                || (activeTab == 'cho_lay_hang' && donHang.trangThaiDonHang == 'cho_lay_hang')
                                                || (activeTab == 'dang_giao' && donHang.trangThaiDonHang == 'dang_giao')
                                                || (activeTab == 'da_giao' && donHang.trangThaiDonHang == 'da_giao')
                                                || (activeTab == 'da_huy' && donHang.trangThaiDonHang == 'da_huy')
                                                || (activeTab == 'tra_hang' && false)}" />

                                <c:if test="${showCard}">
                                    <div class="order-card">
                                        <div class="order-card-head">


                                            <div class="order-card-code-wrap">
                                                <span class="order-card-label">Mã đơn hàng</span>
                                                <h3 class="order-card-code">ĐƠN <span style="color: var(--color-red)">V<span style="color: #D4AF37">$</span>${donHang.maDonHang}</span></h3>
                                                <p class="order-card-date">
                                                <fmt:formatDate value="${donHang.ngayDat}" pattern="dd/MM/yyyy HH:mm"/>
                                                </p>
                                            </div>

                                            <div class="order-card-status">
                                                <span class="order-status-text order-status-text-${donHang.trangThaiDonHang}">
                                                    ${mapTrangThai[donHang.trangThaiDonHang]}
                                                </span>
                                                <span class="order-status-divider">|</span>
                                                <span class="payment-status-text payment-status-text-${donHang.trangThaiThanhToan}">
                                                    ${mapThanhToan[donHang.trangThaiThanhToan]}
                                                </span>
                                            </div>
                                        </div>

                                        <div class="order-card-products">
                                            <div class="order-product-scroll">
                                                <c:forEach var="ct" items="${mapChiTiet[donHang.maDonHang]}">
                                                    <div class="order-product-item">
                                                        <div class="order-product-left">
                                                            <a href="${pageContext.request.contextPath}${ct.linkChiTiet}" class="order-product-thumb-link">
                                                                <div class="order-product-thumb">
                                                                    <c:choose>
                                                                        <c:when test="${not empty ct.anhChinh}">
                                                                            <img src="${pageContext.request.contextPath}/${ct.anhChinh}" alt="${ct.tenSanPham}">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <i data-lucide="shopping-bag"></i>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </a>

                                                            <div class="order-product-content">
                                                                <a href="${pageContext.request.contextPath}${ct.linkChiTiet}" class="order-product-name-link">
                                                                    <p class="order-product-name">${ct.tenSanPham}</p>
                                                                </a>
                                                                <p class="order-product-variant">
                                                                    Đơn giá:
                                                                <fmt:formatNumber value="${ct.giaMua}" type="number"/>đ
                                                                </p>
                                                                <p class="order-product-qty">Số lượng: ${ct.soLuong}</p>

                                                                <c:if test="${donHang.trangThaiDonHang == 'da_giao'}">

                                                                    <c:set
                                                                        var="reviewKey"
                                                                        value="${donHang.maDonHang}-${ct.maSanPham}"
                                                                        />

                                                                    <c:choose>

                                                                        <%-- ĐÃ ĐÁNH GIÁ --%>
                                                                        <c:when test="${mapDaDanhGia[reviewKey]}">

                                                                            <button
                                                                                type="button"
                                                                                class="order-review-btn reviewed"
                                                                                disabled
                                                                                >
                                                                                ✓ Đã đánh giá
                                                                            </button>

                                                                        </c:when>

                                                                        <%-- CHƯA ĐÁNH GIÁ --%>
                                                                        <c:otherwise>

                                                                            <button
                                                                                type="button"
                                                                                class="order-review-btn open-review-popup"

                                                                                data-ma-don-hang="${donHang.maDonHang}"
                                                                                data-ma-san-pham="${ct.maSanPham}"
                                                                                data-ma-nguoi-dung="${nguoiDung.maNguoiDung}"

                                                                                data-ten-san-pham="${ct.tenSanPham}"
                                                                                data-anh="${ct.anhChinh}"
                                                                                >

                                                                                Đánh giá

                                                                            </button>

                                                                        </c:otherwise>

                                                                    </c:choose>

                                                                </c:if>

                                                                <div class="order-print-info">
                                                                    <c:if test="${not empty ct.tenInAo or not empty ct.soInAo}">
                                                                        <div class="order-print-row">
                                                                            <span class="order-print-label">In áo:</span>

                                                                            <c:choose>
                                                                                <c:when test="${not empty ct.tenInAo and not empty ct.soInAo}">
                                                                                    <span class="order-print-value">${ct.tenInAo} - ${ct.soInAo}</span>
                                                                                </c:when>

                                                                                <c:when test="${not empty ct.tenInAo}">
                                                                                    <span class="order-print-value">${ct.tenInAo}</span>
                                                                                </c:when>

                                                                                <c:when test="${not empty ct.soInAo}">
                                                                                    <span class="order-print-value">${ct.soInAo}</span>
                                                                                </c:when>
                                                                            </c:choose>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="order-product-right">
                                                            <fmt:formatNumber value="${ct.thanhTien}" type="number"/>đ
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <div class="order-card-total">
                                            <span>Thành tiền:</span>
                                            <strong><fmt:formatNumber value="${donHang.tongThanhToan}" type="number"/>đ</strong>
                                        </div>

                                        <div class="order-card-actions">
                                            <div class="order-card-actions-left">
                                                <c:choose>


                                                    <c:when test="${donHang.trangThaiDonHang == 'cho_xac_nhan'}">
                                                        <button type="button" class="order-btn order-btn-danger btn-huy-don" data-ma-don-hang="${donHang.maDonHang}">
                                                            Hủy đơn
                                                        </button>
                                                    </c:when>
                                                </c:choose>
                                            </div>

                                            <div class="order-card-actions-right">
                                                <button type="button"
                                                        class="order-btn order-btn-ghost order-toggle-detail"
                                                        data-target="order-detail-${donHang.maDonHang}">
                                                    Thêm
                                                    <i data-lucide="chevron-down"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <div class="order-detail-panel" id="order-detail-${donHang.maDonHang}">
                                            <div class="order-detail-grid">
                                                <div class="order-detail-item">
                                                    <span>Người nhận</span>
                                                    <strong>${donHang.hoTenNguoiNhan}</strong>
                                                </div>

                                                <div class="order-detail-item">
                                                    <span>Số điện thoại</span>
                                                    <strong>${donHang.soDienThoaiNguoiNhan}</strong>
                                                </div>

                                                <div class="order-detail-item full">
                                                    <span>Địa chỉ giao hàng</span>
                                                    <strong>${donHang.diaChiGiaoHang}</strong>
                                                </div>

                                                <div class="order-detail-item">
                                                    <span>Thanh toán</span>
                                                    <strong>${donHang.phuongThucThanhToan}</strong>
                                                </div>

                                                <div class="order-detail-item">
                                                    <span>Mã giảm giá </span>
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${not empty donHang.maGiamGia}">
                                                                ${donHang.maCode}
                                                            </c:when>
                                                            <c:otherwise>Không có</c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                </div>

                                                <c:if test="${not empty donHang.ghiChu}">
                                                    <div class="order-detail-item full">
                                                        <span>Ghi chú</span>
                                                        <strong>${donHang.ghiChu}</strong>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <div class="order-detail-summary">
                                                <div class="order-detail-summary-row">
                                                    <span>Tạm tính</span>
                                                    <strong><fmt:formatNumber value="${donHang.tongTienHang}" type="number"/>đ</strong>
                                                </div>
                                                <div class="order-detail-summary-row">
                                                    <span>Phí vận chuyển</span>
                                                    <strong><fmt:formatNumber value="${donHang.phiVanChuyen}" type="number"/>đ</strong>
                                                </div>
                                                <div class="order-detail-summary-row discount">
                                                    <span>Giảm giá</span>
                                                    <strong>- <fmt:formatNumber value="${donHang.giamGia}" type="number"/>đ</strong>
                                                </div>
                                                <div class="order-detail-summary-row total">
                                                    <span>Tổng thanh toán</span>
                                                    <strong><fmt:formatNumber value="${donHang.tongThanhToan}" type="number"/>đ</strong>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="order-empty">
                            <p class="order-empty-title">Chưa có đơn hàng nào.</p>
                            <p class="order-empty-desc">
                                Sân cỏ còn trống, tủ đồ còn mở. Đặt đơn đầu tiên để lịch sử này bớt cô đơn.
                            </p>
                            <a href="${pageContext.request.contextPath}/trang_chu" class="order-empty-btn">
                                TIẾP TỤC MUA SẮM
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <jsp:include page="/WEB-INF/views/pages/components/review-popup.jsp" />
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />

        <script src="https://unpkg.com/lucide@latest"></script>
        <script>
            lucide.createIcons();

            document.addEventListener("DOMContentLoaded", function () {
                const toggleButtons = document.querySelectorAll(".order-toggle-detail");

                toggleButtons.forEach(function (button) {
                    button.addEventListener("click", function () {
                        const targetId = this.getAttribute("data-target");
                        const panel = document.getElementById(targetId);
                        if (!panel)
                            return;

                        const isOpen = panel.classList.contains("open");

                        document.querySelectorAll(".order-detail-panel").forEach(function (item) {
                            item.classList.remove("open");
                        });

                        document.querySelectorAll(".order-toggle-detail").forEach(function (btn) {
                            btn.classList.remove("active");
                        });

                        if (!isOpen) {
                            panel.classList.add("open");
                            this.classList.add("active");
                        }
                    });
                });
            });
        </script>

        <script>
            window.contextPath = "${pageContext.request.contextPath}";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/common/scroll-reveal.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/login-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/review-popup.js"></script>



        <div class="cancel-order-modal" id="cancelOrderModal">
            <div class="cancel-order-overlay" id="cancelOrderOverlay"></div>

            <div class="cancel-order-box">
                <button type="button" class="cancel-order-close" id="closeCancelOrderModal">×</button>

                <div class="cancel-order-head">
                    <h3>Xác nhận hủy đơn hàng</h3>
                    <p>
                        Để hủy đơn này, vui lòng nhập lại mã đơn:
                        <strong id="cancelOrderCodeText"></strong>
                    </p>
                </div>

                <div class="cancel-order-body">
                    <input type="text"
                           id="cancelOrderCodeInput"
                           class="cancel-order-input"
                           placeholder="Nhập lại mã đơn hàng..." />

                    <p class="cancel-order-error" id="cancelOrderError"></p>
                </div>

                <div class="cancel-order-actions">
                    <button type="button" class="cancel-order-btn cancel-order-btn-secondary" id="cancelOrderBackBtn">
                        Quay lại
                    </button>
                    <button type="button" class="cancel-order-btn cancel-order-btn-danger" id="confirmCancelOrderBtn">
                        Xác nhận hủy
                    </button>
                </div>
            </div>
        </div>


        <script src="${pageContext.request.contextPath}/assets/js/pages/order-history.js"></script>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

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