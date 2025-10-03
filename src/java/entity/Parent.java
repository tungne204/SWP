package entity;

public class Parent {
    private int parentId;
    private String parentname;
    private String idInfo;

    public Parent() {
    }

    public Parent(int parentId, String parentname, String idInfo) {
        this.parentId = parentId;
        this.parentname = parentname;
        this.idInfo = idInfo;
    }

    // Getter & Setter
    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public String getParentname() {
        return parentname;
    }

    public void setParentname(String parentname) {
        this.parentname = parentname;
    }

    public String getIdInfo() {
        return idInfo;
    }

    public void setIdInfo(String idInfo) {
        this.idInfo = idInfo;
    }
}