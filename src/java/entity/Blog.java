/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.sql.Timestamp;

public class Blog {
    private int blogId;
    private String title;
    private String content;
    private int authorId;
    private String authorName;
    private String category;
    private String thumbnail;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    private boolean status;
    private int views;

    // Constructors
    public Blog() {
    }

    public Blog(int blogId, String title, String content, int authorId, String category, 
                String thumbnail, Timestamp createdDate, Timestamp updatedDate, 
                boolean status, int views) {
        this.blogId = blogId;
        this.title = title;
        this.content = content;
        this.authorId = authorId;
        this.category = category;
        this.thumbnail = thumbnail;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
        this.status = status;
        this.views = views;
    }

    // Getters and Setters
    public int getBlogId() {
        return blogId;
    }

    public void setBlogId(int blogId) {
        this.blogId = blogId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
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

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    // Get excerpt (first 200 characters)
    public String getExcerpt() {
        if (content != null && content.length() > 200) {
            return content.substring(0, 200) + "...";
        }
        return content;
    }

    @Override
    public String toString() {
        return "Blog{" +
                "blogId=" + blogId +
                ", title='" + title + '\'' +
                ", authorId=" + authorId +
                ", category='" + category + '\'' +
                ", createdDate=" + createdDate +
                ", status=" + status +
                ", views=" + views +
                '}';
    }
}
