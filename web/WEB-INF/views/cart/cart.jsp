<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.GioHang" %>
<%@ page import="model.GioHangSum" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    List<GioHang> dsGioHang = (List<GioHang>) request.getAttribute("dsGioHang");
    GioHangSum tongQuan = (GioHangSum) request.getAttribute("tongQuan");

    boolean isEmptyCart = (dsGioHang == null || dsGioHang.isEmpty());
    int tongMatHangCart = tongQuan != null ? tongQuan.getTongMatHang() : 0;
    double tongTienCart = tongQuan != null ? tongQuan.getTongGiaTriSanPham() : 0;
    double tongCongCart = tongQuan != null ? tongQuan.getTongCong() : 0;
%>

<%
    String checkoutSuccess = (String) session.getAttribute("checkoutSuccess");

    if (checkoutSuccess != null) {
        request.setAttribute("checkoutSuccess", checkoutSuccess);
        session.removeAttribute("checkoutSuccess");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp" />
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo.png">
    
    <title>Giỏ hàng | VSport</title>
    
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
<body>
    <div class="header-shell">
        <%@ include file="/WEB-INF/views/common/header.jsp" %>
        <%@ include file="/WEB-INF/views/common/navbar.jsp" %>
    </div>

    <main class="cart-page">
        <div class="cart-container">
            <% if (isEmptyCart) { %>
            <div class="cart-empty-page">
                <section class="cart-empty">
                    <h1 class="cart-empty-title">TÚI CỦA BẠN TRỐNG</h1>
                    <p class="cart-empty-text">
                        Khi bạn thêm sản phẩm vào giỏ hàng, sản phẩm đó sẽ hiển thị ở đây. Sẵn sàng mua sắm nào!
                    </p>

                    <a href="${pageContext.request.contextPath}/trang_chu" class="cart-empty-btn">
                        <span>Sẵn sàng</span>
                        <span class="cart-btn-arrow">→</span>
                    </a>
                </section>
                        <section class="cart-empty-right">
                            <img src="${pageContext.request.contextPath}/assets/images/others/yildiz.webp" alt="yildiz" class="cart-empty-right-img"/>
                        </section>
            </div>
            <% } else { %>
                <section class="cart-layout">
                    <div class="cart-left">
                        <div class="cart-heading-row">
                            <h1 class="cart-title">GIỎ HÀNG CỦA BẠN</h1>
                            <span class="cart-count-page">(<%= tongMatHangCart %> các sản phẩm)</span>
                        </div>

                        <p class="cart-note">
                            Các mặt hàng trong giỏ hàng của bạn không được bảo lưu — hãy kiểm tra ngay để đặt hàng.
                        </p>

                        <div class="cart-list">
                            <% for (GioHang item : dsGioHang) { 
                                double thanhTien = item.getSoLuong() * item.getDonGia();
                            %>
                                <div class="cart-item">
                                    <div class="cart-item-image">
                                        <img src="${pageContext.request.contextPath}/<%= item.getAnhChinh() %>"
                                             alt="<%= item.getTenSanPham() %>">
                                    </div>

                                    <div class="cart-item-content">
                                        <div class="cart-item-top">
                                            <div class="cart-item-info">
                                                <h3 class="cart-item-name"><%= item.getTenSanPham() %></h3>
                                                <div class="cart-item-color"><%= item.getMauSac() %></div>
                                                <div class="cart-item-size">Kích cỡ: <%= item.getTenSize() %></div>
                                            </div>

                                            <form action="${pageContext.request.contextPath}/gio_hang/xoa" method="post" class="cart-remove-form">
                                                <input type="hidden" name="maBienThe" value="<%= item.getMaBienThe() %>">
                                                <button type="submit" class="cart-remove-btn" title="Xóa khỏi giỏ">
                                                    <i data-lucide="trash"></i>
                                                </button>
                                            </form>
                                        </div>

                                        <div class="cart-item-bottom">
                                            <div class="cart-item-qty-wrap">
                                                <form action="${pageContext.request.contextPath}/gio_hang/cap_nhat_so_luong"
                                                      method="post"
                                                      class="cart-qty-form">
                                                    <input type="hidden" name="maGioHang" value="<%= item.getMaGioHang() %>">

                                                    <select name="soLuong" class="cart-item-qty" onchange="this.form.submit()">
                                                        <% for (int i = 1; i <= 20; i++) { %>
                                                            <option value="<%= i %>" <%= i == item.getSoLuong() ? "selected" : "" %>>
                                                                <%= i %>
                                                            </option>
                                                        <% } %>
                                                    </select>
                                                </form>
                                            </div>

                                            <div class="cart-item-price">
                                                <%= String.format("%,.0f", thanhTien) %>đ
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <aside class="cart-right">
                        <h2 class="cart-summary-title">TÓM TẮT ĐƠN HÀNG</h2>

                        <div class="cart-summary-line">
                            <span><%= tongMatHang %> các sản phẩm</span>
                            <strong><%= String.format("%,.0f", tongTienCart) %>đ</strong>
                        </div>

                        <div class="cart-summary-line">
                            <span>Giao hàng</span>
                            <strong>Miễn phí</strong>
                        </div>

                        <div class="cart-summary-total">
                            <div class="cart-summary-line cart-summary-total-line">
                                <span>Tổng</span>
                                <strong><%= String.format("%,.0f", tongCongCart) %>đ</strong>
                            </div>
                            <div class="cart-summary-tax">(Đã bao gồm thuế)</div>
                        </div>
                            
                        <button href="#" class="cart-coupon-btn">
                            <span>THÊM MÃ GIẢM GIÁ</span>
                        </button>
                            
                        <button type="button" class="cart-checkout-btn" id="openCheckoutPopupBtn">
                            <span>THANH TOÁN</span>
                            <span class="cart-btn-arrow">→</span>
                        </button>
                            
                            <div id="checkoutPopupRoot"></div>
                    </aside>
                </section>
            <% } %>
        </div>
    </main>
        
        <c:if test="${not empty checkoutSuccess}">
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    if (window.toastr) {
                        toastr.success("${checkoutSuccess}");
                    }
                });
            </script>
        </c:if>
        
        <script src="https://unpkg.com/lucide@latest"></script>
        <script>
          lucide.createIcons();
        </script>

        
        <script>
            window.contextPath = "${pageContext.request.contextPath}";
        </script>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    
    <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/components/checkout-popup.js"></script>
    
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