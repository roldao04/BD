# BD: Guião 3

## ​Problema 3.1

### _a)_

```
Cliente(nome, endereco, num_carta, NIF)
Aluguer(numero, duracao, data, client, balcao, veiculo)
Balcao(numero, nome, endereco)
Veiculo(marca,ano, matricula, tipo)
Tipo_Veiculo(designacao, arcondicionado, designação )
Ligeiro(numlugares, portas, combustivel)
Pesado(peso,passageiros)
Similaridade(Tipo_Veiculo)
```

### _b)_

```
Cliente:
- Candidate Key: NIF, num_carta
- Primary Key: NIF

Aluguer:
- Candidate Key: numero
- Primary Key: numero
- Foreign Key: client, balcao, veiculo

Balcao:
- Candidate Key: numero
- Primary Key: numero

Veiculo:
- Candidate Key: matricula
- Primary Key: matricula

Tipo_Veiculo:
- Candidate Key: codigo
- Primary Key: codigo

```

### _c)_

![ex_3_1c!](ex_3_1c.jpg "AnImage")

## ​Problema 3.2

### _a)_

```
... Write here your answer ...
```

### _b)_

```
... Write here your answer ...
```

### _c)_

![ex_3_2c!](ex_3_2c.jpg "AnImage")

## ​Problema 3.3

### _a)_ 2.1

![ex_3_3_a!](ex_3_3a.jpg "AnImage")

### _b)_ 2.2

![ex_3_3_b!](ex_3_3b.jpg "AnImage")

### _c)_ 2.3

![ex_3_3_c!](ex_3_3c.jpg "AnImage")

### _d)_ 2.4

![ex_3_3_d!](ex_3_3d.jpg "AnImage")
