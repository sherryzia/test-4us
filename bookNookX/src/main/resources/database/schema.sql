-- Table for Books
CREATE TABLE IF NOT EXISTS books (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_code TEXT NOT NULL,
    name TEXT NOT NULL,
    author TEXT NOT NULL,
    category TEXT NOT NULL,
    price REAL NOT NULL
);

-- Table for Orders
CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id TEXT NOT NULL,
    user TEXT NOT NULL,
    total_price REAL NOT NULL
);

-- Table for Order Details
CREATE TABLE IF NOT EXISTS order_details (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id TEXT NOT NULL,
    item_code TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Table for Users
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    role TEXT NOT NULL
);

-- Sample Data
--INSERT INTO books (item_code, name, author, category, price) VALUES
--('B001', 'Dune', 'Frank Herbert', 'Science Fiction', 39.99),
--('B002', 'Atomic Habits', 'James Clear', 'Self-Help', 29.99),
--('B003', 'Gone Girl', 'Gillian Flynn', 'Mystery', 41.99);
--
--INSERT INTO users (name, email, password, role) VALUES
--('Admin', 'admin@booknook.com', 'admin123', 'admin'),
--('User1', 'user1@booknook.com', 'password', 'user');
