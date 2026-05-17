<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.GioHang"%>
<%@page import="model.GioHangSum"%>
<%@page import="model.SanPham"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    GioHang item = (GioHang) request.getAttribute("popupItem");
    GioHangSum summary = (GioHangSum) request.getAttribute("cartSummary");
    List<SanPham> goiYList = (List<SanPham>) request.getAttribute("goiYList");

    String ctx = request.getContextPath();
%>

<div class="cart-popup-overlay active" id="cartPopupOverlay">
    <div class="cart-popup-modal" id="cartPopupModal">
        <button type="button" class="cart-popup-close" id="cartPopupClose" aria-label="Đóng">
            ×
        </button>

        <div class="cart-popup-header">
            ĐÃ THÊM VÀO GIỎ!
        </div>

        <div class="cart-popup-main">
            <div class="cart-popup-left">
                <div class="cart-popup-product">
                    <div class="cart-popup-product-image">
                        <img src="<%= ctx%>/<%= item != null && item.getAnhChinh() != null ? item.getAnhChinh() : "assets/images/no-image.png"%>"
                             alt="<%= item != null ? item.getTenSanPham() : "Sản phẩm"%>">
                    </div>

                    <div class="cart-popup-product-info">
                        <h3 class="cart-popup-product-name">
                            <%= item != null ? item.getTenSanPham() : ""%>
                        </h3>

                        <div class="cart-popup-product-price">
                            <%= item != null ? String.format("%,.0f", item.getDonGia()) : "0"%>₫
                        </div>

                        <div class="cart-popup-product-meta">
                            <div>Colour: <%= item != null && item.getMauSac() != null ? item.getMauSac() : "Mặc định"%></div>
                            <div>Kích cỡ: <%= item != null && item.getTenSize() != null ? item.getTenSize() : ""%></div>
                            <div>Số lượng: <%= item != null ? item.getSoLuong() : 1%></div>

                            <% if (item != null && "1".equals(item.getNhomSanPham())) { %>
                            <p class="cart-popup-print">
                                Nội dung in:
                                <span>
                                    <%
                                        boolean coTenIn = item.getTenInAo() != null && !item.getTenInAo().isBlank();
                                        boolean coSoIn = item.getSoInAo() != null && !item.getSoInAo().isBlank();

                                        if (coTenIn || coSoIn) {
                                            out.print((coTenIn ? item.getTenInAo() : ""));
                                            if (coTenIn && coSoIn) {
                                                out.print(" - ");
                                            }
                                            out.print((coSoIn ? item.getSoInAo() : ""));
                                        } else {
                                            out.print("Không in");
                                        }
                                    %>
                                </span>
                            </p>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <div class="cart-popup-right">
                <div class="cart-popup-cart-title">GIỎ HÀNG CỦA BẠN</div>

                <div class="cart-popup-cart-line">
                    <span><%= summary != null ? summary.getTongMatHang() : 0%> mặt hàng</span>
                    <span></span>
                </div>

                <div class="cart-popup-cart-line">
                    <span>Tổng Giá Trị Sản Phẩm:</span>
                    <strong><%= summary != null ? String.format("%,.0f", summary.getTongGiaTriSanPham()) : "0"%>₫</strong>
                </div>

                <div class="cart-popup-cart-line">
                    <span>Tổng Phí Giao Hàng:</span>
                    <strong><%= summary != null && summary.getPhiGiaoHang() <= 0 ? "Miễn phí" : String.format("%,.0f₫", summary.getPhiGiaoHang())%></strong>
                </div>

                <div class="cart-popup-cart-total">
                    <div class="cart-popup-cart-line cart-popup-total-line">
                        <span>Tổng cộng:</span>
                        <strong><%= summary != null ? String.format("%,.0f", summary.getTongCong()) : "0"%>₫</strong>
                    </div>
                    <div class="cart-popup-tax-note">(Đã bao gồm thuế)</div>
                </div>

                <div class="cart-popup-member-note">
                    Hội viên được miễn phí vận chuyển không giới hạn
                </div>

                <a href="#" class="cart-popup-btn cart-popup-btn-primary">
                    <span>Tham gia miễn phí</span>
                    <span class="cart-popup-btn-arrow">→</span>
                </a>

                <a href="${pageContext.request.contextPath}/gio_hang" class="cart-popup-btn cart-popup-btn-secondary">
                    <span>Xem lại giỏ hàng</span>
                    <span class="cart-popup-btn-arrow">→</span>
                </a>
            </div>
        </div>

        <div class="cart-popup-divider"></div>

        <div class="cart-popup-suggest">
            <div class="cart-popup-suggest-title">Các sản phẩm dễ phối cùng</div>

            <div class="cart-popup-suggest-list">
                <% if (goiYList != null && !goiYList.isEmpty()) { %>
                <% for (SanPham sp : goiYList) {%>
                <a class="cart-popup-suggest-card tilt-card"
                   href="<%= ctx%>/chi-tiet-san-pham/<%= sp.getMaSanPham()%>">
                    <img src="<%= ctx%>/<%= sp.getAnhChinh() != null ? sp.getAnhChinh() : "assets/images/no-image.png"%>"
                         alt="<%= sp.getTenSanPham()%>">
                </a>
                <% } %>
                <% } else { %>
                <div class="cart-popup-suggest-empty">Chưa có sản phẩm gợi ý.</div>
                <% }%>
            </div>
        </div>
    </div>
</div>