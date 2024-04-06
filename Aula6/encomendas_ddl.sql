-- Tabela para Tipos de Fornecedores
CREATE TABLE tipo_fornecedor (
    codigo INT PRIMARY KEY,
    designacao NVARCHAR(255)
);

-- Tabela para Fornecedores
CREATE TABLE fornecedor (
    nif INT PRIMARY KEY,
    nome NVARCHAR(255),
    fax BIGINT,
    endereco NVARCHAR(255),
    condpag INT,
    tipo INT,
    FOREIGN KEY (tipo) REFERENCES tipo_fornecedor(codigo)
);

-- Tabela para Produtos
CREATE TABLE produto (
    codigo INT PRIMARY KEY,
    nome NVARCHAR(255),
    preco DECIMAL(10, 2),
    iva INT,
    unidades INT
);

-- Tabela para Encomendas
CREATE TABLE encomenda (
    numero INT PRIMARY KEY,
    data DATE,
    fornecedor INT,
    FOREIGN KEY (fornecedor) REFERENCES fornecedor(nif)
);

-- Tabela para Itens de Encomendas
CREATE TABLE item (
    numEnc INT,
    codProd INT,
    unidades INT,
    PRIMARY KEY (numEnc, codProd),
    FOREIGN KEY (numEnc) REFERENCES encomenda(numero),
    FOREIGN KEY (codProd) REFERENCES produto(codigo)
);
