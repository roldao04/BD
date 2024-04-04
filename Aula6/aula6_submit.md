# BD: Guião 6

## Problema 6.1

### _a)_ Todos os tuplos da tabela autores (authors);

```
SELECT * FROM authors;
```

### _b)_ O primeiro nome, o último nome e o telefone dos autores;

```
SELECT au_fname, au_lname, phone FROM authors;
```

### _c)_ Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente);

```
SELECT au_fname, au_lname, phone FROM authors ORDER BY au_fname, au_lname;
```

### _d)_ Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone);

```
SELECT au_fname AS first_name, au_lname AS last_name, phone AS telephone FROM authors ORDER BY au_fname, au_lname;
```

### _e)_ Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’;

```
SELECT au_fname AS first_name, au_lname AS last_name, phone AS telephone FROM authors WHERE state <> 'CA' AND au_lname = 'Ringer' ORDER BY au_fname, au_lname;
```

### _f)_ Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome;

```
SELECT pub_name FROM publishers
WHERE pub_name LIKE '%Bo%';
```

### _g)_ Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’;

```
SELECT DISTINCT pub_name
FROM publishers
INNER JOIN titles
ON publishers.pub_id = titles.pub_id
WHERE type = 'Business';
```

### _h)_ Número total de vendas de cada editora;

```
SELECT pub_name, SUM(ytd_sales) AS total_sales
FROM ((sales INNER JOIN titles ON sales.title_id=titles.title_id)
INNER JOIN publishers ON publishers.pub_id=titles.pub_id)
GROUP BY pub_name;
```

### _i)_ Número total de vendas de cada editora agrupado por título;

```
SELECT pub_name, title, SUM(ytd_sales) AS total_sales
FROM (publishers JOIN titles ON publishers.pub_id = titles.pub_id)
GROUP BY pub_name, title
ORDER BY pub_name;
```

### _j)_ Nome dos títulos vendidos pela loja ‘Bookbeat’;

```
SELECT title FROM titles
INNER JOIN sales ON titles.title_id = sales.title_id
INNER JOIN stores ON sales.stor_id = stores.stor_id
WHERE stor_name = 'Bookbeat';
```

### _k)_ Nome de autores que tenham publicações de tipos diferentes;

```
SELECT au_fname AS first_name, au_lname AS last_name FROM ((authors
INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id)
INNER JOIN titles ON titleauthor.title_id = titles.title_id)
GROUP BY au_fname, au_lname
HAVING COUNT (DISTINCT titles.type)>1
```

### _l)_ Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id);

```
SELECT type, pub_id, AVG(price) AS avg_price, SUM(ytd_sales) AS total_sales
```

### _m)_ Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo);

```
SELECT type FROM titles AS t1
WHERE advance > 1.5 * (SELECT AVG(advance) FROM titles AS t2 WHERE t1.type = t2.type)
```

### _n)_ Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda;

```
SELECT title, au_fname, au_lname, price * ytd_sales * royalty /100 AS revenue
FROM (((titleauthor INNER JOIN authors ON titleauthor.au_id = authors.au_id)
INNER JOIN titles ON titleauthor.title_id = titles.title_id)
INNER JOIN sales ON titles.title_id = sales.title_id)
ORDER BY title, au_lname, au_fname;
```

### _o)_ Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;

```
SELECT DISTINCT title, ytd_sales, price * ytd_sales AS total_revenue, price * ytd_sales * royalty / 100 AS authors_revenue, (price * ytd_sales) - (price * ytd_sales * royalty / 100) AS publisher_revenue
FROM ((titles INNER JOIN sales ON titles.title_id = sales.title_id)
INNER JOIN publishers ON titles.pub_id = publishers.pub_id)
ORDER BY title;
```

### _p)_ Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;

```
... Write here your answer ...
```

### _q)_ Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```
... Write here your answer ...
```

### _r)_ Lista de lojas que venderam mais livros do que a média de todas as lojas;

```
... Write here your answer ...
```

### _s)_ Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```
... Write here your answer ...
```

### _t)_ Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora;

```
... Write here your answer ...
```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script

[a) SQL DDL File](ex_6_2_1_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_1_data.sql "SQLFileQuestion")

#### c) Queries

##### _a)_

```
... Write here your answer ...
```

##### _b)_

```
... Write here your answer ...
```

##### _c)_

```
... Write here your answer ...
```

##### _d)_

```
... Write here your answer ...
```

##### _e)_

```
... Write here your answer ...
```

##### _f)_

```
... Write here your answer ...
```

##### _g)_

```
... Write here your answer ...
```

##### _h)_

```
... Write here your answer ...
```

##### _i)_

```
... Write here your answer ...
```

### 5.2

#### a) SQL DDL Script

[a) SQL DDL File](ex_6_2_2_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_2_data.sql "SQLFileQuestion")

#### c) Queries

##### _a)_

```
... Write here your answer ...
```

##### _b)_

```
... Write here your answer ...
```

##### _c)_

```
... Write here your answer ...
```

##### _d)_

```
... Write here your answer ...
```

### 5.3

#### a) SQL DDL Script

[a) SQL DDL File](ex_6_2_3_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_3_data.sql "SQLFileQuestion")

#### c) Queries

##### _a)_

```
... Write here your answer ...
```

##### _b)_

```
... Write here your answer ...
```

##### _c)_

```
... Write here your answer ...
```

##### _d)_

```
... Write here your answer ...
```

##### _e)_

```
... Write here your answer ...
```

##### _f)_

```
... Write here your answer ...
```
