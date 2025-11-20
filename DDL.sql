//*
    Project Title: ZooLink PNW
    Team 46: Joseph Schmid, Courtney Barrick
    CS340: Project Step 4 Draft
*/
DROP PROCEDURE IF EXISTS sp_load_zoolinkpnw;
DELIMITER //
CREATE PROCEDURE sp_load_zoolinkpnw()
BEGIN
    SET FOREIGN_KEY_CHECKS=0;
    SET AUTOCOMMIT = 0;

    /*
        CREATE TABLES
    */

    -- Zoos Table (must be first - no dependencies)
    CREATE OR REPLACE TABLE Zoos (
        zoo_ID INT(11) AUTO_INCREMENT UNIQUE NOT NULL,
        zoo_name VARCHAR(50) NOT NULL,
        city VARCHAR(50) NOT NULL,
        state VARCHAR(50) NOT NULL,
        total_animals INT NOT NULL,
        PRIMARY KEY (zoo_ID)
    );

    -- Diets Table (no dependencies)
    CREATE OR REPLACE TABLE Diets (
        diet_ID INT AUTO_INCREMENT UNIQUE NOT NULL,
        diet_name VARCHAR(255) NOT NULL,
        diet_details VARCHAR(255),
        PRIMARY KEY (diet_ID)
    );

    -- Enclosures Table (no dependencies)
    CREATE OR REPLACE TABLE Enclosures(
        enclosure_ID INT AUTO_INCREMENT UNIQUE NOT NULL,
        enclosure_type VARCHAR(255) NOT NULL,
        PRIMARY KEY (enclosure_ID)
    );

    -- Roles Table (no dependencies)
    CREATE OR REPLACE TABLE Roles(
        role_ID INT AUTO_INCREMENT UNIQUE NOT NULL,
        role_title VARCHAR(50) NOT NULL,
        PRIMARY KEY(role_ID)
    );

    -- Species Table (depends on Diets and Enclosures)
    CREATE OR REPLACE TABLE Species(
        species_ID INT(11) AUTO_INCREMENT UNIQUE NOT NULL,
        common_name VARCHAR(50) NOT NULL,
        scientific_name VARCHAR(50) NOT NULL,
        diet_ID INT NOT NULL,
        enclosure_ID INT NOT NULL,
        PRIMARY KEY (species_ID),
        FOREIGN KEY (diet_ID) REFERENCES Diets(diet_ID) ON DELETE CASCADE,   
        FOREIGN KEY (enclosure_ID) REFERENCES Enclosures(enclosure_ID) ON DELETE CASCADE
    );

    -- Employees Table (depends on Zoos and Roles) - FIXED: Removed diet_ID and enclosure_ID
    CREATE OR REPLACE TABLE Employees(
        employee_ID INT AUTO_INCREMENT UNIQUE NOT NULL,
        zoo_ID INT NOT NULL,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        role_ID INT NOT NULL,
        PRIMARY KEY (employee_ID),
        FOREIGN KEY (zoo_ID) REFERENCES Zoos(zoo_ID) ON DELETE CASCADE,
        FOREIGN KEY (role_ID) REFERENCES Roles(role_ID) ON DELETE CASCADE
    );

    -- Animals Table (depends on Zoos and Species)
    CREATE OR REPLACE TABLE Animals(
        animal_ID INT(11) AUTO_INCREMENT UNIQUE NOT NULL,
        zoo_ID INT NOT NULL,
        species_ID INT NOT NULL,
        arrival_date DATE,
        animal_name VARCHAR(50) NOT NULL,
        PRIMARY KEY(animal_ID),
        FOREIGN KEY (zoo_ID) REFERENCES Zoos(zoo_ID) ON DELETE CASCADE,
        FOREIGN KEY (species_ID) REFERENCES Species(species_ID) ON DELETE CASCADE
    );

    -- Caretakings Table (depends on Animals and Employees)
    CREATE OR REPLACE TABLE Caretakings(
        animal_ID INT NOT NULL,
        employee_ID INT NOT NULL,
        feeding_time TIME NOT NULL,
        PRIMARY KEY (animal_ID, employee_ID),
        FOREIGN KEY (animal_ID) REFERENCES Animals(animal_ID) ON DELETE CASCADE,
        FOREIGN KEY (employee_ID) REFERENCES Employees(employee_ID) ON DELETE CASCADE
    );


    /*
        INSERT DATA
    */

    -- Zoos Table
    INSERT INTO Zoos (zoo_name, city, state, total_animals)
    VALUES
    ('Portland Zoo', 'Portland', 'OR', 15),
    ('Woodland Park Zoo', 'Seattle', 'WA', 25),
    ('Oregon Coast Zoo', 'Newport', 'OR', 28);

    -- Roles Table
    INSERT INTO Roles (role_title)
    VALUES
    ('Feeder'),
    ('Zookeeper'),
    ('Veterinarian'),
    ('Maintenance Staff');

    -- Employees Table
    INSERT INTO Employees (zoo_ID, first_name, last_name, role_ID)
    VALUES
    ((SELECT zoo_ID FROM Zoos WHERE zoo_name = 'Portland Zoo'),
    'John', 'Walker',
      (SELECT role_ID FROM Roles WHERE role_title = 'Feeder')),
    ((SELECT zoo_ID FROM Zoos WHERE zoo_name = 'Woodland Park Zoo'),
    'Clarissa', 'Brown',
      (SELECT role_ID FROM Roles WHERE role_title = 'Feeder')),
    ((SELECT zoo_ID FROM Zoos WHERE zoo_name = 'Oregon Coast Zoo'),
    'Sophia', 'Kim',
      (SELECT role_ID FROM Roles WHERE role_title = 'Zookeeper')),
    ((SELECT zoo_ID FROM Zoos WHERE zoo_name = 'Woodland Park Zoo'),
    'Mark', 'Thompson',
      (SELECT role_ID FROM Roles WHERE role_title = 'Veterinarian')),
    ((SELECT zoo_ID FROM Zoos WHERE zoo_name = 'Oregon Coast Zoo'),
    'Laura', 'Johnson',
      (SELECT role_ID FROM Roles WHERE role_title = 'Maintenance Staff'));

    -- Diets Table
    INSERT INTO Diets (diet_name, diet_details)
    VALUES
    ('Herbivore diet', 'grasses, fruits, and vegetables'),
    ('Carnivore diet', 'fish and small mammals'),
    ('Omnivore diet', 'mixed meats and plants'),
    ('Special diet', 'high protein for recovery');

    -- Enclosures Table
    INSERT INTO Enclosures (enclosure_type)
    VALUES
    ('Savannah'),
    ('Forest'),
    ('Aquatic'),
    ('Aviary Dome'),
    ('Mountain');

    -- Species Table
    INSERT INTO Species (common_name, scientific_name, diet_ID, enclosure_ID)
    VALUES
    ('Lion', 'Panthera leo',
    (SELECT diet_ID FROM Diets WHERE diet_name = 'Carnivore Diet'),
    (SELECT enclosure_ID FROM Enclosures WHERE enclosure_type = 'Savannah')),
    ('Plains Zebra', 'Equus quaagga',
    (SELECT diet_ID FROM Diets WHERE diet_name = 'Herbivore Diet'),
    (SELECT enclosure_ID FROM Enclosures WHERE enclosure_type = 'Forest')),
    ('African Elephant', 'Loxodonta horribilis',
    (SELECT diet_ID FROM Diets WHERE diet_name = 'Omnivore Diet'),
    (SELECT enclosure_ID FROM Enclosures WHERE enclosure_type = 'Mountain')),
    ('Red Panda', 'Ailurus fulgens',
    (SELECT diet_ID FROM Diets WHERE diet_name = 'Herbivore Diet'),
    (SELECT enclosure_ID FROM Enclosures WHERE enclosure_type = 'Forest')),
    ('Sea Otter', 'Enhydra lutris',
    (SELECT diet_ID FROM Diets WHERE diet_name = 'Carnivore Diet'),
    (SELECT enclosure_ID FROM Enclosures WHERE enclosure_type = 'Aquatic'));

    -- Animals Table
    INSERT INTO Animals (zoo_ID, species_ID, arrival_date, animal_name)
    VALUES
    ((SELECT zoo_ID FROM Zoos WHERE zoo_name = 'Portland Zoo'), 
    (SELECT species_ID FROM Species WHERE common_name = 'Lion'),
    '2023-03-15', 'Simba'),
    ((SELECT zoo_ID FROM Zoos WHERE zoo_name = 'Portland Zoo'),
    (SELECT species_ID FROM Species WHERE common_name = 'Plains Zebra'),
    '2024-02-05', 'Clara'),
    ((SELECT zoo_ID FROM Zoos WHERE zoo_name = 'Woodland Park Zoo'),
    (SELECT species_ID FROM Species WHERE common_name = 'African Elephant'),
      '2024-10-23', 'Morty'),
    ((SELECT zoo_ID FROM Zoos WHERE zoo_name = 'Portland Zoo'),
    (SELECT species_ID FROM Species WHERE common_name = 'Red Panda'),
      '2022-07-07', 'Zack'),
    ((SELECT zoo_ID FROM Zoos WHERE zoo_name = 'Woodland Park Zoo'),
    (SELECT species_ID FROM Species WHERE common_name = 'Sea Otter'),
      '2023-08-30', 'Cody');

    -- Caretakings Table
    INSERT INTO Caretakings (animal_ID, employee_ID, feeding_time)
    VALUES
    ((SELECT animal_ID FROM Animals WHERE animal_name = 'Simba'),
    (SELECT employee_ID FROM Employees WHERE first_name = 'John' AND last_name = 'Walker'),
    '08:00:00'),
    ((SELECT animal_ID FROM Animals WHERE animal_name = 'Clara'),
    (SELECT employee_ID FROM Employees WHERE first_name = 'John' AND last_name = 'Walker'),
    '12:00:00'),
    ((SELECT animal_ID FROM Animals WHERE animal_name = 'Morty'),
    (SELECT employee_ID FROM Employees WHERE first_name = 'Clarissa' AND last_name = 'Brown'),
    '16:00:00'),
    ((SELECT animal_ID FROM Animals WHERE animal_name = 'Zack'),
    (SELECT employee_ID FROM Employees WHERE first_name = 'Sophia' AND last_name = 'Kim'),
    '12:00:00'),
    ((SELECT animal_ID FROM Animals WHERE animal_name = 'Cody'),
    (SELECT employee_ID FROM Employees WHERE first_name = 'Mark' AND last_name = 'Thompson'),
    '20:00:00');

    COMMIT;
    SET FOREIGN_KEY_CHECKS=1;
END //
DELIMITER ;