package controller;

import model.World;
import org.newdawn.slick.GameContainer;
import org.newdawn.slick.Graphics;
import org.newdawn.slick.Input;
import org.newdawn.slick.SlickException;
import view.GameView;

public class GameController {
    private static final String LEVEL_0 = "assets/levels/0.lvl";
    private static final String LEVEL_1 = "assets/levels/1.lvl";
    private static final int START_LIVES = 3;

    private World world;
    private GameView view;
    private int currentLevel;

    public GameController() {
        this.view = new GameView();
    }

    public void init(GameContainer gc) throws SlickException {
        currentLevel = 0;
        world = new World(LEVEL_0, START_LIVES);
    }

    public void update(GameContainer gc, int delta) throws SlickException {
        Input input = gc.getInput();
        int code = world.update(input, delta);

        if (code == World.END) {
            gc.exit();
        } else if (code != World.CONTINUE) {
            if (currentLevel == 0) {
                world = new World(LEVEL_1, code);
                currentLevel = 1;
            } else {
                gc.exit();
            }
        }
    }

    public void render(GameContainer gc, Graphics g) throws SlickException {
        view.render(world, g);
    }
}
