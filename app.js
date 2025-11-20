// ########################################
// ########## SETUP


// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 8233;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS


// READ ROUTES
app.get('/', async function (req, res) {
    console.log("🔥 '/' route hit!");
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});
app.get('/ZL-Animals', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = `SELECT animal_name AS Name, Species.common_name AS Species, 
            Zoos.zoo_name AS Zoo, arrival_date AS "Arrival Date" FROM Animals
            INNER JOIN Species ON Animals.species_ID = Species.species_ID
            INNER JOIN Zoos ON Animals.zoo_ID = Zoos.zoo_ID;`;
        const query2 = 'SELECT * FROM Zoos;';
        const query3 = 'SELECT * FROM Species;';
        const [animals] = await db.query(query1);
        const [zoos] = await db.query(query2);
        const [species] = await db.query(query3);

        // Render the Animal.hbs file, and also send the renderer
        res.render('ZL-Animals', {animals: animals, zoos:zoos, species: species});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/ZL-Species', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = `SELECT common_name AS "Common Name",
         scientific_name AS "Scientific Name",
          Diets.diet_name AS Diet, Enclosures.enclosure_type AS Enclosure
         FROM Species
        INNER JOIN Diets ON Species.diet_ID = Diets.diet_ID
        INNER JOIN Enclosures ON Species.enclosure_ID = Enclosures.enclosure_ID;`;
        const query2 = "SELECT * FROM Diets;";
        const query3 = "SELECT * FROM Enclosures;";
        const [species] = await db.query(query1);
        const [diets] = await db.query(query2);
        const [enclosures] = await db.query(query3);
        // Render the Animal.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('ZL-Species', {species:species, diets:diets, enclosures:enclosures});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/ZL-Zoos', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = `SELECT zoo_name AS Name,
         CONCAT(city, ', ', state) AS Address,
         total_animals AS "Total Animals" FROM Zoos;`;
        const [zoos] = await db.query(query1);
        
        // Render the Zoos.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('ZL-Zoos', {zoos: zoos});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/ZL-Employees', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = `SELECT CONCAT(Employees.first_name, ' ', Employees.last_name) AS Name,
            Zoos.zoo_name AS Zoo, Roles.role_title AS Role FROM Employees
            INNER JOIN Zoos ON Employees.zoo_ID = Zoos.zoo_ID
            INNER JOIN Roles ON Employees.role_ID = Roles.role_ID;`;
        const query2 = `SELECT * FROM Zoos;`;
        const query3 = `SELECT * FROM Roles;`;
        const [employees] = await db.query(query1);
        const [zoos] = await db.query(query2);
        const [roles] = await db.query(query3);
        // Render the Employees.hbs file, and also send the renderer
        //  an object that contains our employee information
        res.render('ZL-Employees', {employees: employees, zoos:zoos, roles:roles});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/ZL-Caretakings', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = `SELECT Animals.animal_name AS Animal, 
            CONCAT(Employees.first_name, ' ', Employees.last_name) AS Employee,
            Caretakings.feeding_time AS "Feeding Time" FROM Caretakings
            INNER JOIN Animals ON Caretakings.animal_ID = Animals.animal_ID
            INNER JOIN Employees ON Caretakings.employee_ID = Employees.employee_ID;`;
        const query2 = "SELECT * FROM Animals;";
        const query3 = "SELECT * FROM Employees;";
        const [caretakings] = await db.query(query1);
        const [animals] = await db.query(query2);
        const [employees] = await db.query(query3);

        // Render the Caretakings.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('ZL-Caretakings', {caretakings:caretakings,
            animals:animals, employees:employees
        });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/ZL-Diets', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = "SELECT diet_name AS Name, diet_details AS Details FROM Diets;"
        const [diets] = await db.query(query1);
        
        // Render the Diets.hbs file, and also send the renderer
        //  an object that contains our diets information
        res.render('ZL-Diets', {diets: diets});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/ZL-Enclosures', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = "SELECT enclosure_type AS Enclosure FROM Enclosures;";
        const [enclosures] = await db.query(query1);

        // Render the Enclosures.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('ZL-Enclosures', {enclosures: enclosures});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/ZL-Roles', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = "SELECT role_title AS Role FROM Roles;";
        const [roles] = await db.query(query1);

        // Render the Roles.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('ZL-Roles', {roles: roles});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
//BSG example code
//copied from Exploration - Web Application Technology
//Date 11/18/2025
//url: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-web-application-technology-2
app.get('/bsg-people', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use a JOIN clause to display the names of the homeworlds
        const query1 = `SELECT bsg_people.id, bsg_people.fname, bsg_people.lname, \
            bsg_planets.name AS 'homeworld', bsg_people.age FROM bsg_people \
            LEFT JOIN bsg_planets ON bsg_people.homeworld = bsg_planets.id;`;
        const query2 = 'SELECT * FROM bsg_planets;';
        const [people] = await db.query(query1);
        const [homeworlds] = await db.query(query2);

        // Render the bsg-people.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('bsg-people', { people: people, homeworlds: homeworlds });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// CREATE ROUTES
app.post('/ZL-Animals/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateAnimal(?, ?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_name,
            data.choose_species,
            data.choose_animal_zoo,
            data.create_animal_arrival_date,
        ]);

        console.log(`CREATE ZL-Animals. ID: ${rows.new_id} ` +
            `Name: ${data.create_animal_name}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/ZL-Animals');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
app.post('/ZL-Caretakings/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateCaretaking(?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.choose_animal,
            data.choose_employee,
            data.choose_feed_time,
        ]);

        console.log(`CREATE ZL-Caretakings. ID: ${rows.new_id} `);

        // Redirect the user to the updated webpage
        res.redirect('/ZL-Caretakings');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
app.post('/ZL-Diets/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateDiet(?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_name,
            data.create_details
        ]);

        console.log(`CREATE ZL-Diets. ID: ${rows.new_id} ` +
            `Name: ${data.create_animal_name}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/ZL-Diets');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
app.post('/ZL-Employees/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateEmployee(?, ?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_employee_fname,
            data.create_employee_lname,
            data.create_employee_zoo,
            data.create_employee_role,
        ]);

        console.log(`CREATE ZL-Employees. ID: ${rows.new_id} ` +
            `Name: ${data.create_employee_fname} + ${data.create_employee_lname}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/ZL-Employees');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
app.post('/ZL-Enclosures/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateEnclosure(?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_enclosure_type,
        ]);

        console.log(`CREATE ZL-Enclosures. ID: ${rows.new_id} ` +
            `Name: ${data.create_enclosure_type}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/ZL-Enclosures');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
app.post('/ZL-Roles/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateRole(?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_role_title,
        ]);

        console.log(`CREATE ZL-Roles. ID: ${rows.new_id} ` +
            `Name: ${data.create_role_title}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/ZL-Roles');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
app.post('/ZL-Species/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateSpecies(?, ?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_species_common_name,
            data.create_species_scientific_name,
            data.choose_diet,
            data.choose_enclosure,
        ]);

        console.log(`CREATE ZL-Species. ID: ${rows.new_id} ` +
            `Name: ${data.create_species_common_name}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/ZL-Species');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
app.post('/ZL-Zoos/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateZoo(?, ?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.add_name,
            data.add_city,
            data.add_state,
            data.add_animal_total,
        ]);

        console.log(`CREATE ZL-Zoos. ID: ${rows.new_id} ` +
            `Name: ${data.add_name}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/ZL-Zoos');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
// BSG example code
//Copied from Exploration-Implementing CUD operations in your app
//Date 11/18/2025
//URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
app.post('/bsg-people/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Cleanse data - If the homeworld or age aren't numbers, make them NULL.
        if (isNaN(parseInt(data.create_person_homeworld)))
            data.create_person_homeworld = null;
        if (isNaN(parseInt(data.create_person_age)))
            data.create_person_age = null;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreatePerson(?, ?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_person_fname,
            data.create_person_lname,
            data.create_person_homeworld,
            data.create_person_age,
        ]);

        console.log(`CREATE bsg-people. ID: ${rows.new_id} ` +
            `Name: ${data.create_person_fname} ${data.create_person_lname}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/bsg-people');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

//UPDATE ROUTES
app.post('/ZL-Animals/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = 'CALL sp_UpdateAnimal(?, ?, ?, ?);';
        const query2 = 'SELECT fname, lname FROM bsg_people WHERE id = ?;';
        await db.query(query1, [
            data.update_animal_id,
            data.update_animal_species,
            data.update_animal_zoo,
            data.update_animal_arrival_date,
        ]);
        const [[rows]] = await db.query(query2, [data.update_animal_id]);

        console.log(`UPDATE Zl-Animal. ID: ${data.update_animal_id} ` +
            `Name: ${rows.Name} ${rows.lname}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/ZL-Animals');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
// BSG example code
//Copied from Exploration-Implementing CUD operations in your app
//Date 11/18/2025
//URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
app.post('/bsg-people/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;

        // Cleanse data - If the homeworld or age aren't numbers, make them NULL.
        if (isNaN(parseInt(data.update_person_homeworld)))
            data.update_person_homeworld = null;
        if (isNaN(parseInt(data.update_person_age)))
            data.update_person_age = null;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = 'CALL sp_UpdatePerson(?, ?, ?);';
        const query2 = 'SELECT fname, lname FROM bsg_people WHERE id = ?;';
        await db.query(query1, [
            data.update_person_id,
            data.update_person_homeworld,
            data.update_person_age,
        ]);
        const [[rows]] = await db.query(query2, [data.update_person_id]);

        console.log(`UPDATE bsg-people. ID: ${data.update_person_id} ` +
            `Name: ${rows.fname} ${rows.lname}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/bsg-people');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

//DELETE ROUTES
app.post('/ZL-Animals/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_DeleteAnimal(?);`;
        await db.query(query1, [data.delete_animal_id]);

        console.log(`DELETE ZL-Animal. ID: ${data.delete_animal_id} ` +
            `Name: ${data.delete_animal_name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/ZL-Animals');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});
// BSG example code
//Copied from Exploration-Implementing CUD operations in your app
//Date 11/18/2025
//URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25645149
// DELETE ROUTES
app.post('/bsg-people/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_DeletePerson(?);`;
        await db.query(query1, [data.delete_person_id]);

        console.log(`DELETE bsg-people. ID: ${data.delete_person_id} ` +
            `Name: ${data.delete_person_name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/bsg-people');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// RESET ROUTES
app.get('/reset', async (req, res) => {
    try {
        await db.query('CALL sp_load_zoolinkpnw();');
        console.log('Database has been reset.');
        res.redirect('/');
    } catch (error) {
        console.error('Error resetting database:', error);
        res.status(500).send('Error resetting database');
    }
});



// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});