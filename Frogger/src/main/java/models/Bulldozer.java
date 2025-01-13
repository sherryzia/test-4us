/** Class for bulldozers in game. **/
package models;

import org.newdawn.slick.SlickException;

public class Bulldozer extends Vehicle {

	/** Speed for bulldozers. */
	private static final double SPEED = 0.05f;

	/**
	 * Constructor.
	 * 
	 * @param x         	Initial x coordinate.
	 * @param y         	Initial y coordinate.
	 * @param direction 	Flag for initial direction (Right if true).
	 * @throws SlickException
	 */
	public Bulldozer(float x, float y, boolean direction) throws SlickException {

		super("assets/bulldozer.png", x, y, direction, SPEED);
	}

	/**
	 * Method checks if it contacts a sprite. Updates sprites coordinates to move
	 * with bulldozer if contact has occurred.
	 * 
	 * @param player	Player object for contact check.
	 * @param delta		Number of milliseconds since last frame was updated.
	 */
	public void contactPlayer(Player player, int delta) {

		if (this.getBox().intersects(player.getBox())) {

			player.setX((float) (player.getX() + getSpeed() * delta * getDir()));
		}

	}

}
