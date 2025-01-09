package com.frogger.controller;

import com.frogger.view.GameView;

import java.util.Scanner;

public class GameController {
    private GameModel gameModel;
    private GameView gameView;
    private Scanner scanner;

    public GameController() {
        this.gameModel = new GameModel();
        this.gameView = new GameView();
        this.scanner = new Scanner(System.in);
    }

    public void startGame() {
        while (true) {
            gameView.render(gameModel);
            System.out.print("Enter move (w/a/s/d): ");
            String move = scanner.nextLine();

            switch (move) {
                case "w": gameModel.getPlayer().moveUp(); break;
                case "s": gameModel.getPlayer().moveDown(); break;
                case "a": gameModel.getPlayer().moveLeft(); break;
                case "d": gameModel.getPlayer().moveRight(); break;
                default: System.out.println("Invalid move!");
            }

            gameModel.update();
        }
    }
}
