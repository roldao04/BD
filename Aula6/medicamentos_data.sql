-- Inserindo mais médicos
INSERT INTO medico (numSNS, nome, especialidade) VALUES (106, 'Laura Neves', 'Endocrinologia');
INSERT INTO medico (numSNS, nome, especialidade) VALUES (107, 'Carlos Menezes', 'Gastroenterologia');
INSERT INTO medico (numSNS, nome, especialidade) VALUES (108, 'Patricia Santos', 'Dermatologia');

-- Inserindo mais pacientes
INSERT INTO paciente (numUtente, nome, dataNasc, endereco) VALUES (6, 'Marta Soares', '1984-04-20', 'Praça do Comércio 100');
INSERT INTO paciente (numUtente, nome, dataNasc, endereco) VALUES (7, 'Antonio Costa', '1975-07-15', 'Avenida dos Navegantes 45');
INSERT INTO paciente (numUtente, nome, dataNasc, endereco) VALUES (8, 'Sofia Carvalho', '1992-02-11', 'Rua das Flores 305');

-- Inserindo mais farmácias
INSERT INTO farmacia (nome, telefone, endereco) VALUES ('Farmacia Nova Esperança', 223334444, 'Rua Nova da Esperança 50');
INSERT INTO farmacia (nome, telefone, endereco) VALUES ('Farmacia Mar Azul', 227778888, 'Largo do Mar Azul 10');
INSERT INTO farmacia (nome, telefone, endereco) VALUES ('Farmacia do Povo', 225556666, 'Rua do Comercio 750');

-- Inserindo mais farmacêuticas
INSERT INTO farmaceutica (numReg, nome, endereco) VALUES (909, 'Novartis', 'Avenida das Nações Unidas 1234');
INSERT INTO farmaceutica (numReg, nome, endereco) VALUES (910, 'AstraZeneca', 'Parque Tecnológico de Óbidos');
INSERT INTO farmaceutica (numReg, nome, endereco) VALUES (911, 'Sanofi', 'Zona Industrial Norte');

-- Inserindo mais fármacos
INSERT INTO farmaco (numRegFarm, nome, formula) VALUES (910, 'Calmex', 'CXM20');
INSERT INTO farmaco (numRegFarm, nome, formula) VALUES (911, 'Rapilax', 'RPX45');
INSERT INTO farmaco (numRegFarm, nome, formula) VALUES (909, 'Doril', 'DRL10');

-- Inserindo mais prescrições
INSERT INTO prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10010, 2, 106, 'Farmacia Mar Azul', '2024-01-10');
INSERT INTO prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10011, 4, 107, 'Farmacia Nova Esperança', '2024-02-15');
INSERT INTO prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10012, 6, 108, 'Farmacia do Povo', '2024-03-21');

-- Inserindo mais itens de prescrição
INSERT INTO presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10010, 910, 'Calmex');
INSERT INTO presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10011, 911, 'Rapilax');
INSERT INTO presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10012, 909, 'Doril');
