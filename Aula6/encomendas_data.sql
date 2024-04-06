-- Continuação de inserção de tipos de fornecedores
INSERT INTO tipo_fornecedor(codigo, designacao) VALUES (108, 'Congelados');
INSERT INTO tipo_fornecedor(codigo, designacao) VALUES (109, 'Doces e Sobremesas');
INSERT INTO tipo_fornecedor(codigo, designacao) VALUES (110, 'Padaria e Cereais');
INSERT INTO tipo_fornecedor(codigo, designacao) VALUES (111, 'Produtos de Limpeza');
INSERT INTO tipo_fornecedor(codigo, designacao) VALUES (112, 'Higiene Pessoal');

-- Continuação de inserção de fornecedores
INSERT INTO fornecedor(nif, nome, fax, endereco, condpag, tipo) VALUES (509148322, 'Frutaria Pevides', 221987654, 'Rua das Laranjeiras 58', 45, 103);
INSERT INTO fornecedor(nif, nome, fax, endereco, condpag, tipo) VALUES (509159753, 'Mercearia do Bairro', 229876123, 'Largo do Mercado 12', 30, 104);
INSERT INTO fornecedor(nif, nome, fax, endereco, condpag, tipo) VALUES (509163423, 'Bebidas e Companhia', 231234567, 'Avenida das Bebidas 90', 60, 105);

-- Continuação de inserção de produtos
INSERT INTO produto(codigo, nome, preco, iva, unidades) VALUES (10015, 'Camarão Congelado', 12.50, 23, 150);
INSERT INTO produto(codigo, nome, preco, iva, unidades) VALUES (10016, 'Torta de Chocolate', 3.75, 23, 80);
INSERT INTO produto(codigo, nome, preco, iva, unidades) VALUES (10017, 'Pão Integral', 1.20, 6, 200);

-- Continuação de inserção de encomendas
INSERT INTO encomenda(numero, data, fornecedor) VALUES (11, '2015-03-13', 509148322);
INSERT INTO encomenda(numero, data, fornecedor) VALUES (12, '2015-03-14', 509159753);
INSERT INTO encomenda(numero, data, fornecedor) VALUES (13, '2015-03-15', 509163423);

-- Continuação de inserção de itens de encomendas
INSERT INTO item(numEnc, codProd, unidades) VALUES (11, 10015, 50);
INSERT INTO item(numEnc, codProd, unidades) VALUES (12, 10016, 30);
INSERT INTO item(numEnc, codProd, unidades) VALUES (13, 10017, 100);
