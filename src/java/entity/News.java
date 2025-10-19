package entity;

import java.sql.Timestamp;

/**
 * Entity đại diện cho bảng News trong CSDL.
 * Created by DungPhan - News Manager Module.
 */
public class News {
    private int newsId;
    private String title;
    private String subtitle;
    private String slug;
    private String content;
    private String thumbnail;
    private int categoryId;
    private int authorId;
    private boolean status;
    private Timestamp createdDate;
    private Timestamp updatedDate;

    public News() {}

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

    // Getters & Setters
    public int getNewsId() { return newsId; }
    public void setNewsId(int newsId) { this.newsId = newsId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getSubtitle() { return subtitle; }
    public void setSubtitle(String subtitle) { this.subtitle = subtitle; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }

    public Timestamp getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(Timestamp updatedDate) { this.updatedDate = updatedDate; }
}
