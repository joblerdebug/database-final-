# Library Management System Database

## 📚 Project Overview
A comprehensive relational database system designed for managing library operations including book tracking, member management, loan systems, and financial transactions. This database supports complete library workflows with robust data integrity and scalability.

## 🗄️ Database Schema

### Core Entities
- **Members** - Library patrons with membership tracking
- **Books** - Book catalog with detailed metadata
- **Authors** - Author information and biographies
- **Publishers** - Publishing company details
- **Book Copies** - Physical inventory management
- **Loans** - Book checkout and return system
- **Reservations** - Book reservation tracking
- **Fines** - Late return and penalty management
- **Staff** - Library employee records

## 🔗 Database Relationships

### One-to-Many Relationships
- **Publishers → Books** (One publisher publishes many books)
- **Books → Book_Copies** (One book title has multiple physical copies)
- **Members → Loans** (One member can have multiple active loans)
- **Members → Reservations** (One member can reserve multiple books)
- **Members → Fines** (One member can accumulate multiple fines)

### Many-to-Many Relationships
- **Books ↔ Authors** (via `book_authors` junction table)
- **Members ↔ Book_Copies** (via `loans` junction table)

### One-to-One Relationship
- **Loans → Fines** (One loan can have one associated fine)

## 🛠️ Technical Features

### Constraints Implemented
- **Primary Keys** on all main tables
- **Foreign Keys** for referential integrity
- **Unique Constraints** (ISBN, emails, barcodes, national IDs)
- **Check Constraints** for data validation
- **NOT NULL** on required fields
- **ENUM Constraints** for predefined value sets

### Data Validation
- Membership status tracking
- Book condition monitoring
- Loan duration enforcement
- Fine calculation and payment tracking
- Reservation expiry management

## 📊 Key Functionality

### Member Management
- Membership types (Student, Staff, Public, Premium)
- Membership expiry tracking
- Status monitoring (Active, Suspended, Expired)

### Inventory Control
- Multiple copy tracking per book title
- Condition monitoring (New, Good, Fair, Poor, Damaged)
- Location-based shelf management
- Acquisition cost tracking

### Loan System
- Checkout and return date tracking
- Automatic due date calculation
- Renewal count limitations
- Late fee calculations

### Financial Management
- Fine accumulation and payment tracking
- Multiple fine reasons (Late Return, Damage, Lost Book)
- Payment status monitoring

## 🚀 Installation

1. Execute the SQL script in MySQL:
```sql
source library_management_system.sql
```

2. The database `library_management_system` will be created with all tables and relationships

## 📈 Performance Optimization

### Indexes Created
- Email indexes for quick member/staff lookup
- Category and title indexes for book searching
- Status indexes for filtering active records
- Date indexes for reporting and expiry tracking

## 🔒 Data Integrity

- **Cascade deletes** where appropriate
- **Restricted deletes** to prevent data loss
- **Automatic timestamping** for audit trails
- **Constraint validation** at database level

## 💡 Business Logic Enforced

- Membership expiry validation
- Loan duration rules
- Fine calculation logic
- Reservation conflict prevention
- Copy availability tracking

---

**Designed for scalability and real-world library operations** 🏛️📖
