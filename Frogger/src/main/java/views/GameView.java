package views;

import models.World;
import org.newdawn.slick.Graphics;

public class GameView {
    public void render(World world, Graphics g) {
        world.render(g);
    }
}
