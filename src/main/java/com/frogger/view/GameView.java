package com.frogger.view;

import com.frogger.controller.Obstacle;
import com.frogger.controller.Player;
import com.frogger.model.GameModel;

import com.frogger.model.PowerUp;

public class GameView {
    public void render(GameModel gameModel) {
        Player player = gameModel.getPlayer();
        System.out.println("Player Position: (" + player.getX() + ", " + player.getY() + ") Lives: " + player.getLives());

        for (Obstacle obstacle : gameModel.getObstacles()) {
            System.out.println("Obstacle at: (" + obstacle.getX() + ", " + obstacle.getY() + ")");
        }

        PowerUp powerUp = gameModel.getPowerUp();
        if (powerUp != null) {
            System.out.println("Power-Up at: (" + powerUp.getX() + ", " + powerUp.getY() + ")");
        }

        System.out.println("Score: " + gameModel.getScore());
        System.out.println("=====================");
    }
}
