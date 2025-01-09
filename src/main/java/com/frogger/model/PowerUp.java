package com.frogger.model;

import com.frogger.controller.Player;

public class PowerUp {
    private int x;
    private int y;

    public PowerUp(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public boolean collidesWith(Player player) {
        return this.x == player.getX() && this.y == player.getY();
    }
}
