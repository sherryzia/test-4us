
/** Class for turtles in game. */
import org.newdawn.slick.SlickException;

public class Turtle extends Vehicle {

	/** Speed for turtles. */
	private static final double SPEED = 0.1f;
	/** Two seconds in milliseconds. */
	private static final int TWO_SECS = 2000;
	/** Seven seconds in milliseconds. */
	private static final int SEV_SECS = 7000;
	/** Time flag for how long turtle has been above/below water. */
	private double time = 0;
	/** Boolean flag if turtle is under water (true if under). */
	private static boolean under = false;

	/**
	 * Constructor for turtles.
	 * 
	 * @param x         Initial x coordinate of turtle.
	 * @param y         Initial y coordinate of turtle.
	 * @param direction Flag for initial direction (Right if true).
	 * @throws SlickException
	 */
	public Turtle(float x, float y, boolean direction) throws SlickException {

		super("assets/turtles.png", x, y, direction, SPEED);
	}

	/**
	 * Method draws sprite. Only draws sprite if it is not under water.
	 */
	@Override
	public void render() {

		if (!under) {

			getImg().drawCentered(this.getX(), this.getY());
		}
	}

	/**
	 * Function updates position of turtles.
	 * 
	 * @param delta Number of milliseconds since last frame was updated.
	 */
	@Override
	public void update(int delta) {

		this.setX((float) (this.getX() + getSpeed() * delta * getDir()));
		check_update();

		time += delta;

		/* Send turtle under water after being above water for seven seconds. */
		if (time >= SEV_SECS && !under) {
			time = 0;
			under = true;
			return;
		}

		/* Send turtle above water after being below water for two seconds. */
		if (time >= TWO_SECS && under) {
			under = false;
			return;
		}

	}

	/**
	 * Class checks for contact with player. If contact occurs whilst turtle is
	 * above water, players position moves with turtle.
	 * 
	 * @param player 	Player to check contact with.
	 * @param delta  	Number of milliseconds since last frame was updated.
	 * @return 			True if player contacts turtle above water, false otherwise.
	 */
	public boolean contactSprite(Player player, int delta) {

		if (!under) {

			if (this.getBox().intersects(player.getBox())) {
				player.setX((float) (player.getX() + getSpeed() * delta * getDir()));
				return true;

			}
			return false;
		}

		return false;
	}

}
