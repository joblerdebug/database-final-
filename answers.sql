-- Library Management System Database
-- Comprehensive relational database for book tracking, members, and loans

CREATE DATABASE IF NOT EXISTS library_management_system;
USE library_management_system;

-- 1. Members Table - Library members/patrons
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    national_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    membership_type ENUM('Student', 'Staff', 'Public', 'Premium') DEFAULT 'Public',
    membership_date DATE NOT NULL,
    membership_expiry DATE NOT NULL,
    status ENUM('Active', 'Suspended', 'Expired') DEFAULT 'Active',
    
    INDEX idx_email (email),
    INDEX idx_membership_expiry (membership_expiry),
    INDEX idx_status (status)
);

-- 2. Authors Table - Book authors
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL,
    nationality VARCHAR(100),
    birth_year YEAR,
    death_year YEAR,
    biography TEXT,
    
    INDEX idx_author_name (author_name)
);

-- 3. Publishers Table - Book publishers
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    phone VARCHAR(15),
    address TEXT,
    website VARCHAR(255),
    
    INDEX idx_publisher_name (publisher_name)
);

-- 4. Books Table - Core book information
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(500) NOT NULL,
    publisher_id INT NOT NULL,
    publication_year YEAR,
    edition VARCHAR(50),
    category VARCHAR(100) NOT NULL,
    language VARCHAR(50) DEFAULT 'English',
    page_count INT,
    description TEXT,
    
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE RESTRICT,
    
    INDEX idx_title (title),
    INDEX idx_category (category),
    INDEX idx_isbn (isbn)
);

-- 5. Book_Authors Table - Many-to-Many relationship between Books and Authors
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    author_order INT DEFAULT 1, -- 1 for primary author, 2 for secondary, etc.
    
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE,
    
    INDEX idx_author_id (author_id)
);

-- 6. Book_Copies Table - Individual physical copies of books (One-to-Many with Books)
CREATE TABLE book_copies (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    barcode VARCHAR(50) UNIQUE NOT NULL,
    acquisition_date DATE NOT NULL,
    acquisition_price DECIMAL(8,2),
    location VARCHAR(100), -- Shelf location
    condition ENUM('New', 'Good', 'Fair', 'Poor', 'Damaged') DEFAULT 'Good',
    status ENUM('Available', 'Checked Out', 'Reserved', 'Lost', 'Under Maintenance') DEFAULT 'Available',
    
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    
    INDEX idx_book_id (book_id),
    INDEX idx_status (status),
    INDEX idx_barcode (barcode)
);

-- 7. Loans Table - Book checkout records (Many-to-Many between Members and Book_Copies)
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    renewed_count INT DEFAULT 0 CHECK (renewed_count >= 0),
    late_fee DECIMAL(6,2) DEFAULT 0.00,
    
    FOREIGN KEY (copy_id) REFERENCES book_copies(copy_id) ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE RESTRICT,
    
    INDEX idx_member_id (member_id),
    INDEX idx_due_date (due_date),
    INDEX idx_return_date (return_date),
    
    CHECK (due_date >= checkout_date),
    CHECK (return_date IS NULL OR return_date >= checkout_date)
);

-- 8. Reservations Table - Book reservation system
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    expiry_date DATE NOT NULL,
    status ENUM('Active', 'Fulfilled', 'Cancelled', 'Expired') DEFAULT 'Active',
    
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_active_reservation (book_id, member_id, status),
    
    INDEX idx_member_id (member_id),
    INDEX idx_expiry_date (expiry_date)
);

-- 9. Fines Table - Late return fines tracking
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    loan_id INT NOT NULL,
    amount DECIMAL(6,2) NOT NULL CHECK (amount >= 0),
    fine_date DATE NOT NULL,
    reason ENUM('Late Return', 'Damage', 'Lost Book') DEFAULT 'Late Return',
    status ENUM('Unpaid', 'Paid', 'Waived') DEFAULT 'Unpaid',
    payment_date DATE NULL,
    
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE,
    
    INDEX idx_member_id (member_id),
    INDEX idx_status (status),
    INDEX idx_fine_date (fine_date)
);

-- 10. Staff Table - Library staff members
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(15),
    position VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    status ENUM('Active', 'Inactive', 'Suspended') DEFAULT 'Active',
    
    INDEX idx_email (email),
    INDEX idx_department (department)
);
