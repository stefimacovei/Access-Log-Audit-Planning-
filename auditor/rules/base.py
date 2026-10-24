from dataclasses import dataclass
from pathlib import Path
import sqlite3

SQL_DIR = Path(__file__).resolve().parents[2] / "sql"


@dataclass(frozen=True)
class Finding:
    rule_id: int
    query_id: int
    user_id: int
    dataset_id: int
    detail: str


def run_rule(conn: sqlite3.Connection, rule_id: int, sql_file: str, params: dict | None = None) -> list[Finding]:
    """Run one rule's .sql file and turn each result row into a Finding."""
    sql = (SQL_DIR / sql_file).read_text()
    rows = conn.execute(sql, params or {}).fetchall()
    return [Finding(rule_id, r["query_id"], r["user_id"], r["dataset_id"], r["detail"]) for r in rows]