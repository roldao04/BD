-- Primeiro, criar a tabela de Departamentos sem a chave estrangeira para employee
CREATE TABLE department (
    Dnumber INT PRIMARY KEY,
    Dname NVARCHAR(50) UNIQUE,
    Mgr_ssn INT NULL, -- Inicialmente nulo ou removido
    Mgr_start_date DATE
);

-- Criar a tabela de Funcionários
CREATE TABLE employee (
    Ssn INT PRIMARY KEY,
    Fname NVARCHAR(50),
    Minit CHAR(1),
    Lname NVARCHAR(50),
    Bdate DATE,
    Address NVARCHAR(255),
    Sex CHAR(1),
    Salary DECIMAL(10, 2),
    Super_ssn INT NULL,
    Dno INT,
    FOREIGN KEY (Super_ssn) REFERENCES employee(Ssn),
    FOREIGN KEY (Dno) REFERENCES department(Dnumber)
);

-- Agora adicionar a chave estrangeira para Mgr_ssn em department referenciando employee
ALTER TABLE department
ADD CONSTRAINT FK_department_employee FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn);

-- Tabela de Dependentes
CREATE TABLE dependent (
    Essn INT,
    Dependent_name NVARCHAR(50),
    Sex CHAR(1),
    Bdate DATE,
    Relationship NVARCHAR(50),
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES employee(Ssn)
);

-- Tabela de Localizações de Departamento
CREATE TABLE dept_location (
    Dnumber INT,
    Dlocation NVARCHAR(50),
    PRIMARY KEY (Dnumber, Dlocation),
    FOREIGN KEY (Dnumber) REFERENCES department(Dnumber)
);

-- Tabela de Projetos
CREATE TABLE project (
    Pnumber INT PRIMARY KEY,
    Pname NVARCHAR(50) UNIQUE,
    Plocation NVARCHAR(50),
    Dnum INT,
    FOREIGN KEY (Dnum) REFERENCES department(Dnumber)
);

-- Tabela de Trabalhos em Projetos
CREATE TABLE works_on (
    Essn INT,
    Pno INT,
    Hours DECIMAL(9, 2),
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES employee(Ssn),
    FOREIGN KEY (Pno) REFERENCES project(Pnumber)
);
