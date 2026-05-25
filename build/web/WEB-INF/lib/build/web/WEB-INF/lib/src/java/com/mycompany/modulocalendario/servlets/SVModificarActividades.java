/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
//Librerias Nuevas
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//Librerias para conexion a base de datos

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;

@WebServlet(name = "SVModificarActividades", urlPatterns = {"/SVModificarActividades"})
public class SVModificarActividades extends HttpServlet {

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
        
        String id_act = request.getParameter("idAct");
        String idCalendario = request.getParameter("idCal");
        String idEstudiante = request.getParameter("idEst");
        String idDia = request.getParameter("idDia");
        String boton = request.getParameter("botonSubmit");

        //Datos necesarios para el boton volver
        String year = request.getParameter("year");
        String numMes =  request.getParameter("numMes");
        
        if(boton.equals("Modificar")){
            System.out.println("Modificar");
            try{

                String nombreAct = request.getParameter("nombreAct"); 
                String descriptionAct = request.getParameter("descripcionAct"); 
                String estadoAct = request.getParameter("estadoAct"); 
                String prioridadAct = request.getParameter("prioridadAct");


                Connection conecta;
                PreparedStatement st;
                Class.forName("com.mysql.cj.jdbc.Driver");
                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root" , "n0m3l0");
                st = conecta.prepareStatement("UPDATE Actividad SET nom_act=?, des_act=?, est_act=?, pri_act=?  WHERE id_act=?;");
                st.setString(1,nombreAct);
                st.setString(2,descriptionAct);
                st.setString(3,estadoAct);
                st.setString(4,prioridadAct);
                st.setString(5,id_act);

                st.executeUpdate();
                System.out.println("Todo se ha modificado correctamente");

            }           
            catch(Exception e){
                System.out.println("Error." + e.getMessage());
                System.out.println("Casi");
            }
        }
        else{
            System.out.println("Eliminar");
            try{
                Connection conecta;
                PreparedStatement st;
                Class.forName("com.mysql.cj.jdbc.Driver");
                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/focus", "root" , "n0m3l0");
                st = conecta.prepareStatement("DELETE FROM Actividad WHERE id_act=?;");
                st.setString(1,id_act);

                st.executeUpdate();
                System.out.println("Todo se ha modificado correctamente");

            }           
            catch(Exception e){
                System.out.println("Error." + e.getMessage());
                System.out.println("Casi");
            }
        }
        
        
        
        //Se envian datos para poder regresar al mismo dia del mismo estudiante y calendario
        HttpSession misesion = request.getSession();
        misesion.setAttribute("idDia", idDia);
        misesion.setAttribute("idCal", idCalendario);
        misesion.setAttribute("idEst", idEstudiante);
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
