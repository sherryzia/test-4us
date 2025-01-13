
/**
 * Class used for extra life sprites to be generated during runtime.
 */
package models;

import main.App;
import org.newdawn.slick.SlickException;

public class ExtraLife extends Vehicle {

	/** Private log object for instance. */
	private Log log;
	/** Value for 2 seconds in milliseconds. */
	private static final int TWOSECS = 2000;
	/** Time counter for how long object has been instantiated. */
	private int time;
	/** Direction extra life is moving on its log. */
	private int ownDir;
	/** Pixel offset from centre of log sprite is on. */
	private float offset;

	/**
	 * Constructor.
	 * 
	 * @param log 	Log object extra life is assigned too.
	 * @throws SlickException
	 */
	public ExtraLife(Log log) throws SlickException {

		super("assets/extralife.png", log);
		this.log = log;
		this.time = 0;
		this.ownDir = RIGHT;
	}

	/**
	 * Moves extra life sprite along log.
	 * 
	 * @param delta 	Number of milliseconds since last frame was updated.
	 */
	@Override
	public void update(int delta) {

		this.setX((float) (this.getX() + this.getSpeed() * delta * getDir()));
		time += delta;

		if (time >= TWOSECS) {

			offset += World.TILE * ownDir;
			time = 0;
			this.setX(log.getX() + offset);

			/*
			 * If not on the log, move the offset in the opposite direction and change
			 * sprite direction.
			 */
			if (!onLog()) {
				this.setX(this.getX() - 2 * World.TILE * ownDir);
				offset -= 2 * World.TILE * ownDir;
				ownDir *= -1;
			}
		}
	}

	/**
	 * Checks if extra life is still on its log.
	 * 
	 * @return		True if extra life still on log.
	 */
	public boolean onLog() {

		if (this.getBox().intersects(log.getBox())) {
			return true;
		}
		return false;

	}

	/**
	 * Checks if extra life is still on screen.
	 */
	@Override
	public void check_update() {

		if (this.getX() > App.SCREEN_WIDTH + (this.getImg().getWidth()) / 2
				|| this.getX() < App.LEFT_EDGE - (this.getImg().getWidth()) / 2) {

			this.setX(log.getX() + offset);
		}
	}

	/**
	 * Checks if extra life has been contacted by player, increases player life if
	 * so.
	 * 
	 * @param player 	Player object for contact check.
	 * @return 			True if player is in contact with extra life.
	 */
	public boolean contactPlayer(Player player) {
		if (this.getBox().intersects(player.getBox()) && this.getY() == player.getY()) {
			player.gain();
			return true;
		}
		return false;

	}

}
