
package com.mycompany.modulocalendario.servlets;

import java.io.IOException;
import java.io.PrintWriter;

/*
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
*/
//Nuevas librerias
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//Librerias para conexion a base de datos

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;




@WebServlet(name = "SvGuardarActividades", urlPatterns = {"/SvGuardarActividades"})
public class SvGuardarActividades extends HttpServlet {


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		
        String id_calendario = request.getParameter("idCal");
        String id_est = request.getParameter("idEst");
        String id_dia = request.getParameter("idDia");
        //Datos necesarios para el boton volver
        String year = request.getParameter("year");
        String numMes =  request.getParameter("numMes");
        
        try{

            String nombreAct = request.getParameter("nombreAct"); 
            String descriptionAct = request.getParameter("descripcionAct"); 
            String estadoAct = request.getParameter("estadoAct"); 
            String prioridadAct = request.getParameter("prioridadAct");
            
            
            Connection conecta;
            PreparedStatement st;
            Class.forName("com.mysql.cj.jdbc.Driver");
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root" , "n0m3l0");
            st = conecta.prepareStatement("INSERT INTO Actividad (nom_act, des_act, fec_act, est_act, pri_act, hora_act, pos_act, id_dia, id_cal) VALUES (?,?,?,?,?,?,?,?,?)");
            st.setString(1,nombreAct);
            st.setString(2,descriptionAct);
            st.setString(3,"20/10/2025");
            st.setString(4,estadoAct);
            st.setString(5,prioridadAct);
            st.setString(6, "08:00:00");
            st.setString(7, "1");
            st.setString(8,id_dia);
            st.setString(9,id_calendario);

            st.executeUpdate();
            System.out.println("Todo se ha registrado correctamente");
            
        }           
        catch(Exception e){
            System.out.println("Error." + e.getMessage());
            System.out.println("Casi");
        }
        
        HttpSession misesion = request.getSession();
        misesion.setAttribute("idDia", id_dia);
        misesion.setAttribute("idCal", id_calendario);
        misesion.setAttribute("idEst", id_est);
        //Datos necesarios para el boton volver
        misesion.setAttribute("year", year);
        misesion.setAttribute("numMes", numMes);
        //Direccion a la que seran enviados estos datos
        response.sendRedirect("actividadesDia.jsp");
      
        
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
