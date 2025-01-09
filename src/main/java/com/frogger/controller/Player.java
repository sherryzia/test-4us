package com.frogger.controller;

public class Player {
    private int x;
    private int y;
    private int lives;

    public Player() {
        this.x = 5; // Starting position
        this.y = 0;
        this.lives = 3;
    }

    public void moveUp() {
        y++;
    }

    public void moveDown() {
        if (y > 0) y--;
    }

    public void moveLeft() {
        if (x > 0) x--;
    }

    public void moveRight() {
        if (x < 10) x++;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public int getLives() {
        return lives;
    }

    public void loseLife() {
        lives--;
    }

    public void gainLife() {
        lives++;
    }
}
