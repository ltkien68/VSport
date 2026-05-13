document.addEventListener("DOMContentLoaded", () => {
    const cards = document.querySelectorAll(".hover-float");

    let clone = null;
    let targetX = 0, targetY = 0;
    let currentX = 0, currentY = 0;
    let raf = null;

    function animate() {
        if (!clone) return;

        // easing kiểu “có quán tính”
        currentX += (targetX - currentX) * 0.12;
        currentY += (targetY - currentY) * 0.12;

        clone.style.transform = `
            translate3d(${currentX}px, ${currentY}px, 0)
            scale(1.08)
        `;

        raf = requestAnimationFrame(animate);
    }

    cards.forEach(card => {
        const img = card.querySelector("img");

        card.addEventListener("mouseenter", (e) => {

            const rect = img.getBoundingClientRect();

            clone = document.createElement("div");
            clone.className = "float-clone";

            clone.style.width = rect.width + "px";
            clone.style.height = rect.height + "px";
            clone.style.left = rect.left + "px";
            clone.style.top = rect.top + "px";

            const cloneImg = img.cloneNode(true);
            clone.appendChild(cloneImg);

            document.body.appendChild(clone);

            targetX = rect.left;
            targetY = rect.top;

            raf = requestAnimationFrame(animate);
        });

        card.addEventListener("mousemove", (e) => {
            if (!clone) return;

            const offsetX = (e.clientX - window.innerWidth / 2) * 0.02;
            const offsetY = (e.clientY - window.innerHeight / 2) * 0.02;

            targetX = parseFloat(clone.style.left) + offsetX;
            targetY = parseFloat(clone.style.top) + offsetY;
        });

        card.addEventListener("mouseleave", () => {
            if (clone) {
                clone.remove();
                clone = null;
            }
            cancelAnimationFrame(raf);
        });
    });
});