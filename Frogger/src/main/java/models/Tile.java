
/** Class for tiles in game. **/

import org.newdawn.slick.SlickException;

public class Tile extends Sprite {

	/**
	 * Constructor for tiles in game.
	 * 
	 * @param imageSrc	Directory address for image to be used for sprite.
	 * @param x			Initial x coordinate of tile.
	 * @param y			Initial y coordinate of tile.
	 * @throws SlickException
	 */
	public Tile(String imageSrc, float x, float y) throws SlickException {
		super(imageSrc, x, y);
	}
	

}
