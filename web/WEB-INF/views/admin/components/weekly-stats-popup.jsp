<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div id="weeklyStatOverlay" class="weekly-stat-overlay">
    <div class="weekly-stat-popup">
        <button type="button" id="closeWeeklyStat" class="weekly-stat-close">×</button>

        <div class="weekly-stat-head">
            <p>Thống kê theo tuần</p>
            <h2 id="weeklyStatTitle">Tổng đơn hàng</h2>
        </div>

        <div id="weeklyStatList" class="weekly-stat-list">
            <!-- JS render dữ liệu ở đây -->
        </div>
    </div>
</div>