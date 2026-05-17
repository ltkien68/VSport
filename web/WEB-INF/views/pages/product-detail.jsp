<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.SanPham"%>
<%
    SanPham sp = (SanPham) request.getAttribute("sp");
%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/WEB-INF/views/common/head.jsp" />


        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo.png">

        <title><%= sp.getTenSanPham() %></title>

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

        <main class="pd-page">
            <section class="pd-top">
                <div class="pd-top-left">
                    <jsp:include page="/WEB-INF/views/pages/components/product-gallery.jsp" />
                    <jsp:include page="/WEB-INF/views/pages/components/product-fit.jsp" />
                    <jsp:include page="/WEB-INF/views/pages/components/product-accordion.jsp" />
                </div>

                <div class="pd-top-right">
                    <jsp:include page="/WEB-INF/views/pages/components/product-info.jsp" />
                </div>
            </section>

            <section class="pd-bottom-recommend">

                <jsp:include page="/WEB-INF/views/pages/components/product-recommend.jsp" />

            </section>
        </main>

        <%@ include file="/WEB-INF/views/auth/login-popup.jsp" %>

        <%@ include file="/WEB-INF/views/common/footer.jsp" %>

        <div id="cart-popup-root"></div>



        <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/product-detail.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/login-popup.js"></script>
        <script src="https://unpkg.com/lucide@latest"></script>

        <script>
        window.contextPath = "${pageContext.request.contextPath}";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/common/scroll-reveal.js"></script>
        <script>
            lucide.createIcons();
        </script>

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