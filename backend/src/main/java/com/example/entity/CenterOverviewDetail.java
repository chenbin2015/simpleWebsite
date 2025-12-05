package com.example.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "center_overview_detail")
public class CenterOverviewDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "video_url", length = 500)
    private String videoUrl;
    
    @Column(name = "video_url_external", length = 500)
    private String videoUrlExternal;
    
    @Column(name = "main_title", nullable = false, length = 200)
    private String mainTitle;
    
    @Column(columnDefinition = "TEXT")
    private String background;
    
    @Column(columnDefinition = "TEXT")
    private String overview;
    
    @Column(columnDefinition = "TEXT")
    private String vision;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    public CenterOverviewDetail() {
    }
    
    public CenterOverviewDetail(String videoUrl, String videoUrlExternal, String mainTitle, 
                                 String background, String overview, String vision) {
        this.videoUrl = videoUrl;
        this.videoUrlExternal = videoUrlExternal;
        this.mainTitle = mainTitle;
        this.background = background;
        this.overview = overview;
        this.vision = vision;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getVideoUrl() {
        return videoUrl;
    }
    
    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }
    
    public String getVideoUrlExternal() {
        return videoUrlExternal;
    }
    
    public void setVideoUrlExternal(String videoUrlExternal) {
        this.videoUrlExternal = videoUrlExternal;
    }
    
    public String getMainTitle() {
        return mainTitle;
    }
    
    public void setMainTitle(String mainTitle) {
        this.mainTitle = mainTitle;
    }
    
    public String getBackground() {
        return background;
    }
    
    public void setBackground(String background) {
        this.background = background;
    }
    
    public String getOverview() {
        return overview;
    }
    
    public void setOverview(String overview) {
        this.overview = overview;
    }
    
    public String getVision() {
        return vision;
    }
    
    public void setVision(String vision) {
        this.vision = vision;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}



