from auditor.db import init_db

conn = init_db("check.db", reset=True)
rows = conn.execute("SELECT name FROM sqlite_master WHERE type = 'table'").fetchall()
print([r[0] for r in rows])