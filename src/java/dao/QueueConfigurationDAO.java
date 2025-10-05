package dao;

import context.DBContext;
import entity.QueueConfiguration;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QueueConfigurationDAO extends DBContext {

    // Create a new queue configuration
    public void createQueueConfiguration(QueueConfiguration config) {
        String sql = "INSERT INTO QueueConfiguration (config_key, config_value, description) VALUES (?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, config.getConfigKey());
            ps.setString(2, config.getConfigValue());
            ps.setString(3, config.getDescription());
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get queue configuration by key
    public QueueConfiguration getQueueConfigurationByKey(String configKey) {
        String sql = "SELECT * FROM QueueConfiguration WHERE config_key = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, configKey);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    QueueConfiguration config = new QueueConfiguration();
                    config.setConfigId(rs.getInt("config_id"));
                    config.setConfigKey(rs.getString("config_key"));
                    config.setConfigValue(rs.getString("config_value"));
                    config.setDescription(rs.getString("description"));
                    return config;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all queue configurations
    public List<QueueConfiguration> getAllQueueConfigurations() {
        List<QueueConfiguration> configs = new ArrayList<>();
        String sql = "SELECT * FROM QueueConfiguration";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                QueueConfiguration config = new QueueConfiguration();
                config.setConfigId(rs.getInt("config_id"));
                config.setConfigKey(rs.getString("config_key"));
                config.setConfigValue(rs.getString("config_value"));
                config.setDescription(rs.getString("description"));
                configs.add(config);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return configs;
    }

    // Update queue configuration value
    public void updateQueueConfigurationValue(String configKey, String configValue) {
        String sql = "UPDATE QueueConfiguration SET config_value = ? WHERE config_key = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, configValue);
            ps.setString(2, configKey);
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Delete queue configuration by key
    public void deleteQueueConfiguration(String configKey) {
        String sql = "DELETE FROM QueueConfiguration WHERE config_key = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, configKey);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}