USE hotel_support_operations;

SELECT
    response_code,
    COUNT(*) AS total_requests
FROM api_logs
GROUP BY response_code
ORDER BY response_code;

-- Identify hotels with the most API failures

SELECT
    s.hotel_name,
    COUNT(*) AS total_failures
FROM support_tickets s
JOIN api_logs a
    ON s.ticket_id = a.ticket_id
WHERE a.response_code >= 400
GROUP BY s.hotel_name
ORDER BY total_failures DESC;

-- Identify API endpoints with the most failures

SELECT
    endpoint,
    COUNT(*) AS total_failures
FROM api_logs
WHERE response_code >= 400
GROUP BY endpoint
ORDER BY total_failures DESC;

-- Calculate average response time for each API endpoint

SELECT
    endpoint,
    ROUND(AVG(response_time_ms), 2) AS average_response_time
FROM api_logs
GROUP BY endpoint
ORDER BY average_response_time DESC;

-- Identify unresolved support tickets

SELECT
    ticket_id,
    hotel_name,
    issue_category,
    priority,
    status,
    created_at,
    sla_hours
FROM support_tickets
WHERE status IN ('Open', 'Pending')
ORDER BY created_at;

-- Identify tickets that have breached their SLA

SELECT
    ticket_id,
    hotel_name,
    issue_category,
    status,
    sla_hours,

    TIMESTAMPDIFF(
        HOUR,
        created_at,
        COALESCE(resolved_at, NOW())
    ) AS hours_taken,

    CASE
        WHEN TIMESTAMPDIFF(
            HOUR,
            created_at,
            COALESCE(resolved_at, NOW())
        ) > sla_hours
        THEN 'Breached'
        ELSE 'Within SLA'
    END AS sla_status

FROM support_tickets
ORDER BY ticket_id;

-- Consolidated API troubleshooting report

SELECT
    s.ticket_id,
    s.hotel_name,
    s.issue_category,
    s.status,

    COUNT(a.log_id) AS total_api_requests,

    SUM(
        CASE
            WHEN a.response_code >= 400 THEN 1
            ELSE 0
        END
    ) AS failed_requests,

    ROUND(
        AVG(a.response_time_ms), 2
    ) AS average_response_time,

    MAX(a.response_time_ms) AS max_response_time

FROM support_tickets s

LEFT JOIN api_logs a
    ON s.ticket_id = a.ticket_id

GROUP BY
    s.ticket_id,
    s.hotel_name,
    s.issue_category,
    s.status

ORDER BY failed_requests DESC;