# BD: Guião 8

## ​8.1. Complete a seguinte tabela.

Complete the following table.

| #   | Query                                                                                                      | Rows  | Cost  | Pag. Reads | Time (ms) | Index used | Index Op.            | Discussion |
| :-- | :--------------------------------------------------------------------------------------------------------- | :---- | :---- | :--------- | :-------- | :--------- | :------------------- | :--------- |
| 1   | SELECT \* from Production.WorkOrder                                                                        | 72591 | 0.488 | 552        | 768       | 1          | Clustered Index Scan |            |
| 2   | SELECT \* from Production.WorkOrder where WorkOrderID=1234                                                 |     1 | 0.003 | 26         | 30        | 1          | Clustered Index Scan |            |
| 3.1 | SELECT \* FROM Production.WorkOrder WHERE WorkOrderID between 10000 and 10010                              |    11 | 0.003 | 26         | 66        | 1          | Clustered Index Scan |            |
| 3.2 | SELECT \* FROM Production.WorkOrder WHERE WorkOrderID between 1 and 72591                                  | 72591 | 0.473 | 744        | 547       | 1          | Clustered Index Scan |            |
| 4   | SELECT \* FROM Production.WorkOrder WHERE StartDate = '2012-05-14'                                         | 72591 | 0.393 | 748        | 115       | 1          | Clustered Index Scan |            |
| 5   | SELECT \* FROM Production.WorkOrder WHERE ProductID = 757                                                  |     9 | 0.034 | 238        | 54        | 1          | Non Clustered Index  |            |
| 6.1 | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 757                              |     9 | 0.003 | 28         | 9         | 1          | *                    |            |
| 6.2 | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945                              |  1105 | 0.003 | 6          | 46        | 1          | *                    |            |
| 6.3 | SELECT WorkOrderID FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04'            |  1105 | 0.005 | 34         | 4         | 1          | *                    |            |
| 7   | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' |     1 | 0.003 | 30         | 12        | 1          |                      |            |
| 8   | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' |     1 | 0.003 | 32         | 6         | 1          |                      |            |


*Created a new index 'CREATE NONCLUSTERED INDEX IX_WorkOrder_ProductID_Include_StartDate ON Production.WorkOrder (ProductID) INCLUDE (StartDate);'


## ​8.2.

### a)

```sql
CREATE CLUSTERED INDEX rid_idx on dbo.mytemp(rid);
```

### b)

```
Inserted      50000 total records
Milliseconds used: 64670
[2024-05-09 09:59:08] completed in 1 m 7 s 34 ms

Os dados indicam que o índice com ID 597577167 apresenta uma alta fragmentação de 98,78% no nível mais superficial, o que pode impactar negativamente o desempenho das operações de busca. A ocupação média das páginas para este índice é de cerca de 69,78%, sugerindo um uso moderado do espaço. No nível mais profundo do índice com ID 1977058079, a ocupação das páginas é extremamente baixa, apenas 0,39%, indicando um uso ineficiente do espaço. Recomenda-se realizar manutenção regular dos índices, como reconstrução ou reorganização, especialmente para o índice altamente fragmentado, para melhorar a performance geral da base de dados.
```

### c)

```
Fillfactor 65
Inserted 50000 total records
Milliseconds used: 140080
Fillfactor 80
Inserted 50000 total records
Milliseconds used: 138410
Fillfactor 90
Inserted 50000 total records
Milliseconds used: 163433
```

### d)

```
Eliminar tabela mytemp, executar a query e criar o Clustered Index
CREATE TABLE mytemp (
rid BIGINT IDENTITY (1, 1) NOT NULL,
at1 INT NULL,
at2 INT NULL,
at3 INT NULL,
lixo varchar(100) NULL
);
SET IDENTITY_INSERT mytemp ON;
Inserted 50000 total records
Milliseconds used: 180714
```

### e)

```
CREATE NONCLUSTERED INDEX at1_index ON mytemp(at1);
CREATE NONCLUSTERED INDEX at2_index ON mytemp(at2);
CREATE NONCLUSTERED INDEX at3_index ON mytemp(at3);
CREATE NONCLUSTERED INDEX lixo_index ON mytemp(lixo);
Sem indexes
Inserted 50000 total records
Milliseconds used: 249760
Com indexes
Inserted 50000 total records
Milliseconds used: 304643
A performance é pior com todos os indexes porque não há eficiência na
inserção dos tuplos na tabela
```

## ​8.3.

```
-- Índice para Funcionários por Nome
CREATE INDEX idx_employee_name ON Employees (Fname, Lname);

-- Índice para Funcionários por Departamento
CREATE INDEX idx_employee_department ON Employees (Dno);

-- Índice para Projetos por Departamento
CREATE INDEX idx_projects_department ON Projects (Dnum);

-- Índice para Dependentes por Funcionário
CREATE INDEX idx_dependents_employee ON Dependents (Essn);
```
