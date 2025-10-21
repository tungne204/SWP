package control;

import dao.NewsDAO;
import entity.News;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet điều khiển hiển thị trang chi tiết tin tức.
 * URL: /news?newsId=...
 */
@WebServlet(name = "NewsServlet", urlPatterns = {"/news"})
public class NewsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("newsId");

            if (idParam == null || idParam.isEmpty()) {
                // Nếu không có ID → redirect về trang danh sách News
                response.sendRedirect("NewsList.jsp");
                return;
            }

            int newsId = Integer.parseInt(idParam);

            // Gọi DAO để lấy dữ liệu
            NewsDAO dao = new NewsDAO();
            News news = dao.getNewsById(newsId);

            if (news == null) {
                // Không tìm thấy bài viết → báo lỗi
                request.setAttribute("error", "Bài viết không tồn tại hoặc đã bị xóa.");
                request.getRequestDispatcher("News.jsp").forward(request, response);
                return;
            }

            // Lấy các bài viết liên quan & mới nhất
            List<News> relatedNews = dao.getRelatedNews(news.getCategoryId(), newsId);
            List<News> latestNews = dao.getLatestNews();

            // Gửi dữ liệu sang JSP
            request.setAttribute("news", news);
            request.setAttribute("relatedNews", relatedNews);
            request.setAttribute("latestNews", latestNews);

            // Forward sang trang News.jsp
            request.getRequestDispatcher("News.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading news detail");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet hiển thị chi tiết tin tức - Medilab";
    }
}
