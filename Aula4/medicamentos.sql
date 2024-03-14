CREATE TABLE Medico (
    NumeroSNS INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Especialidade VARCHAR(255) NOT NULL
);

CREATE TABLE Farmaceutica (
    NumeroRegistroNacional INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255) NOT NULL,
    Telefone VARCHAR(20) NOT NULL
);

CREATE TABLE Farmacia (
    NIF INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255) NOT NULL,
    Telefone VARCHAR(20) NOT NULL
);

CREATE TABLE Farmaco (
    NomeComercial VARCHAR(255) PRIMARY KEY,
    Formula VARCHAR(255) NOT NULL,
    Farmacia_NIF INT,
    Farmaceutica_NumeroRegistroNacional INT,
    FOREIGN KEY (Farmacia_NIF) REFERENCES Farmacia(NIF),
    FOREIGN KEY (Farmaceutica_NumeroRegistroNacional) REFERENCES Farmaceutica(NumeroRegistroNacional)
);

CREATE TABLE Paciente (
    NumeroUtente INT PRIMARY KEY,
    DataNascimento DATE NOT NULL,
    Endereco VARCHAR(255) NOT NULL,
    Nome VARCHAR(255) NOT NULL,
    Medico_NumeroSNS INT,
    FOREIGN KEY (Medico_NumeroSNS) REFERENCES Medico(NumeroSNS)
);

CREATE TABLE Prescricao (
    Numero INT PRIMARY KEY,
    DataPrescricao DATE NOT NULL,
    Medico_NumeroSNS INT,
    Paciente_NumeroUtente INT,
    Farmacia_NIF INT,
    Farmaco_NomeComercial VARCHAR(255),
    FOREIGN KEY (Medico_NumeroSNS) REFERENCES Medico(NumeroSNS),
    FOREIGN KEY (Paciente_NumeroUtente) REFERENCES Paciente(NumeroUtente),
    FOREIGN KEY (Farmacia_NIF) REFERENCES Farmacia(NIF),
    FOREIGN KEY (Farmaco_NomeComercial) REFERENCES Farmaco(NomeComercial)
);
CREATE TABLE Medico (
    NumeroSNS INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Especialidade VARCHAR(255) NOT NULL
);

CREATE TABLE Farmaceutica (
    NumeroRegistroNacional INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255) NOT NULL,
    Telefone VARCHAR(20) NOT NULL
);

CREATE TABLE Farmacia (
    NIF INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255) NOT NULL,
    Telefone VARCHAR(20) NOT NULL
);

CREATE TABLE Farmaco (
    NomeComercial VARCHAR(255) PRIMARY KEY,
    Formula VARCHAR(255) NOT NULL,
    Farmacia_NIF INT,
    Farmaceutica_NumeroRegistroNacional INT,
    FOREIGN KEY (Farmacia_NIF) REFERENCES Farmacia(NIF),
    FOREIGN KEY (Farmaceutica_NumeroRegistroNacional) REFERENCES Farmaceutica(NumeroRegistroNacional)
);

CREATE TABLE Paciente (
    NumeroUtente INT PRIMARY KEY,
    DataNascimento DATE NOT NULL,
    Endereco VARCHAR(255) NOT NULL,
    Nome VARCHAR(255) NOT NULL,
    Medico_NumeroSNS INT,
    FOREIGN KEY (Medico_NumeroSNS) REFERENCES Medico(NumeroSNS)
);

CREATE TABLE Prescricao (
    Numero INT PRIMARY KEY,
    DataPrescricao DATE NOT NULL,
    Medico_NumeroSNS INT,
    Paciente_NumeroUtente INT,
    Farmacia_NIF INT,
    Farmaco_NomeComercial VARCHAR(255),
    FOREIGN KEY (Medico_NumeroSNS) REFERENCES Medico(NumeroSNS),
    FOREIGN KEY (Paciente_NumeroUtente) REFERENCES Paciente(NumeroUtente),
    FOREIGN KEY (Farmacia_NIF) REFERENCES Farmacia(NIF),
    FOREIGN KEY (Farmaco_NomeComercial) REFERENCES Farmaco(NomeComercial)
);
