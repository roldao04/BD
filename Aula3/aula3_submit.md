# BD: Guião 3

## ​Problema 3.1

### _a)_

```
Cliente(nome, endereco, num_carta, NIF)
Aluguer(numero, duracao, data, client, balcao, veiculo)
Balcao(numero, nome, endereco)
Veiculo(marca,ano, matricula, tipo)
Tipo_Veiculo(código, arcondicionado, designação)
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
- Foreign Key: tipo

Tipo_Veiculo:
- Candidate Key: codigo
- Primary Key: codigo

Similaridade:
- Candidate Key: tipo1, tipo2
- Primary Key: tipo1, tipo2
- Foreign Key: tipo1, tipo2

Ligeiro:
- Freign Key: codigo

Pesado:
- Freign Key: codigo

```

### _c)_

![ex_3_1c!](ex_3_1c.jpg "AnImage")

## ​Problema 3.2

### _a)_

```
Airport(Airport_code, City, State, Name);
Airplane_Type(Type_name, Max_seats, Company);
Airplane(Airplane_id, Total_no_seats, Type);
Flight_Leg(Leg_no, Scheduled_dep_time, Scheduled_arr_time, Departure_airport, Arrival_airport);
Flight(Number, Airlane, Weekdays);
Leg_Instance(Date, No_of_avail_seats, Flight_Leg);
Fare(Code, Amount, Restrictions, Flight);
Reservation(Custumer_name, Cphone, Seat, Leg_instance);
Seat(Seat_no);
```

### _b)_

```
Airport:
- Candidate Key: Airport_code
- Primary Key: Airport_code

Airplane_Type:
- Candidate Key: Type_name
- Primary Key: Type_name

Airplane:
- Candidate Key: Airplane_id
- Primary Key: Airplane_id
- Foreign Key: Type

Flight_Leg:
- Candidate Key: Leg_no
- Primary Key: Leg_no
- Foreign Keys: 
  - Departure_airport
  - Arrival_airport

Flight:
- Candidate Key: Number
- Primary Key: Number

Leg_Instance:
- Candidate Keys: 
  - Date
  - Leg_no
- Primary Key: (Date, Leg_no)
- Foreign Key: Flight_Leg

Fare:
- Candidate Key: Code
- Primary Key: Code
- Foreign Key: Flight

Seat:
- Candidate Key: Seat_no
- Primary Key: Seat_no

Reservation:
- Candidate Keys: 
  - Customer_name
  - Cphone
  - Seat_no
  - Date
  - Leg_no
- Primary Key: (Customer_name, Cphone, Seat_no, Date, Leg_no)
- Foreign Keys:
  - Seat
  - Leg_Instance
```

### _c)_

![ex_3_2c!](ex2.drawio.svg "AnImage")

## ​Problema 3.3

### _a)_ 2.1

![ex_3_3_a!](ex_3_3a.jpg "AnImage")

### _b)_ 2.2

![ex_3_3_b!](ex3b.drawio.svg "AnImage")

### _c)_ 2.3

![ex_3_3_c!](ex3c.drawio.svg "AnImage")

### _d)_ 2.4

![ex_3_3_d!](ex_3_3d.jpg "AnImage")
