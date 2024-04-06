INSERT INTO department (Dnumber, Dname) VALUES
(1, 'Human Resources'),
(2, 'Research'),
(3, 'Development'),
(4, 'IT Support'),
(5, 'Sales'),
(6, 'Marketing');

-- Note que omitimos Dno para evitar conflitos na inserção inicial
INSERT INTO employee (Ssn, Fname, Minit, Lname, Bdate, Address, Sex, Salary) VALUES
(123456789, 'John', 'A', 'Doe', '1980-01-15', '123 Elm St.', 'M', 60000.00),
(234567890, 'Jane', 'B', 'Smith', '1985-05-20', '456 Oak St.', 'F', 55000.00),
(345678901, 'Michael', 'C', 'Johnson', '1978-11-10', '789 Maple St.', 'M', 65000.00);


-- Garanta que os SSNs usados já foram inseridos
UPDATE department SET Mgr_ssn = 123456789 WHERE Dnumber = 1;

INSERT INTO dependent (Essn, Dependent_name, Sex, Bdate, Relationship) VALUES
(123456789, 'Jane Doe', 'F', '1982-04-03', 'Spouse'),
(123456789, 'James Doe', 'M', '2005-07-15', 'Child'),
(234567890, 'John Smith', 'M', '2010-10-20', 'Child'),
(345678901, 'Mary Johnson', 'F', '2008-03-25', 'Child');

INSERT INTO dept_location (Dnumber, Dlocation) VALUES
(1, 'New York'),
(2, 'Los Angeles'),
(3, 'Chicago'),
(4, 'Houston'),
(5, 'Boston'),
(6, 'San Francisco');

INSERT INTO project (Pnumber, Pname, Plocation, Dnum) VALUES
(101, 'Project Alpha', 'New York', 1),
(102, 'Project Beta', 'Los Angeles', 2),
(103, 'Project Gamma', 'Chicago', 3),
(104, 'Project Delta', 'Houston', 4),
(105, 'Project Epsilon', 'Boston', 5),
(106, 'Project Zeta', 'San Francisco', 6);

INSERT INTO works_on (Essn, Pno, Hours) VALUES
(123456789, 101, 40.0),
(234567890, 102, 30.0),
(345678901, 103, 35.0);
