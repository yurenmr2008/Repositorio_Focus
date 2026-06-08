package mx.focus.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter(urlPatterns = {"/moduloCuestionarios/*", "/moduloMatematicasInteractivas/*", "/GuardarRetro", "/ServletGuardarResultado", "/ObtenerTemasRetro", "/MarcarCompletado"})
public class AuthFilter implements Filter {
    @Override public void init(FilterConfig cfg) {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idEstudiante") == null) {
            response.sendRedirect(request.getContextPath() + "/iniciar.jsp");
            return;
        }

        // Mapear atributos para compatibilidad con módulos existentes
        Object idEstudiante = session.getAttribute("idEstudiante");
        if (idEstudiante != null) session.setAttribute("id_est", idEstudiante);

        Object nombreEstudiante = session.getAttribute("nombreEstudiante");
        if (nombreEstudiante != null) session.setAttribute("nombre", nombreEstudiante);

        chain.doFilter(request, response);
    }

    @Override public void destroy() {}
}
