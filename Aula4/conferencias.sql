CREATE TABLE Instituicao (
    Nome VARCHAR(255) PRIMARY KEY,
    Endereco VARCHAR(255) NOT NULL
);	

CREATE TABLE Autor (
    Nome VARCHAR(255) PRIMARY KEY,
    Email VARCHAR(255) NOT NULL,
    Instituicao_Nome VARCHAR(255),
    FOREIGN KEY (Instituicao_Nome) REFERENCES Instituicao(Nome)
);

CREATE TABLE Artigo (
    Numero_de_Registo INT PRIMARY KEY,
    Titulo VARCHAR(255) NOT NULL,
    Autor_Nome VARCHAR(255),
    FOREIGN KEY (Autor_Nome) REFERENCES Autor(Nome)
);

CREATE TABLE Participante (
    Nome VARCHAR(255) PRIMARY KEY,
    Email VARCHAR(255) NOT NULL,
    Data_de_Inscricao DATE NOT NULL,
    Morada TEXT NOT NULL,
    Instituicao_Nome VARCHAR(255),
    FOREIGN KEY (Instituicao_Nome) REFERENCES Instituicao(Nome)
);

CREATE TABLE Nao_Estudante (
    Nome VARCHAR(255) PRIMARY KEY,
    Referencia TEXT NOT NULL,
    FOREIGN KEY (Nome) REFERENCES Participante(Nome)
);

CREATE TABLE Estudante (
    Nome VARCHAR(255) PRIMARY KEY,
    Comprovativo TEXT NOT NULL,
    FOREIGN KEY (Nome) REFERENCES Participante(Nome)
);
