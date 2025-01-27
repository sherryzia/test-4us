package combine.booknook;

import de.vandermeer.asciitable.AsciiTable;
import de.vandermeer.skb.interfaces.transformers.textformat.TextAlignment;
import java.util.Scanner;

/**
 *
 * @authors Delia Larisa Turiac; Alin Golesie; Roberto Escobar-Prada 
 */
public class Combine {

    public static booknook.parta.BookManagement a_bookManagement = new booknook.parta.BookManagement();
    public static booknook.parta.ui.GuiController a_gui = new booknook.parta.ui.GuiController();
    public static booknook.partb.BookManagement b_bookManagement = new booknook.partb.BookManagement();
    public static booknook.partb.ui.GuiController b_gui = new booknook.partb.ui.GuiController();
    public static alin.partc.BookManagement c_bookService = new alin.partc.BookManagement ();
    public static alin.partc.ui.GuiController c_gui = new alin.partc.ui.GuiController();
//    
    /**
     * Display simple information message when user is at main screen.
     */
    public static void displayInformation(){
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow(" Running all three task combined.");
        asciiTable.addRule();
        asciiTable.setTextAlignment(TextAlignment.JUSTIFIED_LEFT);
        String render = asciiTable.render(60);
        System.out.println(render);
    }
    
    /**
     * Creates main menu.
     */
    public static void createStartMenu() {
        Combine.displayInformation();
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow("  Choose Member Tasks");
        asciiTable.addRule();
        asciiTable.addRow("[1]        Member A Tasks");
        asciiTable.addRow("[2]        Member B Tasks");
        asciiTable.addRow("[3]        Member C Tasks");
        asciiTable.addRow("[4]        Exit");
        asciiTable.addRule();
        asciiTable.addRow("  Choose from options [1... 4]");
        asciiTable.addRule();
        asciiTable.setTextAlignment(TextAlignment.JUSTIFIED_LEFT);
        String render = asciiTable.render(60);
        System.out.println(render);
    }
    public void exitMessage(String message){
        AsciiTable asciiTable = new AsciiTable();
        asciiTable.addRule();
        asciiTable.addRow(message);
        asciiTable.addRule();
        asciiTable.setTextAlignment(TextAlignment.JUSTIFIED_LEFT);
        String render = asciiTable.render(50);
        System.out.println(render);
    }
    
    /**
     * Shows Group A Tasks.
     */
    public void displayMenuGroupA(){
        a_gui.appStart("Welcome to BookNook Member A Tasks");
    }
    
    /**
     * Shows Group B Tasks.
     */
    public void displayMenuGroupB(){
        b_gui.appStart("Welcome to BookNook Member B Tasks");
    }
    
    /**
     * Shows Group C Tasks.
     */
    public void displayMenuGroupC(){
        c_gui.appStart("Welcome to BookNook Member C Tasks");
        
    }
    
    /**
     * Start Console Menu and Loop through it 
     * until user choose to exit the system.
     */
    public void processMenu() {
        Scanner scanner = new Scanner(System.in);
        boolean action = true;
        //String getKey="";

        while (action) {
           a_gui.clearScreen();
            this.createStartMenu();
           int getKey=0;
            String key = scanner.next();
            try {
                //getKey = (key.toUpperCase());
                 getKey = Integer.parseInt(key);
                switch (getKey) {
                    case 1:
                        this.displayMenuGroupA();
                        break;
                    case 2:
                        this.displayMenuGroupB();
                        break;
                    case 3 :
                        this.displayMenuGroupC();
                        break;
                    case 4:
                        this.exitMessage("Thank you for using BookNook.");
                        System.exit(0);
                        action = false;
                    default:
                        
                        break;
                }
                
            } catch (Exception e) {
                System.out.println("Please Enter numbers only");
            }
        }

    }
    
   
}
