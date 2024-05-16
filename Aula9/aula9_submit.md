# BD: Guião 9


## ​9.1
 
### *a)*

```
... Write here your answer ...
```

### *b)* 

```sql
create procedure getManagersAndLongestServing
as
begin
    create table #manageryears (
        ssn char(9),
        mgr_start_date date,
        yearsasmanager int
    );

    insert into #manageryears
    select
        e.ssn,
        d.mgr_start_date,
        datediff(year, d.mgr_start_date, getdate()) as yearsasmanager
    from
        employee e
    inner join 
        department d on e.ssn = d.mgr_ssn;

    create table #longestservingmanager (
        ssn char(9),
        maxyearsasmanager int
    );

    insert into #longestservingmanager
    select
        top 1 ssn,
        yearsasmanager as maxyearsasmanager
    from
        #manageryears
    order by
        yearsasmanager desc;

    select
        m.*,
        l.maxyearsasmanager
    from
        #manageryears m
    inner join
        #longestservingmanager l on m.ssn = l.ssn;

    drop table #manageryears;
    drop table #longestservingmanager;
end;
```

### *c)* 

```
... Write here your answer ...
```

### *d)* 

```
... Write here your answer ...
```

### *e)* 

```
... Write here your answer ...
```

### *f)* 

```
... Write here your answer ...
```

### *g)* 

```
... Write here your answer ...
```

### *h)* 

```
... Write here your answer ...
```

### *i)* 

```
... Write here your answer ...
```
