# BD: Guião 9

## ​9.1

### _a)_

```sql
CREATE PROCEDURE remove_funcionario
    @ssn CHAR(9),
AS
BEGIN
    DELETE FROM Dependente
    WHERE Essn = @ssn;

    DELETE FROM Works_on
    WHERE Essn = @ssn;

    UPDATE Department SET Mgr_ssn = NULL
    WHERE Mgr_ssn = @ssn;

    UPDATE Employee SET Super_ssn = NULL
    WHERE Super_ssn = @ssn;

    DELETE FROM Employee
    WHERE Ssn = @ssn;
END;

```

### _b)_

```
... Write here your answer ...
```

### _c)_

```sql
CREATE TRIGGER dep_manage_lock ON Department INSTEAD OF INSERT, UPDATE
AS
    BEGIN
        IF (SELECT count(*) FROM inserted) > 0
        BEGIN
            DECLARE @employee_ssn CHAR(9);
            @employee_ssn = (SELECT Mgr_ssn FROM inserted);

            IF (@employee_ssn) IS NULL OR ((SELECT count(*) FROM Employee WHERE Ssn=@employee_ssn) = 0)
                                RAISERROR('employee doesnt exist', 16, 1);
            ELSE
                BEGIN
                    IF (SELECT COUNT(Dnumber) FROM Department WHERE Mgr_ssn=@employee_ssn) >=1
                        RAISERROR('employee cannot manage more than one department', 16, 1);
                    ELSE
                        INSERT INTO Department SELECT * FROM inserted;
                END
        END
    END;
```

### _d)_

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

### _e)_

```sql
CREATE FUNCTION get_name_location (@employee_ssn NVARCHAR(9))
RETURNS TABLE
AS
RETURN(
    SELECT p.name AS project_name, p.location AS project_location
    FROM project p
    JOIN works_on w ON p.pnumber = w.pnumber
    WHERE w.essn = @employee_ssn
);

```

### _f)_

```
... Write here your answer ...
```

### _g)_

```
... Write here your answer ...
```

### _h)_

```
... Write here your answer ...
```

### _i)_

```
... Write here your answer ...
```
