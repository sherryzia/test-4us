package combine.booknook;

/**
 * Combining all group tasks.
 * 
 * @authors Delia Larisa Turiac; Alin Golesie; Roberto Escobar-Prada
 * We combine our project by adding them as dependencies using group ID, artefact ID and version.
 * 
 */



public class Booknook {
    static Combine gui = new Combine();

    public static void main(String[] args) {
        // Initialize the database
        combine.booknook.utils.DatabaseInitializer.initialize();

        // Start the application
        gui.processMenu();
    }
}

