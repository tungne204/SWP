package control;

import dao.NewsDAO;
import entity.News;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/news")
public class NewsServlet extends HttpServlet {
    private NewsDAO dao = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<News> list = dao.getAllNews();
        req.setAttribute("listNews", list);
        req.getRequestDispatcher("news.jsp").forward(req, resp);
    }
}
