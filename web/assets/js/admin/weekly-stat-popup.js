document.addEventListener("DOMContentLoaded", function () {
    const cards = document.querySelectorAll(".stat-clickable");
    const overlay = document.getElementById("weeklyStatOverlay");
    const closeBtn = document.getElementById("closeWeeklyStat");
    const title = document.getElementById("weeklyStatTitle");
    const list = document.getElementById("weeklyStatList");

    if (!overlay || !closeBtn || !title || !list)
        return;

    const titleMap = {
        don_hang: "Tổng đơn hàng",
        doanh_thu: "Tổng doanh thu",
        loi_nhuan: "Tổng lợi nhuận",
        thanh_vien: "Số thành viên"
    };

    cards.forEach(card => {
        card.addEventListener("click", function () {
            const type = this.dataset.type;

            title.textContent = titleMap[type] || "Thống kê";
            list.innerHTML = `<p class="weekly-stat-loading">Đang tải dữ liệu...</p>`;
            overlay.classList.add("active");

            fetch(`${contextPath}/admin/dashboard/thong-ke-tuan?type=${type}`)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error("Không tải được dữ liệu");
                        }
                        return response.json();
                    })
                    .then(data => {
                        renderWeeklyStats(data, type);
                    })
                    .catch(error => {
                        console.error(error);
                        list.innerHTML = `<p class="weekly-stat-empty">Không tải được dữ liệu.</p>`;
                    });
        });
    });

    closeBtn.addEventListener("click", closePopup);

    overlay.addEventListener("click", function (e) {
        if (e.target === overlay) {
            closePopup();
        }
    });

    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape") {
            closePopup();
        }
    });

    function closePopup() {
        overlay.classList.remove("active");
    }

    function renderWeeklyStats(data, type) {
        if (!Array.isArray(data) || data.length === 0) {
            list.innerHTML = `<p class="weekly-stat-empty">Chưa có dữ liệu thống kê.</p>`;
            return;
        }

        list.innerHTML = data.map((item, index) => {
            const value = Number(item.value || 0);
            const valueClass = value < 0 ? "negative" : "positive";
            const currentWeekClass = isCurrentWeek(item.fromDate, item.toDate) ? "current-week" : "";

            return `
                <div class="weekly-stat-item ${currentWeekClass}">
                    <div class="weekly-stat-info">
                        <strong>${item.weekName || "Tuần " + (index + 1)}</strong>
                        <span>${formatDate(item.fromDate)} - ${formatDate(item.toDate)}</span>
                    </div>

                    <div class="weekly-stat-value ${valueClass}">
                        ${formatValue(value, type)}
                    </div>
                </div>
            `;
        }).join("");
    }

    function formatValue(value, type) {
        if (type === "doanh_thu" || type === "loi_nhuan") {
            return value.toLocaleString("vi-VN") + "đ";
        }

        return value.toLocaleString("vi-VN");
    }

    function formatDate(dateString) {
        if (!dateString)
            return "--/--/----";

        const date = new Date(dateString);

        if (isNaN(date.getTime())) {
            return dateString;
        }

        return date.toLocaleDateString("vi-VN");
    }

    function isCurrentWeek(fromDate, toDate) {
        if (!fromDate || !toDate)
            return false;

        const today = new Date();
        today.setHours(0, 0, 0, 0);

        const start = new Date(fromDate);
        const end = new Date(toDate);

        start.setHours(0, 0, 0, 0);
        end.setHours(23, 59, 59, 999);

        return today >= start && today <= end;
    }
});