import sqlite3

from auditor.rules.base import Finding, run_rule


def find_no_valid_grant(conn: sqlite3.Connection) -> list[Finding]:
    return run_rule(conn, 1, "01_no_valid_grant.sql")