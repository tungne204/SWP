package dao;

import context.DBContext;
import entity.News;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * NewsDAO - xử lý truy vấn cho bảng News (cả frontend & admin)
 */
public class NewsDAO {

    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    /* ==================== FRONTEND ==================== */

    public List<News> getAllNews() {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM News WHERE status = 1 ORDER BY created_date DESC";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractNews(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }
        return list;
    }

    public News getNewsById(int id) {
        String sql = "SELECT * FROM News WHERE news_id = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractNews(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }
        return null;
    }

    public List<News> getLatestNews() {
        List<News> list = new ArrayList<>();
        String sql = "SELECT TOP 5 * FROM News WHERE status = 1 ORDER BY created_date DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractNews(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }
        return list;
    }

    public List<News> getRelatedNews(int categoryId, int excludeId) {
        List<News> list = new ArrayList<>();
        String sql = "SELECT TOP 5 * FROM News WHERE category_id = ? AND news_id <> ? AND status = 1 ORDER BY created_date DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setInt(2, excludeId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractNews(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }
        return list;
    }

    /* ==================== ADMIN / MANAGER ==================== */

    // Lấy tất cả tin (kể cả ẩn)
    public List<News> getAllNewsForAdmin() {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM News ORDER BY created_date DESC";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractNews(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }
        return list;
    }

    // Thêm tin mới
    public boolean insertNews(News n) {
        String sql = "INSERT INTO News (title, subtitle, slug, content, thumbnail, category_id, author_id, status, created_date, updated_date) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, n.getTitle());
            ps.setString(2, n.getSubtitle());
            ps.setString(3, n.getSlug());
            ps.setString(4, n.getContent());
            ps.setString(5, n.getThumbnail());
            ps.setInt(6, n.getCategoryId());
            ps.setInt(7, n.getAuthorId());
            ps.setBoolean(8, n.isStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }
        return false;
    }

    // Cập nhật tin
    public boolean updateNews(News n) {
        String sql = "UPDATE News SET title=?, subtitle=?, slug=?, content=?, thumbnail=?, category_id=?, author_id=?, status=?, updated_date=GETDATE() "
                   + "WHERE news_id=?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, n.getTitle());
            ps.setString(2, n.getSubtitle());
            ps.setString(3, n.getSlug());
            ps.setString(4, n.getContent());
            ps.setString(5, n.getThumbnail());
            ps.setInt(6, n.getCategoryId());
            ps.setInt(7, n.getAuthorId());
            ps.setBoolean(8, n.isStatus());
            ps.setInt(9, n.getNewsId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }
        return false;
    }

    // Xóa tin
    public boolean deleteNews(int id) {
        String sql = "DELETE FROM News WHERE news_id = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }
        return false;
    }

    // Đổi trạng thái ẩn/hiện tin
    public boolean changeStatus(int id, boolean newStatus) {
        String sql = "UPDATE News SET status = ?, updated_date = GETDATE() WHERE news_id = ?";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, newStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }
        return false;
    }

    /* ==================== UTILITIES ==================== */

    private News extractNews(ResultSet rs) throws SQLException {
        News n = new News();
        n.setNewsId(rs.getInt("news_id"));
        n.setTitle(rs.getString("title"));
        n.setSubtitle(rs.getString("subtitle"));
        n.setSlug(rs.getString("slug"));
        n.setContent(rs.getString("content"));
        n.setThumbnail(rs.getString("thumbnail"));
        n.setCategoryId(rs.getInt("category_id"));
        n.setAuthorId(rs.getInt("author_id"));
        n.setStatus(rs.getBoolean("status"));
        n.setCreatedDate(rs.getTimestamp("created_date"));
        n.setUpdatedDate(rs.getTimestamp("updated_date"));
        return n;
    }

    private void close() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
