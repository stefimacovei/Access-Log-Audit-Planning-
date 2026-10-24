-- The manager must be inserted before the people who reference them.
INSERT INTO users VALUES (1, 'Chen Wei',   'Marketing', 'manager',  NULL);
INSERT INTO users VALUES (2, 'Maria Lopez','Marketing', 'analyst',  1);
INSERT INTO users VALUES (3, 'Tom Becker', 'Finance',   'engineer', 1);

INSERT INTO datasets VALUES (1, 'salaries',    'RESTRICTED', 'HR');
INSERT INTO datasets VALUES (2, 'web_traffic', 'INTERNAL',   'Marketing');

-- Maria's salaries grant expired the day before her query (the violation).
INSERT INTO access_grants VALUES (1, 2, 1, '2026-01-01', '2026-03-13', 'Q1 pay review', NULL);
INSERT INTO access_grants VALUES (2, 2, 2, '2026-01-01', '2026-12-31', 'Campaign reporting', NULL);
INSERT INTO access_grants VALUES (3, 3, 2, '2026-01-01', '2026-12-31', 'Traffic analysis', NULL);

-- 1: violation (expired grant)   2 and 3: clean
INSERT INTO query_log VALUES (1, 2, '2026-03-14 10:15:00', 1,
    'SELECT employee_id, salary FROM salaries', 'employee_id,salary', 40, '10.0.0.5', 1);
INSERT INTO query_log VALUES (2, 2, '2026-03-14 11:00:00', 2,
    'SELECT page, visits FROM web_traffic', 'page,visits', 200, '10.0.0.5', 1);
INSERT INTO query_log VALUES (3, 3, '2026-03-14 11:30:00', 2,
    'SELECT page, visits FROM web_traffic', 'page,visits', 150, '10.0.0.9', 1);