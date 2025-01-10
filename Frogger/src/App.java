
/**
 * Sample Project for SWEN20003: Object Oriented Software Development 2018
 * by Eleanor McMurtry, University of Melbourne
 */

import org.newdawn.slick.AppGameContainer;
import org.newdawn.slick.BasicGame;
import org.newdawn.slick.GameContainer;
import org.newdawn.slick.Graphics;
import org.newdawn.slick.SlickException;
import org.newdawn.slick.Input;

/**
 * Main class for the game. Handles initialisation, input and rendering.
 */
public class App extends BasicGame {
	/** screen width, in pixels */
	public static final int SCREEN_WIDTH = 1024;
	/** screen height, in pixels */
	public static final int SCREEN_HEIGHT = 768;
	/** Left hand x coordinate of screen. */
	public static final int LEFT_EDGE = 0;
	private static final String LVL0 = "assets/levels/0.lvl";
	private static final String LVL1 = "assets/levels/1.lvl";
	private static final int START_LIVES = 3;
	public static final int END = -1;
	public static final int CONTINUE = 0;
	private static int current;
	private World world;

	public App() {
		super("Shadow Leap");
	}

	@Override
	public void init(GameContainer gc) throws SlickException {
		world = new World(LVL0, START_LIVES);
		App.current = 0;
	}

	/**
	 * Update the game state for a frame.
	 * 
	 * @param gc    The Slick game container object.
	 * @param delta Time passed since last frame (milliseconds).
	 */
	@Override
	public void update(GameContainer gc, int delta) throws SlickException {
		// Get data about the current input (keyboard state).
		Input input = gc.getInput();

		int code = world.update(input, delta);
		
		/* Check if new level has been reached or user has lost. */
		if (code == END) {
			gc.exit();
			
		}
		if (code != CONTINUE) {
			if (current == 0) {
				/* Change level. */
				world = new World(LVL1, code);
				current = 1;
			} else {

				gc.exit();
			}
		}

	}

	/**
	 * Render the entire screen, so it reflects the current game state.
	 * 
	 * @param gc The Slick game container object.
	 * @param g  The Slick graphics object, used for drawing.
	 */
	public void render(GameContainer gc, Graphics g) throws SlickException {
		world.render(g);
	}

	/**
	 * Start-up method. Creates the game and runs it.
	 * 
	 * @param args Command-line arguments (ignored).
	 * @throws SlickException
	 */
	public static void main(String[] args) throws SlickException {

		AppGameContainer app = new AppGameContainer(new App());
		app.setShowFPS(false);
		app.setDisplayMode(SCREEN_WIDTH, SCREEN_HEIGHT, false);
		app.start();
	}

}