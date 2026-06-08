<%-- 
    Document   : seguridad
    Created on : 7 jun 2026, 15:09:00
    Author     : yuren
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
if(session.getAttribute("idEstudiante") == null){
    response.sendRedirect(request.getContextPath() + "/jsp/iniciar.jsp");
    return;
}
%>