USE ATL;

CREATE TABLE Pessoa (
    ncartao_cidadao INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    morada VARCHAR(50) NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

CREATE TABLE Enc_Educacao (
    ncartao_cidadao INT PRIMARY KEY NOT NULL,
    FOREIGN KEY (ncartao_cidadao) REFERENCES Pessoa(ncartao_cidadao)
);

CREATE TABLE Responsavel (
    ncartao_cidadao INT PRIMARY KEY NOT NULL,
    FOREIGN KEY (ncartao_cidadao) REFERENCES Pessoa(ncartao_cidadao)
);

CREATE TABLE Professor (
    n_funcionario INT PRIMARY KEY NOT NULL,
    ncartao_cidadao INT NOT NULL,
    FOREIGN KEY (ncartao_cidadao) REFERENCES Pessoa(ncartao_cidadao),
);

CREATE TABLE Aluno (
    ncartao_cidadao INT PRIMARY KEY NOT NULL,
    Nome VARCHAR(255) NOT NULL,
    morada VARCHAR(50) NOT NULL,
    encarregado_ed INT,
    turma_id INT,
    FOREIGN KEY (ncartao_cidadao) REFERENCES Pessoa(ncartao_cidadao),
    FOREIGN KEY (encarregado_ed) REFERENCES Enc_Educacao(ncartao_cidadao)
);

CREATE TABLE Turma (
    id INT PRIMARY KEY NOT NULL,
    classe VARCHAR(255) NOT NULL,
    nmax_alunos INT NOT NULL CHECK ( nmax_alunos > 0 ),
    ano_letivo INT NOT NULL,
    designation VARCHAR(255) NOT NULL,
    professor INT NOT NULL,
    FOREIGN KEY (professor) REFERENCES Professor(n_funcionario)
);

CREATE TABLE Atividades (
    id INT PRIMARY KEY NOT NULL,
    designation VARCHAR(255) NOT NULL,
    custo_financeiro DECIMAL(10,2) NOT NULL CHECK ( custo_financeiro > 0 )
);

CREATE TABLE Realiza (
    id_turma INT NOT NULL,
    id_atividade INT NOT NULL,
    PRIMARY KEY (id_turma, id_atividade),
    FOREIGN KEY (id_turma) REFERENCES Turma(id),
    FOREIGN KEY (id_atividade) REFERENCES Atividades(id)
);

CREATE TABLE Participa (
    id_atividade INT NOT NULL ,
    ncartao_cidadao_aluno INT NOT NULL ,
    PRIMARY KEY (id_atividade, ncartao_cidadao_aluno),
    FOREIGN KEY (id_atividade) REFERENCES Atividades(id),
    FOREIGN KEY (ncartao_cidadao_aluno) REFERENCES Aluno(ncartao_cidadao)
);

CREATE TABLE LevantaEntrega (
    ncartao_cidadao_aluno INT NOT NULL,
    ncartao_cidadao_educ  INT NOT NULL,
    PRIMARY KEY (ncartao_cidadao_aluno, ncartao_cidadao_educ),
    FOREIGN KEY (ncartao_cidadao_aluno) REFERENCES Aluno(ncartao_cidadao),
    FOREIGN KEY (ncartao_cidadao_educ) REFERENCES Enc_Educacao(ncartao_cidadao),
);
