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
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

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


app.get('/ZL-Animals', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = `SELECT animal_name, Species.common_name AS species, 
            Zoos.zoo_name AS zoo, arrival_date FROM Animals
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
        const query1 = "SELECT common_name, scientific_name FROM Species;";
        const [species] = await db.query(query1);
        // Render the Animal.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('ZL-Species', {species:species});

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
        const query1 = "SELECT zoo_name, city, state, total_animals FROM Zoos;";
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
        const query1 = `SELECT Employees.first_name, Employees.last_name,
            Zoos.zoo_name, Roles.role_title FROM Employees
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
        const query1 = `SELECT Animals.animal_name AS animal, 
            Employees.first_name, Employees.last_name,
            Diets.diet_details AS diet, Caretakings.feeding_time,
            Enclosures.enclosure_type FROM Caretakings
            INNER JOIN Animals ON Caretakings.animal_ID = Animals.animal_ID
            INNER JOIN Employees ON Caretakings.employee_ID = Employees.employee_ID
            INNER JOIN Diets ON Caretakings.diet_ID = Diets.diet_ID
            INNER JOIN Enclosures ON Caretakings.enclosure_ID = Enclosures.enclosure_ID;`;
        const query2 = "SELECT * FROM Animals;";
        const query3 = "SELECT * FROM Employees;";
        const query4 = "SELECT * FROM Diets;";
        const query5 = "SELECT * FROM Enclosures;";
        const [caretakings] = await db.query(query1);
        const [animals] = await db.query(query2);
        const [employees] = await db.query(query3);
        const [diets] = await db.query(query4);
        const [enclosures] = await db.query(query5);

        // Render the Caretakings.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('ZL-Caretakings', {caretakings:caretakings, animals:animals, 
            employees:employees, diets:diets, enclosures:enclosures
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
        const query1 = "SELECT diet_details FROM Diets;"
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
        const query1 = "SELECT enclosure_type FROM Enclosures;";
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
        const query1 = "SELECT role_title FROM Roles;";
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
// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});