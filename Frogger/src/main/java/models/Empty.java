/** Class for empty holes in game. **/

package models;

import org.newdawn.slick.SlickException;

public class Empty extends Sprite {
	
	/** Flag if empty hole instance has been reached by player. */
	private boolean reached;
	
	/**
	 * Constructor.
	 * 
	 * @param x		Pixel x coordinate for centre of hole.
	 * @param y		Pixel y coordinate for centre of hole.
	 * @throws SlickException
	 */
	public Empty(float x, float y) throws SlickException {

		super("assets/frog.png", x, y);
		this.reached = false;

	}
	
	/**
	 * Draws hole with frog in it if it has been reached.
	 */
	@Override
	public void render() {
		if (reached) {
			this.getImg().drawCentered(this.getX(), this.getY());
		}
	}

	/**
	 * Determines how to respond to a frog reaching the hole.
	 */
	@Override
	public void contactSprite(Player player) {

		if (this.getBox().intersects(player.getBox())) {
			
			if (reached) {
				player.kill();
				player.reset();
				
			} else {
				reached = true;
			}
			
		}
	}

}
