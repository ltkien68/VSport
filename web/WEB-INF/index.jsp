<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>

<%
    response.sendRedirect(request.getContextPath() + "/trang_chu");
%>
