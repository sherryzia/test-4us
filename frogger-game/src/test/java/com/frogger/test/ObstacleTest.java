package com.frogger.test;

import com.frogger.controller.Obstacle;
import com.frogger.controller.Player;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for the Obstacle class.
 */
public class ObstacleTest {

    @Test
    public void testObstacleMoves() {
        Obstacle obstacle = new Obstacle(0, 1);
        int initialX = obstacle.getX();
        obstacle.move();
        assertEquals((initialX + 1) % 10, obstacle.getX(), "Obstacle should move one unit and wrap around.");
    }

    @Test
    public void testObstacleCollisionWithPlayer() {
        Player player = new Player();
        Obstacle obstacle = new Obstacle(player.getX(), player.getY());
        assertTrue(obstacle.collidesWith(player), "Obstacle should collide with player at the same position.");
    }

    @Test
    public void testObstacleNoCollisionWithPlayer() {
        Player player = new Player();
        Obstacle obstacle = new Obstacle(player.getX() + 1, player.getY());
        assertFalse(obstacle.collidesWith(player), "Obstacle should not collide with player at different positions.");
    }
}
