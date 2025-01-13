package Controllers;

import org.newdawn.slick.GameContainer;
import org.newdawn.slick.Graphics;
import org.newdawn.slick.Input;
import org.newdawn.slick.SlickException;
import views.GameView;
import models.World;

public class GameController {
    private static final String[] LEVELS = {"assets/levels/0.lvl", "assets/levels/1.lvl"};
    private static final int START_LIVES = 3;
    public static final int CONTINUE = 0; // Game is still running
    public static final int END = -1;     // Game has ended

    private World world;
    private GameView view;
    private int currentLevel;

    public GameController() {
        this.view = new GameView();
    }

    public void init(GameContainer gc) throws SlickException {
        currentLevel = 0;
        world = new World(LEVELS[currentLevel], START_LIVES);
    }

    public void update(GameContainer gc, int delta) throws SlickException {
        Input input = gc.getInput();
        int code = world.update(input, delta);

        if (code == World.END) {
            gc.exit();
        } else if (code != World.CONTINUE) {
            changeLevel(code, gc);
        }
    }

    public void render(GameContainer gc, Graphics g) throws SlickException {
        view.render(world, g);
    }

    private void changeLevel(int playerLives, GameContainer gc) throws SlickException {
        if (currentLevel < LEVELS.length - 1) {
            currentLevel++;
            world = new World(LEVELS[currentLevel], playerLives);
        } else {
            gc.exit(); // End the game if no more levels.
        }
    }
}
