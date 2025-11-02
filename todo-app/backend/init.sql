-- Create database
CREATE DATABASE IF NOT EXISTS todos_db;

-- Create user if not exists (MySQL 5.7+)
CREATE USER IF NOT EXISTS 'todo_user'@'%' IDENTIFIED BY '12345678';

-- Grant privileges
GRANT ALL PRIVILEGES ON todos_db.* TO 'todo_user'@'%';

-- Apply changes
FLUSH PRIVILEGES;

-- Use database
USE todos_db;

-- Create table
CREATE TABLE IF NOT EXISTS todos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    completed TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create user and allow access from any host
CREATE USER IF NOT EXISTS 'todo_user'@'%' IDENTIFIED BY '12345678';
GRANT ALL PRIVILEGES ON todos_db.* TO 'todo_user'@'%';
FLUSH PRIVILEGES;