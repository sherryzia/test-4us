package com.frogger.model;

import com.frogger.controller.Obstacle;
import com.frogger.controller.Player;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class GameModel {
    private static final int GRID_WIDTH = 10;
    private Player player;
    private List<Obstacle> obstacles;
    private PowerUp powerUp;
    private int score;
    private int level;

    public GameModel() {
        this.player = new Player();
        this.obstacles = new ArrayList<>();
        this.score = 0;
        this.level = 1;
        generateObstacles();
        spawnPowerUp();
    }

    private void generateObstacles() {
        obstacles.clear();
        for (int i = 0; i < level + 2; i++) {
            obstacles.add(new Obstacle(i * 2, level));
        }
    }

    private void spawnPowerUp() {
        Random random = new Random();
        int x = random.nextInt(GRID_WIDTH);
        int y = random.nextInt(level + 1); // Spawn within the current level range
        powerUp = new PowerUp(x, y);
    }

    public void update() {
        for (Obstacle obstacle : obstacles) {
            obstacle.move();
            if (obstacle.collidesWith(player)) {
                player.loseLife();
                if (player.getLives() <= 0) {
                    System.out.println("Game Over!");
                    System.exit(0);
                }
            }
        }

        if (powerUp != null && powerUp.collidesWith(player)) {
            player.gainLife();
            System.out.println("Power-Up Collected! Extra life gained.");
            powerUp = null; // Remove the power-up after collection
        }

        if (player.getY() >= level) {
            score += 10;
            level++;
            player = new Player(); // Reset player position
            generateObstacles();
            spawnPowerUp(); // Spawn a new power-up for the next level
            System.out.println("Level Up! Current level: " + level);
        }
    }

    public Player getPlayer() {
        return player;
    }

    public List<Obstacle> getObstacles() {
        return obstacles;
    }

    public PowerUp getPowerUp() {
        return powerUp;
    }

    public int getScore() {
        return score;
    }
}
