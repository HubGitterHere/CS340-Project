-- #############################
-- CREATE bsg_people
-- copied from Exploration-implementing CUD operations in your app
-- date 11/18/2025
-- URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
-- #############################
DROP PROCEDURE IF EXISTS sp_CreatePerson;

DELIMITER //
CREATE PROCEDURE sp_CreatePerson(
    IN p_fname VARCHAR(255), 
    IN p_lname VARCHAR(255), 
    IN p_homeworld INT, 
    IN p_age INT,
    OUT p_id INT)
BEGIN
    INSERT INTO bsg_people (fname, lname, homeworld, age) 
    VALUES (p_fname, p_lname, p_homeworld, p_age);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_id;
    -- Display the ID of the last inserted person.
    SELECT LAST_INSERT_ID() AS 'new_id';

    -- Example of how to get the ID of the newly created person:
        -- CALL sp_CreatePerson('Theresa', 'Evans', 2, 48, @new_id);
        -- SELECT @new_id AS 'New Person ID';
END //
DELIMITER ;
-- #############################
-- UPDATE bsg_people
-- copied from Exploration-implementing CUD operations in your app
-- date 11/18/2025
-- URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdatePerson;

DELIMITER //
CREATE PROCEDURE sp_UpdatePerson(IN p_id INT, IN p_homeworld INT, IN p_age INT)

BEGIN
    UPDATE bsg_people SET homeworld = p_homeworld, age = p_age WHERE id = p_id; 
END //
DELIMITER ;
-- #############################
-- DELETE bsg_people
-- copied from Exploration-implementing CUD operations in your app
-- date 11/18/2025
-- URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
-- #############################
DROP PROCEDURE IF EXISTS sp_DeletePerson;

DELIMITER //
CREATE PROCEDURE sp_DeletePerson(IN p_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both bsg_people table and 
        --      intersection table to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        --      inside the bsg_cert_people table.
        DELETE FROM bsg_cert_people WHERE pid = p_id;
        DELETE FROM bsg_people WHERE id = p_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', p_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- CREATE Animal
-- #############################
-- AI tool used: Microsoft Copilot
-- Used on 11/18/2025
-- Used to find errors in SQL syntax
DROP PROCEDURE IF EXISTS sp_CreateAnimal;

DELIMITER //
CREATE PROCEDURE sp_CreateAnimal(
    IN a_name VARCHAR(50),  
    IN a_species INT,
    IN a_zoo INT, 
    IN a_arrival_date DATE,
    OUT a_id INT)
BEGIN
    INSERT INTO Animals (species_ID, zoo_ID, arrival_date, animal_name) 
    VALUES (a_species, a_zoo, a_arrival_date, a_name);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into a_id;
    -- Display the ID of the last inserted animal.
    SELECT LAST_INSERT_ID() AS 'new_id';
END //
DELIMITER ;
-- #############################
-- UPDATE Animals
-- copied from Exploration-implementing CUD operations in your app
-- date 11/19/2025
-- URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateAnimal;

DELIMITER //
CREATE PROCEDURE sp_UpdateAnimal(IN a_id INT, IN a_species INT, IN a_zoo INT, IN a_arrival_date DATE)

BEGIN
    UPDATE bsg_people SET species_ID = a_id, zoo_ID = a_zoo, arrival_date = a_arrival_date WHERE animal_ID = a_id; 
END //
DELIMITER ;
-- #############################
-- DELETE Animal
-- copied from Exploration-implementing CUD operations in your app
-- date 11/19/2025
-- URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteAnimal;

DELIMITER //
CREATE PROCEDURE sp_DeleteAnimal(IN a_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Animals table and 
        --      intersection table to prevent a data anomaly
        DELETE FROM Animals WHERE animal_ID = a_id;
        DELETE FROM Caretakings WHERE animal_ID = a_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', a_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- CREATE Caretaking
-- #############################
-- Based off of CREATE Animals
DROP PROCEDURE IF EXISTS sp_CreateCaretaking;

DELIMITER //
CREATE PROCEDURE sp_CreateCaretaking(
    IN a_id INT,
    IN emp_id INT,
    IN feed_time TIME,
    OUT ct_id INT)
BEGIN
    INSERT INTO Caretaking (animal_ID, employee_ID, feeding_time) 
    VALUES (a_id, emp_id, feed_time);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into ct_id;
    -- Display the ID of the last inserted animal.
    SELECT LAST_INSERT_ID() AS 'new_id';
END //
DELIMITER ;
-- #############################
-- UPDATE Caretakings
-- based off of UPDATE Animals
-- date 11/19/2025
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateCaretaking;

DELIMITER //
CREATE PROCEDURE sp_UpdateCaretaking(IN ct_id INT, IN a_id INT, IN emp_id INT, IN feed_time TIME) 

BEGIN
    UPDATE bsg_people SET WHERE id = ct_id; 
END //
DELIMITER ;
-- #############################
-- DELETE Caretaking
-- Based off of DELETE Animal
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteCaretaking;

DELIMITER //
CREATE PROCEDURE sp_DeleteCaretaking(IN a_id INT, IN emp_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Animals table and 
        --      intersection table to prevent a data anomaly
        DELETE FROM Caretakings WHERE animal_ID = a_id AND employee_ID = emp_id;
        
        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', emp_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- CREATE Diet
-- #############################
-- Based off of CREATE Animals
DROP PROCEDURE IF EXISTS sp_CreateDiet;

DELIMITER //
CREATE PROCEDURE sp_CreateDiet(
    IN d_name VARCHAR(255),
    IN d_details VARCHAR(255),
    OUT d_id INT)
BEGIN
    INSERT INTO Diets (diet_name, diet_details) 
    VALUES (d_name, d_details);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into d_id;
    -- Display the ID of the last inserted animal.
    SELECT LAST_INSERT_ID() AS 'new_id';
END //
DELIMITER ;

-- #############################
-- DELETE Diet
-- Based off of DELETE Caretakings
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteDiet;

DELIMITER //
CREATE PROCEDURE sp_DeleteDiet(IN d_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Animals table and 
        --      intersection table to prevent a data anomaly
        DELETE FROM Diets WHERE diet_ID = d_id;
        DELETE FROM Species WHERE diet_ID d_id;
        
        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', d_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- CREATE Employee
-- #############################
-- Based off of CREATE Animals
DROP PROCEDURE IF EXISTS sp_CreateEmployee;

DELIMITER //
CREATE PROCEDURE sp_CreateEmployee(
    IN emp_fname VARCHAR(255), -- get first name
    IN emp_lname VARCHAR(255), -- get last name
    IN z_id INT, -- get zoo id
    IN r_id INT, -- get role id

    OUT emp_id INT)
BEGIN
    INSERT INTO Employees (zoo_ID, first_name, last_name, role_ID) 
    VALUES (z_id, emp_fname, emp_lname, r_id);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into emp_id;
    -- Display the ID of the last inserted animal.
    SELECT LAST_INSERT_ID() AS 'new_id';
END //
DELIMITER ;

-- #############################
-- DELETE Employee
-- Based off of DELETE Diet
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteEmployee;

DELIMITER //
CREATE PROCEDURE sp_DeleteEmployee(IN emp_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Animals table and 
        --      intersection table to prevent a data anomaly
        DELETE FROM Employee WHERE employee_ID = emp_id;
        DELETE FROM Caretakings WHERE employee_ID = emp_id;
        
        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', emp_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- CREATE Enclosure
-- #############################
-- Based off of CREATE Animals
DROP PROCEDURE IF EXISTS sp_CreateEnclosure;

DELIMITER //
CREATE PROCEDURE sp_CreateEnclosure(
    IN enc_type VARCHAR(255), -- get enclosure type
    OUT enc_id INT)
BEGIN
    INSERT INTO Enclosures (enclosure_type) 
    VALUES (enc_type);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into enc_id;
    -- Display the ID of the last inserted animal.
    SELECT LAST_INSERT_ID() AS 'new_id';
END //
DELIMITER ;

-- #############################
-- DELETE Enclosure
-- Based off of DELETE Employee
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteEnclosure;

DELIMITER //
CREATE PROCEDURE sp_DeleteEnclosure(IN enc_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Animals table and 
        --      intersection table to prevent a data anomaly
        DELETE FROM Enclosures WHERE enclosure_ID = enc_id;
        DELETE FROM Species WHERE enclosure_ID = enc_id;
        
        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', enc_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- CREATE Role
-- #############################
-- Based off of CREATE Animals
DROP PROCEDURE IF EXISTS sp_CreateRole;

DELIMITER //
CREATE PROCEDURE sp_CreateRole(
    IN r_title VARCHAR(255), -- get role title
    OUT r_id INT)
BEGIN
    INSERT INTO Roles (role_title) 
    VALUES (r_title);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into r_id;
    -- Display the ID of the last inserted animal.
    SELECT LAST_INSERT_ID() AS 'new_id';
END //
DELIMITER ;

-- #############################
-- DELETE Role
-- Based off of DELETE Enclosure
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteRole;

DELIMITER //
CREATE PROCEDURE sp_DeleteRole(IN r_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Animals table and 
        --      intersection table to prevent a data anomaly
        DELETE FROM Roles WHERE role_ID = r_id;
        DELETE FROM Employees WHERE role_ID = r_id;
        
        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', r_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- CREATE Species
-- #############################
-- Based off of CREATE Animals
DROP PROCEDURE IF EXISTS sp_CreateSpecies;

DELIMITER //
CREATE PROCEDURE sp_CreateSpecies(
    IN s_common_name VARCHAR(255), -- get common name
    IN s_scientific_name VARCHAR(255), -- get scientific name
    IN d_id INT, -- get diet id
    IN enc_id INT, -- get enclosure id
    OUT s_id INT)
BEGIN
    INSERT INTO Species (common_name, scientific_name, diet_ID, enclosure_ID) 
    VALUES (s_common_name, s_scientific_name, d_id, enc_id);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into s_id;
    -- Display the ID of the last inserted animal.
    SELECT LAST_INSERT_ID() AS 'new_id';
END //
DELIMITER ;

-- #############################
-- DELETE Species
-- Based off of DELETE Role
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteSpecies;

DELIMITER //
CREATE PROCEDURE sp_DeleteSpecies(IN s_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Animals table and 
        --      intersection table to prevent a data anomaly
        DELETE FROM Species WHERE species_ID = s_id;
        DELETE FROM Animals WHERE species_ID = s_id;
        
        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', s_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- CREATE Zoo
-- #############################
-- Based off of CREATE Animals
DROP PROCEDURE IF EXISTS sp_CreateZoo;

DELIMITER //
CREATE PROCEDURE sp_CreateZoo(
    IN z_name VARCHAR(255), -- get zoo's name
    IN z_city VARCHAR(255), -- get city zoo is in
    IN z_state VARCHAR(255), -- get state zoo is in
    IN a_total INT, -- get animal total
    OUT z_id INT)
BEGIN
    INSERT INTO Zoos (zoo_name, city, state, total_animals) 
    VALUES (z_name, z_city, z_state, a_total);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into z_id;
    -- Display the ID of the last inserted animal.
    SELECT LAST_INSERT_ID() AS 'new_id';
END //
DELIMITER ;

-- #############################
-- DELETE Zoo
-- Based off of DELETE Species
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteZoo;

DELIMITER //
CREATE PROCEDURE sp_DeleteZoo(IN z_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Animals table and 
        --      intersection table to prevent a data anomaly
        DELETE FROM Zoos WHERE zoo_ID = z_id;
        DELETE FROM Animals WHERE zoo_ID = z_id;
        DELETE FROM Employees WHERE zoo_ID = z_id;
        
        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', z_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

