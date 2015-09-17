-- FUNCTIONS AND TRIGGERS FOR PATS DATABASE
--
-- by Sang Ha Lee & Linda Zhang
--
--

-- calculate_total_costs
-- (associated with two triggers: update_total_costs_for_medicines_changes & update_total_costs_for_treatments_changes)

CREATE OR REPLACE FUNCTION calculate_total_costs() RETURNS integer AS $$
	DECLARE
		number_of_medicine_units_given integer;
		medicine_cost integer;
		medicine_discount decimal(2,2);
		procedure_cost integer;
		procedure_discount decimal(2,2);
		total_cost decimal(2,2);
		v_id integer;
	BEGIN
		v_id = (NEW.visit_id);
		-- number_of_medicine_units_given = (SELECT units_given FROM visit_medicines WHERE visit_id =v_id);
		medicine_cost = (SELECT sum(medicine_costs.cost_per_unit * visit_medicines.units_given)
						FROM visits JOIN visit_medicines ON visits.id = visit_medicines.visit_id 
						JOIN medicines ON visit_medicines.medicine_id = medicines.id
						JOIN medicine_costs ON medicines.id = medicine_costs.medicine_id
						WHERE medicine_costs.end_date = NULL and visits.id = v_id);
		medicine_discount = (SELECT discount FROM visit_medicines WHERE visit_id = v_id);
		procedure_cost = (SELECT sum(procedure_costs.cost) 
						FROM visits JOIN treatments on visits.id = treatments.visit_id 
						JOIN procedures ON treatments.procedure_id = procedures.id
						JOIN procedure_costs ON procedures.id = procedure_costs.procedure_id
						WHERE procedure_costs.end_date = NULL and visits.id = v_id);
		procedure_discount = (SELECT discount FROM treatments WHERE visit_id = v_id);
		total_cost = medicine_cost + procedure_cost - medicine_discount - procedure_discount;
		return total_cost;
	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER update_total_costs_for_medicines_changes
	AFTER INSERT OR UPDATE OR DELETE ON visit_medicines
	FOR EACH ROW 
	EXECUTE PROCEDURE calculate_total_costs();

CREATE TRIGGER update_total_costs_for_treatments_changes
	AFTER INSERT OR UPDATE OR DELETE ON treatments
	FOR EACH ROW
	EXECUTE PROCEDURE calculate_total_costs();

-- calculate_overnight_stay
-- (associated with a trigger: update_overnight_stay_flag)
CREATE OR REPLACE FUNCTION calculate_overnight_stay() RETURNS boolean AS $$
	DECLARE
		overnight_stay boolean;
		length_of_time integer;
		v_id integer;
	BEGIN
		v_id = (OLD.visit_id); --double check
		length_of_time = (SELECT SUM(procedures.length_of_time) 
						FROM treatments JOIN procedures ON treatments.procedure_id = procedures.id
						WHERE treatments.visit_id = v_id);
		IF length_of_time > 720 THEN 
			overnight_stay = 't';
		ELSE
			overnight_stay = 'f'; 
		END IF;
		RETURN overnight_stay;
	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER update_overnight_stay_flag
	AFTER INSERT OR UPDATE OR DELETE ON treatments 
	FOR EACH ROW 
	EXECUTE PROCEDURE calculate_overnight_stay();

-- set_end_date_for_medicine_costs
-- (associated with a trigger: set_end_date_for_previous_medicine_cost)

CREATE OR REPLACE FUNCTION set_end_date_for_medicine_costs() RETURNS TRIGGER AS $$
	DECLARE
		last_med_cost_id integer;
	BEGIN
		last_med_cost_id = (OLD.id);
		UPDATE medicine_costs SET end_date = current_date WHERE id = last_med_cost_id;
		RETURN NULL;
	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER set_end_date_for_previous_medicine_cost
	AFTER INSERT OR UPDATE OR DELETE ON medicine_costs
	FOR EACH ROW
	EXECUTE PROCEDURE set_end_date_for_medicine_costs();



-- set_end_date_for_procedure_costs
-- (associated with a trigger: set_end_date_for_previous_procedure_cost)

CREATE OR REPLACE FUNCTION set_end_date_for_procedure_costs() RETURNS TRIGGER AS $$
	DECLARE
		last_proced_cost_id integer;
	BEGIN
		last_proced_cost_id = (OLD.id);
		UPDATE procedure_costs SET end_date = current_date WHERE id = last_proced_cost_id;
		RETURN NULL;
	END;
	$$ LANGUAGE plpgsql; 

CREATE TRIGGER set_end_date_for_previous_procedure_costs
	AFTER INSERT OR UPDATE OR DELETE ON procedure_costs
	FOR EACH ROW 
	EXECUTE PROCEDURE set_end_date_for_procedure_costs();
-- decrease_stock_amount_after_dosage
-- (associated with a trigger: update_stock_amount_for_medicines)


CREATE OR REPLACE FUNCTION decrease_stock_amount_after_dosage() RETURNS TRIGGER AS $$
	DECLARE
		current_stock_amount integer;
		last_med_id integer;
		recent_dosage integer;
	BEGIN
		last_med_id = (OLD.medicine_id);
		current_stock_amount = (SELECT stock_amount FROM medicines WHERE id = last_med_id);
		recent_dosage = (SELECT units_given FROM visit_medicines WHERE medicine_id = last_med_id);
		current_stock_amount = current_stock_amount - recent_dosage;
		UPDATE medicines SET stock_amount = current_stock_amount WHERE id = last_med_id;
	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER update_stock_amount_for_medicines
	AFTER INSERT OR UPDATE OR DELETE ON visit_medicines
	FOR EACH ROW 
	EXECUTE PROCEDURE decrease_stock_amount_after_dosage();

-- verify_that_medicine_requested_in_stock
-- (takes medicine_id and units_needed as arguments and returns a boolean)

CREATE OR REPLACE FUNCTION verify_that_medicine_requested_in_stock(m_id integer, units_needed integer) RETURNS boolean AS $$
	DECLARE
		stock_amount integer;
		verification boolean;
	BEGIN
		stock_amount = (SELECT stock_amount FROM medicines WHERE medicines.id = m_id); 
		IF stock_amount - units_needed >= 0 THEN
			verification = 'true';
		ELSE
			verification = 'false';
		END IF;
	RETURN verification; 
END;
$$ LANGUAGE plpgsql;


-- verify_that_medicine_is_appropriate_for_pet
-- (takes medicine_id and pet_id as arguments and returns a boolean)

CREATE OR REPLACE FUNCTION verify_that_medicine_is_appropriate_for_pet(m_id integer, p_id integer) RETURNS boolean AS $$
	DECLARE
		visit_units_given integer;
		recommended_number_of_units integer;
		is_appropriate boolean;
	BEGIN
		visit_units_given = (SELECT visit_medicines.units_given FROM visit_medicines 
			JOIN visits on visit_medicines.visit_id = visits.id  
			WHERE visit_medicines.medicine_id = m_id AND visits.pet_id = p_id);
		recommended_number_of_units = (SELECT animal_medicines.recommended_num_of_units
			FROM animal_medicines JOIN animals ON animal_medicines.animal_id = animals.id
			JOIN pets ON animals.id = pets.animal_id
			WHERE animal_medicines.medicine_id = m_id AND pets.id = p_id);
		IF visit_units_given <= recommended_number_of_units THEN
			is_appropriate = 'true';
		ELSE 
			is_appropriate = 'false';
		END IF;
	RETURN is_appropriate;
END;
$$ LANGUAGE plpgsql; 