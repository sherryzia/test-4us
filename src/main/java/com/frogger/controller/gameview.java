package com.frogger.view;

import com.frogger.model.GameModel;
import com.frogger.model.Obstacle;
import com.frogger.model.Player;

public class GameView {
    public void render(GameModel gameModel) {
        Player player = gameModel.getPlayer();
        System.out.println("Player Position: (" + player.getX() + ", " + player.getY() + ") Lives: " + player.getLives());

        for (Obstacle obstacle : gameModel.getObstacles()) {
            System.out.println("Obstacle at: (" + obstacle.getX() + ", " + obstacle.getY() + ")");
        }

        System.out.println("Score: " + gameModel.getScore());
        System.out.println("=====================");
    }
}
