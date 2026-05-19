// /assets/js/components/tra-hang-popup.js
document.addEventListener('DOMContentLoaded', function () {
    (function () {
        console.log('=== Khởi tạo modal trả hàng ===');

        const modal = document.getElementById('traHangModal');
        if (!modal || modal.dataset.initialized === 'true') return;
        modal.dataset.initialized = 'true';

        const closeBtn = document.getElementById('closeTraHangModal');
        const cancelBtn = document.getElementById('cancelTraHang');
        const form = document.getElementById('traHangForm');
        const btnTaoYeuCau = document.getElementById('btnTaoYeuCau');
        const maDonHangInput = document.getElementById('maDonHangTraHang');
        const lyDoSelect = document.getElementById('lyDoTraHang');
        const soTienInput = document.getElementById('soTienHoan');
        const soTienDisplay = document.getElementById('soTienHoanDisplay');
        const ghiChuInput = document.getElementById('ghiChuTraHang');

        if (!closeBtn || !cancelBtn || !form || !btnTaoYeuCau || !maDonHangInput || !lyDoSelect || !soTienInput || !soTienDisplay || !ghiChuInput) {
            console.error('❌ Thiếu elements');
            return;
        }

        console.log('✅ Tất cả elements OK');

        // Format tiền VNĐ
        function formatCurrency(amount) {
            if (!amount) return '0 ₫';
            return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
        }

        // Kiểm tra form hợp lệ (chỉ cần chọn lý do)
        function checkFormValidity() {
            const lyDo = lyDoSelect.value;
            btnTaoYeuCau.disabled = !lyDo;
        }

        lyDoSelect.addEventListener('change', checkFormValidity);

        // Hàm mở modal
        window.openTraHangModal = function (maDonHang, tongTien) {
            console.log('🚀 Mở modal cho đơn:', maDonHang, 'Tổng tiền:', tongTien);
            maDonHangInput.value = maDonHang;
            form.reset();
            maDonHangInput.value = maDonHang;

            // Set tổng tiền
            soTienInput.value = tongTien || 0;
            soTienDisplay.value = formatCurrency(tongTien);

            btnTaoYeuCau.disabled = true; // Phải chọn lý do mới enable
            modal.classList.add('show');
        };

        // Bắt sự kiện click nút trả hàng
        document.addEventListener('click', function (e) {
            const btn = e.target.closest('.btn-tra-hang');
            if (btn) {
                e.preventDefault();
                e.stopPropagation();
                const maDonHang = btn.getAttribute('data-ma-don-hang');
                const tongTien = btn.getAttribute('data-tong-tien');
                if (maDonHang) {
                    window.openTraHangModal(maDonHang, tongTien);
                }
            }
        });

        // Đóng modal
        function closeModal() {
            modal.classList.remove('show');
        }

        closeBtn.addEventListener('click', closeModal);
        cancelBtn.addEventListener('click', closeModal);
        modal.addEventListener('click', function (e) {
            if (e.target === modal) closeModal();
        });

        // Gửi form
        form.addEventListener('submit', function (e) {
            e.preventDefault();

            const maDonHang = maDonHangInput.value;
            const lyDo = lyDoSelect.value;
            const soTienHoan = soTienInput.value;
            const ghiChu = ghiChuInput.value;

            if (!lyDo) {
                toastr.warning('Vui lòng chọn lý do trả hàng.');
                return;
            }

            btnTaoYeuCau.disabled = true;
            btnTaoYeuCau.textContent = 'Đang xử lý...';

            const url = (window.contextPath || '') + '/tra-hang';

            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: new URLSearchParams({
                    action: 'yeu_cau',
                    maDonHang: maDonHang,
                    lyDo: lyDo,
                    soTienHoan: soTienHoan,
                    ghiChu: ghiChu
                })
            })
            .then(response => {
                if (!response.ok) {
                    // Thử parse JSON từ response lỗi để lấy message
                    return response.json().then(err => {
                        throw new Error(err.message || 'Lỗi máy chủ');
                    }).catch(() => {
                        throw new Error('Lỗi máy chủ (HTTP ' + response.status + ')');
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    toastr.success(data.message || 'Yêu cầu trả hàng đã được gửi thành công!');
                    closeModal();
                    setTimeout(() => location.reload(), 1500);
                } else {
                    toastr.error(data.message || 'Không thể tạo yêu cầu.');
                }
            })
            .catch(error => {
                console.error('Lỗi:', error);
                toastr.error(error.message || 'Đã xảy ra lỗi không xác định.');
            })
            .finally(() => {
                btnTaoYeuCau.disabled = false;
                btnTaoYeuCau.textContent = 'Tạo yêu cầu';
            });
        });

        console.log('✅ Modal trả hàng sẵn sàng');
    })();
});