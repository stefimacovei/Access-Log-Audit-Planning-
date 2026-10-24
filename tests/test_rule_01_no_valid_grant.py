from auditor.rules.no_valid_grant import find_no_valid_grant


def test_flags_expired_grant_only(db):
    findings = find_no_valid_grant(db)
    assert [f.query_id for f in findings] == [1]
    assert findings[0].detail == "expired_or_not_yet_valid"


def test_grant_is_valid_on_its_expiry_day(db):
    # Marias salaries grant ends 2026-03-13, so all good
    db.execute(
        "INSERT INTO query_log VALUES (4, 2, '2026-03-13 09:00:00', 1, 'SELECT salary FROM salaries', 'salary', 5, '10.0.0.5', 1)"
    )
    assert 4 not in [f.query_id for f in find_no_valid_grant(db)]


def test_user_with_no_grant_at_all_is_flagged(db):
    # Tom has never had a grant for salaries, he is poor
    db.execute(
        "INSERT INTO query_log VALUES (5, 3, '2026-03-14 12:00:00', 1, 'SELECT salary FROM salaries', 'salary', 5, '10.0.0.9', 1)"
    )
    flagged = {f.query_id: f.detail for f in find_no_valid_grant(db)}
    assert flagged[5] == "no_grant"