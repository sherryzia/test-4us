package models;

import org.newdawn.slick.Graphics;
import org.newdawn.slick.Input;
import org.newdawn.slick.SlickException;
import java.io.*;
import java.util.ArrayList;
import java.util.Random;
import models.*;
import main.App;

public class World {

	/** y coordinates for empty frog holes. **/
	private static final int HOLE_Y = 48;
	/** x coordinates of centre of frog holes. */
	private static final int[] EMPTY_X = { 120, 312, 504, 696, 888 };
	/** Side length of one tile in game. */
	public static final int TILE = 48;
	/** Minimum delay in seconds to generate extra life. */
	private static final int EXTRA_TIME_MIN = 25;
	/** Range value for time delays to generate extra life. */
	private static final int EXTRA_TIME_RANGE = 12;
	/** Conversion value from seconds to milliseconds. */
	private static final int S_TO_MS = 1000;
	/** Counter for number of frog holes reached. */
	private int holes_reached = 0;
	/** Time delay to create extra life. */
	private Integer extraStart;
	/** Flag for how long extra life has existed. */
	private Integer extraTime;
	/** Random generator used for instantiating extra life. */
	private Random randomGenerator;
	/** Player object. */
	private Player player;
	/** Extra life object. */
	private ExtraLife extra;
	/** Array list to hold water tiles. */

	private ArrayList<Tile> water = new ArrayList<Tile>();
	/** Array list to hold tree tiles. */
	private ArrayList<Tile> trees = new ArrayList<Tile>();
	/** Array list to hold grass tiles. */
	private ArrayList<Tile> grass = new ArrayList<Tile>();
	/** Array list to hold bike objects. */
	private ArrayList<Bike> bikes = new ArrayList<Bike>();
	/** Array list to hold empty hole objects. */
	private ArrayList<Empty> empties = new ArrayList<Empty>();
	/** Array list to hold log objects. */
	private ArrayList<Log> logs = new ArrayList<Log>();
	/** Array list to hold bulldozer objects. */
	private ArrayList<Bulldozer> bulldozers = new ArrayList<Bulldozer>();
	/** Array list to hold turtle objects. */
	private ArrayList<Turtle> turtles = new ArrayList<Turtle>();
	/** Array list to hold four wheeler objects. */
	private ArrayList<fourWheeler> fours = new ArrayList<fourWheeler>();

	public static final int CONTINUE = 0; // Game is still running
	public static final int END = -1;     // Game has ended

	/**
	 * Creates world level for user.
	 *
	 * @param level 	Address of csv file containing details of world to create.
	 * @param lives 	Number of lives player is to have at world creation.
	 * @throws SlickException
	 */
	public World(String level, int lives) throws SlickException {


		player = new Player(lives);


		for (int x : EMPTY_X) {
			empties.add(new Empty(x, HOLE_Y));
		}

		try (BufferedReader br = new BufferedReader(new FileReader(level))) {
			String[] line = new String[4];
			String x;
			while ((x = br.readLine()) != null) {
				line = x.split(",");
				switch (line[0]) {

				case "water":
					water.add(new Tile("assets/water.png", Float.parseFloat(line[1]), Float.parseFloat(line[2])));
					break;

				case "tree":
					trees.add(new Tile("assets/tree.png", Float.parseFloat(line[1]), Float.parseFloat(line[2])));
					break;

				case "grass":
					grass.add(new Tile("assets/grass.png", Float.parseFloat(line[1]), Float.parseFloat(line[2])));
					break;

				case "bus":
					fours.add(new fourWheeler(Float.parseFloat(line[1]), Float.parseFloat(line[2]),
							Boolean.parseBoolean(line[3]), true));
					break;

				case "racecar":
					fours.add(new fourWheeler(Float.parseFloat(line[1]), Float.parseFloat(line[2]),
							Boolean.parseBoolean(line[3])));
					break;

				case "bike":
					bikes.add(new Bike(Float.parseFloat(line[1]), Float.parseFloat(line[2]),
							Boolean.parseBoolean(line[3])));
					break;

				case "bulldozer":
					bulldozers.add(new Bulldozer(Float.parseFloat(line[1]), Float.parseFloat(line[2]),
							Boolean.parseBoolean(line[3])));
					break;

				case "longLog":
					logs.add(new Log(Float.parseFloat(line[1]), Float.parseFloat(line[2]),
							Boolean.parseBoolean(line[3]), true));
					break;

				case "log":
					logs.add(new Log(Float.parseFloat(line[1]), Float.parseFloat(line[2]),
							Boolean.parseBoolean(line[3])));
					break;

				case "turtle":
					turtles.add(new Turtle(Float.parseFloat(line[1]), Float.parseFloat(line[2]),
							Boolean.parseBoolean(line[3])));
					break;

				default:
					break;

				}

			}

		} catch (IOException e) {
			System.out.println("Didn't read");
		}

		randomGenerator = new Random();
		extra = null;
		extraTime = 0;
		extraStart = randomGenerator.nextInt(EXTRA_TIME_RANGE) + EXTRA_TIME_MIN;

	}

	/**
	 * Generates extra life when designated time is reached.
	 *
	 * @param extraTime 	Indicates how long since last extra life was in world.
	 * @throws SlickException
	 */
	public void create_extra(Integer extraTime) throws SlickException {

		int index = randomGenerator.nextInt(logs.size());

		if (extraTime >= extraStart * S_TO_MS) {
			this.extra = new ExtraLife(logs.get(index));
			this.extraTime = 0;
		}
	}

	/**
	 * Method handles updating status of the extra life object in the game.
	 *
	 * @param delta 	Number of milliseconds since last frame was updated.
	 * @throws SlickException
	 */
	public void update_extra(int delta) throws SlickException {

		extraTime += delta;

		if (extra != null) {

			extra.update(delta);

			/*
			 * Check if player has contacted the extra life or 14 seconds has passed since
			 * instantiating the extra life.
			 */
			if (extra.contactPlayer(player) || extraTime > 14000) {

				extra = null;
				extraTime = 0;
			}

		} else {
			create_extra(extraTime);
		}

	}

	/**
	 * Method updates the all sprites in the world. Checks for collisions between
	 * sprites too.
	 *
	 * @param input 	Keyboard input from user.
	 * @param delta 	Number of milliseconds since last frame was updated.
	 * @return 			Returns game status value from called method game_status().
	 * @throws SlickException
	 */
	public int update(Input input, int delta) throws SlickException {

		update_extra(delta);

		/* Flag if player is riding an object, true if riding. */
		boolean ride = false;

		player.update(input);

		for (fourWheeler f : fours) {
			f.update(delta);
			f.contactSprite(player);
		}

		for (Tile t : trees) {
			player.contactSolid(t);
		}

		for (Bulldozer bd : bulldozers) {
			bd.update(delta);
			bd.contactPlayer(player, delta);
			player.contactSolid(bd);
		}

		for (Log l : logs) {
			l.update(delta);
			if (l.contactSprite(player, delta)) {
				ride = true;
			}
		}

		for (Turtle t : turtles) {
			t.update(delta);
			if (t.contactSprite(player, delta)) {
				ride = true;
			}
		}

		for (Bike b : bikes) {
			b.update(delta);
			b.contactSprite(player);
		}

		for (Tile w : water) {
			if (!ride) {
				w.contactSprite(player);
			}
		}

		for (Empty e : empties) {
			e.contactSprite(player);
		}

		player.update();

		return game_status();

	}

	/**
	 * Method assess state of the world, makes decision whether game continues,
	 * ends, or next level is reached.
	 *
	 * @return		Game status code indicating the state of the game.
	 */
	public int game_status() {

		if (player.getY() == HOLE_Y) {
			holes_reached++;
			player.reset();
		}

		if (player.getLives() == App.END) {
			return App.END;
		}
		if (holes_reached == 5) {
			System.out.printf("Lives: %d", player.getLives());
			return player.getLives();
		}

		return App.CONTINUE;

	}

	/**
	 * Draws all sprites in game.
	 * @param g		The Slick graphics object, used for drawing.
	 */
	public void render(Graphics g) {

		for (Empty e : empties) {
			e.render();
		}

		for (Tile w : water) {
			w.render();
		}

		for (Tile t : trees) {
			t.render();
		}

		for (Tile gr : grass) {
			gr.render();
		}

		for (Bulldozer bd : bulldozers) {
			bd.render();
		}
		for (Log l : logs) {
			l.render();
		}

		for (Bike b : bikes) {
			b.render();
		}

		for (Turtle t : turtles) {
			t.render();
		}

		for (fourWheeler f : fours) {
			f.render();

		}

		/* Only render extra sprite if its in game. */
		if (extra != null) {

			extra.render();
		}

		player.render();

	}

}
