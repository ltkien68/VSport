
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="checkout-popup-overlay" id="checkoutPopupOverlay">
    <div class="checkout-popup">
        <button type="button" class="checkout-popup-close" id="closeCheckoutPopup">×</button>

        <div class="checkout-popup-header">
            <p class="checkout-popup-sub">V<span style="color: #D4AF37">$</span>PORT CHECKOUT</p>
            <h2 class="checkout-popup-title">XÁC NHẬN ĐƠN HÀNG</h2>
        </div>

        <form action="${pageContext.request.contextPath}/don_hang/tao" method="post" class="checkout-form">
            <div class="checkout-popup-body">

                <div class="checkout-popup-left">
                    <div class="checkout-card">
                        <h3 class="checkout-card-title">Thông tin người nhận</h3>

                        <div class="checkout-form-grid">
                            <div class="checkout-form-group">
                                <label>Họ tên người nhận</label>
                                <input type="text" name="hoTenNguoiNhan"
                                       value="${nguoiDung.hoTen}" required />
                            </div>

                            <div class="checkout-form-group">
                                <label>Số điện thoại</label>
                                <input type="text" name="soDienThoaiNguoiNhan"
                                       value="${nguoiDung.soDienThoai}" required />
                            </div>
                        </div>

                        <div class="checkout-form-group">
                            <label>Địa chỉ giao hàng</label>
                            <c:choose>
                                <c:when test="${not empty nguoiDung.diaChi}">
                                    <textarea name="diaChiGiaoHang" rows="3" required>${nguoiDung.diaChi}</textarea>
                                    <p class="checkout-note">
                                        Địa chỉ đang lấy từ hồ sơ tài khoản của bạn. Có thể sửa trực tiếp nếu cần.
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <textarea name="diaChiGiaoHang" rows="3"
                                              placeholder="Nhập địa chỉ giao hàng của bạn..." required></textarea>
                                    <p class="checkout-note checkout-note-warning">
                                        Tài khoản của bạn chưa có địa chỉ, vui lòng nhập thủ công.
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="checkout-form-group">
                            <label>Ghi chú</label>
                            <textarea name="ghiChu" rows="2"
                                      placeholder="Ví dụ: giao giờ hành chính, gọi trước khi giao..."></textarea>
                        </div>
                    </div>

                    <div class="checkout-card">
                        <h3 class="checkout-card-title">Phương thức vận chuyển</h3>

                        <div class="checkout-shipping-list" id="shippingMethods">
                            <c:forEach var="vc" items="${dsVanChuyen}" varStatus="loop">
                                <label class="checkout-radio-card">
                                    <input type="radio"
                                           name="shippingPreview"
                                           value="${vc.phiVanChuyen}"
                                           data-ma-ptvc="${vc.maPtvc}"
                                           ${vc.maPtvc == maPtvcDaChon ? 'checked' : ''} />
                                    <span class="checkout-radio-content">
                                        <span class="checkout-radio-top">
                                            <strong>${vc.tenPhuongThuc}</strong>
                                            <span>
                                                <fmt:formatNumber value="${vc.phiVanChuyen}" type="number"/>đ
                                            </span>
                                        </span>
                                        <span class="checkout-radio-sub">
                                            ${vc.thoiGianDuKien}
                                        </span>
                                    </span>
                                </label>
                            </c:forEach>
                        </div>

                        <input type="hidden" name="phiVanChuyen" id="phiVanChuyenInput" value="${phiVanChuyen}" />
                        <input type="hidden" name="maPtvc" id="maPtvcInput"
                               value="${not empty dsVanChuyen ? dsVanChuyen[0].maPtvc : 0}" />

                    </div>

                    <div class="checkout-card">
                        <h3 class="checkout-card-title">Phương thức thanh toán</h3>

                        <div class="checkout-payment-list">

                            <!-- COD -->
                            <label class="checkout-radio-card active" data-payment="cod">

                                <input type="radio"
                                       name="phuongThucThanhToan"
                                       value="cod"
                                       checked />

                                <span class="checkout-radio-content">

                                    <span class="checkout-radio-top">
                                        <strong>Thanh toán khi nhận hàng</strong>
                                    </span>

                                    <span class="checkout-radio-sub">
                                        COD
                                    </span>

                                </span>
                            </label>

                            <!-- QR -->
                            <label class="checkout-radio-card" data-payment="chuyen_khoan">

                                <input type="radio"
                                       name="phuongThucThanhToan"
                                       value="chuyen_khoan" />

                                <span class="checkout-radio-content">

                                    <span class="checkout-radio-top">
                                        <strong>Chuyển khoản</strong>
                                    </span>

                                    <span class="checkout-radio-sub">
                                        Xác nhận thủ công sau khi thanh toán
                                    </span>

                                    <!-- BOX QR -->
                                    <div class="checkout-qr-box">

                                        <img id="vietQrImage"
                                             class="checkout-qr-image"
                                             src=""
                                             alt="QR thanh toán">

                                        <div class="checkout-qr-info">
                                            <p>Ngân hàng: <b>MB Bank</b></p>
                                            <p>Số tài khoản: <b>0333568051111</b></p>
                                            <p>Chủ tài khoản: <b>LE TRUNG KIEN</b></p>
                                            <p>
                                                Nội dung:
                                                <b id="vietQrContent">VSPORT</b>
                                            </p>
                                        </div>

                                        <p class="checkout-qr-note">
                                            Sau khi chuyển khoản, đơn hàng sẽ chờ admin xác nhận thanh toán.
                                        </p>

                                    </div>

                                </span>
                            </label>

                        </div>
                    </div>
                </div>

                <div class="checkout-popup-right">
                    <div class="checkout-card">
                        <h3 class="checkout-card-title">Mã giảm giá</h3>

                        <div class="checkout-coupon-row">
                            <select name="maGiamGia" id="maGiamGiaSelect" class="checkout-voucher-select">
                                <option value="">Chọn mã giảm giá</option>

                                <c:forEach var="ma" items="${dsMaGiamGiaKhaDung}">
                                    <option 
                                        value="${ma.maGiamGia}"
                                        data-code="${ma.maGiamGia}"
                                        data-ten="${ma.tenMa}"
                                        data-loai="${ma.loaiGiam}"
                                        data-gia-tri="${ma.giaTriGiam}"
                                        data-dieu-kien="${ma.dieuKienToiThieu}"
                                        data-giam-toi-da="${ma.giamToiDa}"
                                        ${ma.maGiamGia == maGiamGiaDaChon ? 'selected' : ''}>
                                        ${ma.maGiamGia} - ${ma.tenMa}
                                    </option>
                                </c:forEach>
                            </select>

                            <button type="button" class="checkout-apply-btn" id="applyCouponBtn">
                                Áp dụng
                            </button>
                            <div id="voucherSelectedInfo" class="checkout-voucher-info"></div>
                        </div>

                        <c:if test="${not empty couponResult}">
                            <p class="checkout-coupon-message ${couponResult.hopLe ? 'success' : 'error'}">
                                ${couponResult.thongBao}
                            </p>
                        </c:if>
                    </div>

                    <div class="checkout-card">
                        <h3 class="checkout-card-title">Sản phẩm trong đơn</h3>

                        <div class="checkout-order-items">
                            <c:forEach var="item" items="${dsGioHang}">
                                <div class="checkout-order-item">
                                    <div class="checkout-order-item-left">
                                        <img src="${pageContext.request.contextPath}/${item.anhChinh}" alt="${item.tenSanPham}" />
                                        <div>
                                            <p class="checkout-item-name">${item.tenSanPham}</p>
                                            <p class="checkout-item-sub">Số lượng: ${item.soLuong}</p>
                                        </div>
                                    </div>

                                    <div class="checkout-order-item-right">
                                        <fmt:formatNumber value="${item.donGia * item.soLuong}" type="number"/>đ
                                    </div>
                                </div>

                                <c:if test="${not empty item.dsQuaTang}">
                                    <c:forEach var="gift" items="${item.dsQuaTang}">
                                        <div class="checkout-gift-inline">
                                            <div class="checkout-gift-product">
                                                <img class="checkout-gift-thumb"
                                                     src="${pageContext.request.contextPath}/${gift.anhChinh}"
                                                     alt="${gift.tenSanPham}" />

                                                <div class="checkout-gift-info">
                                                    <p class="checkout-gift-name">
                                                        <span class="checkout-gift-label">Quà Tặng</span>
                                                        ${gift.tenSanPham}
                                                    </p>
                                                    <p class="checkout-gift-shop">Được tặng kèm theo sản phẩm</p>
                                                </div>
                                            </div>

                                            <div class="checkout-gift-qty">
                                                ${gift.soLuong}
                                            </div>

                                            <div class="checkout-gift-price">
                                                0đ
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="checkout-card checkout-summary-card">
                        <h3 class="checkout-card-title">Tổng thanh toán</h3>

                        <div class="checkout-summary-row">
                            <span>Tạm tính</span>
                            <strong><fmt:formatNumber value="${tongTienHang}" type="number"/>đ</strong>
                        </div>

                        <div class="checkout-summary-row">
                            <span>Phí vận chuyển</span>
                            <strong id="shippingFeePreview"><fmt:formatNumber value="${phiVanChuyen}" type="number"/>đ</strong>
                        </div>

                        <div class="checkout-summary-row discount">
                            <span>Giảm giá</span>
                            <strong id="discountPreview">- <fmt:formatNumber value="${giamGia}" type="number"/>đ</strong>
                        </div>

                        <input type="hidden"
                               id="tongThanhToanFinal"
                               value="${tongThanhToan}" />

                        <div class="checkout-summary-row total">
                            <span>Tổng cộng</span>
                            <strong id="totalPreview"><fmt:formatNumber value="${tongThanhToan}" type="number"/>đ</strong>
                        </div>

                        <input type="hidden" name="maGiamGiaApplied" id="maGiamGiaApplied" value="${maGiamGiaDaChon}" />

                        <button type="submit" class="checkout-submit-btn">
                            XÁC NHẬN ĐẶT HÀNG
                        </button>
                    </div>
                </div>

            </div>
        </form>
    </div>
</div>