package com.frogger;

import com.frogger.controller.GameController;

public class Main {
    public static void main(String[] args) {
        GameController gameController = new GameController();
        gameController.startGame();
    }
}
