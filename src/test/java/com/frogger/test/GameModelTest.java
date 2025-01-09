package com.frogger.test;

import com.frogger.model.GameModel;
import com.frogger.model.Player;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for the GameModel class.
 */
public class GameModelTest {

    @Test
    public void testPlayerInitialPosition() {
        GameModel gameModel = new GameModel();
        Player player = gameModel.getPlayer();
        assertEquals(5, player.getX(), "Player should start at x = 5.");
        assertEquals(0, player.getY(), "Player should start at y = 0.");
    }

    @Test
    public void testScoreIncreasesOnLevelUp() {
        GameModel gameModel = new GameModel();
        Player player = gameModel.getPlayer();

        // Simulate moving to next level
        for (int i = 0; i <= gameModel.getPlayer().getY(); i++) {
            player.moveUp();
        }
        gameModel.update();
        assertEquals(10, gameModel.getScore(), "Score should increase by 10 on level up.");
    }

    @Test
    public void testGameEndsWhenLivesDeplete() {
        GameModel gameModel = new GameModel();
        Player player = gameModel.getPlayer();

        player.loseLife();
        player.loseLife();
        player.loseLife();

        // Simulate game loop with no lives
        assertDoesNotThrow(gameModel::update, "Game should handle game over gracefully.");
    }
}
