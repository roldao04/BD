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
    NIF INT PRIMARY KEY NOT NULL,
    num_carta INT NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
);
GO

CREATE TABLE Balcao (
    numero INT PRIMARY KEY,
    nome VARCHAR(255),
    endereco VARCHAR(255)
);
GO

CREATE TABLE Aluguer (
    numero INT PRIMARY KEY NOT NULL ,
    duracao INT NOT NULL ,
    data DATE NOT NULL ,
    client VARCHAR(255) NOT NULL  FOREIGN KEY REFERENCES Cliente(NIF),
    balcao INT NOT NULL  FOREIGN KEY REFERENCES Balcao(numero),
    veiculo VARCHAR(255) NOT NULL  FOREIGN KEY REFERENCES Veiculo(matricula)
);
GO

CREATE TABLE Ligeiro (
    codigo INT NOT NULL  PRIMARY KEY FOREIGN KEY REFERENCES Tipo_Veiculo(codigo),
    num_lugares INT NOT NULL ,
    portas INT NOT NULL ,
    combustivel VARCHAR(255) NOT NULL
);
GO

CREATE TABLE Pesado (
    codigo INT PRIMARY KEY FOREIGN KEY REFERENCES Tipo_Veiculo(codigo),
    peso DECIMAL(10,2) NOT NULL ,
    passageiros INT NOT NULL
);
GO

CREATE TABLE Similaridade (
    Tipo1 INT NOT NULL  FOREIGN KEY REFERENCES Tipo_Veiculo(codigo),
    Tipo2 INT NOT NULL  FOREIGN KEY REFERENCES Tipo_Veiculo(codigo)
);
GO
