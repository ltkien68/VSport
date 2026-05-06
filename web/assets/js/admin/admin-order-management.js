document.addEventListener("DOMContentLoaded", function () {
    const approveButtons = document.querySelectorAll(
            ".btn-duyet-don, .btn-xac-nhan-thanh-toan"
            );

    const toggleButtons = document.querySelectorAll(".btn-toggle-history-detail");
    const historyRows = document.querySelectorAll(".history-row-toggle");
    const orderCards = document.querySelectorAll(".admin-order-card");

    approveButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            const maDonHang = this.dataset.maDonHang;
            const action = this.dataset.action || "duyet_don";

            let confirmMessage = "Duyệt đơn #" + maDonHang + " ?";
            let confirmTitle = "Duyệt đơn hàng";

            if (action === "xac_nhan_thanh_toan") {
                confirmTitle = "Xác nhận thanh toán";
                confirmMessage = "Xác nhận đã nhận thanh toán cho đơn #" + maDonHang + " ?";
            }

            showAdminConfirm({
                title: confirmTitle,
                message: confirmMessage,
                onConfirm: function () {
                    xuLyDonHang(maDonHang, action);
                }
            });
        });
    });

    toggleButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            const targetId = this.dataset.target;
            const panel = document.getElementById(targetId);

            if (!panel) {
                return;
            }

            panel.classList.toggle("open");
        });
    });

    historyRows.forEach(function (row) {
        row.addEventListener("click", function () {
            const targetId = this.dataset.target;
            const detailRow = document.getElementById(targetId);

            if (!detailRow) {
                return;
            }

            detailRow.classList.toggle("open");
        });
    });

    function formatDuration(ms) {
        if (ms <= 0) {
            return "00d 00h 00m 00s";
        }

        let totalSeconds = Math.floor(ms / 1000);

        const days = Math.floor(totalSeconds / 86400);
        totalSeconds %= 86400;

        const hours = Math.floor(totalSeconds / 3600);
        totalSeconds %= 3600;

        const minutes = Math.floor(totalSeconds / 60);
        const seconds = totalSeconds % 60;

        return (
                String(days).padStart(2, "0") + "d "
                + String(hours).padStart(2, "0") + "h "
                + String(minutes).padStart(2, "0") + "m "
                + String(seconds).padStart(2, "0") + "s"
                );
    }

    function updateCountdowns() {
        const now = Date.now();

        orderCards.forEach(function (card) {
            const orderStatus = card.dataset.orderStatus;
            const paymentStatus = card.dataset.paymentStatus;

            const ngayDat = parseInt(card.dataset.ngayDat || "0", 10);
            const ngayXacNhan = parseInt(card.dataset.ngayXacNhan || "0", 10);
            const ngayBatDauGiao = parseInt(card.dataset.ngayBatDauGiao || "0", 10);
            const ngayDaGiao = parseInt(card.dataset.ngayDaGiao || "0", 10);

            const countdownEl = card.querySelector(".js-countdown");
            const subEl = card.querySelector(".js-countdown-sub");

            if (!countdownEl || !subEl) {
                return;
            }

            if (
                    orderStatus === "cho_xac_nhan"
                    && paymentStatus === "cho_xac_nhan"
                    ) {
                countdownEl.textContent = "Chờ thanh toán";
                subEl.textContent = "Đơn chuyển khoản đang chờ admin xác nhận thanh toán";
                return;
            }

            if (orderStatus === "cho_xac_nhan") {
                if (!ngayDat) {
                    countdownEl.textContent = "--";
                    subEl.textContent = "Thiếu mốc ngày đặt";
                    return;
                }

                const target = ngayDat + 2 * 60 * 1000;
                const diff = target - now;

                if (diff > 0) {
                    countdownEl.textContent = formatDuration(diff);
                    subEl.textContent = "Còn lại để tự chuyển sang chờ lấy hàng nếu chưa được duyệt";
                } else {
                    countdownEl.textContent = "Đến hạn";
                    subEl.textContent = "Đang chờ backend chuyển sang chờ lấy hàng";
                }

                return;
            }

            if (orderStatus === "cho_lay_hang") {
                if (!ngayXacNhan) {
                    countdownEl.textContent = "--";
                    subEl.textContent = "Thiếu mốc xác nhận";
                    return;
                }

                const target = ngayXacNhan + 2 * 60 * 1000;
                const diff = target - now;

                if (diff > 0) {
                    countdownEl.textContent = formatDuration(diff);
                    subEl.textContent = "Còn lại để tự chuyển sang đang giao";
                } else {
                    countdownEl.textContent = "Đến hạn";
                    subEl.textContent = "Đang chờ backend chuyển sang đang giao";
                }

                return;
            }

            if (orderStatus === "dang_giao") {
                if (!ngayBatDauGiao) {
                    countdownEl.textContent = "--";
                    subEl.textContent = "Thiếu mốc bắt đầu giao";
                    return;
                }

                const target = ngayBatDauGiao + 2 * 60 * 1000;
                const diff = target - now;

                if (diff > 0) {
                    countdownEl.textContent = formatDuration(diff);
                    subEl.textContent = "Còn lại để tự chuyển sang đã giao";
                } else {
                    countdownEl.textContent = "Đến hạn";
                    subEl.textContent = "Đang chờ backend chuyển sang đã giao";
                }

                return;
            }

            if (orderStatus === "da_giao" && paymentStatus === "chua_thanh_toan") {
                if (!ngayDaGiao) {
                    countdownEl.textContent = "Đã giao";
                    subEl.textContent = "Đơn đang chờ cập nhật thanh toán";
                    return;
                }

                const target = ngayDaGiao + 1 * 60 * 1000;
                const diff = target - now;

                if (diff > 0) {
                    countdownEl.textContent = formatDuration(diff);
                    subEl.textContent = "Còn lại để COD tự chuyển sang đã thanh toán";
                } else {
                    countdownEl.textContent = "Đến hạn";
                    subEl.textContent = "Đang chờ backend cập nhật thanh toán";
                }

                return;
            }

            if (orderStatus === "da_giao" && paymentStatus === "da_thanh_toan") {
                countdownEl.textContent = "Hoàn tất";
                subEl.textContent = "Đơn đã giao và đã thanh toán";
                return;
            }

            if (orderStatus === "da_huy") {
                countdownEl.textContent = "Đã hủy";
                subEl.textContent = "Đơn hàng đã bị hủy";
                return;
            }

            countdownEl.textContent = "--";
            subEl.textContent = "Không có dữ liệu tiến trình";
        });
    }

    function showAdminConfirm(options) {
        const overlay = document.getElementById("adminConfirmOverlay");
        const titleEl = document.getElementById("adminConfirmTitle");
        const messageEl = document.getElementById("adminConfirmMessage");
        const cancelBtn = document.getElementById("adminConfirmCancel");
        const okBtn = document.getElementById("adminConfirmOk");

        if (!overlay || !titleEl || !messageEl || !cancelBtn || !okBtn) {
            if (options && typeof options.onConfirm === "function") {
                options.onConfirm();
            }
            return;
        }

        titleEl.textContent = options.title || "Xác nhận thao tác";
        messageEl.textContent = options.message || "Bạn có chắc muốn thực hiện thao tác này?";

        overlay.classList.add("open");

        const closeModal = function () {
            overlay.classList.remove("open");
            okBtn.onclick = null;
            cancelBtn.onclick = null;
            overlay.onclick = null;
        };

        cancelBtn.onclick = closeModal;

        overlay.onclick = function (e) {
            if (e.target === overlay) {
                closeModal();
            }
        };

        okBtn.onclick = function () {
            closeModal();

            if (typeof options.onConfirm === "function") {
                options.onConfirm();
            }
        };
    }

    function xuLyDonHang(maDonHang, action) {
        fetch(window.contextPath + "/admin/don-hang/duyet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body:
                    "maDonHang=" + encodeURIComponent(maDonHang)
                    + "&action=" + encodeURIComponent(action)
        })
                .then(async function (res) {
                    const text = await res.text();

                    if (!res.ok) {
                        throw new Error(text || "Lỗi xử lý đơn hàng");
                    }

                    return text;
                })
                .then(function (msg) {
                    toastr.success(msg || "Thao tác thành công");

                    setTimeout(function () {
                        window.location.reload();
                    }, 700);
                })
                .catch(function (err) {
                    toastr.error(err.message || "Có lỗi xảy ra");
                });
    }

    updateCountdowns();
    setInterval(updateCountdowns, 1000);
});