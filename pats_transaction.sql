-- TRANSACTION EXAMPLE FOR PATS DATABASE
--
-- by Sang Ha Lee & Linda Zhang
--
--

BEGIN;
INSERT INTO visits (pet_id,date,weight,overnight_stay) VALUES (173,current_date,39,false);
INSERT INTO treatments (visit_id,procedure_id,successful,discount) VALUES 
(select id from visits where animal_id = 173 AND date= current_date, select id from procedures where name = "examination", true, 0);
INSERT INTO visit_medicines (visit_id, medicine_id,units_given, discount)
VALUES (select id from visits where animal_id = 173 AND date= current_date,3,500,0);
INSERT INTO visit_medicines (visit_id, medicine_id,units_given, discount)
VALUES (select id from visits where animal_id = 173 AND date= current_date,5,200,0);
update "total cost calculation goes here (when function is created)"
COMMIT;