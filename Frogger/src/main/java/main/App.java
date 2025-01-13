package main;

import Controllers.GameController;
import org.newdawn.slick.AppGameContainer;
import org.newdawn.slick.BasicGame;
import org.newdawn.slick.GameContainer;
import org.newdawn.slick.Graphics;
import org.newdawn.slick.SlickException;

public class App extends BasicGame {
    public static final int SCREEN_WIDTH = 1024;
    public static final int SCREEN_HEIGHT = 768;

    private GameController controller;

    public static final int LEFT_EDGE = 0;
    public static final int END = 0;  // Replace with the actual end condition value
    public static final int CONTINUE = 1;  // Replace with the actual continue condition value

    public App() {
        super("Shadow Leap MVC");
    }

    @Override
    public void init(GameContainer gc) {
        try {
            controller = new GameController();
            controller.init(gc);

            // Disable JInput plugin for controllers to avoid warnings
            System.setProperty("net.java.games.input.useDefaultPlugin", "false");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(GameContainer gc, int delta) {
        try {
            controller.update(gc, delta);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void render(GameContainer gc, Graphics g) {
        try {
            controller.render(gc, g);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws SlickException {
        AppGameContainer app = new AppGameContainer(new App());
        app.setDisplayMode(SCREEN_WIDTH, SCREEN_HEIGHT, false);
        app.setShowFPS(false);
        app.start();
    }
}
