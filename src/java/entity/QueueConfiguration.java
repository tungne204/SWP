package entity;

public class QueueConfiguration {
    private int configId;
    private String configKey;
    private String configValue;
    private String description;

    public QueueConfiguration() {
    }

    public QueueConfiguration(int configId, String configKey, String configValue, String description) {
        this.configId = configId;
        this.configKey = configKey;
        this.configValue = configValue;
        this.description = description;
    }

    // Getter & Setter
    public int getConfigId() {
        return configId;
    }

    public void setConfigId(int configId) {
        this.configId = configId;
    }

    public String getConfigKey() {
        return configKey;
    }

    public void setConfigKey(String configKey) {
        this.configKey = configKey;
    }

    public String getConfigValue() {
        return configValue;
    }

    public void setConfigValue(String configValue) {
        this.configValue = configValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}