-- INDEXES FOR PATS DATABASE
--
-- by Sang Ha Lee & Linda Zhang
--
--

CREATE INDEX medicine_description_idx ON medicines USING gin(to_tsvector(description)); 

CREATE INDEX procedure_description_idx ON procedures USING gin(to_tsvector(description));

CREATE INDEX note_content_idx ON notes USING gin(to_tsvector(content));

CREATE INDEX owner_names ON owners ((first_name || ' ' || last_name));

CREATE INDEX notable_type_idx ON notes (notable_type); 

CREATE INDEX pets_animal_idx ON pets (animal_id);

CREATE INDEX pets_owner_idx ON pets (owner_id);

CREATE INDEX visits_pet_idx ON visits (pet_id);

CREATE INDEX medicine_cost_med_idx ON medicine_costs (medicine_id);

CREATE INDEX animal_medicines_animals_idx ON animal_medicines(animal_id);

CREATE INDEX animal_medicines_med_idx ON animal_medicines(medicine_id);

CREATE INDEX visit_medicines_visit_idx ON visit_medicines(visit_id);

CREATE INDEX visit_medicines_med_idx ON visit_medicines(medicine_id);

CREATE INDEX treatments_visit_idx ON treatments (visit_id);

CREATE INDEX treatments_procd_idx ON treatments (procedure_id);

CREATE INDEX procedure_costs_procd_idx ON procedure_costs (procedure_id);

CREATE INDEX notes_user_idx ON notes (user_id);