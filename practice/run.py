import sqlite3
from pathlib import Path

DB_PATH = Path("practice/petstore2.db")
SCHEMA = Path("practice/petstore2.sql")

DB_PATH.unlink(missing_ok=True)          # start fresh every run
conn = sqlite3.connect(DB_PATH)
conn.execute("PRAGMA foreign_keys = ON") # SQLite ignores foreign keys unless you do this
conn.executescript(SCHEMA.read_text())
conn.commit()

rows = conn.execute("""
    SELECT c.name, p.name, p.price
    FROM sales s
    JOIN customers c ON c.customer_id = s.customer_id
    JOIN pets p      ON p.pet_id = s.pet_id
""").fetchall()

for row in rows:
    print(row)
conn.close()