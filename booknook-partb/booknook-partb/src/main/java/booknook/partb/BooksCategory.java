/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package booknook.partb;

/*
 * BooksCategory Class
 * This class represents a category for books in the system.
 * Each category has a unique identifier and a name.
 */


public class BooksCategory {
    int id;
    String name;

    public BooksCategory() {
    }

    public BooksCategory(int id ,String name) {
        this.id = id;
        this.name = name;
    }

    


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        //sb.append("").append(id);
        sb.append("").append(name);
        sb.append('}');
        return sb.toString();
    }

    

}
//end