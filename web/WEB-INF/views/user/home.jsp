<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Boolean loginSuccessFlag = (Boolean) request.getAttribute("loginSuccess");
    Boolean logoutSuccessFlag = (Boolean) request.getAttribute("logoutSuccess");

    if (loginSuccessFlag == null) {
        loginSuccessFlag = false;
    }
    if (logoutSuccessFlag == null)
        logoutSuccessFlag = false;
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Trang chủ | LKsport</title>

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo-header.png">

        <!-- CSS nền tảng -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/reset.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/fonts.css">

        <!-- CSS component -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/header.css">
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

    <body class="home-page"
          data-login-success="<%= loginSuccessFlag%>"
          data-logout-success="<%= logoutSuccessFlag%>"
          >
        
        <!-- Loading -->
        <%-- <jsp:include page="/WEB-INF/views/common/loading.jsp" /> --%>

        <!-- HEADER -->
        <div >
            <div class="header-shell" id="siteHeaderShell">
                <%@ include file="/WEB-INF/views/common/header.jsp" %>
                <%@ include file="/WEB-INF/views/common/navbar.jsp" %>
            </div>


            <%@ include file="/WEB-INF/views/common/banner.jsp" %>
            <%@ include file="/WEB-INF/views/auth/login-popup.jsp" %>
            <%@ include file="/WEB-INF/views/pages/components/new-product-section.jsp" %>
            <%@ include file="/WEB-INF/views/pages/components/favorite-section.jsp" %>
            <%@ include file="/WEB-INF/views/pages/components/best-seller-section.jsp" %>
            <%@ include file="/WEB-INF/views/pages/components/shop-category.jsp" %>
            <%@ include file="/WEB-INF/views/pages/components/newsletter-bar.jsp" %>

            <%@ include file="/WEB-INF/views/common/footer.jsp" %>
        </div>


        <script>
            window.contextPath = "${pageContext.request.contextPath}";
        </script>

        <script type="importmap">
            {
            "imports": {
            "three": "https://cdn.jsdelivr.net/npm/three@0.165.0/build/three.module.js"
            }
            }
        </script>



        <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/banner.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/best-seller-section.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/login-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/favorite-section.js"></script>
        <script type="module" src="${pageContext.request.contextPath}/assets/js/components/new-product-section.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/newsletter-bar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/common/scroll-reveal.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/common/hover-float.js"></script>






        <script src="https://unpkg.com/lucide@latest"></script>
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