<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt Sân Bóng | VSport - Trải nghiệm 3D</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo-header.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/dat-san-bong.css">
        <jsp:include page="/WEB-INF/views/common/head.jsp" />
    </head>
    <body>
        <!-- Nút quay lại trang chủ -->
        <button class="back-home-btn" id="backHomeBtn">
            ← Về trang chủ
        </button>

        <div class="info-panel">
            🖱️ Chuột: Xoay / Kéo / Zoom | 🏟️ Sân vận động 3D
        </div>

        <div class="booking-overlay">
            <h3>📅 Đặt sân ngay</h3>
            <p style="font-size: 12px; margin-bottom: 12px;">Chọn ngày giờ, nhận ưu đãi</p>
            <button id="bookingBtn">Chọn sân & Đặt lịch</button>
        </div>

        <!-- Import map cho Three.js -->
        <script type="importmap">
            {
                "imports": {
                    "three": "https://unpkg.com/three@0.128.0/build/three.module.js",
                    "three/addons/": "https://unpkg.com/three@0.128.0/examples/jsm/"
                }
            }
        </script>

        <script>
            // Truyền contextPath cho JS
            window.contextPath = "${pageContext.request.contextPath}";
        </script>

        <!-- File JS chính xử lý 3D -->
        <script type="module" src="${pageContext.request.contextPath}/assets/js/pages/dat-san-bong.js"></script>

        <!-- Các script phụ (giữ nguyên từ code cũ) -->
        <script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>
        <script src="https://unpkg.com/lucide@latest"></script>
        <script> lucide.createIcons();</script>
        
        <%-- jQuery và Toastr --%>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
        <script>
            toastr.options = {
                closeButton: true,
                progressBar: true,
                newestOnTop: true,
                preventDuplicates: true,
                positionClass: "toast-bottom-right",
                timeOut: "1000",
                extendedTimeOut: "1000",
                showDuration: "250",
                hideDuration: "250",
                showMethod: "fadeIn",
                hideMethod: "fadeOut"
            };
        </script>
    </body>
</html>