SELECT q.query_id, q.user_id, q.dataset_id,
    CASE
        WHEN EXISTS (
            SELECT 1 FROM access_grants g2
            WHERE g2.user_id = q.user_id AND g2.dataset_id = q.dataset_id
        ) THEN 'expired_or_not_yet_valid'
        ELSE 'no_grant'
    END AS detail
FROM query_log q
WHERE q.success = 1
AND NOT EXISTS (
    SELECT 1 FROM access_grants g
    WHERE g.user_id = q.user_id
    AND g.dataset_id = q.dataset_id
    AND date(q.timestamp) BETWEEN g.granted_on AND g.expires_on
)
ORDER BY q.query_id;