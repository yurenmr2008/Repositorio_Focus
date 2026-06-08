package chat;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/chat/ChatServlet")

public class ChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idEst = Integer.parseInt(request.getParameter("idEstudiante"));
        String contenido = request.getParameter("contenido");

        String idEstStr = request.getParameter("idEstudiante");
        ChatDAO dao = new ChatDAO();
        dao.insertarMensaje(idEst, contenido);

        response.sendRedirect("../chat/Chat.jsp?idEstudiante="+idEstStr );
    }
}
