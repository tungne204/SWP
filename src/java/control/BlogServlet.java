/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package control;

import dao.BlogDAO;
import entity.Blog;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Quang Anh
 */
@WebServlet(name = "BlogServlet", urlPatterns = {"/blog"})
public class BlogServlet extends HttpServlet {

    private BlogDAO blogDAO = new BlogDAO();
    private static final int PAGE_SIZE = 6;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BlogServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BlogServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listBlogs(request, response);
                break;
            case "view":
                viewBlog(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBlog(request, response);
                break;
            case "search":
                searchBlogs(request, response);
                break;
            case "category":
                filterByCategory(request, response);
                break;
            default:
                listBlogs(request, response);
                break;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            insertBlog(request, response);
        } else if ("update".equals(action)) {
            updateBlog(request, response);
        }
    }

    // List all blogs with pagination
    private void listBlogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Blog> blogs = blogDAO.getAllBlogs(page, PAGE_SIZE);
        int totalBlogs = blogDAO.getTotalBlogs();
        int totalPages = (int) Math.ceil((double) totalBlogs / PAGE_SIZE);

        List<String> categories = blogDAO.getAllCategories();

        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("blog/blog-list.jsp").forward(request, response);
    }

    // View single blog
    private void viewBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int blogId = Integer.parseInt(request.getParameter("id"));
        Blog blog = blogDAO.getBlogById(blogId);

        if (blog != null) {
            blogDAO.increaseViewCount(blogId);
            request.setAttribute("blog", blog);
            request.getRequestDispatcher("blog/blog-detail.jsp").forward(request, response);
        } else {
            response.sendRedirect("blog?action=list");
        }
    }

    // Show add blog form
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> categories = blogDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("blog/blog-form.jsp").forward(request, response);
    }

    // Show edit blog form
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int blogId = Integer.parseInt(request.getParameter("id"));
        Blog blog = blogDAO.getBlogById(blogId);
        List<String> categories = blogDAO.getAllCategories();

        request.setAttribute("blog", blog);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("blog/blog-form.jsp").forward(request, response);
    }

    // Insert new blog
    private void insertBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Integer userId = null;

        if (session != null && session.getAttribute("acc") != null) {
            entity.User acc = (entity.User) session.getAttribute("acc");
            userId = acc.getUserId(); // ✅ Lấy userId từ đối tượng acc
        }

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        String thumbnail = request.getParameter("thumbnail");
        boolean status = "1".equals(request.getParameter("status"));

        Blog blog = new Blog();
        blog.setTitle(title);
        blog.setContent(content);
        blog.setAuthorId(userId);
        blog.setCategory(category);
        blog.setThumbnail(thumbnail);
        blog.setStatus(status);

        boolean success = blogDAO.insertBlog(blog);

        if (success) {
            request.setAttribute("message", "Thêm bài viết thành công!");
        } else {
            request.setAttribute("error", "Thêm bài viết thất bại!");
        }

        response.sendRedirect("blog?action=list");
    }

    // Update blog
    private void updateBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int blogId = Integer.parseInt(request.getParameter("blogId"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        String thumbnail = request.getParameter("thumbnail");
        boolean status = "1".equals(request.getParameter("status"));

        Blog blog = new Blog();
        blog.setBlogId(blogId);
        blog.setTitle(title);
        blog.setContent(content);
        blog.setCategory(category);
        blog.setThumbnail(thumbnail);
        blog.setStatus(status);

        boolean success = blogDAO.updateBlog(blog);

        if (success) {
            request.setAttribute("message", "Cập nhật bài viết thành công!");
        } else {
            request.setAttribute("error", "Cập nhật bài viết thất bại!");
        }

        response.sendRedirect("blog?action=list");
    }

    // Delete blog
    private void deleteBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int blogId = Integer.parseInt(request.getParameter("id"));
        boolean success = blogDAO.deleteBlog(blogId);

        if (success) {
            request.setAttribute("message", "Xóa bài viết thành công!");
        } else {
            request.setAttribute("error", "Xóa bài viết thất bại!");
        }

        response.sendRedirect("blog?action=list");
    }

    // Search blogs
    private void searchBlogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Blog> blogs = blogDAO.searchBlogs(keyword, page, PAGE_SIZE);
        List<String> categories = blogDAO.getAllCategories();

        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("keyword", keyword);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("blog/blog-list.jsp").forward(request, response);
    }

    // Filter by category
    private void filterByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("cat");
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Blog> blogs = blogDAO.getBlogsByCategory(category, page, PAGE_SIZE);
        List<String> categories = blogDAO.getAllCategories();

        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("blog/blog-list.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
