/** Class for bikes in game. */
import org.newdawn.slick.SlickException;

public class Bike extends Vehicle {

	/** Left pixel x coordinate for bike to turn around. */
	private static final int LEFT_BOUND = 24;
	/** Right pixel x coordinate for bike to turn around. */
	private static final int RIGHT_BOUND = 1000;
	/** Speed for bikes. */
	private static final double SPEED = 0.2f;

	/**
	 * Constructor for bikes.
	 * 
	 * @param x         Initial x coordinate.
	 * @param y         Initial y coordinate.
	 * @param direction Flag for initial direction (Right if true).
	 * @throws SlickException
	 */
	public Bike(float x, float y, boolean direction) throws SlickException {

		super("assets/bike.png", x, y, direction, SPEED);
	}

	/**
	 * Checks if bike has reached its bounds, if so, sets bike direction to opposite
	 * way.
	 */
	@Override
	public void check_update() {

		if (this.getX() > RIGHT_BOUND || this.getX() < LEFT_BOUND) {
			if (getDir() == LEFT) {
				this.changeDir();

			} else {
				this.changeDir();
			}
		}
	}

}
