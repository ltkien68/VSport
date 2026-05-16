<%-- 
    File: loading-screen.jsp 
    Màn hình loading toàn trang – bounce → xoay + shrink → biến mất
    Chèn vào <body> trang chủ bằng <jsp:include page="loading-screen.jsp" />
    Icon: thẻ <img> với src="", bạn tự điền link ảnh.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    /* Loader overlay */
    #loader {
        position: fixed;
        inset: 0;
        background: #000;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 99999;
        transition: opacity 0.5s ease, visibility 0.5s ease;
        visibility: visible;
        opacity: 1;
    }

    #loader.fade-out {
        opacity: 0;
        visibility: hidden;
    }

    #spinner {
        display: flex;
        align-items: center;
        justify-content: center;
        will-change: transform;
    }

    /* Icon ảnh: giữ nguyên vuông, nền trắng nếu muốn, nhưng bạn có thể dùng ảnh trong suốt */
    .icon-t {
        width: 80px;
        height: 80px;
        object-fit: contain;  /* ảnh sẽ vừa khung, giữ tỉ lệ */
        background: transparent;
        will-change: transform, opacity;
    }

    @keyframes bounceIn {
        0%   { transform: scale(0);    opacity: 0; }
        50%  { transform: scale(1.35); opacity: 1; }
        70%  { transform: scale(0.85); }
        85%  { transform: scale(1.05); }
        100% { transform: scale(1);    opacity: 1; }
    }

    @keyframes wrapperSpin {
        from { transform: rotate(0deg); }
        to   { transform: rotate(1080deg); }
    }

    @keyframes iconShrink {
        from { transform: scale(1); opacity: 1; }
        to   { transform: scale(0); opacity: 0; }
    }

    #spinner.do-bounce { animation: bounceIn 0.7s cubic-bezier(0.68, -0.55, 0.27, 1.55) forwards; }
    #spinner.do-spin   { animation: wrapperSpin 1s cubic-bezier(0.2, 0, 0.8, 1) forwards; }
    #icon.do-shrink    { animation: iconShrink  1s cubic-bezier(0.4, 0, 1, 1)   forwards; }

    /* Responsive */
    @media (max-width: 600px) {
        .icon-t {
            width: 60px;
            height: 60px;
        }
    }
</style>

<div id="loader">
    <div id="spinner">
        <!-- 👇 THAY ĐỔI src BẰNG LINK ẢNH CỦA BẠN -->
        <img id="icon" class="icon-t" src="${pageContext.request.contextPath}/assets/images/logos/lk-logo.png" alt="Loading icon">
    </div>
</div>

<script>
(function() {
    const spinner = document.getElementById('spinner');
    const icon    = document.getElementById('icon');
    const loader  = document.getElementById('loader');

    // Kiểm tra các phần tử tồn tại (tránh lỗi nếu vô tình load trước DOM)
    if (!spinner || !icon || !loader) return;

    function hideLoader() {
        loader.classList.add('fade-out');
        // Sau khi ẩn, khôi phục cuộn trang và có thể xoá loader khỏi DOM (tuỳ chọn)
        setTimeout(() => {
            document.body.style.overflow = '';
            // Nếu muốn xoá hẳn loader khỏi DOM để tránh ảnh hưởng sự kiện:
            // if (loader.parentNode) loader.parentNode.removeChild(loader);
        }, 500); // khớp với transition 0.5s
    }

    // Bước 1: bounce in
    spinner.classList.add('do-bounce');

    spinner.addEventListener('animationend', function onBounce(e) {
        if (e.animationName !== 'bounceIn') return;
        spinner.removeEventListener('animationend', onBounce);
        spinner.classList.remove('do-bounce');
        spinner.classList.add('do-spin');
        icon.classList.add('do-shrink');
    });

    spinner.addEventListener('animationend', function onSpin(e) {
        if (e.animationName !== 'wrapperSpin') return;
        spinner.removeEventListener('animationend', onSpin);
        hideLoader();
    });

    // Fallback an toàn (5s)
    setTimeout(() => {
        if (!loader.classList.contains('fade-out')) {
            hideLoader();
        }
    }, 5000);

    // Ngăn cuộn trang khi loader đang hiện
    document.body.style.overflow = 'hidden';
})();
</script>