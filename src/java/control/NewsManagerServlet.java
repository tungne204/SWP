package control;

import dao.NewsDAO;
import entity.News;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NewsManagerServlet", urlPatterns = {"/admin/news"})
public class NewsManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        NewsDAO dao = new NewsDAO();

        try {
            if (action == null || action.equals("list")) {
                // 🧾 Hiển thị danh sách tin tức
                List<News> list = dao.getAllNews();
                request.setAttribute("newsList", list);
                request.getRequestDispatcher("/admin/NewsManager.jsp").forward(request, response);

            } else if (action.equals("add")) {
                // 📝 Hiển thị form thêm
                request.getRequestDispatcher("/admin/addNews.jsp").forward(request, response);

            } else if (action.equals("edit")) {
                // ✏ Hiển thị form sửa
                int id = Integer.parseInt(request.getParameter("id"));
                News n = dao.getNewsById(id);
                request.setAttribute("news", n);
                request.getRequestDispatcher("/admin/editNews.jsp").forward(request, response);

            } else if (action.equals("delete")) {
                // 🗑 Xóa bài viết
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteNews(id);
                response.sendRedirect("news?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("news?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        NewsDAO dao = new NewsDAO();

        try {
            if ("insert".equals(action)) {
                // ➕ Thêm bài viết
                News n = new News();
                n.setTitle(request.getParameter("title"));
                n.setSubtitle(request.getParameter("subtitle"));
                n.setContent(request.getParameter("content"));
                n.setThumbnail(request.getParameter("thumbnail"));
                n.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
                n.setAuthorId(1); // Có thể thay bằng session.getUserId()
                n.setStatus(true);
                dao.insertNews(n);
                response.sendRedirect("news?action=list");

            } else if ("update".equals(action)) {
                // ✏ Cập nhật bài viết
                int id = Integer.parseInt(request.getParameter("newsId"));
                News n = new News();
                n.setNewsId(id);
                n.setTitle(request.getParameter("title"));
                n.setSubtitle(request.getParameter("subtitle"));
                n.setContent(request.getParameter("content"));
                n.setThumbnail(request.getParameter("thumbnail"));
                n.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
                n.setAuthorId(1);
                n.setStatus(true);
                dao.updateNews(n);
                response.sendRedirect("news?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("news?action=list");
        }
    }
}
