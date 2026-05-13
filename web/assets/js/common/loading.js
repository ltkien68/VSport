// loader.js - fixed initialization error
(function() {
    // Kiểm tra loader đã tồn tại chưa
    if (document.querySelector('.loader-overlay')) return;

    // Tạo DOM elements
    const loaderDiv = document.createElement('div');
    loaderDiv.className = 'loader-overlay';
    loaderDiv.id = 'loader';
    const canvas = document.createElement('canvas');
    canvas.id = 'loaderCanvas';
    loaderDiv.appendChild(canvas);
    document.body.insertBefore(loaderDiv, document.body.firstChild);

    const ctx = canvas.getContext('2d');

    // ===== KHAI BÁO TẤT CẢ BIẾN STATE TRƯỚC =====
    let w, h, cx, cy;
    let percent = 0;
    let bend = 0;
    let rot = 0;
    let scaleVal = 1;
    let opacity = 1;
    let phase = "load"; // "load", "bend", "zoom"
    let phaseStartTime = 0;
    let animFrame = null;

    // Hằng số
    const HALF_LEN = 260;
    const LINE_WIDTH = 56;
    const easeOut = t => 1 - Math.pow(1 - t, 3);

    // Hàm màu loading
    function getLoadingColor(p) {
        const intensity = 100 + Math.floor(155 * (p / 100));
        return `rgb(${intensity}, ${intensity}, ${intensity})`;
    }

    // Hàm vẽ (sử dụng các biến đã khai báo)
    function draw() {
        if (!ctx) return;
        ctx.clearRect(0, 0, w, h);
        ctx.fillStyle = '#000';
        ctx.fillRect(0, 0, w, h);
        ctx.save();
        ctx.translate(cx, cy);

        if (phase === "zoom") {
            ctx.rotate(rot);
            ctx.scale(scaleVal, scaleVal);
        }

        ctx.lineWidth = LINE_WIDTH;
        ctx.lineCap = "round";
        ctx.shadowBlur = 0;

        let color;
        if (phase === "load") {
            color = getLoadingColor(percent);
        } else {
            color = "#ffffff";
            ctx.shadowColor = "rgba(255,255,255,0.4)";
            ctx.shadowBlur = 15;
        }
        ctx.strokeStyle = color;

        let currentLen = HALF_LEN;
        if (phase === "load") {
            currentLen = HALF_LEN * (percent / 100);
        }

        if (phase === "load") {
            // Vẽ thanh ngang
            ctx.beginPath();
            ctx.moveTo(-currentLen, 0);
            ctx.lineTo(currentLen, 0);
            ctx.stroke();
        } else {
            // Vẽ chữ V
            const leftAngle = bend;
            const rightAngle = -bend;
            const leftX = -HALF_LEN * Math.cos(leftAngle);
            const leftY = -HALF_LEN * Math.sin(leftAngle);
            const rightX = HALF_LEN * Math.cos(rightAngle);
            const rightY = HALF_LEN * Math.sin(rightAngle);
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(leftX, leftY);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(rightX, rightY);
            ctx.stroke();
        }
        ctx.restore();
    }

    // Hàm resize (gọi draw sau khi cập nhật kích thước)
    function resize() {
        w = canvas.width = window.innerWidth;
        h = canvas.height = window.innerHeight;
        cx = w / 2;
        cy = h / 2;
        draw();
    }
    window.addEventListener('resize', resize);
    resize(); // an toàn vì các biến đã được khởi tạo

    // Animation loop
    function animate(now) {
        switch (phase) {
            case "load":
                let inc = 0;
                if (percent < 25) inc = 1.3;
                else if (percent >= 25 && percent < 38) inc = 0.35;
                else if (percent >= 38 && percent < 70) inc = 3.2;
                else if (percent >= 70) inc = 5.5;
                else inc = 2.0;
                percent += inc;
                if (percent > 100) percent = 100;
                if (percent >= 100) {
                    percent = 100;
                    phase = "bend";
                    phaseStartTime = now;
                }
                break;

            case "bend":
                if (!phaseStartTime) phaseStartTime = now;
                let tBend = Math.min(1, (now - phaseStartTime) / 550);
                bend = easeOut(tBend) * (Math.PI / 4); // 45°
                if (tBend >= 1) {
                    bend = Math.PI / 4;
                    phase = "zoom";
                    phaseStartTime = now;
                    scaleVal = 1;
                    rot = 0;
                }
                break;

            case "zoom":
                if (!phaseStartTime) phaseStartTime = now;
                let tZoom = Math.min(1, (now - phaseStartTime) / 700);
                const easeCubic = 1 - Math.pow(1 - tZoom, 3);
                scaleVal = 1 + easeCubic * 28;
                rot = easeCubic * (Math.PI / 3.6);
                opacity = 1 - easeCubic * 1.3;
                loaderDiv.style.opacity = Math.max(0, opacity);
                if (tZoom >= 1 || opacity <= 0) {
                    loaderDiv.style.opacity = 0;
                    const app = document.getElementById('app');
                    if (app) app.style.opacity = '1';
                    setTimeout(() => {
                        if (loaderDiv && loaderDiv.parentNode) loaderDiv.remove();
                        if (animFrame) cancelAnimationFrame(animFrame);
                    }, 100);
                    return;
                }
                break;
        }
        draw();
        animFrame = requestAnimationFrame(animate);
    }

    // Bắt đầu
    const app = document.getElementById('app');
    if (app) app.style.opacity = '0';
    loaderDiv.style.opacity = '1';
    animFrame = requestAnimationFrame(animate);
})();