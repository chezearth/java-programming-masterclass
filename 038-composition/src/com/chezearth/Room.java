package com.chezearth;

import java.awt.*;

public class Room {
    private String roomType;
    private Bed bed;
    private Cupboard cupboard;
    private Lamp lamp;
    private Window window;

    public Room(String roomType, Bed bed, Cupboard cupboard, Lamp lamp, Window window) {
        this.roomType = roomType;
        this.bed = bed;
        this.cupboard = cupboard;
        this.lamp = lamp;
        this.window = window;
    }

    public Bed getBed() {
        return bed;
    }

    public String getBedSize() {
        return bed.getSize();
    }

    public void hideBed() {
        bed.setHidden(true);
    }

}
