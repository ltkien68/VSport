<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<div id="traHangModal" class="tra-hang-modal">
    <div class="tra-hang-box">
        <div class="tra-hang-header">
            <h3>Yêu cầu trả hàng / hoàn tiền</h3>
            <button type="button" class="tra-hang-close" id="closeTraHangModal">&times;</button>
        </div>
        <div class="tra-hang-body">
            <form id="traHangForm">
                <input type="hidden" id="maDonHangTraHang" name="maDonHang">
                <input type="hidden" id="soTienHoan" name="soTienHoan">

                <div class="form-group">
                    <label for="lyDoTraHang">Lý do trả hàng <span class="required">*</span></label>
                    <select id="lyDoTraHang" name="lyDo" class="form-control" required>
                        <option value="">-- Chọn lý do --</option>
                        <option value="het_nhu_cau">Hết nhu cầu</option>
                        <option value="hang_hong">Hàng hỏng</option>
                        <option value="that_lac">Thất lạc</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="soTienHoanDisplay">Số tiền hoàn <span class="required">*</span></label>
                    <input type="text" id="soTienHoanDisplay" class="form-control"
                           readonly placeholder="Tự động từ tổng đơn hàng">
                </div>

                <div class="form-group">
                    <label for="ghiChuTraHang">Ghi chú</label>
                    <textarea id="ghiChuTraHang" name="ghiChu" class="form-control" rows="3"
                              placeholder="Nhập ghi chú nếu có..."></textarea>
                </div>

                <div class="tra-hang-actions">
                    <button type="button" class="tra-hang-btn tra-hang-btn-secondary" id="cancelTraHang">Hủy</button>
                    <button type="submit" class="tra-hang-btn tra-hang-btn-primary" id="btnTaoYeuCau">
                        Tạo yêu cầu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>