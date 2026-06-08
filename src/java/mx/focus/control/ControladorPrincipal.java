package mx.focus.control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ControladorPrincipal", urlPatterns = {"/inicio"})
public class ControladorPrincipal extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sesion = req.getSession();
        if (sesion.getAttribute("id_est") == null) {
            sesion.setAttribute("id_est", 1);
            sesion.setAttribute("nombre", "Alumno Ejemplo");
        }
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
