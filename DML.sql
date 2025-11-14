-- Create
    -- add a new animal
INSERT INTO Animals (animal_name, species_ID, zoo_ID, arrival_date) VALUES  
(:nameInput, :species_id_from_dropdown_Input, :zoo_id_from_dropdown_Input, :arrivalDate);
    -- add a new species
INSERT INTO Species(common_name, scientific_name) VALUES
(:commonNameInput, :scientificNameInput);
    -- add a new zoo
INSERT INTO Zoos(zoo_name, city, state, total_animals) VALUES
(:zooNameInput, :cityNameInput, :stateNameInput, :totalAnimalInput);
    -- add a new employee
INSERT INTO Employees(first_name, last_name, zoo_ID, role_ID) VALUES
(:firstNameInput, :lastNameInput, :zoo_id_from_dropdown_Input, :role_id_from_dropdown_Input);
    -- associate an employee to an animal, diet, feeding schedule and enclosure
INSERT INTO Caretakings(animal_ID, employee_ID, diet_ID, feeding_schedule_ID, enclosure_ID) VALUES
(:animal_id_from_dropdown_Input, :employee_id_from_dropdown_input, :diet_id_from_dropdown_input, 
:feeding_schedule_id_from_dropdown_input, :enclosure_id_from_dropdown_input);
    -- add a new diet
INSERT INTO Diets(diet_details) VALUES (:dietDetailsInput);
    -- add a new feeding schedule
INSERT INTO FeedingSchedules(feeding_time) VALUES (:feedTime);
    -- add a new enclosure
INSERT INTO Enclosures(enclosure_type) VALUES (:enclosureTypeInput);
    -- add a new role
INSERT INTO Roles (role_title) VALUES (:roleTitleInput);

-- Retrieve
    -- get a single animal's data for updating the animal form
SELECT animal_ID, animal_name, Species.common_name AS species, 
    Zoos.zoo_name AS zoo, arrival_date FROM Animals
    INNER JOIN Species ON Animals.species_ID = Species.species_ID
    INNER JOIN Zoos ON Animals.zoo_ID = Zoos.zoo_ID;
    -- get all animal's data to populate a dropdown to associate with a caretaking
SELECT animal_ID AS aid, animal_name FROM Animals;
    -- get a single species' data for updating the species form
SELECT species_ID, common_name, scientific_name FROM Species;
    -- get all species to populate a dropdown to associate with an animal
SELECT species_ID AS sid, common_name FROM Species;
    -- get a single zoo's data for updating the zoo form
SELECT zoo_ID, city, state, total_animals FROM Zoos;
    -- get all species to populate a dropdown to associate with an animal or employee
SELECT zoo_ID as zid FROM Zoos;
    -- get a single employee's data for updating the employee form
SELECT employee_ID, first_name, last_name, Zoo.zoo_name, Roles.role_title FROM Employees
    INNER JOIN Zoos ON Employees.zoo_ID = Zoos.zoo_ID
    INNER JOIN Roles ON Employees.role_ID = Roles.role_ID;
    -- get all employees to populate a dropdown to associate with a caretaking
SELECT employee_ID AS emid, first_name + ' ' + last_name AS FullName FROM Employees;
    -- get a single caretaking's data for updating the caretaking form
SELECT Animals.animal_name, employee.FullName, diet.diet_details,
    FeedingSchedules.feeding_time, Enclosures.enclosure_type FROM Caretakings
    INNER JOIN Animals ON Caretakings.animal_ID = aid,
    INNER JOIN Employees ON Caretakings.employee_ID = emid,
    INNER JOIN Diets ON Caretakings.diet_ID = did,
    INNER JOIN FeedingSchedules ON Caretakings.feeding_schedule_ID = fsid,
    INNER JOIN Enclosures ON Caretakings.enclosure_ID = enid;
    -- get a single diet's data for updating the diet form
SELECT diet_ID, diet_details FROM Diets;
    -- get all diets to populate a dropdown to associate with a caretaking
SELECT diet_ID did, FROM Diets;
    -- get a single feeding schedule's data for updating the feeding schedule form
SELECT feeding_schedule_ID, feeding_time FROM FeedingSchedules;
    -- get all feeding schedules to populate a dropdown to associate with a caretaking
SELECT feeding_schedule_ID as fsid FROM FeedingSchedules;
    -- get a single enclosure's data for updating the feeding schedule form
SELECT enclosure_ID, enclosure_type FROM Enclosures;
    -- get all enclosures to populate a dropdown to associate with a caretaking
SELECT enclosure_ID as enid FROM Enclosures;
    -- get a single role's data for updating the role form
SELECT role_ID, role_title FROM Roles;
    -- get all roles to populate a dropdown to associate with a caretaking
SELECT role_ID AS rid FROM Roles;

-- Update
UPDATE Animals
    SET animal_name = :nameInput, species_ID = :species_id_from_dropdown_Input,
        zoo_ID = zoo_id_from_dropdown_Input, arrival_date = :arrivalDate
    WHERE animal_ID = :animal_id_from_dropdown_Input;
UPDATE Species
    SET common_name =:commonNameInput, scientific_name =:scientificNameInput
    WHERE species_ID =:species_id_from_dropdown_Input;
UPDATE Zoos
    SET zoo_name =:zooNameInput, city =:cityNameInput, state =:stateNameInput, total_animals =:totalAnimalInput
    WHERE zoo_ID =:zoo_id_from_dropdown_Input
UPDATE Employees
    SET first_name =:firstNameInput, last_name =:lastNameInput, 
    zoo_ID =:zoo_id_from_dropdown_Input, role_ID =:role_id_from_dropdown_Input
    WHERE employee_ID =:employee_id_from_dropdown_input
UPDATE Diets
    SET diet_details =:dietDetailsInput
    WHERE diet_ID =:diet_id_from_dropdown_input
UPDATE FeedingSchedules
    SET =:feeding_time
    WHERE feeding_schedule_ID =:feeding_schedule_id_from_dropdown_input
UPDATE Enclosures
    SET enclosure_type =:enclosureTypeInput
    WHERE enclosure_ID =:enclosure_id_from_dropdown_input
-- Delete
    -- delete an animal
DELETE FROM Animals WHERE animal_ID = :animal_ID_selected_from_browse_animal_page;
DELETE FROM Species WHERE species_ID = :species_id_from_dropdown_Input;
DELETE FROM Zoos WHERE zoo_ID = :zoo_id_from_dropdown_Input;
DELETE FROM Employees WHERE employee_ID =:employee_id_from_dropdown_input;
DELETE FROM Diets WHERE diet_ID =:diet_id_from_dropdown_input;
DELETE FROM FeedingSchedules WHERE feeding_schedule_ID =:feeding_schedule_id_from_dropdown_input;
DELETE FROM Enclosures WHERE enclosure_ID =:enclosure_id_from_dropdown_input;