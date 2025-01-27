/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */

package partb;

import java.util.List;

/*
 * ProductManagement Interface
 * Defines the operations for managing books and categories in the system.
 * Includes methods for adding books, categories, and other product-related functionalities.
 */

public interface ProductManagement {
    
    //GroupA
//    public List<Book> searchBook();
//    public List<Book> purchaseBook(Book book);
//    public List<Book> createOrderBook(Book book);
//    public List<Book> createSalesBook(Book book);
//    public List<Book> viewOrdersBook();
    
    //GroupB
    /*
 * Adds a new book entry to the system.
 * This method accepts a BooksEntry object and returns the updated list of books.
 *
 * @param book The book entry to be added
 * @return The updated list of books
 */

    public List<BooksEntry> addBook(BooksEntry book);
    /*
 * Adds a new category to the system.
 * This method accepts a category name as a string and returns the updated list of categories.
 *
 * @param category The name of the category to be added
 * @return The updated list of categories
 */

    public List<BooksCategory> addCategory(String category);
    
    //GroupC
//    public List<Book> viewBooks();
//    public List<Order> viewSales();
//    public String updateBook(Book book);
//    public String deleteBook(int id);
    
   
    
    
    

}
