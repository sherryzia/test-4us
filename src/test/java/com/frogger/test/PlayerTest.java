package com.frogger.test;

import com.frogger.model.Player;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for the Player class.
 */
public class PlayerTest {

    @Test
    public void testMoveUp() {
        Player player = new Player();
        int initialY = player.getY();
        player.moveUp();
        assertEquals(initialY + 1, player.getY(), "Player should move up by 1 unit.");
    }

    @Test
    public void testMoveDown() {
        Player player = new Player();
        player.moveUp(); // Move up to ensure we're not at the initial boundary
        int initialY = player.getY();
        player.moveDown();
        assertEquals(initialY - 1, player.getY(), "Player should move down by 1 unit.");
    }

    @Test
    public void testMoveLeft() {
        Player player = new Player();
        int initialX = player.getX();
        player.moveLeft();
        assertEquals(initialX - 1, player.getX(), "Player should move left by 1 unit.");
    }

    @Test
    public void testMoveRight() {
        Player player = new Player();
        int initialX = player.getX();
        player.moveRight();
        assertEquals(initialX + 1, player.getX(), "Player should move right by 1 unit.");
    }

    @Test
    public void testLoseLife() {
        Player player = new Player();
        int initialLives = player.getLives();
        player.loseLife();
        assertEquals(initialLives - 1, player.getLives(), "Player should lose one life.");
    }

    @Test
    public void testCannotMoveBelowBoundary() {
        Player player = new Player();
        player.moveDown(); // Already at y = 0
        assertEquals(0, player.getY(), "Player should not move below y = 0.");
    }

    @Test
    public void testPlayerStartsWithThreeLives() {
        Player player = new Player();
        assertEquals(3, player.getLives(), "Player should start with 3 lives.");
    }
}
