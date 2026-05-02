<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý thương hiệu</title>
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo.png">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/fonts.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-thuong-hieu.css">
</head>

<body>
<div class="admin-shell">

    <%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

    <main class="admin-main admin-brand-main">

        <section class="admin-brand-header">
            <div>
                <p class="admin-brand-label">VSport Admin</p>
                <h1>Quản lý thương hiệu</h1>
                <span>Thêm, sửa, xóa thương hiệu sản phẩm trong hệ thống.</span>
            </div>

            <button class="admin-brand-add-btn" type="button" id="openAddBrandModal">
                <i data-lucide="plus"></i>
                Thêm thương hiệu
            </button>
        </section>

        <c:if test="${not empty sessionScope.toastMessage}">
            <div class="admin-brand-toast ${sessionScope.toastType}">
                ${sessionScope.toastMessage}
            </div>

            <c:remove var="toastMessage" scope="session"/>
            <c:remove var="toastType" scope="session"/>
        </c:if>

        <section class="admin-brand-card">
            <div class="admin-brand-card-head">
                <div>
                    <h2>Danh sách thương hiệu</h2>
                    <p>Tổng số: <strong>${dsThuongHieu.size()}</strong> thương hiệu</p>
                </div>

                <div class="admin-brand-search">
                    <i data-lucide="search"></i>
                    <input type="text" id="brandSearchInput" placeholder="Tìm kiếm thương hiệu...">
                </div>
            </div>

            <div class="admin-brand-table-wrap">
                <table class="admin-brand-table">
                    <thead>
                    <tr>
                        <th>Mã</th>
                        <th>Tên thương hiệu</th>
                        <th>Slug</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>

                    <tbody id="brandTableBody">
                    <c:choose>
                        <c:when test="${not empty dsThuongHieu}">
                            <c:forEach var="th" items="${dsThuongHieu}">
                                <tr>
                                    <td>#${th.maThuongHieu}</td>

                                    <td class="brand-name">
                                        <span class="brand-icon">
                                            <i data-lucide="tag"></i>
                                        </span>
                                        <strong>${th.tenThuongHieu}</strong>
                                    </td>

                                    <td>
                                        <span class="brand-slug">${th.slug}</span>
                                    </td>

                                    <td>
                                        <div class="brand-actions">
                                            <button
                                                type="button"
                                                class="brand-action-btn edit"
                                                data-id="${th.maThuongHieu}"
                                                data-name="${th.tenThuongHieu}"
                                                data-slug="${th.slug}">
                                                <i data-lucide="pencil"></i>
                                            </button>

                                            <button
                                                type="button"
                                                class="brand-action-btn delete"
                                                data-id="${th.maThuongHieu}"
                                                data-name="${th.tenThuongHieu}">
                                                <i data-lucide="trash-2"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td colspan="4" class="admin-brand-empty">
                                    Chưa có thương hiệu nào.
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

<div class="brand-modal-overlay" id="brandModalOverlay"></div>

<div class="brand-modal" id="brandModal">
    <div class="brand-modal-head">
        <div>
            <p id="brandModalLabel">Thương hiệu</p>
            <h2 id="brandModalTitle">Thêm thương hiệu</h2>
        </div>

        <button type="button" class="brand-modal-close" id="closeBrandModal">
            <i data-lucide="x"></i>
        </button>
    </div>

    <form action="${pageContext.request.contextPath}/admin/thuong-hieu" method="post" class="brand-form">
        <input type="hidden" name="action" id="brandAction" value="add">
        <input type="hidden" name="ma_thuong_hieu" id="brandId">

        <div class="brand-form-group">
            <label>Tên thương hiệu</label>
            <input type="text" name="ten_thuong_hieu" id="brandName" placeholder="Ví dụ: Nike" required>
        </div>

        <div class="brand-form-group">
            <label>Slug</label>
            <input type="text" name="slug" id="brandSlug" placeholder="nike" required>
            <small>Slug không dấu, viết thường, cách nhau bằng dấu gạch ngang.</small>
        </div>

        <div class="brand-form-actions">
            <button type="button" class="brand-cancel-btn" id="cancelBrandModal">
                Hủy
            </button>

            <button type="submit" class="brand-save-btn">
                Lưu thương hiệu
            </button>
        </div>
    </form>
</div>

<div class="brand-modal delete-modal" id="deleteBrandModal">
    <div class="brand-modal-head">
        <div>
            <p>Xác nhận</p>
            <h2>Xóa thương hiệu?</h2>
        </div>

        <button type="button" class="brand-modal-close" id="closeDeleteBrandModal">
            <i data-lucide="x"></i>
        </button>
    </div>

    <p class="delete-warning">
        M có chắc muốn xóa thương hiệu <strong id="deleteBrandName"></strong> không?
    </p>

    <form action="${pageContext.request.contextPath}/admin/thuong-hieu" method="post">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="ma_thuong_hieu" id="deleteBrandId">

        <div class="brand-form-actions">
            <button type="button" class="brand-cancel-btn" id="cancelDeleteBrandModal">
                Hủy
            </button>

            <button type="submit" class="brand-delete-submit">
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
<script src="${pageContext.request.contextPath}/assets/js/admin/admin-thuong-hieu.js"></script>

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