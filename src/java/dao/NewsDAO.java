package dao;

import context.DBContext;
import entity.News;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NewsDAO extends DBContext {

    // 🟢 Lấy tất cả bài viết
    public List<News> getAllNews() {
        List<News> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.News ORDER BY news_id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                News n = new News(
                        rs.getInt("news_id"),
                        rs.getString("title"),
                        rs.getString("subtitle"),
                        rs.getString("slug"),
                        rs.getString("content"),
                        rs.getString("thumbnail"),
                        rs.getInt("category_id"),
                        rs.getInt("author_id"),
                        rs.getBoolean("status"),
                        rs.getTimestamp("created_date"),
                        rs.getTimestamp("updated_date")
                );
                list.add(n);
            }

        } catch (Exception e) {
            System.out.println("[getAllNews] lỗi: " + e.getMessage());
        }
        return list;
    }

    // 🟢 Thêm bài viết mới
    public void addNews(News n) {
        String sql = "INSERT INTO dbo.News (title, subtitle, slug, content, thumbnail, category_id, author_id, [status], created_date, updated_date) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, n.getTitle());
            ps.setNString(2, n.getSubtitle());
            ps.setNString(3, n.getSlug());
            ps.setNString(4, n.getContent());
            ps.setNString(5, n.getThumbnail());
            ps.setInt(6, n.getCategoryId());
            ps.setInt(7, n.getAuthorId());
            ps.setBoolean(8, n.isStatus());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("[addNews] lỗi: " + e.getMessage());
        }
    }

    // 🟢 Lấy bài viết theo ID
    public News getNewsById(int id) {
        String sql = "SELECT * FROM dbo.News WHERE news_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new News(
                        rs.getInt("news_id"),
                        rs.getString("title"),
                        rs.getString("subtitle"),
                        rs.getString("slug"),
                        rs.getString("content"),
                        rs.getString("thumbnail"),
                        rs.getInt("category_id"),
                        rs.getInt("author_id"),
                        rs.getBoolean("status"),
                        rs.getTimestamp("created_date"),
                        rs.getTimestamp("updated_date")
                );
            }
        } catch (Exception e) {
            System.out.println("[getNewsById] lỗi: " + e.getMessage());
        }
        return null;
    }

    // 🟢 Cập nhật bài viết
    public void updateNews(News n) {
        String sql = "UPDATE dbo.News SET title=?, subtitle=?, slug=?, content=?, thumbnail=?, category_id=?, author_id=?, [status]=?, updated_date=GETDATE() WHERE news_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, n.getTitle());
            ps.setNString(2, n.getSubtitle());
            ps.setNString(3, n.getSlug());
            ps.setNString(4, n.getContent());
            ps.setNString(5, n.getThumbnail());
            ps.setInt(6, n.getCategoryId());
            ps.setInt(7, n.getAuthorId());
            ps.setBoolean(8, n.isStatus());
            ps.setInt(9, n.getNewsId());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("[updateNews] lỗi: " + e.getMessage());
        }
    }

    // 🟢 Xóa bài viết
    public void deleteNews(int id) {
        String sql = "DELETE FROM dbo.News WHERE news_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("[deleteNews] lỗi: " + e.getMessage());
        }
    }

    // 🟢 Đổi trạng thái hiển thị
    public void toggleStatus(int id, boolean status) {
        String sql = "UPDATE dbo.News SET [status] = ?, updated_date = GETDATE() WHERE news_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("[toggleStatus] lỗi: " + e.getMessage());
        }
    }
}
