-- Uses the official dev/qa fixture and never changes real accounts.
SELECT current_database() = 'hu_ref_020' AS isolated_database \gset
\if :isolated_database
\else
  \echo Wrong database; IAM fixtures were not changed.
  \quit 1
\endif
\getenv fixture_password FIXTURE_PASSWORD
SELECT count(*) = 2 AS fixtures_present FROM identity."user"
WHERE id IN ('c0000000-0000-0000-0000-000000000018', 'c0000000-0000-0000-0000-000000000019') \gset
\if :fixtures_present
\else
  \echo Apply IAM migrations with context dev before preparing fixtures.
  \quit 1
\endif
UPDATE identity."user"
SET password_hash = crypt(:'fixture_password', gen_salt('bf', 12)),
    must_change_password = FALSE, password_temporary_expires_at = NULL
WHERE id IN ('c0000000-0000-0000-0000-000000000018', 'c0000000-0000-0000-0000-000000000019');

SELECT column_name FROM information_schema.columns
WHERE table_schema = 'identity' AND table_name = 'user'
  AND column_name IN ('must_change_password', 'password_temporary_expires_at') ORDER BY column_name;
SELECT to_regclass('identity.outbox') AS iam_outbox;
SELECT u.email, r.name AS role FROM identity."user" u
JOIN rbac.user_role ur ON ur.user_id = u.id JOIN rbac.role r ON r.id = ur.role_id
WHERE u.id IN ('c0000000-0000-0000-0000-000000000018', 'c0000000-0000-0000-0000-000000000019') ORDER BY u.email, r.name;
