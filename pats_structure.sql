-- TABLE STRUCTURE FOR PATS DATABASE
--
-- by Sang Ha Lee & Linda Zhang
--
--

CREATE TABLE owners (
	id SERIAL NOT NULL,
	first_name varchar NOT NULL,
	last_name varchar NOT NULL,
	street varchar NOT NULL,
	city varchar NOT NULL,
	state varchar DEFAULT 'PA',
	zip varchar NOT NULL,
	phone varchar, --limit to 10 digits 
	email varchar,
	active boolean DEFAULT true
);

CREATE TABLE animals (
	id SERIAL NOT NULL,
	name varchar NOT NULL,
	active boolean DEFAULT true
);

CREATE TABLE pets (
	id SERIAL NOT NULL PRIMARY KEY,
	name varchar NOT NULL,
	animal_id SERIAL NOT NULL,
	owner_id SERIAL NOT NULL,
	female boolean NOT NULL,
	date_of_birth date,
	active boolean DEFAULT true
);

CREATE TABLE visits (
	id SERIAL NOT NULL,
	pet_id SERIAL NOT NULL,
	date date NOT NULL,
	weight int,
	overnight_stay boolean DEFAULT false,
	total_charge integer DEFAULT 0
);

CREATE TABLE medicines (
	id SERIAL NOT NULL,
	name varchar NOT NULL,
	description text NOT NULL,
	stock_amount integer NOT NULL,
	method varchar NOT NULL,
	unit varchar NOT NULL,
	vaccine boolean DEFAULT false
);

CREATE TABLE medicine_costs(
	id SERIAL NOT NULL,
	medicine_id SERIAL NOT NULL,
	cost_per_unit integer NOT NULL,
	start_date date NOT NULL,
	end_date date
);

CREATE TABLE animal_medicines(
	id SERIAL NOT NULL,
	animal_id SERIAL NOT NULL,
	medicine_id SERIAL NOT NULL,
	recommended_num_of_units integer
);
CREATE TABLE visit_medicines (
	id SERIAL NOT NULL,
	visit_id SERIAL NOT NULL,
	medicine_id SERIAL NOT NULL,
	units_given varchar NOT NULL,
	discount decimal(2,2) NOT NULL
);

CREATE TABLE treatments (
	id SERIAL NOT NULL,
	visit_id SERIAL NOT NULL,
	procedure_id SERIAL NOT NULL,
	successful boolean,
	discount decimal(2,2) NOT NULL
);
CREATE TABLE procedures( 
	id SERIAL NOT NULL,
	name varchar NOT NULL,
	description text,
	length_of_time integer NOT NULL,
	active boolean DEFAULT true
);

CREATE TABLE procedure_costs (
	id SERIAL NOT NULL,
	procedure_id SERIAL NOT NULL,
	cost varchar NOT NULL,
	start_date date NOT NULL,
	end_date date
); 

CREATE TABLE notes (
	id SERIAL NOT NULL,
	notable_type varchar NOT NULL,
	notable_id SERIAL NOT NULL,
	title varchar NOT NULL,
	content text NOT NULL,
	user_id SERIAL NOT NULL,
	date date NOT NULL
);

CREATE TABLE users (
	id SERIAL NOT NULL,
	first_name varchar NOT NULL,
	last_name varchar NOT NULL,
	role varchar NOT NULL,
	username varchar NOT NULL,
	password_digest varchar NOT NULL, --is password a varchar
	active boolean DEFAULT true
);