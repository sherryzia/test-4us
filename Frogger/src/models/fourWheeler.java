
/** Class for four wheeled sprite vehicles in game. */
import org.newdawn.slick.SlickException;

public class fourWheeler extends Vehicle {

	/** Speed for buses. */
	private static final double BUS_SPEED = 0.15f;
	/** Speed for racecars. */
	private static final double RACECAR_SPEED = 0.5f;

	/**
	 * Constructor used to instantiate bus vehicles in game.
	 * 
	 * @param x         Initial x coordinate.
	 * @param y         Initial y coordinate.
	 * @param direction Flag for initial direction (Right if true).
	 * @param isBus     Boolean value to indicate bus to instantiate (used to
	 *                  differentiate constructors).
	 * @throws SlickException
	 */
	public fourWheeler(float x, float y, boolean direction, boolean isBus) throws SlickException {

		super("assets/bus.png", x, y, direction, BUS_SPEED);
	}

	/**
	 * Constructor used to instantiate racecar vehicles in game.
	 * 
	 * @param x         Initial x coordinate.
	 * @param y         Initial y coordinate.
	 * @param direction Flag for initial direction (Right if true).
	 * @throws SlickException
	 */
	public fourWheeler(float x, float y, boolean direction) throws SlickException {

		super("assets/racecar.png", x, y, direction, RACECAR_SPEED);
	}

}
