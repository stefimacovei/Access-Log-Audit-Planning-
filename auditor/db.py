import sqlite3
from pathlib import Path

SCHEMA_PATH = Path(__file__).parent / "schema.sql"


def connect(db_path: str | Path = ":memory:") -> sqlite3.Connection:
    """Open a connection with foreign keys on and name-based row access."""
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    return conn


def init_db(db_path: str | Path = ":memory:", reset: bool = False) -> sqlite3.Connection:
    """Create the tables. With reset=True, delete an existing file first."""
    if reset and str(db_path) != ":memory:":
        Path(db_path).unlink(missing_ok=True)
    conn = connect(db_path)
    conn.executescript(SCHEMA_PATH.read_text())
    conn.commit()
    return conn


def load_sql(conn: sqlite3.Connection, path: str | Path) -> None:
    """Run a .sql file (used for test fixtures)."""
    conn.executescript(Path(path).read_text())
    conn.commit()