CREATE DATABASE RENT_A_CAR;
GO

USE RENT_A_CAR;

CREATE TABLE Tipo_Veiculo (
    codigo INT PRIMARY KEY,
    designacao VARCHAR(255),
    arcondicionado BIT
);
GO

CREATE TABLE Veiculo (
    matricula VARCHAR(255) PRIMARY KEY,
    marca VARCHAR(255),
    ano INT,
    tipo INT FOREIGN KEY REFERENCES Tipo_Veiculo(codigo)
);
GO

CREATE TABLE Cliente (
    NIF INT PRIMARY KEY,
    num_carta VARCHAR(255),
    endereco VARCHAR(255),
    nome VARCHAR(255)
);
CREATE TABLE CLIENTE (
	NIF INT NOT NULL,
	nome VARCHAR(30) NOT NULL,
	endereco VARCHAR(30) NOT NULL,
	CHECK (NIF > 0 AND NIF < 999999),
	PRIMARY KEY (NIF)
);
GO

CREATE TABLE Balcao (
    numero INT PRIMARY KEY,
    nome VARCHAR(255),
    endereco VARCHAR(255)
);
GO

CREATE TABLE Aluguer (
    numero INT PRIMARY KEY,
    duracao INT,
    data DATE,
    client VARCHAR(255) FOREIGN KEY REFERENCES Cliente(NIF),
    balcao INT FOREIGN KEY REFERENCES Balcao(numero),
    veiculo VARCHAR(255) FOREIGN KEY REFERENCES Veiculo(matricula)
);
GO

CREATE TABLE Ligeiro (
    codigo INT PRIMARY KEY FOREIGN KEY REFERENCES Tipo_Veiculo(codigo),
    num_lugares INT,
    portas INT,
    combustivel VARCHAR(255)
);
GO

CREATE TABLE Pesado (
    codigo INT PRIMARY KEY FOREIGN KEY REFERENCES Tipo_Veiculo(codigo),
    peso DECIMAL(10,2),
    passageiros INT
);
GO

CREATE TABLE Similaridade (
    Tipo1 INT FOREIGN KEY REFERENCES Tipo_Veiculo(codigo),
    Tipo2 INT FOREIGN KEY REFERENCES Tipo_Veiculo(codigo)
);
GO
