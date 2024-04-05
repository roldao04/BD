-- Tabela para médicos
CREATE TABLE medico (
    numSNS INT PRIMARY KEY,
    nome NVARCHAR(255),
    especialidade NVARCHAR(255)
);

-- Tabela para pacientes
CREATE TABLE paciente (
    numUtente INT PRIMARY KEY,
    nome NVARCHAR(255),
    dataNasc DATE,
    endereco NVARCHAR(255)
);

-- Tabela para farmácias
CREATE TABLE farmacia (
    nome NVARCHAR(255) PRIMARY KEY,
    telefone BIGINT,
    endereco NVARCHAR(255)
);

-- Tabela para farmacêuticos
CREATE TABLE farmaceutica (
    numReg INT PRIMARY KEY,
    nome NVARCHAR(255),
    endereco NVARCHAR(255)
);

-- Tabela para medicamentos
CREATE TABLE farmaco (
    numRegFarm INT PRIMARY KEY,
    nome NVARCHAR(255),
    formula NVARCHAR(255)
);

-- Tabela para prescrições
CREATE TABLE prescricao (
    numPresc INT PRIMARY KEY,
    numUtente INT FOREIGN KEY REFERENCES paciente(numUtente),
    numMedico INT FOREIGN KEY REFERENCES medico(numSNS),
    farmacia NVARCHAR(255) FOREIGN KEY REFERENCES farmacia(nome),
    dataProc DATE
);

-- Tabela para a relação entre prescrições e medicamentos
CREATE TABLE presc_farmaco (
    numPresc INT FOREIGN KEY REFERENCES prescricao(numPresc),
    numRegFarm INT FOREIGN KEY REFERENCES farmaco(numRegFarm),
    nomeFarmaco NVARCHAR(255),
    PRIMARY KEY (numPresc, numRegFarm)
);
