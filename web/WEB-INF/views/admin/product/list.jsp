<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="model.SanPham" %>
<%@ page import="model.DanhMuc" %>
<%@ page import="model.ThuongHieu" %>
<%@ page import="model.DoiBong" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    List<SanPham> dsSanPham = (List<SanPham>) request.getAttribute("dsSanPham");
    if (dsSanPham == null) dsSanPham = new ArrayList<>();

    List<DanhMuc> dsDanhMuc = (List<DanhMuc>) request.getAttribute("dsDanhMuc");
    if (dsDanhMuc == null) dsDanhMuc = new ArrayList<>();

    List<ThuongHieu> dsThuongHieu = (List<ThuongHieu>) request.getAttribute("dsThuongHieu");
    if (dsThuongHieu == null) dsThuongHieu = new ArrayList<>();

    List<DoiBong> dsDoiBong = (List<DoiBong>) request.getAttribute("dsDoiBong");
    if (dsDoiBong == null) dsDoiBong = new ArrayList<>();

    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    String createdFrom = request.getParameter("createdFrom");
    if (createdFrom == null) createdFrom = "";

    String createdTo = request.getParameter("createdTo");
    if (createdTo == null) createdTo = "";

    String trangThai = request.getParameter("trangThai");
    if (trangThai == null) trangThai = "";

    String maDanhMuc = request.getParameter("maDanhMuc");
    if (maDanhMuc == null) maDanhMuc = "";

    String maThuongHieu = request.getParameter("maThuongHieu");
    if (maThuongHieu == null) maThuongHieu = "";

    String maDoiBong = request.getParameter("maDoiBong");
    if (maDoiBong == null) maDoiBong = "";

    Integer currentPage = (Integer) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = 1;

    Integer totalPages = (Integer) request.getAttribute("totalPages");
    if (totalPages == null) totalPages = 1;

    Integer totalRecords = (Integer) request.getAttribute("totalRecords");
    if (totalRecords == null) totalRecords = 0;

    Integer pageSize = (Integer) request.getAttribute("pageSize");
    if (pageSize == null) pageSize = 10;

    int startRecord = totalRecords == 0 ? 0 : ((currentPage - 1) * pageSize) + 1;
    int endRecord = Math.min(currentPage * pageSize, totalRecords);

    DecimalFormat priceFormat = new DecimalFormat("#,###");

    String contextPath = request.getContextPath();
    String baseUrl = contextPath + "/admin/san-pham";

    StringBuilder queryBuilder = new StringBuilder();
    if (!keyword.isEmpty()) queryBuilder.append("&keyword=").append(URLEncoder.encode(keyword, "UTF-8"));
    if (!createdFrom.isEmpty()) queryBuilder.append("&createdFrom=").append(URLEncoder.encode(createdFrom, "UTF-8"));
    if (!createdTo.isEmpty()) queryBuilder.append("&createdTo=").append(URLEncoder.encode(createdTo, "UTF-8"));
    if (!trangThai.isEmpty()) queryBuilder.append("&trangThai=").append(URLEncoder.encode(trangThai, "UTF-8"));
    if (!maDanhMuc.isEmpty()) queryBuilder.append("&maDanhMuc=").append(URLEncoder.encode(maDanhMuc, "UTF-8"));
    if (!maThuongHieu.isEmpty()) queryBuilder.append("&maThuongHieu=").append(URLEncoder.encode(maThuongHieu, "UTF-8"));
    if (!maDoiBong.isEmpty()) queryBuilder.append("&maDoiBong=").append(URLEncoder.encode(maDoiBong, "UTF-8"));
    queryBuilder.append("&size=").append(pageSize);

    String paginationQuery = queryBuilder.toString();
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm | Admin</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/fonts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-product-list.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-add-product-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-delete-product-popup.css">
</head>
<body>

<div class="admin-shell">


        <%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>
        

    <main class="admin-main">
        <div class="admin-product-page">
            <div class="admin-product-shell">

                <div class="admin-product-topbar">
                    <form class="admin-product-top-search" action="<%= baseUrl %>" method="get">
                        <input type="text" name="keyword" value="<%= keyword %>" placeholder="Search">
                        <input type="hidden" name="createdFrom" value="<%= createdFrom %>">
                        <input type="hidden" name="createdTo" value="<%= createdTo %>">
                        <input type="hidden" name="trangThai" value="<%= trangThai %>">
                        <input type="hidden" name="maDanhMuc" value="<%= maDanhMuc %>">
                        <input type="hidden" name="maThuongHieu" value="<%= maThuongHieu %>">
                        <input type="hidden" name="maDoiBong" value="<%= maDoiBong %>">
                        <input type="hidden" name="size" value="<%= pageSize %>">
                        <button type="submit" aria-label="Search">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M21 21L16.65 16.65M18 11C18 14.866 14.866 18 11 18C7.13401 18 4 14.866 4 11C4 7.13401 7.13401 4 11 4C14.866 4 18 7.13401 18 11Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </button>
                    </form>

                    <div class="admin-product-top-icons">
                        <button type="button" class="admin-product-top-icon-btn" aria-label="Thông báo">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M14.857 17H9.143M18 8C18 5.23858 15.3137 3 12 3C8.68629 3 6 5.23858 6 8C6 10.0902 5.32847 11.5789 4.58579 12.5786C3.98154 13.3919 4.56581 14.5 5.5802 14.5H18.4198C19.4342 14.5 20.0185 13.3919 19.4142 12.5786C18.6715 11.5789 18 10.0902 18 8Z" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
                                <path d="M13.73 17C13.5542 17.6078 13.0275 18 12.4394 18H11.5606C10.9725 18 10.4458 17.6078 10.27 17" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
                            </svg>
                        </button>

                        <button type="button" class="admin-product-top-icon-btn" aria-label="Tin nhắn">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M4 6.5C4 5.67157 4.67157 5 5.5 5H18.5C19.3284 5 20 5.67157 20 6.5V17.5C20 18.3284 19.3284 19 18.5 19H5.5C4.67157 19 4 18.3284 4 17.5V6.5Z" stroke="currentColor" stroke-width="1.7"/>
                                <path d="M5 7L11.1688 11.3174C11.6764 11.6727 12.3236 11.6727 12.8312 11.3174L19 7" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <div class="admin-product-header">
                    <div class="admin-product-header-left">
                        <h1 class="admin-product-title">Danh Sách Sản Phẩm</h1>
                    </div>

                    <div class="admin-product-actions">
                        <button type="button" class="admin-product-btn admin-product-btn-light">
                            <span class="admin-product-btn-icon">↓</span>
                            <span>Nhập Dữ Liệu</span>
                        </button>

                        <button type="button" class="admin-product-btn admin-product-btn-light">
                            <span class="admin-product-btn-icon">⇪</span>
                            <span>Xuất Dữ Liệu</span>
                        </button>

                        <button type="button"
                                id="openAddProductPopup"
                                class="admin-product-btn admin-product-btn-primary">
                            <span class="admin-product-btn-icon">＋</span>
                            <span>Thêm Sản Phẩm</span>
                        </button>
                    </div>
                </div>

                <div class="admin-product-card">
                    <form method="get" action="<%= baseUrl %>" class="admin-product-filter-bar" id="adminProductFilterForm">
                        <div class="admin-product-filter-search">
                            <input type="text" name="keyword" value="<%= keyword %>" placeholder="Search">
                            <button type="submit" aria-label="Search">
                                <svg viewBox="0 0 24 24" fill="none">
                                    <path d="M21 21L16.65 16.65M18 11C18 14.866 14.866 18 11 18C7.13401 18 4 14.866 4 11C4 7.13401 7.13401 4 11 4C14.866 4 18 7.13401 18 11Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </button>
                        </div>

                        <div class="admin-product-filter-group">
                            <div class="admin-product-filter-date-wrap">
                                <span class="admin-product-filter-date-icon">
                                    <svg viewBox="0 0 24 24" fill="none">
                                        <path d="M8 2V5M16 2V5M3 9H21M5 4H19C20.1046 4 21 4.89543 21 6V19C21 20.1046 20.1046 21 19 21H5C3.89543 21 3 20.1046 3 19V6C3 4.89543 3.89543 4 5 4Z" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
                                    </svg>
                                </span>
                                <input type="date" name="createdFrom" value="<%= createdFrom %>" class="admin-product-date-input">
                                <span class="admin-product-date-separator">—</span>
                                <input type="date" name="createdTo" value="<%= createdTo %>" class="admin-product-date-input">
                            </div>

                            <select name="trangThai" class="admin-product-select auto-submit">
                                <option value="">Trạng Thái</option>
                                <option value="dang_ban" <%= "dang_ban".equals(trangThai) ? "selected" : "" %>>Đang bán</option>
                                <option value="an" <%= "an".equals(trangThai) ? "selected" : "" %>>Ẩn</option>
                            </select>

                            <select name="maDanhMuc" class="admin-product-select auto-submit">
                                <option value="">Danh Mục</option>
                                <% for (DanhMuc dm : dsDanhMuc) { %>
                                    <option value="<%= dm.getMaDanhMuc() %>" <%= String.valueOf(dm.getMaDanhMuc()).equals(maDanhMuc) ? "selected" : "" %>>
                                        <%= dm.getTenDanhMuc() %>
                                    </option>
                                <% } %>
                            </select>

                            <select name="maThuongHieu" class="admin-product-select auto-submit">
                                <option value="">Thương Hiệu</option>
                                <% for (ThuongHieu th : dsThuongHieu) { %>
                                    <option value="<%= th.getMaThuongHieu() %>" <%= String.valueOf(th.getMaThuongHieu()).equals(maThuongHieu) ? "selected" : "" %>>
                                        <%= th.getTenThuongHieu() %>
                                    </option>
                                <% } %>
                            </select>

                            <select name="maDoiBong" class="admin-product-select auto-submit">
                                <option value="">Đội Bóng</option>
                                <% for (DoiBong db : dsDoiBong) { %>
                                    <option value="<%= db.getMaDoiBong() %>" <%= String.valueOf(db.getMaDoiBong()).equals(maDoiBong) ? "selected" : "" %>>
                                        <%= db.getTenDoiBong() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <input type="hidden" name="page" value="1">
                    </form>

                    <div class="admin-product-table-wrap">
                        <table class="admin-product-table">
                            <thead>
                                <tr>
                                    <th class="admin-product-col-checkbox">
                                        <label class="admin-product-checkbox">
                                            <input type="checkbox" id="checkAllProducts">
                                            <span></span>
                                        </label>
                                    </th>
                                    <th>Mã Sản Phẩm</th>
                                    <th>Tên Sản Phẩm</th>
                                    <th>Danh Mục</th>
                                    <th>Tồn Kho</th>
                                    <th>Giá</th>
                                    <th>Trạng Thái</th>
                                    <th class="admin-product-col-action">Hành Động</th>
                                </tr>
                            </thead>

                            <tbody>
                                <% if (dsSanPham.isEmpty()) { %>
                                    <tr>
                                        <td colspan="7" class="admin-product-empty-cell">
                                            Không có sản phẩm nào phù hợp
                                        </td>
                                    </tr>
                                <% } else { %>
                                    <% for (SanPham sp : dsSanPham) { %>
                                        <tr>
                                            <td>
                                                <label class="admin-product-checkbox">
                                                    <input type="checkbox" class="product-row-check">
                                                    <span></span>
                                                </label>
                                            </td>
                                            
                                            <td>V$<%= sp.getMaSanPham() %></td>

                                            <td>
                                                <div class="admin-product-cell-product">
                                                    <div class="admin-product-thumb">
                                                        <img src="<%= contextPath + "/" + sp.getAnhChinh() %>" alt="<%= sp.getTenSanPham() %>">
                                                    </div>
                                                    <div class="admin-product-name"><%= sp.getTenSanPham() %></div>
                                                </div>
                                            </td>
                                            

                                            <td><%= sp.getTenDanhMuc() != null ? sp.getTenDanhMuc() : "-" %></td>

                                            <td>
                                                <%
                                                    int ton = sp.getTongTonKho();
                                                %>
                                                <% if (ton == 0) { %>
                                                    <span class="stock-out">Hết Hàng</span>
                                                <% } else if (ton < 20) { %>
                                                    <span class="stock-low"><%= ton %> Sắp hết Hàng </span>
                                                <% } else { %>
                                                    <span class="stock-normal"><%= ton %></span>
                                                <% } %>
                                            </td>

                                            <td><%= priceFormat.format(sp.getGiaSanPham()) %>₫</td>

                                            <td>
                                                <% if ("dang_ban".equals(sp.getTrangThai())) { %>
                                                    <span class="admin-product-status-badge published">Đang Bán</span>
                                                <% } else { %>
                                                    <span class="admin-product-status-badge hidden">Ẩn</span>
                                                <% } %>
                                            </td>

                                            <td>
                                                <div class="admin-product-action-menu-wrap">
                                                    <button type="button" class="admin-product-dots-btn">•••</button>
                                                    <div class="admin-product-action-menu">
                                                        <a href="<%= contextPath %>/chi-tiet-san-pham/<%= sp.getMaSanPham() %>">Xem</a>
                                                        <a href="javascript:void(0)"
                                                            class="open-edit-product-btn"
                                                            data-ma-san-pham="<%= sp.getMaSanPham() %>">
                                                            Sửa
                                                         </a>
                                                        <a href="javascript:void(0)"
                                                            class="admin-product-delete-btn danger"
                                                            data-ma-san-pham="<%= sp.getMaSanPham() %>"
                                                            data-ten-san-pham="<%= sp.getTenSanPham() %>">
                                                            Xóa
                                                         </a>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="admin-product-footer">
                        <div class="admin-product-footer-left">
                            <span class="admin-product-result-text">
                                Result <%= startRecord %>-<%= endRecord %> of <%= totalRecords %>
                            </span>

                            <select class="admin-product-page-size" name="size" form="adminProductFilterForm">
                                <option value="10" <%= pageSize == 10 ? "selected" : "" %>>10</option>
                                <option value="20" <%= pageSize == 20 ? "selected" : "" %>>20</option>
                                <option value="30" <%= pageSize == 30 ? "selected" : "" %>>30</option>
                            </select>
                        </div>

                        <div class="admin-product-pagination">
                            <% if (currentPage > 1) { %>
                                <a class="page-nav-btn" href="<%= baseUrl %>?page=<%= currentPage - 1 %><%= paginationQuery %>">← Trước</a>
                            <% } else { %>
                                <span class="page-nav-btn disabled">← Trước</span>
                            <% } %>

                            <%
                                int pageStart = Math.max(1, currentPage - 2);
                                int pageEnd = Math.min(totalPages, currentPage + 2);

                                if (pageStart > 1) {
                            %>
                                <a class="page-number" href="<%= baseUrl %>?page=1<%= paginationQuery %>">1</a>
                                <% if (pageStart > 2) { %>
                                    <span class="page-number dots">…</span>
                                <% } %>
                            <% } %>

                            <% for (int i = pageStart; i <= pageEnd; i++) { %>
                                <a class="page-number <%= i == currentPage ? "active" : "" %>" href="<%= baseUrl %>?page=<%= i %><%= paginationQuery %>"><%= i %></a>
                            <% } %>

                            <% if (pageEnd < totalPages) { %>
                                <% if (pageEnd < totalPages - 1) { %>
                                    <span class="page-number dots">…</span>
                                <% } %>
                                <a class="page-number" href="<%= baseUrl %>?page=<%= totalPages %><%= paginationQuery %>"><%= totalPages %></a>
                            <% } %>

                            <% if (currentPage < totalPages) { %>
                                <a class="page-nav-btn" href="<%= baseUrl %>?page=<%= currentPage + 1 %><%= paginationQuery %>">Tiếp →</a>
                            <% } else { %>
                                <span class="page-nav-btn disabled">Tiếp →</span>
                            <% } %>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </main>
</div>
                        <%@ include file="/WEB-INF/views/admin/product/create.jsp" %>
                        <%@ include file="/WEB-INF/views/admin/product/edit.jsp" %>
                        <%@ include file="/WEB-INF/views/admin/product/delete.jsp" %>
                        
                        <script>
    window.APP_CONTEXT = "${pageContext.request.contextPath}";
</script>
                        

<script src="${pageContext.request.contextPath}/assets/js/admin/admin-product-list.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/admin-delete-product-popup.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/admin-add-product-popup.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/admin-dashboard.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/admin-edit-product-popup.js"></script>
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