<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>

<%
    String correo = request.getParameter("correo");
    String contrasena = request.getParameter("contrasena");

    boolean loginExitoso = false;

    if (correo != null && contrasena != null) {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/Focus?useSSL=false&serverTimezone=UTC",
                "root",
                "n0m3l0" 
            );


            PreparedStatement st = con.prepareStatement(
                "SELECT id_est, nom_est FROM Estudiante WHERE correo_est = ? AND con_est=?");
            st.setString(1, correo);
            st.setString(2, contrasena);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                int id_est = rs.getInt("id_est");
                String nombreEstudiante = rs.getString("nom_est");                 

                session.setAttribute("idEstudiante", id_est);
                session.setAttribute("correoEstudiante", correo);
                session.setAttribute("nombreEstudiante", nombreEstudiante); 
                loginExitoso = true;

            }
            else{
                loginExitoso = false;

            }

            rs.close();
            st.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    

    if (loginExitoso == true){
        response.sendRedirect("inicio.jsp"); 
    } 
    else {
        if (loginExitoso == false){
            response.sendRedirect("iniciar.jsp?error=1");
        }
    }
%>