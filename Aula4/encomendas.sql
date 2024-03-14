USE ENCOMENDAS;

CREATE TABLE Tipo_Fornecedor (
                                 code INT PRIMARY KEY NOT NULL,
                                 nome VARCHAR(255)
);

CREATE TABLE Fornecedor (
                            nome VARCHAR(50),
                            NIF INT PRIMARY KEY NOT NULL CHECK (NIF > 0),
                            addr VARCHAR(50) NOT NULL,
                            fax VARCHAR(50)NOT NULL,
                            cond_pagamento INT NOT NULL CHECK(cond_pagamento > 0),
                            tipo_fornecedor INT NOT NULL ,
                            FOREIGN KEY (tipo_fornecedor) REFERENCES Tipo_Fornecedor(code)
);

CREATE TABLE Produto (
                         code INT PRIMARY KEY NOT NULL,
                         nome VARCHAR(50) NOT NULL,
                         iva DECIMAL(5, 2) NOT NULL,
                         stock INT NOT NULL CHECK (stock >= 0),
);

CREATE TABLE Encomenda (
                           data DATE NOT NULL ,
                           num_unidade INT NOT NULL ,
                           product_code INT NOT NULL,
                           supplier_code INT NOT NULL ,
                           PRIMARY KEY (product_code),
                           FOREIGN KEY (product_code) REFERENCES Produto(code),
                           FOREIGN KEY (supplier_code) REFERENCES Fornecedor(NIF)
);
