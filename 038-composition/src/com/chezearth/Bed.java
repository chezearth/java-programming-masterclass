package com.chezearth;

public class Bed {
    private String size;
    private boolean isHidden;

    public Bed(String size, boolean isHidden) {
        this.size = size;
        this.isHidden = isHidden;
    }

    public String getSize() {
        return this.size;
    }

    public boolean isHidden() {
        return isHidden;
    }

    public void setHidden(boolean hidden) {
        this.isHidden = hidden;
    }
}

