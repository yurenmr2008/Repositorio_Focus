package panelProgreso;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegistrarMetaCompletada")
public class RegistrarMetaCompletada extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idEstStr = request.getParameter("idEstudiante");
        String idMetStr = request.getParameter("id_met");

        if (idEstStr != null && idMetStr != null) {
            int idEst = Integer.parseInt(idEstStr);
            int idMet = Integer.parseInt(idMetStr);

            PanelProgresoDAO dao = new PanelProgresoDAO();
            dao.insertarMetaCompletada(idEst, idMet);
        }

        // Redirige al panel de progreso o a la vista que prefieras
        response.sendRedirect("PanelProgreso/PanelProgreso.jsp?idEstudiante="+idEstStr );
    }
}
