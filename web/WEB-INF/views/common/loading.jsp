<%-- 
    File: loading-screen.jsp 
    Màn hình loading toàn trang – bounce icon → chữ nhảy lên từng cái → xoay + shrink → biến mất
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    #loader {
        position: fixed;
        inset: 0;
        background: #000;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        gap: 20px;
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

    .icon-t {
        width: 80px;
        height: 80px;
        object-fit: contain;
        background: transparent;
        will-change: transform, opacity;
    }

    /* Dòng chữ */
    #loader-text {
        display: flex;
        gap: 4px;
        overflow: hidden;
    }

    #loader-text span {
        display: inline-block;
        color: #ffffff;
        font-family: var(--font-body-2);
        font-size: 28px;
        font-weight: bold;
        letter-spacing: 2px;
        opacity: 0;
        transform: translateY(20px);
        transition: none;
    }

    #loader-text span.jump {
        animation: letterJump 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
    }

    @keyframes letterJump {
        0%   { opacity: 0; transform: translateY(20px); }
        60%  { opacity: 1; transform: translateY(-6px); }
        80%  { transform: translateY(3px); }
        100% { opacity: 1; transform: translateY(0); }
    }

    /* Animations */
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

    @keyframes textFadeOut {
        from { opacity: 1; transform: translateY(0); }
        to   { opacity: 0; transform: translateY(10px); }
    }

    #spinner.do-bounce { animation: bounceIn 0.7s cubic-bezier(0.68, -0.55, 0.27, 1.55) forwards; }
    #spinner.do-spin   { animation: wrapperSpin 1s cubic-bezier(0.2, 0, 0.8, 1) forwards; }
    #icon.do-shrink    { animation: iconShrink  1s cubic-bezier(0.4, 0, 1, 1) forwards; }

    #loader-text.text-out {
        animation: textFadeOut 0.3s ease forwards;
    }

    @media (max-width: 600px) {
        .icon-t { width: 60px; height: 60px; }
        #loader-text span { font-size: 22px; }
    }
</style>

<div id="loader">
    <div id="spinner">
        <img id="icon" class="icon-t" src="${pageContext.request.contextPath}/assets/images/logos/lk-logo.png" alt="Loading icon">
    </div>
    <div id="loader-text">
        <span>l</span>
        <span>t</span>
        <span>r</span>
        <span>n</span>
        <span>g</span>
        <span>k</span>
        <span>i</span>
        <span>e</span>
        <span>n</span>
    </div>
</div>

<script>
(function () {
    const spinner    = document.getElementById('spinner');
    const icon       = document.getElementById('icon');
    const loader     = document.getElementById('loader');
    const loaderText = document.getElementById('loader-text');

    if (!spinner || !icon || !loader) return;

    document.body.style.overflow = 'hidden';

    function hideLoader() {
        loader.classList.add('fade-out');
        setTimeout(() => {
            document.body.style.overflow = '';
        }, 500);
    }

    // Bước 1: bounce icon
    spinner.classList.add('do-bounce');

    spinner.addEventListener('animationend', function onBounce(e) {
        if (e.animationName !== 'bounceIn') return;
        spinner.removeEventListener('animationend', onBounce);

        // Bước 2: từng chữ nhảy lên lần lượt
        const letters = loaderText.querySelectorAll('span');
        const DELAY   = 40; // ms giữa mỗi chữ

        letters.forEach((el, i) => {
            setTimeout(() => {
                el.classList.add('jump');
            }, i * DELAY);
        });

        const totalTextTime = letters.length * DELAY + 400;

        // Bước 3: sau khi chữ xong → xoay + shrink
        setTimeout(() => {
            loaderText.classList.add('text-out');
            spinner.classList.remove('do-bounce');
            spinner.classList.add('do-spin');
            icon.classList.add('do-shrink');
        }, totalTextTime);
    });

    spinner.addEventListener('animationend', function onSpin(e) {
        if (e.animationName !== 'wrapperSpin') return;
        spinner.removeEventListener('animationend', onSpin);
        hideLoader();
    });

    // Fallback 6s
    setTimeout(() => {
        if (!loader.classList.contains('fade-out')) hideLoader();
    }, 6000);
})();
</script>
