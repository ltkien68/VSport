document.addEventListener("DOMContentLoaded", function () {
    const root = document.documentElement;
    const header = document.getElementById("siteHeader");

    function setTheme(theme) {
        if (theme === "dark") {
            root.classList.add("dark-mode");
        } else {
            root.classList.remove("dark-mode");
        }
        localStorage.setItem("theme", theme);
    }

    function toggleTheme() {
        const isDark = root.classList.contains("dark-mode");
        setTheme(isDark ? "light" : "dark");
    }

    /* đảm bảo đồng bộ sau khi DOM xong */
    const savedTheme = localStorage.getItem("theme") || "light";
    setTheme(savedTheme);

    /* HEADER SHRINK */
    if (header) {
        let ticking = false;

        function updateHeader() {
            const currentScrollY = window.scrollY;

            if (currentScrollY > 40) {
                header.classList.add("shrink");
            } else {
                header.classList.remove("shrink");
            }

            ticking = false;
        }

        window.addEventListener("scroll", function () {
            if (!ticking) {
                window.requestAnimationFrame(updateHeader);
                ticking = true;
            }
        });

        updateHeader();
    }

    /* render icon 1 lần */
    if (typeof lucide !== "undefined") {
        lucide.createIcons();
    }

    /* event delegation */
    document.addEventListener("click", function (e) {
        const themeBtn = e.target.closest("#themeToggleBtn");
        if (!themeBtn) return;
        e.preventDefault();
        toggleTheme();
    });
});

document.addEventListener("DOMContentLoaded", function () {
    const header = document.getElementById("siteHeader");
    const headerShell = document.getElementById("siteHeaderShell");
    const isHome = document.body.classList.contains("home-page");

    if (!header || !headerShell) return;

    let ticking = false;

    // 👇 CHỈNH Ở ĐÂY
    const bannerHeight = 750; // px - m tự set theo banner

    function updateHeader() {
        const scrollY = window.scrollY;

        // shrink vẫn giữ
        if (scrollY > 40) {
            header.classList.add("shrink");
        } else {
            header.classList.remove("shrink");
        }

        // chỉ trang home mới đổi màu
        if (isHome) {
            const triggerPoint = bannerHeight - headerShell.offsetHeight;

            if (scrollY >= triggerPoint) {
                headerShell.classList.add("header-light");
            } else {
                headerShell.classList.remove("header-light");
            }
        } else {
            // trang khác luôn trắng
            headerShell.classList.remove("header-light");
        }

        ticking = false;
    }

    window.addEventListener("scroll", function () {
        if (!ticking) {
            requestAnimationFrame(updateHeader);
            ticking = true;
        }
    });

    window.addEventListener("resize", updateHeader);
    updateHeader();
});