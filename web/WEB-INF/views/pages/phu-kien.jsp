<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Phụ Kiện .LKsport</title>

        <link rel="icon" type="image/png"
              href="${pageContext.request.contextPath}/assets/images/logos/logo-header.png">

        <jsp:include page="/WEB-INF/views/common/head.jsp" />

        <script>
            (function () {
                try {
                    const theme = localStorage.getItem("theme");

                    if (theme === "dark") {
                        document.documentElement.classList.add("dark-mode");
                    } else {
                        document.documentElement.classList.remove("dark-mode");
                    }
                } catch (e) {
                }
            })();
        </script>
    </head>

    <body class="inner">

        <div class="header-shell">
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
            <%@ include file="/WEB-INF/views/common/navbar.jsp" %>
        </div>

        <jsp:include page="/WEB-INF/views/pages/phu_kien_product.jsp" />
        <jsp:include page="/WEB-INF/views/pages/components/filter-popup.jsp" />

        <%@ include file="/WEB-INF/views/auth/login-popup.jsp" %>

        <script src="https://unpkg.com/lucide@latest"></script>

        <script>
            lucide.createIcons();
        </script>

        <script>
        window.contextPath = "${pageContext.request.contextPath}";
        </script>

        <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/common/scroll-reveal.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/filter-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/login-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/favorite-section.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>

        <script src="${pageContext.request.contextPath}/assets/js/pages/phu_kien_product.js"></script>

        <%-- jQuery bắt buộc cho Toastr --%>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <%-- Toastr JS --%>
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