<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>

<%
String nombre = request.getParameter("nombre");
String correo = request.getParameter("correo");
String contrasena = request.getParameter("contrasena");
String fecha = request.getParameter("fch_nac");
String id_sem = request.getParameter("id_sem");

if (nombre != null && correo != null && contrasena != null && fecha != null && id_sem != null) {

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/focus?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
        "root",
        "n0m3l0"
    );

   
PreparedStatement st = con.prepareStatement(
    "INSERT INTO Estudiante (nom_est, con_est, correo_est, pun_est, id_sem) VALUES (?, ?, ?, 0, ?)"
);



st.setString(1, nombre);


st.setString(2, contrasena);


st.setString(3, correo);


//st.setString(4, fecha); No se ha integrado debido a que no esta en la base 


st.setInt(4, Integer.parseInt(id_sem));

st.executeUpdate();

    out.println("<script>alert('Registro exitoso'); window.location='iniciar.jsp';</script>");
}
%>