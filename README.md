# Frogger Game - Application Documentation

## Overview

The Frogger game is a simplified version of the classic arcade game, developed in Java.
It includes various gameplay features such as player movement, obstacles, levels, and power-ups. 
The project demonstrates object-oriented programming principles and uses the Slick2D library for rendering.

## Directory Structure

- `/Frogger/`
  - **README.md**: Documentation for setting up and running the game.
  - **Frogger.iml**: IntelliJ IDEA configuration file for the project.
  - `/assets/`
    - **credit.txt**: Attribution to the creators of assets used in the game.
    - `/levels/`: Contains level configuration files (`0.lvl`, `1.lvl`).
  - `/out/`: Contains compiled classes and production files.
  - `/src/`: Source code for the application.
    - **App.java**: Entry point of the game.
    - `/utilities/`: Utility classes such as `BoundingBox.java` for collision detection.
    - **Core Classes**: `Player.java`, `World.java`, `Vehicle.java`, and others for game mechanics.

## Key Components

### 1. **Core Gameplay**
- **Player**: Represents the player character. Responsible for movement, collision detection, and lives.
- **World**: Manages the game state, including level transitions and rendering of all game objects.
- **Levels**: Configured via `.lvl` files, which define the layout of obstacles, water, grass, and other elements.

### 2. **Entities**
- **Vehicles**: Includes various types such as `Bike`, `Bulldozer`, and `fourWheeler`. Each has unique behavior and speed.
- **Logs and Turtles**: Allow the player to cross water areas. Turtles periodically submerge, adding a challenge.
- **ExtraLife**: A collectible that grants an additional life to the player.

### 3. **Assets**
- The `/assets/` folder contains graphical resources (sprites) and level configurations.
- **credit.txt**: Lists sources of assets used in the game.

### 4. **Utilities**
- **BoundingBox**: Handles collision detection between objects.
- **Slick2D Integration**: The game uses the Slick2D library for rendering and input handling.

## How to Set Up

1. **Clone the Repository**: Download or clone the project to your local machine.
2. **Install Dependencies**: Set up the Slick2D library as described in the `README.md` file.
3. **Run the Game**:
   - Use your IDE (e.g., IntelliJ IDEA) to build and run `App.java`.
   - Alternatively, use the provided Gradle or Maven configuration.

## Gameplay

- Use the arrow keys to move the player.
- Cross the road and water obstacles to reach the other side.
- Avoid vehicles and collect power-ups to increase your score and lives.
- Progress through levels, each becoming increasingly challenging.

## Future Improvements

- Adding more levels with varied layouts.
- Enhancing AI behavior for moving objects.
- Incorporating sound effects and background music.

## Credits

- **Developers**: This game was developed as an educational project for learning object-oriented programming.
- **Assets**: Refer to `/assets/credit.txt` for detailed attribution.
