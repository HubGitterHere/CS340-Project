-- Write the query to create the 4 tables below.


CREATE TABLE client(
  	id int(11) AUTO_INCREMENT,
  	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT full_name UNIQUE(first_name, last_name)
);

CREATE TABLE employee(
	id int(11) AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT full_name UNIQUE(first_name, last_name)
);

CREATE TABLE project(
	id int(11) AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL UNIQUE,
    comments TEXT,
    cid int,
    PRIMARY KEY (id),
    FOREIGN KEY(cid) REFERENCES client(id)
);

CREATE TABLE works_on(
    pid int,
	eid int,
    due_date DATE NOT NULL,
    FOREIGN KEY(pid) REFERENCES project(id),
    FOREIGN KEY(eid) REFERENCES employee(id),
    PRIMARY KEY(eid, pid)
);
