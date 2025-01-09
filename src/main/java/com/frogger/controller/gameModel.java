package com.frogger.model;

import java.util.ArrayList;
import java.util.List;

public class GameModel {
    private Player player;
    private List<Obstacle> obstacles;
    private int score;
    private int level;

    public GameModel() {
        this.player = new Player();
        this.obstacles = new ArrayList<>();
        this.score = 0;
        this.level = 1;
        generateObstacles();
    }

    private void generateObstacles() {
        obstacles.clear();
        for (int i = 0; i < level + 2; i++) {
            obstacles.add(new Obstacle(i * 2, level));
        }
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
        if (player.getY() >= level) {
            score += 10;
            level++;
            player = new Player(); // Reset player position
            generateObstacles();
            System.out.println("Level Up! Current level: " + level);
        }
    }

    public Player getPlayer() { return player; }
    public List<Obstacle> getObstacles() { return obstacles; }
    public int getScore() { return score; }
}
