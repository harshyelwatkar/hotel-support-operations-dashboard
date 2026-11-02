USE hotel_support_operations;


CREATE TABLE support_tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_name VARCHAR(100) NOT NULL,
    issue_category VARCHAR(50) NOT NULL,
    issue_description VARCHAR(255) NOT NULL,
    priority VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL,
    resolved_at DATETIME,
    sla_hours INT NOT NULL
);

SHOW TABLES;

DESCRIBE support_tickets;