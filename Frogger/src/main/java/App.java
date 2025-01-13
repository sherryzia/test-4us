import controller.GameController;
import org.newdawn.slick.AppGameContainer;
import org.newdawn.slick.BasicGame;
import org.newdawn.slick.GameContainer;
import org.newdawn.slick.Graphics;
import org.newdawn.slick.SlickException;

public class App extends BasicGame {
    public static final int SCREEN_WIDTH = 1024;
    public static final int SCREEN_HEIGHT = 768;

    private GameController controller;

    public App() {
        super("Shadow Leap MVC");
    }

    @Override
    public void init(GameContainer gc) throws SlickException {
        controller = new GameController();
        controller.init(gc);
    }

    @Override
    public void update(GameContainer gc, int delta) throws SlickException {
        controller.update(gc, delta);
    }

    @Override
    public void render(GameContainer gc, Graphics g) throws SlickException {
        controller.render(gc, g);
    }

    public static void main(String[] args) throws SlickException {
        AppGameContainer app = new AppGameContainer(new App());
        app.setDisplayMode(SCREEN_WIDTH, SCREEN_HEIGHT, false);
        app.setShowFPS(false);
        app.start();
    }
}
