<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.SanPham" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    List<SanPham> dsSanPham = (List<SanPham>) request.getAttribute("dsSanPham");
    if (dsSanPham == null) {
        dsSanPham = new ArrayList<>();
    }

    List<SanPham> dsQuaTang = (List<SanPham>) request.getAttribute("dsQuaTang");
    if (dsQuaTang == null) {
        dsQuaTang = new ArrayList<>();
    }

    DecimalFormat priceFormat = new DecimalFormat("#,###");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý quà tặng | Admin</title>

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/reset.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/fonts.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-qua-tang.css">
    </head>

    <body>
        <div class="admin-shell">

            <%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

            <main class="admin-main">
                <div class="admin-gift-page">
                    <div class="admin-gift-shell">

                        <div class="admin-gift-topbar">
                            <form class="admin-gift-top-search" action="<%= contextPath%>/admin/qua-tang" method="get">
                                <input type="text" name="keyword" placeholder="Search">
                                <button type="submit" aria-label="Search">
                                    <svg viewBox="0 0 24 24" fill="none">
                                    <path d="M21 21L16.65 16.65M18 11C18 14.866 14.866 18 11 18C7.13401 18 4 14.866 4 11C4 7.13401 7.13401 4 11 4C14.866 4 18 7.13401 18 11Z"
                                          stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                                    </svg>
                                </button>
                            </form>

                            <div class="admin-gift-top-icons">
                                <button type="button" class="admin-gift-top-icon-btn">
                                    <i data-lucide="bell"></i>
                                </button>
                                <button type="button" class="admin-gift-top-icon-btn">
                                    <i data-lucide="mail"></i>
                                </button>
                            </div>
                        </div>

                        <div class="admin-gift-header">
                            <div>
                                <h1 class="admin-gift-title">Quản Lý Quà Tặng</h1>
                                <p class="admin-gift-subtitle">Chọn sản phẩm thường và quản lý danh sách sản phẩm quà tặng.</p>
                            </div>

                            <!-- BUTTON -->
                            <button type="button"
                                    class="admin-gift-btn admin-gift-btn-primary"
                                    id="openGiftPopupBtn">

                                <span>＋</span>
                                <span>Thêm Quà Tặng</span>
                            </button>

                            <!-- POPUP -->
                            <div class="gift-popup-overlay" id="giftPopup">

                                <div class="gift-popup-box">

                                    <!-- HEADER -->
                                    <div class="gift-popup-header">
                                        <h2>Tạo Liên Kết Quà Tặng</h2>

                                        <button type="button"
                                                class="gift-popup-close"
                                                id="closeGiftPopupBtn">
                                            ×
                                        </button>
                                    </div>

                                    <!-- FORM -->
                                    <form action="${pageContext.request.contextPath}/admin/qua-tang/them-qua-tang"
                                          method="post"
                                          class="gift-popup-form">

                                        <!-- SẢN PHẨM CHÍNH -->
                                        <div class="gift-form-group">
                                            <label>Sản phẩm chính</label>

                                            <select name="maSanPhamChinh" required>
                                                <option value="">-- Chọn sản phẩm --</option>

                                                <c:forEach var="sp" items="${dsSanPham}">
                                                    <option value="${sp.maSanPham}">
                                                        ${sp.tenSanPham}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- QUÀ TẶNG -->
                                        <div class="gift-form-group">
                                            <label>Sản phẩm quà tặng</label>

                                            <select name="maSanPhamQua" id="giftProductSelect" required>
                                                <option value="">-- Chọn quà tặng --</option>

                                                <c:forEach var="q" items="${dsQuaTang}">
                                                    <option value="${q.maSanPham}">
                                                        ${q.tenSanPham}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- BIẾN THỂ -->
                                        <div class="gift-form-group">
                                            <label>Biến thể quà</label>

                                            <select name="maBienTheQua" id="giftVariantSelect">
                                                <option value="0">Không có size</option>
                                            </select>
                                        </div>

                                        <!-- SỐ LƯỢNG -->
                                        <div class="gift-form-group">
                                            <label>Số lượng quà</label>

                                            <input type="number"
                                                   name="soLuongQua"
                                                   min="1"
                                                   value="1"
                                                   required>
                                        </div>

                                        <!-- ACTION -->
                                        <div class="gift-popup-actions">

                                            <button type="button"
                                                    class="admin-gift-btn admin-gift-btn-cancel"
                                                    id="cancelGiftPopupBtn">
                                                Hủy
                                            </button>

                                            <button type="submit"
                                                    class="admin-gift-btn admin-gift-btn-primary">
                                                Tạo Quà Tặng
                                            </button>

                                        </div>
                                    </form>

                                </div>
                            </div>
                        </div>

                        <!-- LIST SẢN PHẨM -->
                        <div class="admin-gift-card admin-gift-card-short">
                            <div class="admin-gift-card-head">
                                <div>
                                    <h2>Danh sách sản phẩm</h2>
                                    <p>Sản phẩm có thể chọn làm quà tặng</p>
                                </div>
                                <span class="admin-gift-count"><%= dsSanPham.size()%> sản phẩm</span>
                            </div>

                            <div class="admin-gift-table-wrap">
                                <table class="admin-gift-table">
                                    <thead>
                                        <tr>
                                            <th>Mã</th>
                                            <th>Sản phẩm</th>
                                            <th>Giá</th>
                                            <th>Nhóm</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <% if (dsSanPham.isEmpty()) { %>
                                        <tr>
                                            <td colspan="5" class="admin-gift-empty-cell">
                                                Không có sản phẩm nào
                                            </td>
                                        </tr>
                                        <% } else { %>
                                        <% for (SanPham sp : dsSanPham) {%>
                                        <tr>
                                            <td>V$<%= sp.getMaSanPham()%></td>

                                            <td>
                                                <div class="admin-gift-product-cell">
                                                    <div class="admin-gift-thumb">
                                                        <img src="<%= contextPath + "/" + sp.getAnhChinh()%>"
                                                             alt="<%= sp.getTenSanPham()%>">
                                                    </div>
                                                    <div class="admin-gift-name">
                                                        <%= sp.getTenSanPham()%>
                                                    </div>
                                                </div>
                                            </td>

                                            <td><%= priceFormat.format(sp.getGiaSanPham())%>₫</td>

                                            <td>
                                                <span class="admin-gift-group-badge">
                                                    <%= sp.getTenNhomSanPham()%>
                                                </span>
                                            </td>

                                            <td>
                                                <a class="admin-gift-action-link"
                                                   href="<%= contextPath%>/admin/qua-tang/them?maSanPham=<%= sp.getMaSanPham()%>">
                                                    Chọn
                                                </a>
                                            </td>
                                        </tr>
                                        <% } %>
                                        <% }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- LIST QUÀ TẶNG -->
                        <div class="admin-gift-card admin-gift-card-short">
                            <div class="admin-gift-card-head">
                                <div>
                                    <h2>Danh sách quà tặng</h2>
                                    <p>Chỉ hiển thị sản phẩm có nhóm sản phẩm bằng 5</p>
                                </div>
                                <span class="admin-gift-count"><%= dsQuaTang.size()%> quà tặng</span>
                            </div>

                            <div class="admin-gift-table-wrap">
                                <table class="admin-gift-table">
                                    <thead>
                                        <tr>
                                            <th>Mã</th>
                                            <th>Quà tặng</th>
                                            <th>Giá</th>
                                            <th>Nhóm</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <% if (dsQuaTang.isEmpty()) { %>
                                        <tr>
                                            <td colspan="5" class="admin-gift-empty-cell">
                                                Chưa có sản phẩm quà tặng
                                            </td>
                                        </tr>
                                        <% } else { %>
                                        <% for (SanPham sp : dsQuaTang) {%>
                                        <tr>
                                            <td>V$<%= sp.getMaSanPham()%></td>

                                            <td>
                                                <div class="admin-gift-product-cell">
                                                    <div class="admin-gift-thumb gift">
                                                        <img src="<%= contextPath + "/" + sp.getAnhChinh()%>"
                                                             alt="<%= sp.getTenSanPham()%>">
                                                    </div>
                                                    <div class="admin-gift-name">
                                                        <%= sp.getTenSanPham()%>
                                                    </div>
                                                </div>
                                            </td>

                                            <td><%= priceFormat.format(sp.getGiaSanPham())%>₫</td>

                                            <td>
                                                <span class="admin-gift-status-badge">Quà tặng</span>
                                            </td>

                                            <td>
                                                <a class="admin-gift-action-link danger"
                                                   href="<%= contextPath%>/admin/qua-tang/xoa?maSanPham=<%= sp.getMaSanPham()%>">
                                                    Xóa
                                                </a>
                                            </td>
                                        </tr>
                                        <% } %>
                                        <% }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div>
                </div>
            </main>
        </div>

        <script src="https://unpkg.com/lucide@latest"></script>
        <script>
            lucide.createIcons();
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/admin/admin-qua-tang.js"></script>
    </body>
</html>