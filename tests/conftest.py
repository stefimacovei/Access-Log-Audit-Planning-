from pathlib import Path

import pytest

from auditor.db import init_db, load_sql


@pytest.fixture
def db():
    conn = init_db(":memory:")
    load_sql(conn, Path(__file__).parent / "fixtures" / "tiny.sql")
    yield conn
    conn.close()