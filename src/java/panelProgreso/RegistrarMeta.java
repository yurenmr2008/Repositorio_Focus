package panelProgreso;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegistrarMeta")
public class RegistrarMeta extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener parámetros del formulario
        String nomMet = request.getParameter("nomMet");
        String desMet = request.getParameter("desMet");
        String idEstStr = request.getParameter("idEstudiante");

        if (nomMet != null && desMet != null && idEstStr != null) {
            int idEst = Integer.parseInt(idEstStr);

            PanelProgresoDAO dao = new PanelProgresoDAO();
            dao.insertarMeta(idEst, nomMet, desMet);
        }

        // Redirigir al panel de progreso
        response.sendRedirect("PanelProgreso/PanelProgreso.jsp?idEstudiante="+idEstStr );
    }
}
