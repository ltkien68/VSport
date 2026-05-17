<%-- 
    Document   : giay-gang-bong-da
    Created on : Apr 23, 2026, 11:31:13 PM
    Author     : ltrgk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>In theo yêu cầu | VSport</title>
        
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logos/logo-header.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/header.css">
        <jsp:include page="/WEB-INF/views/common/head.jsp" />
    </head>
    <body class="inner">
        <div class="header-shell">
            <%@ include file="/WEB-INF/views/common/header.jsp" %>
            <%@ include file="/WEB-INF/views/common/navbar.jsp" %>
        </div>
        
        <script>
            window.contextPath = "${pageContext.request.contextPath}";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/components/search-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/components/header.js"></script>

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
