package entity.Receptionist;

/**
 * Entity Parent - đại diện cho thông tin người giám hộ
 * @author Kiên
 */
public class Parent {
    private int parentId;
    private String parentName;  

    public Parent() {
    }

    public Parent(int parentId, String parentName) {
        this.parentId = parentId;
        this.parentName = parentName;
    }

    // Getter & Setter
    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    

    @Override
    public String toString() {
        return "Parent{" +
                "parentId=" + parentId +
                ", parentName='" + parentName + '\'' +
                
                '}';
    }
}
