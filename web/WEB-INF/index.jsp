<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<%
    response.sendRedirect(request.getContextPath() + "/trang_chu");
%>