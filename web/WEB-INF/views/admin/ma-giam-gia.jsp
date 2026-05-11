<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý mã giảm giá</title>

        <link rel="icon" type="image/png"
              href="${pageContext.request.contextPath}/assets/images/logos/logo.png">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/base/reset.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/base/variables.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/base/fonts.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/admin/admin-dashboard.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/admin/admin-ma-giam-gia.css">
    </head>

    <body>

        <div class="admin-shell">

            <%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

            <main class="admin-main admin-voucher-main">

                <!-- HEADER -->
                <section class="admin-voucher-header">

                    <div>
                        <p class="admin-voucher-label">VSport Admin</p>

                        <h1>Quản lý mã giảm giá</h1>

                        <span>
                            Quản lý coupon, voucher và mã ưu đãi trong hệ thống.
                        </span>
                    </div>

                    <button type="button"
                            class="admin-voucher-add-btn"
                            id="openVoucherModal">

                        <i data-lucide="ticket-percent"></i>
                        Thêm mã giảm giá
                    </button>
                </section>

                <!-- TOAST -->
                <c:if test="${not empty sessionScope.toastMessage}">
                    <div class="admin-voucher-toast ${sessionScope.toastType}">
                        ${sessionScope.toastMessage}
                    </div>

                    <c:remove var="toastMessage" scope="session"/>
                    <c:remove var="toastType" scope="session"/>
                </c:if>

                <!-- CARD -->
                <section class="admin-voucher-card">

                    <div class="admin-voucher-card-head">

                        <div>
                            <h2>Danh sách mã giảm giá</h2>

                            <p>
                                Tổng số:
                                <strong>${dsMaGiamGia.size()}</strong>
                                mã giảm giá
                            </p>
                        </div>

                        <div class="admin-voucher-search">
                            <i data-lucide="search"></i>

                            <input type="text"
                                   id="voucherSearchInput"
                                   placeholder="Tìm kiếm mã giảm giá...">
                        </div>
                    </div>

                    <!-- TABLE -->
                    <div class="admin-voucher-table-wrap">

                        <table class="admin-voucher-table">

                            <thead>
                                <tr>
                                    <th>Mã</th>
                                    <th>Code</th>
                                    <th>Loại</th>
                                    <th>Giá trị</th>
                                    <th>Số lượng</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>

                            <tbody id="voucherTableBody">

                                <c:choose>

                                    <c:when test="${not empty dsMaGiamGia}">

                                        <c:forEach var="mg" items="${dsMaGiamGia}">

                                            <tr>

                                                <td>CP${mg.maGiamGia}</td>

                                                <td>
                                                    <span class="voucher-code">
                                                        ${mg.maCode}
                                                    </span>
                                                </td>

                                                <td>
                                                    <c:choose>

                                                        <c:when test="${mg.loaiGiam == 'phan_tram'}">
                                                            %
                                                        </c:when>

                                                        <c:otherwise>
                                                            VNĐ
                                                        </c:otherwise>

                                                    </c:choose>
                                                </td>

                                                <td>
                                                    ${mg.giaTriGiam}
                                                </td>

                                                <td>
                                                    ${mg.soLuong}
                                                </td>

                                                <td>

                                                    <span class="voucher-status ${mg.trangThai}">

                                                        <c:choose>

                                                            <c:when test="${mg.trangThai == 'hoat_dong'}">
                                                                Hoạt động
                                                            </c:when>

                                                            <c:otherwise>
                                                                Ẩn
                                                            </c:otherwise>

                                                        </c:choose>

                                                    </span>

                                                </td>

                                                <td>

                                                    <div class="voucher-actions">

                                                        <!-- EDIT -->
                                                        <button type="button"
                                                                class="voucher-action-btn edit"

                                                                data-id="${mg.maGiamGia}"
                                                                data-code="${mg.maCode}"
                                                                data-name="${mg.tenMa}"
                                                                data-value="${mg.giaTriGiam}"
                                                                data-min="${mg.dieuKienToiThieu}"
                                                                data-start="${mg.ngayBatDau}"
                                                                data-end="${mg.ngayKetThuc}"
                                                                data-quantity="${mg.soLuong}"
                                                                data-status="${mg.trangThai}"
                                                                data-type="${mg.loaiGiam}"
                                                                data-max="${mg.giamToiDa}"
                                                                data-xu="${mg.soXuCan}"
                                                                data-showxu="${mg.hienThiDoiXu}">

                                                            <i data-lucide="pencil"></i>

                                                        </button>

                                                        <!-- DELETE -->
                                                        <button type="button"
                                                                class="voucher-action-btn delete"
                                                                data-id="${mg.maGiamGia}"
                                                                data-code="${mg.maCode}">

                                                            <i data-lucide="trash-2"></i>

                                                        </button>

                                                    </div>

                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:when>

                                    <c:otherwise>

                                        <tr>
                                            <td colspan="7"
                                                class="admin-voucher-empty">

                                                Chưa có mã giảm giá nào.

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

        <!-- OVERLAY -->
        <div class="voucher-modal-overlay"
             id="voucherModalOverlay"></div>

        <!-- ADD / EDIT MODAL -->
        <div class="voucher-modal"
             id="voucherModal">

            <div class="voucher-modal-head">

                <div>
                    <p id="voucherModalLabel">Mã giảm giá</p>

                    <h2 id="voucherModalTitle">
                        Thêm mã giảm giá
                    </h2>
                </div>

                <button type="button"
                        class="voucher-modal-close"
                        id="closeVoucherModal">

                    <i data-lucide="x"></i>

                </button>

            </div>

            <form action="${pageContext.request.contextPath}/admin/ma-giam-gia"
                  method="post"
                  class="voucher-form">

                <input type="hidden"
                       name="action"
                       id="voucherAction"
                       value="add">

                <input type="hidden"
                       name="ma_giam_gia"
                       id="voucherId">

                <!-- CODE -->
                <div class="voucher-form-group">

                    <label>Mã code</label>

                    <input type="text"
                           name="ma_code"
                           id="voucherCode"
                           required>

                </div>

                <!-- NAME -->
                <div class="voucher-form-group">

                    <label>Tên mã</label>

                    <input type="text"
                           name="ten_ma"
                           id="voucherName">

                </div>

                <!-- VALUE -->
                <div class="voucher-form-grid">

                    <div class="voucher-form-group">

                        <label>Loại giảm</label>

                        <select name="loai_giam"
                                id="voucherType">

                            <option value="tien">
                                Tiền mặt
                            </option>

                            <option value="phan_tram">
                                Phần trăm
                            </option>

                        </select>

                    </div>

                    <div class="voucher-form-group">

                        <label>Giá trị giảm</label>

                        <input type="number"
                               name="gia_tri_giam"
                               id="voucherValue"
                               required>

                    </div>

                </div>

                <!-- CONDITIONS -->
                <div class="voucher-form-grid">

                    <div class="voucher-form-group">

                        <label>Đơn tối thiểu</label>

                        <input type="number"
                               name="dieu_kien_toi_thieu"
                               id="voucherMin">

                    </div>

                    <div class="voucher-form-group">

                        <label>Giảm tối đa</label>

                        <input type="number"
                               name="giam_toi_da"
                               id="voucherMax">

                    </div>

                </div>

                <!-- DATE -->
                <div class="voucher-form-grid">

                    <div class="voucher-form-group">

                        <label>Ngày bắt đầu</label>

                        <input type="datetime-local"
                               name="ngay_bat_dau"
                               id="voucherStart">

                    </div>

                    <div class="voucher-form-group">

                        <label>Ngày kết thúc</label>

                        <input type="datetime-local"
                               name="ngay_ket_thuc"
                               id="voucherEnd">

                    </div>

                </div>

                <!-- OTHER -->
                <div class="voucher-form-grid">

                    <div class="voucher-form-group">

                        <label>Số lượng</label>

                        <input type="number"
                               name="so_luong"
                               id="voucherQuantity">

                    </div>

                    <div class="voucher-form-group">

                        <label>Trạng thái</label>

                        <select name="trang_thai"
                                id="voucherStatus">

                            <option value="hoat_dong">
                                Hoạt động
                            </option>

                            <option value="an">
                                Ẩn
                            </option>

                        </select>

                    </div>

                </div>

                <!-- XU -->
                <div class="voucher-form-grid">

                    <div class="voucher-form-group">

                        <label>Số xu cần</label>

                        <input type="number"
                               name="so_xu_can"
                               id="voucherXu">

                    </div>

                    <div class="voucher-form-group checkbox-group">

                        <label class="checkbox-label">

                            <input type="checkbox"
                                   name="hien_thi_doi_xu"
                                   id="voucherShowXu">

                            Hiển thị đổi xu

                        </label>

                    </div>

                </div>

                <!-- ACTION -->
                <div class="voucher-form-actions">

                    <button type="button"
                            class="voucher-cancel-btn"
                            id="cancelVoucherModal">

                        Hủy

                    </button>

                    <button type="submit"
                            class="voucher-save-btn">

                        Lưu mã giảm giá

                    </button>

                </div>

            </form>

        </div>

        <!-- DELETE MODAL -->
        <div class="voucher-modal delete-modal"
             id="deleteVoucherModal">

            <div class="voucher-modal-head">

                <div>
                    <p>Xác nhận</p>
                    <h2>Xóa mã giảm giá?</h2>
                </div>

                <button type="button"
                        class="voucher-modal-close"
                        id="closeDeleteVoucherModal">

                    <i data-lucide="x"></i>

                </button>

            </div>

            <p class="delete-warning">

                M có chắc muốn xóa mã
                <strong id="deleteVoucherCode"></strong>
                không?

            </p>

            <form action="${pageContext.request.contextPath}/admin/ma-giam-gia"
                  method="post">

                <input type="hidden"
                       name="action"
                       value="delete">

                <input type="hidden"
                       name="ma_giam_gia"
                       id="deleteVoucherId">

                <div class="voucher-form-actions">

                    <button type="button"
                            class="voucher-cancel-btn"
                            id="cancelDeleteVoucherModal">

                        Hủy

                    </button>

                    <button type="submit"
                            class="voucher-delete-submit">

                        Xóa

                    </button>

                </div>

            </form>

        </div>

        <script>
    window.APP_CONTEXT = "${pageContext.request.contextPath}";
        </script>

        <script src="https://unpkg.com/lucide@latest"></script>

        <script src="${pageContext.request.contextPath}/assets/js/admin/admin-dashboard.js"></script>

        <script src="${pageContext.request.contextPath}/assets/js/admin/admin-ma-giam-gia.js"></script>

        <script>
            lucide.createIcons();
        </script>

        <!-- jQuery -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <!-- Toastr -->
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