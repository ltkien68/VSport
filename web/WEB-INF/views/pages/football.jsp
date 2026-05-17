<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Bóng đá | VSport</title>

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo.png">

        <!-- CSS nền tảng -->


        <!-- CSS component -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/header.css">
        <jsp:include page="/WEB-INF/views/common/head.jsp" />


    </head>

    <body class="inner">

        <!-- HEADER -->
        <div class="header-shell">
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
            <%@ include file="/WEB-INF/views/common/navbar.jsp" %>
        </div>


        <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>

        <script src="https://unpkg.com/lucide@latest"></script>
        <script>
            lucide.createIcons();
        </script>

        <%@ include file="/WEB-INF/views/pages/football-sections/football-jersey.jsp" %>     
        <%@ include file="/WEB-INF/views/common/football-jersey-banner.jsp" %>

        <jsp:include page="/WEB-INF/views/pages/components/collections.jsp" />
        <%@ include file="/WEB-INF/views/auth/login-popup.jsp" %>

        <%@ include file="/WEB-INF/views/common/footer.jsp" %>

        <script src="${pageContext.request.contextPath}/assets/js/pages/football.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/football-jersey-banner.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/common/scroll-reveal.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/login-popup.js"></script>
        <script src="<%= request.getContextPath() %>/assets/js/components/collections.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/football-jersey.js"></script>



        <script>
            window.contextPath = "${pageContext.request.contextPath}";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>

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