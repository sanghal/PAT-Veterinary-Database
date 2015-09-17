-- PRIVILEGES FOR pats USER OF PATS DATABASE
--
-- by Sang Ha Lee & Linda Zhang
--
--
-- SQL needed to create the pats user
CREATE USER pats WITH LOGIN ENCRYPTED PASSWORD 'profh'; -- not real



-- SQL to limit pats user access on key tables
--GRANT SELECT ON users TO pats;
--GRANT SELECT, UPDATE, INSERT, DELETE ON owners TO pats;
REVOKE UPDATE('units_given') ON visit_medicines FROM pats;
REVOKE DELETE ON visit_medicines FROM pats;
REVOKE DELETE ON treatments FROM pats; 

--- FOR security purposes, all databases users who are not superusers are limited to SELECT access only on the users table. 

REVOKE UPDATE, INSERT, DELETE ON users FROM PUBLIC;
GRANT SELECT ON users TO PUBLIC;