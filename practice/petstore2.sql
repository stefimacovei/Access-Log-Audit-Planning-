CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    email       TEXT UNIQUE
);

CREATE TABLE pets (
    pet_id  INTEGER PRIMARY KEY,
    name    TEXT NOT NULL,
    species TEXT NOT NULL CHECK (species IN ('dog', 'cat', 'bird', 'fish')),
    price   REAL NOT NULL CHECK (price >= 0)
);

CREATE TABLE sales (
    sale_id     INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    pet_id      INTEGER NOT NULL REFERENCES pets(pet_id),
    sold_on     TEXT NOT NULL   -- ISO text, e.g. 2026-03-14
);

INSERT INTO customers VALUES (1, 'Ana', 'ana@example.com'), (2, 'Bob', 'bob@example.com');
INSERT INTO pets VALUES (1, 'Rex', 'dog', 250.0), (2, 'Mia', 'cat', 120.0);
INSERT INTO sales VALUES (1, 1, 1, '2026-03-14'), (2, 2, 2, '2026-03-15');