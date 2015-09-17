-- CONSTRAINTS FOR PATS DATABASE
-- CONSTRAINTS FOR PATS DATABASE
--
-- by (student_1) & (student_2)

ALTER TABLE owners ADD CONSTRAINT owners_pkey PRIMARY KEY (id);
ALTER TABLE pets ADD CONSTRAINT pets_pkey PRIMARY KEY (id);
ALTER TABLE visits ADD CONSTRAINT visits_pkey PRIMARY KEY (id);
ALTER TABLE animals ADD CONSTRAINT animals_pkey PRIMARY KEY (id);
ALTER TABLE medicines ADD CONSTRAINT medicines_pkey PRIMARY KEY (id);
ALTER TABLE medicine_costs ADD CONSTRAINT medicine_costs_pkey PRIMARY KEY (id);
ALTER TABLE animal_medicines ADD CONSTRAINT animal_medicines_pkey PRIMARY KEY (id);
ALTER TABLE visit_medicines ADD CONSTRAINT visit_medicines_pkey PRIMARY KEY (id);
ALTER TABLE procedures ADD CONSTRAINT procedures_pkey PRIMARY KEY (id);
ALTER TABLE treatments ADD CONSTRAINT treatments_pkey PRIMARY KEY (id);
ALTER TABLE procedure_costs ADD CONSTRAINT  procedure_costs_pkey PRIMARY KEY (id);
ALTER TABLE notes ADD CONSTRAINT notes_pkey PRIMARY KEY (id);
ALTER TABLE users ADD CONSTRAINT stores_pkey PRIMARY KEY (id);

ALTER TABLE pets ADD CONSTRAINT  pet_fkey1 FOREIGN KEY (owner_id) REFERENCES owners (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE pets ADD CONSTRAINT pet_fkey2 FOREIGN KEY (animal_id) REFERENCES animals (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE visits ADD CONSTRAINT visit_fkey FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE medicine_costs ADD CONSTRAINT medicine_cost_fkey FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE animal_medicines ADD CONSTRAINT animal_medicine1_fkey FOREIGN KEY (animal_id) REFERENCES animals (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE animal_medicines ADD CONSTRAINT animal_medicine2_fkey FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE visit_medicines ADD CONSTRAINT visit_medicine1_fkey FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE visit_medicines ADD CONSTRAINT visit_medicine2_fkey FOREIGN KEY (visit_id) REFERENCES visits (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE treatments ADD CONSTRAINT treatment_fkey1 FOREIGN KEY (visit_id) REFERENCES visits (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE treatments ADD CONSTRAINT treatment_fkey2 FOREIGN KEY (procedure_id) REFERENCES procedures (id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE procedure_costs ADD CONSTRAINT procedure_cost_fkey FOREIGN KEY (procedure_id) REFERENCES procedures (id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE notes ADD CONSTRAINT note_fkey FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE;
-- by Sang Ha Lee & Linda Zhang
--
--