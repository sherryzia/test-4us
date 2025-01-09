package com.frogger.controller;

import com.frogger.model.Player;

public class Obstacle {
    private int x;
    private int y;

    public Obstacle(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public void move() {
        x = (x + 1) % 10; // Moves in a loop
    }

    public int getX() { return x; }
    public int getY() { return y; }

    public boolean collidesWith(Player player) {
        return this.x == player.getX() && this.y == player.getY();
    }
}
