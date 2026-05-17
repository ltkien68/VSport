<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý danh mục</title>

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo.png">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/reset.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/fonts.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-danh-muc.css">
    </head>

    <body>
        <div class="admin-shell">

            <%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

            <main class="admin-main admin-category-main">

                <section class="admin-category-header">
                    <div>
                        <p class="admin-category-label">LKsport Admin</p>
                        <h1>Quản lý danh mục</h1>
                        <span>Thêm, sửa, xóa danh mục sản phẩm trong hệ thống.</span>
                    </div>

                    <button class="admin-category-add-btn" type="button" id="openAddCategoryModal">
                        <i data-lucide="plus"></i>
                        Thêm danh mục
                    </button>
                </section>

                <c:if test="${not empty sessionScope.toastMessage}">
                    <div class="admin-category-toast ${sessionScope.toastType}">
                        ${sessionScope.toastMessage}
                    </div>

                    <c:remove var="toastMessage" scope="session"/>
                    <c:remove var="toastType" scope="session"/>
                </c:if>

                <section class="admin-category-card">
                    <div class="admin-category-card-head">
                        <div>
                            <h2>Danh sách danh mục</h2>
                            <p>Tổng số: <strong>${dsDanhMuc.size()}</strong> danh mục</p>
                        </div>

                        <div class="admin-category-search">
                            <i data-lucide="search"></i>
                            <input type="text" id="categorySearchInput" placeholder="Tìm kiếm danh mục...">
                        </div>
                    </div>

                    <div class="admin-category-table-wrap">
                        <table class="admin-category-table">
                            <thead>
                                <tr>
                                    <th>Mã</th>
                                    <th>Tên danh mục</th>
                                    <th>Slug</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>

                            <tbody id="categoryTableBody">
                                <c:choose>
                                    <c:when test="${not empty dsDanhMuc}">
                                        <c:forEach var="dm" items="${dsDanhMuc}">
                                            <tr>
                                                <td>#${dm.maDanhMuc}</td>

                                                <td class="category-name">
                                                    <span class="category-icon">
                                                        <i data-lucide="folder"></i>
                                                    </span>
                                                    <strong>${dm.tenDanhMuc}</strong>
                                                </td>

                                                <td>
                                                    <span class="category-slug">${dm.slug}</span>
                                                </td>

                                                <td>
                                                    <div class="category-actions">
                                                        <button
                                                            type="button"
                                                            class="category-action-btn edit"
                                                            data-id="${dm.maDanhMuc}"
                                                            data-name="${dm.tenDanhMuc}"
                                                            data-slug="${dm.slug}">
                                                            <i data-lucide="pencil"></i>
                                                        </button>

                                                        <button
                                                            type="button"
                                                            class="category-action-btn delete"
                                                            data-id="${dm.maDanhMuc}"
                                                            data-name="${dm.tenDanhMuc}">
                                                            <i data-lucide="trash-2"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>

                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="admin-category-empty">
                                                Chưa có danh mục nào.
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

        <div class="category-modal-overlay" id="categoryModalOverlay"></div>

        <div class="category-modal" id="categoryModal">
            <div class="category-modal-head">
                <div>
                    <p id="categoryModalLabel">Danh mục</p>
                    <h2 id="categoryModalTitle">Thêm danh mục</h2>
                </div>

                <button type="button" class="category-modal-close" id="closeCategoryModal">
                    <i data-lucide="x"></i>
                </button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/danh-muc" method="post" class="category-form">
                <input type="hidden" name="action" id="categoryAction" value="add">
                <input type="hidden" name="ma_danh_muc" id="categoryId">

                <div class="category-form-group">
                    <label>Tên danh mục</label>
                    <input type="text" name="ten_danh_muc" id="categoryName" placeholder="Ví dụ: Áo bóng đá" required>
                </div>

                <div class="category-form-group">
                    <label>Slug</label>
                    <input type="text" name="slug" id="categorySlug" placeholder="ao-bong-da" required>
                    <small>Slug không dấu, viết thường, cách nhau bằng dấu gạch ngang.</small>
                </div>

                <div class="category-form-actions">
                    <button type="button" class="category-cancel-btn" id="cancelCategoryModal">
                        Hủy
                    </button>

                    <button type="submit" class="category-save-btn">
                        Lưu danh mục
                    </button>
                </div>
            </form>
        </div>

        <div class="category-modal delete-modal" id="deleteCategoryModal">
            <div class="category-modal-head">
                <div>
                    <p>Xác nhận</p>
                    <h2>Xóa danh mục?</h2>
                </div>

                <button type="button" class="category-modal-close" id="closeDeleteCategoryModal">
                    <i data-lucide="x"></i>
                </button>
            </div>

            <p class="delete-warning">
                M có chắc muốn xóa danh mục <strong id="deleteCategoryName"></strong> không?
            </p>

            <form action="${pageContext.request.contextPath}/admin/danh-muc" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="ma_danh_muc" id="deleteCategoryId">

                <div class="category-form-actions">
                    <button type="button" class="category-cancel-btn" id="cancelDeleteCategoryModal">
                        Hủy
                    </button>

                    <button type="submit" class="category-delete-submit">
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
        <script src="${pageContext.request.contextPath}/assets/js/admin/admin-danh-muc.js"></script>

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