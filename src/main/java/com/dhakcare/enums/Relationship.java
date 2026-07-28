package com.dhakcare.enums;

public enum Relationship {
    SELF("Bản thân"),
    FATHER("Cha"),
    MOTHER("Mẹ"),
    BROTHER("Anh / Em trai"),
    SISTER("Chị / Em gái"),
    HUSBAND("Chồng"),
    WIFE("Vợ"),
    SON("Con trai"),
    DAUGHTER("Con gái"),
    OTHER("Người thân khác");

    private final String displayName;

    
    Relationship(String displayName) {
        this.displayName = displayName;
    }

    
    public String getDisplayName() {
        return displayName;
    }
}