package entity;

import java.sql.Timestamp;

/**
 * Entity đại diện cho bảng News trong CSDL.
 * Mỗi đối tượng News tương ứng với một bản ghi trong bảng dbo.News.
 * Created by DungPhan - News Manager Module.
 */
public class News {

    private int newsId;              // Mã tin tức (news_id)
    private String title;            // Tiêu đề chính
    private String subtitle;         // Tiêu đề phụ
    private String slug;             // Đường dẫn thân thiện (SEO)
    private String content;          // Nội dung bài viết
    private String thumbnail;        // Link ảnh minh họa
    private int categoryId;          // Mã danh mục
    private int authorId;            // Mã người viết
    private boolean status;          // 1 = hiển thị, 0 = ẩn
    private Timestamp createdDate;   // Ngày tạo
    private Timestamp updatedDate;   // Ngày cập nhật

    // ==============================
    // Constructors
    // ==============================
    public News() {
    }

    public News(int newsId, String title, String subtitle, String slug, String content,
                String thumbnail, int categoryId, int authorId, boolean status,
                Timestamp createdDate, Timestamp updatedDate) {
        this.newsId = newsId;
        this.title = title;
        this.subtitle = subtitle;
        this.slug = slug;
        this.content = content;
        this.thumbnail = thumbnail;
        this.categoryId = categoryId;
        this.authorId = authorId;
        this.status = status;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // ==============================
    // Getters & Setters
    // ==============================
    public int getNewsId() {
        return newsId;
    }

    public void setNewsId(int newsId) {
        this.newsId = newsId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }

    // ==============================
    // ToString for Debugging
    // ==============================
    @Override
    public String toString() {
        return "News{" +
                "newsId=" + newsId +
                ", title='" + title + '\'' +
                ", subtitle='" + subtitle + '\'' +
                ", slug='" + slug + '\'' +
                ", content='" + (content != null ? content.substring(0, Math.min(50, content.length())) + "..." : null) + '\'' +
                ", thumbnail='" + thumbnail + '\'' +
                ", categoryId=" + categoryId +
                ", authorId=" + authorId +
                ", status=" + status +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                '}';
    }
}
