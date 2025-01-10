
/** Class used for all log sprites in game. */
import org.newdawn.slick.SlickException;

public class Log extends Vehicle {

	/** Speed for normal length log in game. */
	private static final double LOG_SPEED = 0.1f;
	/** Speed for long length log in game. */
	private static final double LONGLOG_SPEED = 0.07f;

	/**
	 * Constructor used to instantiate normal logs in game.
	 * 
	 * @param x         Initial x coordinate.
	 * @param y         Initial y coordinate.
	 * @param direction Flag for initial direction (Right if true).
	 * @throws SlickException
	 */
	public Log(float x, float y, boolean direction) throws SlickException {

		super("assets/log.png", x, y, direction, LOG_SPEED);
	}

	/**
	 * Constructor used to instantiate long logs in game.
	 * 
	 * @param x         Initial x coordinate.
	 * @param y         Initial y coordinate.
	 * @param direction Flag for initial direction (Right if true).
	 * @param isLong    Boolean value to indicate long long to instantiate (used to
	 *                  differentiate constructors).
	 * @throws SlickException
	 */
	public Log(float x, float y, boolean direction, boolean isLong) throws SlickException {

		super("assets/longlog.png", x, y, direction, LONGLOG_SPEED);
	}

	/**
	 * Method checks if it contacts a sprite. Updates sprites coordinates to move
	 * with log if contact has occurred.
	 * 
	 * @param player	Player object to check contact with.
	 * @param delta		Number of milliseconds since last frame was updated.
	 * @return			True if player has contacted the log.
	 */
	public boolean contactSprite(Player player, int delta) {

		if (this.getBox().intersects(player.getBox())) {
			player.setX((float) (player.getX() + getSpeed() * delta * getDir()));
			return true;

		}
		return false;

	}

}
