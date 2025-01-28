/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package combine.booknook.parta.ui;

import combine.booknook.partb.BookManagement;
import combine.booknook.partb.BooksCategory;
import combine.booknook.partb.BooksEntry;

import java.util.Arrays;
import java.util.Random;

/**
 * The TestData class populates the application with initial data for testing.
 * @author Delia Turiac
 */
public class TestData {
    public BookManagement bs = new BookManagement(); // Instance of the BookManagement class
    public BooksCategory cat = new BooksCategory(); // Instance of the BooksCategory class
    
    /**
     * Initializes the test data by creating categories and books.
     */
    public void Data() {
        // Define and add a list of categories to the system
        BooksCategory[] categories = {
            new BooksCategory(1, "Science Fiction"),
            new BooksCategory(2, "Mystery & Thriller"),
            new BooksCategory(3, "Self-Help")
        };
        
        bs.categoryList.addAll(Arrays.asList(categories));
        
        // Define and add a list of books linked to specific categories
        BooksEntry[] books = {
            new BooksEntry(1, "S0001", "Dune", bs.categoryList.get(1), "Frank Herbert", 39.99),
            new BooksEntry(2, "M0001", "The Girl with the Dragon Tattoo", bs.categoryList.get(2), "Stieg Larsson", 45.50),
            new BooksEntry(3, "S0002", "Atomic Habits", bs.categoryList.get(3), "James Clear", 29.99),                 
            new BooksEntry(4, "S0003", "Sapiens: A Brief History of Humankind", bs.categoryList.get(1), "Yuval Noah Harari", 50.00),
            new BooksEntry(5, "M0002", "Gone Girl", bs.categoryList.get(2), "Gillian Flynn", 41.99),
            new BooksEntry(6, "S0004", "The Power of Habit", bs.categoryList.get(3), "Charles Duhigg", 31.50),
        };
        
        bs.bookList.addAll(Arrays.asList(books));
    }
    
    /**
     * Generates a random user from a predefined list of users.
     *
     * @return A randomly selected user's name.
     */
    public String  getRandomUser(){
        String[][] arr={
            {"Alice", "alice@example.com"},
            {"Bob", "bob@example.com"},
            {"Clara", "clara@example.com"},
            {"Derek", "derek@example.com"},
            {"Eva", "eva@example.com"},
            {"Frank", "frank@example.com"}
        }; 
        Random r=new Random(); 
        int randomNumber=r.nextInt(arr.length); 
        return (arr[randomNumber][0]); 
    }

}
