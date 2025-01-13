
/** Class for player in game. **/
package models;

import main.App;
import org.newdawn.slick.Image;
import org.newdawn.slick.Input;
import org.newdawn.slick.SlickException;

public class Player extends Sprite {

	/** Initial x coordinate for Player. */
	private static final int PLAYER_INIT_X = 512;
	/** Initial y coordinate for Player. */
	private static final int PLAYER_INIT_Y = 720;
	/** Initial x coordinate of number of lives left images. */
	private static final int LIVES_INIT_X = 24;
	/** Initial x coordinate of number of lives left images. */
	private static final int LIVES_INIT_Y = 744;
	/** Number of pixels between lives left images. */
	private static final int LIVES_SPACE = 32;

	/** Holds image used to show number of lives left. */
	private Image life;
	/** Number of lives player has left. */
	private int lives;
	/** Change in pixel y coordinates from last move. */
	private int dy;
	/** Change in pixel x coordinates from last move. */
	private int dx;

	/**
	 * Constructor for player.
	 * 
	 * @param lives 	Number of lives to instantiate player with.
	 * @throws SlickException
	 */
	public Player(int lives) throws SlickException {

		super("assets/frog.png", PLAYER_INIT_X, PLAYER_INIT_Y);
		this.lives = lives;
		life = new Image("assets/lives.png");
	}

	/**
	 * Method checks if Player object is still within the bounds of the game and
	 * road.
	 * 
	 * @param dx 	Change in pixel x coordinates for current move.
	 * @param dy 	Change in pixel y coordinates for current move.
	 */
	private void check_update(int dx, int dy) {

		if (this.getX() + dx < App.SCREEN_WIDTH && this.getX() + dx > App.LEFT_EDGE) {
			this.setX(this.getX() + dx);
		}

		if (this.getY() + dy < App.SCREEN_HEIGHT) {
			this.setY(this.getY() + dy);
		}

	}

	/**
	 * Checks which key has been pressed, and submits the player move to be
	 * validated by the check_update method.
	 * 
	 * @param input Keyboard input from user.
	 */
	public void update(Input input) {

		this.dx = 0;
		this.dy = 0;

		if (input.isKeyPressed(Input.KEY_UP)) {
			dy -= World.TILE;
		}
		if (input.isKeyPressed(Input.KEY_DOWN)) {
			dy += World.TILE;
		}
		if (input.isKeyPressed(Input.KEY_LEFT)) {
			dx -= World.TILE;
		}
		if (input.isKeyPressed(Input.KEY_RIGHT)) {
			dx += World.TILE;
		}

		/* Check if update is valid. */
		check_update(dx, dy);
	}

	/**
	 * Draws how many lives player has left in designated area.
	 */
	public void render() {

		this.getImg().drawCentered(this.getX(), this.getY());
		for (int i = LIVES_INIT_X, j = 0; j < this.lives; j++, i += LIVES_SPACE) {
			life.drawCentered(i, LIVES_INIT_Y);

		}
	}

	/**
	 * Getter for lives player has left.
	 * 
	 * @return Number of lives player has left.
	 */
	public int getLives() {
		return this.lives;
	}

	/**
	 * Removes one life from players total lives.
	 */
	public void kill() {
		this.lives -= 1;
	}

	/**
	 * Returns player to its designated initial position.
	 */
	public void reset() {
		setX(PLAYER_INIT_X);
		setY(PLAYER_INIT_Y);
	}

	/**
	 * Increase the number of lives the player has by 1.
	 */
	public void gain() {
		this.lives += 1;
	}

	/**
	 * Checks is player has left the screen. Removes one life and resets the player
	 * to its initial position if so.
	 */
	public void update() {
		if (getX() < App.LEFT_EDGE || getX() > App.SCREEN_WIDTH) {
			kill();
			reset();
		}

	}

	/**
	 * Checks if player attempts to move into a solid object. If so, undoes users
	 * last input so player doesn't move into solid object.
	 * 
	 * @param other Solid sprite object to check contact with.
	 */
	public void contactSolid(Sprite other) {

		if (this.getY() == other.getY() && (Math.abs(this.getX() - other.getX())) <= World.TILE) {
			this.setX(this.getX() - this.dx);
			this.setY(this.getY() - this.dy);

		}

	}
}
