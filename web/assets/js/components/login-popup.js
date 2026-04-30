document.addEventListener("DOMContentLoaded", function () {
    const overlay = document.getElementById("loginPopupOverlay");
    if (!overlay) return;

    const body = document.body;

    const openBtns = document.querySelectorAll(
        "#openLoginPopup, #showLoginPopup, .open-login-popup"
    );
    const closeBtn = document.getElementById("closeLoginPopup");

    const loginWrap = document.getElementById("loginFormWrap");
    const registerWrap = document.getElementById("registerFormWrap");

    const showRegisterBtn = document.getElementById("showRegisterForm");
    const showLoginBtn = document.getElementById("showLoginForm");

    const title = document.getElementById("authPopupTitle");
    const subtitle = document.getElementById("authPopupSubtitle");
    const note = document.getElementById("authPopupNote");

    const switchBtns = document.querySelectorAll(".login-switch-btn");
    const dangNhapInput = document.getElementById("popupDangNhap");
    const passwordInput = document.getElementById("popupPassword");
    const label = document.getElementById("loginLabel");
    const loginErrorText = document.getElementById("loginPopupSubmitError");
    const togglePasswordBtn = document.getElementById("togglePopupPassword");

    const loginForm = document.getElementById("loginPopupForm");

    const registerForm = document.getElementById("registerPopupForm");
    const registerHoTen = document.getElementById("registerHoTen");
    const registerEmail = document.getElementById("registerEmail");
    const registerPhone = document.getElementById("registerPhone");
    const registerPassword = document.getElementById("registerPassword");
    const registerConfirmPassword = document.getElementById("registerConfirmPassword");
    const registerErrorText = document.getElementById("registerPopupSubmitError");

    function showToast(type, message) {
        if (!message || !window.toastr) return;

        if (type === "success") toastr.success(message);
        else if (type === "error") toastr.error(message);
        else if (type === "warning") toastr.warning(message);
        else toastr.info(message);
    }

    function refreshLucide() {
        if (window.lucide) lucide.createIcons();
    }

    function openPopup() {
        overlay.classList.add("show");
        body.classList.add("login-popup-open");
    }

    function closePopup() {
        overlay.classList.remove("show");
        body.classList.remove("login-popup-open");
    }

    function clearLoginError() {
        if (!loginErrorText) return;
        loginErrorText.textContent = "";
        loginErrorText.classList.remove("show");
    }

    function showLoginError(message, useToast = false) {
        if (loginErrorText) {
            loginErrorText.textContent = message;
            loginErrorText.classList.add("show");
        }

        if (useToast) showToast("error", message);
    }

    function clearRegisterError() {
        if (!registerErrorText) return;
        registerErrorText.textContent = "";
        registerErrorText.classList.remove("show");
    }

    function showRegisterError(message, useToast = true) {
        if (registerErrorText) {
            registerErrorText.textContent = message;
            registerErrorText.classList.add("show");
        }

        if (useToast) showToast("error", message);
    }

    function clearLoginFields() {
        if (dangNhapInput) dangNhapInput.value = "";

        if (passwordInput) {
            passwordInput.value = "";
            passwordInput.type = "password";
        }

        if (togglePasswordBtn) {
            togglePasswordBtn.innerHTML = '<i data-lucide="eye-off"></i>';
            refreshLucide();
        }
    }

    function setLoginMode(mode) {
        if (!dangNhapInput || !label) return;

        switchBtns.forEach((btn) => {
            btn.classList.toggle("active", btn.dataset.type === mode);
        });

        if (mode === "phone") {
            label.textContent = "SỐ ĐIỆN THOẠI";
            dangNhapInput.placeholder = "Số điện thoại";
            dangNhapInput.type = "text";
        } else {
            label.textContent = "E-MAIL ADDRESS";
            dangNhapInput.placeholder = "E-mail";
            dangNhapInput.type = "email";
        }
    }

    function switchToLogin() {
        if (loginWrap) loginWrap.classList.add("active");
        if (registerWrap) registerWrap.classList.remove("active");

        if (title) title.textContent = "CHÀO MỪNG TRỞ LẠI";
        if (subtitle) subtitle.textContent = "Đăng nhập để không bỏ lỡ bất kỳ sản phẩm và ưu đãi nào.";
        if (note) {
            note.innerHTML =
                'Nhập thông tin tài khoản của bạn để tiếp tục mua sắm cùng <span style="font-weight: bold"><span style="color: var(--color-red)">V</span>$PORT</span>';
        }

        clearLoginError();
        setLoginMode("email");
    }

    function switchToRegister() {
        if (loginWrap) loginWrap.classList.remove("active");
        if (registerWrap) registerWrap.classList.add("active");

        if (title) title.textContent = "TẠO TÀI KHOẢN";
        if (subtitle) subtitle.textContent = "Đăng ký để bắt đầu mua sắm và săn ưu đãi cùng VSport.";
        if (note) {
            note.innerHTML =
                'Điền thông tin của bạn để tạo tài khoản mới cùng <span style="font-weight: bold"><span style="color: var(--color-red)">V</span>$PORT</span>';
        }

        clearRegisterError();
    }

    function loadTheme() {
        const savedTheme = localStorage.getItem("theme");
        body.classList.toggle("dark-mode", savedTheme === "dark");
    }

    loadTheme();

    openBtns.forEach((btn) => {
        btn.addEventListener("click", function (e) {
            e.preventDefault();
            switchToLogin();
            clearLoginFields();
            openPopup();
        });
    });

    if (closeBtn) {
        closeBtn.addEventListener("click", closePopup);
    }

    overlay.addEventListener("click", function (e) {
        if (e.target === overlay) closePopup();
    });

    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape" && overlay.classList.contains("show")) {
            closePopup();
        }
    });

    if (showRegisterBtn) {
        showRegisterBtn.addEventListener("click", function (e) {
            e.preventDefault();
            switchToRegister();
        });
    }

    if (showLoginBtn) {
        showLoginBtn.addEventListener("click", function (e) {
            e.preventDefault();
            switchToLogin();
        });
    }

    switchBtns.forEach((btn) => {
        btn.addEventListener("click", function () {
            const type = this.dataset.type || "email";
            setLoginMode(type);
            if (dangNhapInput) dangNhapInput.value = "";
            clearLoginError();
        });
    });

    if (togglePasswordBtn && passwordInput) {
        togglePasswordBtn.addEventListener("click", function () {
            const isPassword = passwordInput.type === "password";
            passwordInput.type = isPassword ? "text" : "password";
            togglePasswordBtn.innerHTML = isPassword
                ? '<i data-lucide="eye"></i>'
                : '<i data-lucide="eye-off"></i>';
            refreshLucide();
        });
    }

    document.querySelectorAll(".register-password-toggle").forEach((btn) => {
        btn.addEventListener("click", function () {
            const wrap = btn.closest(".login-popup-password-wrap");
            const input = wrap ? wrap.querySelector("input") : null;
            if (!input) return;

            const isPassword = input.type === "password";
            input.type = isPassword ? "text" : "password";
            btn.innerHTML = isPassword
                ? '<i data-lucide="eye"></i>'
                : '<i data-lucide="eye-off"></i>';

            refreshLucide();
        });
    });

    const shouldOpenPopup = overlay.dataset.open === "true";
    const shouldOpenRegister = overlay.dataset.registerOpen === "true";

    const loginErrorMessage = (overlay.dataset.loginError || "").trim();
    const loginSuccess = overlay.dataset.loginSuccess === "true";

    const registerErrorMessage = (overlay.dataset.registerError || "").trim();
    const registerSuccessMessage = (overlay.dataset.registerSuccess || "").trim();

    const toastSuccess = (overlay.dataset.toastSuccess || "").trim();
    const toastError = (overlay.dataset.toastError || "").trim();

    if (shouldOpenRegister || registerErrorMessage) {
        switchToRegister();
        openPopup();
    } else if (shouldOpenPopup || loginErrorMessage) {
        switchToLogin();
        openPopup();
        clearLoginFields();
    } else {
        switchToLogin();
    }

    if (loginErrorMessage) {
        showLoginError(loginErrorMessage, true);
    }

    if (registerErrorMessage) {
        showRegisterError(registerErrorMessage, true);
    }

    if (loginSuccess) {
        closePopup();
    }

    if (registerSuccessMessage) {
        closePopup();
        showToast("success", registerSuccessMessage);
    }

    if (toastSuccess) {
        showToast("success", toastSuccess);
    }

    if (toastError) {
        showToast("error", toastError);
    }

    if (loginForm) {
        loginForm.addEventListener("submit", function () {
            clearLoginError();
        });
    }

    if (registerForm) {
        registerForm.addEventListener("submit", function (e) {
            clearRegisterError();

            const hoTen = registerHoTen ? registerHoTen.value.trim() : "";
            const email = registerEmail ? registerEmail.value.trim() : "";
            const phone = registerPhone ? registerPhone.value.trim() : "";
            const password = registerPassword ? registerPassword.value.trim() : "";
            const confirmPassword = registerConfirmPassword ? registerConfirmPassword.value.trim() : "";

            const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
            const phoneRegex = /^\d{9,11}$/;

            if (!hoTen) {
                e.preventDefault();
                showRegisterError("Họ tên không được để trống.");
                registerHoTen.focus();
                return;
            }

            if (hoTen.length < 2) {
                e.preventDefault();
                showRegisterError("Họ tên phải có ít nhất 2 ký tự.");
                registerHoTen.focus();
                return;
            }

            if (!email) {
                e.preventDefault();
                showRegisterError("Email không được để trống.");
                registerEmail.focus();
                return;
            }

            if (!emailRegex.test(email)) {
                e.preventDefault();
                showRegisterError("Email không đúng định dạng.");
                registerEmail.focus();
                return;
            }

            if (!phone) {
                e.preventDefault();
                showRegisterError("Số điện thoại không được để trống.");
                registerPhone.focus();
                return;
            }

            if (!phoneRegex.test(phone)) {
                e.preventDefault();
                showRegisterError("Số điện thoại không hợp lệ.");
                registerPhone.focus();
                return;
            }

            if (!password) {
                e.preventDefault();
                showRegisterError("Mật khẩu không được để trống.");
                registerPassword.focus();
                return;
            }

            if (password.length < 6) {
                e.preventDefault();
                showRegisterError("Mật khẩu phải có ít nhất 6 ký tự.");
                registerPassword.focus();
                return;
            }

            if (!confirmPassword) {
                e.preventDefault();
                showRegisterError("Vui lòng nhập xác nhận mật khẩu.");
                registerConfirmPassword.focus();
                return;
            }

            if (password !== confirmPassword) {
                e.preventDefault();
                showRegisterError("Xác nhận mật khẩu không khớp.");
                registerConfirmPassword.focus();
            }
        });
    }
});