package dao;

import context.DBContext;
import entity.Blog;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BlogDAO extends DBContext {

    // Get all blogs with pagination
    public List<Blog> getAllBlogs(int page, int pageSize) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, u.username as author_name " +
                     "FROM Blog b " +
                     "LEFT JOIN [User] u ON b.author_id = u.user_id " +
                     "ORDER BY b.created_date DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBlogFromResultSet(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Get total number of blogs
    public int getTotalBlogs() {
        String sql = "SELECT COUNT(*) FROM Blog";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // Get blog by ID
    public Blog getBlogById(int blogId) {
        String sql = "SELECT b.*, u.username as author_name " +
                     "FROM Blog b " +
                     "LEFT JOIN [User] u ON b.author_id = u.user_id " +
                     "WHERE b.blog_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractBlogFromResultSet(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Search blogs by title or content
    public List<Blog> searchBlogs(String keyword, int page, int pageSize) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, u.username as author_name " +
                     "FROM Blog b " +
                     "LEFT JOIN [User] u ON b.author_id = u.user_id " +
                     "WHERE b.title LIKE ? OR b.content LIKE ? " +
                     "ORDER BY b.created_date DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, (page - 1) * pageSize);
            ps.setInt(4, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBlogFromResultSet(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Get blogs by category
    public List<Blog> getBlogsByCategory(String category, int page, int pageSize) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, u.username as author_name " +
                     "FROM Blog b " +
                     "LEFT JOIN [User] u ON b.author_id = u.user_id " +
                     "WHERE b.category = ? " +
                     "ORDER BY b.created_date DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBlogFromResultSet(rs));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Get all categories
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM Blog WHERE category IS NOT NULL";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return categories;
    }

    // Insert new blog
    public boolean insertBlog(Blog blog) {
        String sql = "INSERT INTO Blog (title, content, author_id, category, thumbnail, " +
                     "created_date, status, views) VALUES (?, ?, ?, ?, ?, GETDATE(), ?, 0)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getContent());
            ps.setInt(3, blog.getAuthorId());
            ps.setString(4, blog.getCategory());
            ps.setString(5, blog.getThumbnail());
            ps.setBoolean(6, blog.isStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Update blog
    public boolean updateBlog(Blog blog) {
        String sql = "UPDATE Blog SET title = ?, content = ?, category = ?, " +
                     "thumbnail = ?, updated_date = GETDATE(), status = ? " +
                     "WHERE blog_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getContent());
            ps.setString(3, blog.getCategory());
            ps.setString(4, blog.getThumbnail());
            ps.setBoolean(5, blog.isStatus());
            ps.setInt(6, blog.getBlogId());

            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Delete blog
    public boolean deleteBlog(int blogId) {
        String sql = "DELETE FROM Blog WHERE blog_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Increase view count
    public void increaseViewCount(int blogId) {
        String sql = "UPDATE Blog SET views = views + 1 WHERE blog_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (Exception ex) {
            Logger.getLogger(BlogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Helper method to extract Blog from ResultSet
    private Blog extractBlogFromResultSet(ResultSet rs) throws SQLException {
        Blog blog = new Blog();
        blog.setBlogId(rs.getInt("blog_id"));
        blog.setTitle(rs.getString("title"));
        blog.setContent(rs.getString("content"));
        blog.setAuthorId(rs.getInt("author_id"));
        blog.setAuthorName(rs.getString("author_name"));
        blog.setCategory(rs.getString("category"));
        blog.setThumbnail(rs.getString("thumbnail"));
        blog.setCreatedDate(rs.getTimestamp("created_date"));
        blog.setUpdatedDate(rs.getTimestamp("updated_date"));
        blog.setStatus(rs.getBoolean("status"));
        blog.setViews(rs.getInt("views"));
        return blog;
    }
}
