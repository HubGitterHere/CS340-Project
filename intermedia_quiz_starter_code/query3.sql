-- Write your query to select data here
SELECT employee.first_name, employee.last_name, project.title
    FROM works_on
    INNER JOIN project ON works_on.pid = project.id
    INNER JOIN employee ON works_on.eid = employee.id
    ORDER BY employee.first_name ASC;