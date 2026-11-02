USE hotel_support_operations;


INSERT INTO support_tickets
(hotel_name, issue_category, issue_description, priority, status, created_at, resolved_at, sla_hours)
VALUES
('Hotel Sunshine', 'Reservation Sync', 'New reservations are not syncing with the hotel system', 'High', 'Open', '2026-10-27 09:30:00', NULL, 8),

('Grand Palace', 'Payment Failure', 'Guest payment was deducted but booking shows unpaid', 'Critical', 'Open', '2026-10-27 10:15:00', NULL, 4),

('Hotel Royal', 'Report Mismatch', 'Daily revenue report shows incorrect totals', 'Medium', 'Resolved', '2026-10-28 11:00:00', '2026-10-28 15:30:00', 24),

('City Inn', 'API Timeout', 'Reservation API is taking too long to respond', 'High', 'Pending', '2026-10-29 12:20:00', NULL, 8),

('Lake View Hotel', 'Login Issue', 'Hotel staff members are unable to log in', 'Low', 'Resolved', '2026-10-29 14:00:00', '2026-10-29 15:00:00', 24),

('Hotel Paradise', 'Reservation Sync', 'Updated booking details are not reflecting', 'Critical', 'Pending', '2026-10-30 09:45:00', NULL, 4),

('Green Valley', 'Payment Failure', 'Payment confirmation is missing from the booking record', 'High', 'Resolved', '2026-10-30 11:30:00', '2026-10-30 14:00:00', 8),

('Hotel Comfort', 'Report Mismatch', 'Occupancy report displays incorrect room counts', 'Medium', 'Open', '2026-10-31 10:00:00', NULL, 24);


SELECT * FROM support_tickets;

SELECT COUNT(*) AS total_tickets
FROM support_tickets;

INSERT INTO api_logs
(ticket_id, endpoint, response_code, response_time_ms, log_time, error_message)
VALUES

(1, '/api/reservations', 500, 2500, '2026-10-27 09:32:00', 'Internal server error'),

(1, '/api/reservations', 504, 5000, '2026-10-27 09:35:00', 'Reservation API timeout'),

(2, '/api/payments', 404, 1200, '2026-10-27 10:17:00', 'Payment record not found'),

(2, '/api/payments', 500, 3200, '2026-10-27 10:20:00', 'Payment processing failed'),

(3, '/api/reports', 200, 350, '2026-10-28 11:10:00', NULL),

(3, '/api/reports', 200, 420, '2026-10-28 11:30:00', NULL),

(4, '/api/reservations', 504, 6000, '2026-10-29 12:25:00', 'Gateway timeout'),

(4, '/api/reservations', 503, 4500, '2026-10-29 12:30:00', 'Service temporarily unavailable'),

(5, '/api/auth/login', 200, 280, '2026-10-29 14:05:00', NULL),

(6, '/api/reservations', 500, 3500, '2026-10-30 09:50:00', 'Reservation update failed'),

(7, '/api/payments', 200, 450, '2026-10-30 11:35:00', NULL),

(8, '/api/reports', 500, 2800, '2026-10-31 10:05:00', 'Report generation failed');

SELECT * FROM api_logs;

SELECT COUNT(*) AS total_logs
FROM api_logs;

SELECT
    s.ticket_id,
    s.hotel_name,
    s.issue_category,
    a.response_code,
    a.endpoint
FROM support_tickets s
JOIN api_logs a
ON s.ticket_id = a.ticket_id;