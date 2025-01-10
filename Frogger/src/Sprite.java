
/** Abstract Class for Sprites in game. **/

import org.newdawn.slick.SlickException;
import utilities.BoundingBox;
import org.newdawn.slick.Image;

public abstract class Sprite {

	/** x coordinate of Sprite. */
	private float x;
	/** y coordinate of Sprite. */
	private float y;
	/** Sprite image. */
	private Image img;
	/** BoundingBox object used for collision detection. */
	private BoundingBox box;

	/**
	 * Constructor for sprite.
	 * 
	 * @param imageSrc Directory address for image to be used for sprite.
	 * @param x        Initial x coordinate of sprite.
	 * @param y        Initial y coordinate of sprite.
	 * @throws SlickException
	 */
	public Sprite(String imageSrc, float x, float y) throws SlickException {

		this.x = x;
		this.y = y;
		this.img = new Image(imageSrc);
	}

	/**
	 * Method draws the sprite.
	 */
	public void render() {

		this.img.drawCentered(this.getX(), this.getY());
	}

	/**
	 * Setter for x coordinate.
	 * 
	 * @param x x coordinate to set.
	 */
	public void setX(float x) {
		this.x = x;
	}

	/**
	 * Getter for x coordinate.
	 * 
	 * @return x coordinate of sprite.
	 */
	public float getX() {
		return this.x;
	}

	/**
	 * Setter for y coordinate.
	 * 
	 * @param y y coordinate to set.
	 */
	public void setY(float y) {
		this.y = y;
	}

	/**
	 * Getter for y coordinate.
	 * 
	 * @return y coordinate of sprite.
	 */
	public float getY() {
		return this.y;
	}

	/**
	 * Getter for private Image instance variable of sprite.
	 * 
	 * @return Image instance variable of sprite.
	 */
	public Image getImg() {
		return this.img;
	}

	/**
	 * Getter for private BoundingBox instance variable of sprite.
	 * 
	 * @return BoundingBox instance variable of sprite.
	 */
	public BoundingBox getBox() {

		box = new BoundingBox(this.getImg(), this.getX(), this.getY());

		return box;
	}

	/**
	 * Checks for contact with player object. If so, player loses life and is sent
	 * back to their initial position.
	 * 
	 * @param player	Player object to check contact with.
	 */
	public void contactSprite(Player player) {

		if (this.getBox().intersects(player.getBox())) {
			player.kill();
			player.reset();

		}
	}

}
