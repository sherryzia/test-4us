
/** Abstract class for in game vehicles. */

import org.newdawn.slick.SlickException;

public abstract class Vehicle extends Sprite {

	/** Directional flag, sign is relative to positive x direction of output. */
	public static final int LEFT = -1;
	/** Directional flag, sign is relative to positive x direction of output. */
	public static final int RIGHT = 1;
	/** Flag to hold current vehicle direction. Sign indicates left or right. */
	private int direction;
	/** Flag to hold speed for vehicle. */
	private double speed;

	/**
	 * Constructor for vehicles in game.
	 * 
	 * @param imageSrc  Directory address for image to be used for sprite.
	 * @param x         Initial x coordinate for vehicle.
	 * @param y         Initial y coordinate for vehicle.
	 * @param direction Flag for initial direction (Right if true).
	 * @param speed     Speed of vehicle.
	 * @throws SlickException
	 */
	public Vehicle(String imageSrc, float x, float y, boolean direction, double speed) throws SlickException {

		super(imageSrc, x, y);
		this.speed = speed;
		if (direction) {
			this.direction = RIGHT;
		} else {
			this.direction = LEFT;
		}

	}

	/**
	 * Vehicle constructor used to instantiate ExtraLife class objects.
	 * 
	 * @param imageSrc Directory address for image to be used for sprite.
	 * @param log      Log to create extra life vehicle.
	 * @throws SlickException
	 */
	public Vehicle(String imageSrc, Log log) throws SlickException {

		super(imageSrc, log.getX(), log.getY());
		this.direction = log.getDir();
		this.speed = log.getSpeed();
	}

	/**
	 * Updates position of vehicle.
	 * 
	 * @param delta Number of milliseconds since last frame was updated.
	 */
	public void update(int delta) {

		this.setX((float) (this.getX() + this.speed * delta * getDir()));
		check_update();
	}

	/**
	 * Changes direction of vehicle to be in opposite direction.
	 */
	public void changeDir() {
		this.direction *= -1;
	}

	/**
	 * Getter for direction for vehicle.
	 * 
	 * @return Sign of vehicle direction.
	 */
	public int getDir() {
		return this.direction;
	}

	/**
	 * Getter for vehicle speed.
	 * 
	 * @return Returns speed of vehicle.
	 */
	public double getSpeed() {
		return this.speed;
	}

	/**
	 * Checks if vehicle has gone of screen. If so, returns it to the other side of
	 * the screen.
	 */
	public void check_update() {

		/* If the Vehicle position has gone off the screen. */
		if (this.getX() > App.SCREEN_WIDTH + (this.getImg().getWidth()) / 2
				|| this.getX() < App.LEFT_EDGE - (this.getImg().getWidth()) / 2) {
			if (getDir() == LEFT) {
				this.setX(App.SCREEN_WIDTH + (this.getImg().getWidth()) / 2);
			} else {
				this.setX(App.LEFT_EDGE - (this.getImg().getWidth()) / 2);
			}
		}
	}

}
