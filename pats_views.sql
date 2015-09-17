-- VIEWS FOR PATS DATABASE
--
-- by Sang Ha Lee & Linda Zhang
--

create view owners_view as 
	select o.id as "owner_id" ,o.first_name, o.last_name,o.street,o.city,o.state,o.zip,o.phone,o.email,o.active,
	p.id as "pet_id" , p.name, a.name, p.female,p.date_of_birth,p.active, v.id as"visit_id", v.date, v.weight, v.overnight_stay, v.total_charge
	from owners as o left join pets as p on o.id = p.owner_id left join visits as v on v.pet_id = p.id left join animals as a on a.id =p.animal_id;
	
create view medicine_views as 
	select mc.id as "medicine_cost_id" , mc.cost_per_unit as "current cost", mc.start_date, m.id as "medicine_id", m.name,
	m.description, m.stock_amount,m.method,m.unit,m.vaccine, am.recm_num_units,a.name,a.active
	from medicine_costs as mc left join medicines as m on mc.medicine_id=m.id left join animal_medicines as am on am.medicine_id = m.id left join animals as a on am.animal_id = a.id
	where mc.end_date is NULL;


	