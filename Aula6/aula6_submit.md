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
SELECT titles.pub_id, type, COUNT(ytd_sales) AS sales_amount, AVG(price) AS average_price
FROM publishers JOIN titles ON titles.pub_id=publishers.pub_id
GROUP BY titles.pub_id, type
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
SELECT title, au_fname, au_lname,
	ytd_sales*price*royalty/100 as auths_revenue,
	price*ytd_sales-price*ytd_sales*royalty/100 AS publisher_revenue
FROM titles
INNER JOIN titleauthor ON titleauthor.title_id=titles.title_id
INNER JOIN authors ON authors.au_id=titleauthor.au_id
GROUP BY title, price, au_fname, au_lname, ytd_sales, royalty
```

### _q)_ Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```
SELECT stor_name FROM stores
INNER JOIN sales ON stores.stor_id=sales.stor_id
INNER JOIN titles ON sales.title_id=titles.title_id
GROUP BY stores.stor_name
HAVING COUNT(title)=(SELECT COUNT(title_id) FROM titles);
```

### _r)_ Lista de lojas que venderam mais livros do que a média de todas as lojas;

```
SELECT stor_name FROM stores
INNER JOIN sales ON stores.stor_id=sales.stor_id
INNER JOIN titles ON sales.title_id=titles.title_id
GROUP BY stores.stor_name
HAVING SUM(sales.qty)>(SELECT SUM(sales.qty)/COUNT(stor_id) FROM sales);
```

### _s)_ Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```
SELECT title FROM titles
WHERE title_id NOT IN (SELECT title_id FROM sales WHERE stor_id = (SELECT stor_id FROM stores WHERE stor_name = 'Bookbeat'));
```

### _t)_ Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora;

```
SELECT pub_name, stor_name 
FROM publishers
INNER JOIN titles ON publishers.pub_id = titles.pub_id
INNER JOIN sales ON titles.title_id = sales.title_id
INNER JOIN stores ON sales.stor_id = stores.stor_id
GROUP BY pub_name, stor_name
HAVING COUNT(titles.title_id) = 0;
```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script

[a) SQL DDL File](company_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](company_data.sql "SQLFileQuestion")

#### c) Queries

##### _a)_

```
SELECT e.Ssn, e.Fname
FROM employee e
JOIN department d ON e.Dno = d.Dnumber;
```

##### _b)_

```
SELECT e.Fname
FROM employee e
JOIN employee supervisor ON e.Super_ssn = supervisor.Ssn
WHERE supervisor.Fname = 'Carlos' AND supervisor.Minit = 'D' AND supervisor.Lname = 'Gomes';
```

##### _c)_

```
SELECT p.Pnumber, p.Pname, SUM(w.Hours) AS TotalHours
FROM project p
JOIN works_on w ON p.Pnumber = w.Pno
GROUP BY p.Pnumber, p.Pname;
```

##### _d)_

```
SELECT e.Fname
FROM employee e
JOIN works_on w ON e.Ssn = w.Essn
JOIN project p ON w.Pno = p.Pnumber
WHERE p.Pname = 'Aveiro Digital' AND p.Dnum = 3 AND w.Hours > 20;
```

##### _e)_

```
SELECT e.Fname
FROM employee e
LEFT JOIN works_on w ON e.Ssn = w.Essn
WHERE w.Pno IS NULL;
```

##### _f)_

```
SELECT d.Dname, AVG(e.Salary) AS avg_salary
FROM employee e
JOIN department d ON e.Dno = d.Dnumber
WHERE e.Sex = 'F'
GROUP BY d.Dname;
```

##### _g)_

```
... Write here your answer ...SELECT e.*
FROM employee e
JOIN (
    SELECT Essn
    FROM dependent
    GROUP BY Essn
    HAVING COUNT(Essn) > 2
) AS subquery ON e.Ssn = subquery.Essn;
```

##### _h)_

```
SELECT e.*
FROM employee e
WHERE e.Ssn IN (
    SELECT d.Mgr_ssn
    FROM department d
)
AND e.Ssn NOT IN (
    SELECT d.Essn
    FROM dependent d
);
```

##### _i)_

```
SELECT e.Fname, e.Address
FROM employee e
JOIN works_on w ON e.Ssn = w.Essn
JOIN project p ON w.Pno = p.Pnumber
JOIN department d ON e.Dno = d.Dnumber
JOIN dept_location dl ON d.Dnumber = dl.Dnumber
WHERE p.Plocation = 'Aveiro' AND dl.Dlocation != 'Aveiro';
```

### 5.2

#### a) SQL DDL Script

[a) SQL DDL File](encomendas_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](encomendas_data.sql "SQLFileQuestion")

#### c) Queries

##### _a)_

```
SELECT f.nome
FROM fornecedor f
LEFT JOIN encomenda e ON f.nif = e.fornecedor
WHERE e.numero IS NULL;
```

##### _b)_

```
SELECT p.nome, AVG(i.unidades) AS media
FROM item i
JOIN produto p ON i.codProd = p.codigo
GROUP BY p.nome;
```

##### _c)_

```
SELECT AVG(num_prod) AS media
FROM (
    SELECT count(i.codProd) AS num_prod
    FROM item i
    GROUP BY i.numEnc
) AS subquery;
```

##### _d)_

```
SELECT f.nome, p.nome, SUM(i.unidades) AS qnt_total
FROM item i
JOIN encomenda e ON i.numEnc = e.numero
JOIN fornecedor f ON e.fornecedor = f.nif
JOIN produto p ON i.codProd = p.codigo
GROUP BY f.nome, p.nome;
```

### 5.3

#### a) SQL DDL Script

[a) SQL DDL File](medicamentos_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](medicamentos_data.sql "SQLFileQuestion")

#### c) Queries

##### _a)_

```
SELECT numUtente
FROM paciente
EXCEPT
SELECT numUtente
FROM prescricao;
```

##### _b)_

```
SELECT m.especialidade, COUNT(p.numMedico) AS numPresc
FROM prescricao p
JOIN medico m ON p.numMedico = m.numSNS
GROUP BY m.especialidade;
```

##### _c)_

```
SELECT p.farmacia, COUNT(f.nome) AS numPresc
FROM prescricao p
JOIN farmacia f ON p.farmacia = f.nome
GROUP BY p.farmacia;
```

##### _d)_

```
SELECT f.nome
FROM farmaco f
JOIN farmaceutica fa ON f.numRegFarm = fa.numReg
LEFT JOIN presc_farmaco pf ON f.nome = pf.nomeFarmaco AND fa.numReg = 906
WHERE pf.nomeFarmaco IS NULL;
```

##### _e)_

```
SELECT p.farmacia, fa.nome, COUNT(fa.nome) AS num_Farmacos_Vendidos
FROM prescricao p
JOIN presc_farmaco pf ON p.numPresc = pf.numPresc
JOIN farmaco f ON pf.numRegFarm = f.codigo
JOIN farmaceutica fa ON f.numRegFarm = fa.numReg
GROUP BY p.farmacia, fa.nome;
```

##### _f)_

```
SELECT pa.nome, pa.numUtente
FROM paciente pa
JOIN (
    SELECT p.numUtente
    FROM prescricao p
    GROUP BY p.numUtente
    HAVING COUNT(DISTINCT p.numMedico) > 1
) AS T ON pa.numUtente = T.numUtente;
```
