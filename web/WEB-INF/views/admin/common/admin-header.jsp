<%-- 
    Document   : admin-header
    Created on : Apr 22, 2026, 10:24:36 AM
    Author     : ltrgk
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header class="admin-topbar">
    <div class="admin-topbar-left">
        <h1>TỔNG QUAN</h1>
        <div class="filter-admin">
            <p>Kết quả phân tích dành cho bạn:</p>

            <select class="admin-topbar-select">
                <option>Tháng này</option>
                <option>Tuần này</option>
                <option>Năm này</option>
            </select>
        </div>
    </div>

    <div class="admin-topbar-right">
        <button class="admin-icon-btn" type="button"><i data-lucide="bell"></i></button>
        <button 
            class="admin-icon-btn" 
            type="button"
            onclick="window.location.href = '${pageContext.request.contextPath}/dang_xuat'">
            <i data-lucide="log-out"></i>
        </button>
    </div>
</header>
