# BD: Guião 9

## ​9.1

### _a)_

```sql
CREATE PROCEDURE remove_funcionario
    @ssn CHAR(9)
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

### _c)_

```sql
CREATE TRIGGER dep_manage_lock ON Department INSTEAD OF INSERT, UPDATE
AS
    BEGIN
        IF (SELECT count(*) FROM inserted) > 0
        BEGIN
            DECLARE @employee_ssn CHAR(9);
            SET @employee_ssn = (SELECT Mgr_ssn FROM inserted);

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
create trigger salary_check on Employee
after insert, update
as
begin
    declare @emp_ssn char(9);
    declare @empl_dno int;
    declare @empl_salary decimal(10,2);
    declare @mgr_ssn char(9);
    declare @mgr_salary decimal(10,2);

    declare cur cursor for 
    select ssn, salary, dno from inserted;

    open cur;
    fetch next from cur into @emp_ssn, @empl_salary, @empl_dno;

    while @@fetch_status = 0
    begin 
        select @mgr_ssn = super_ssn from employee where ssn = @emp_ssn;
        select @mgr_salary = salary from employee where ssn = @mgr_ssn;

        if @empl_salary > @mgr_salary
        begin
            update employee
            set salary = @mgr_salary - 1
            where ssn = @emp_ssn;
        end;

        fetch next from cur into @emp_ssn, @empl_salary, @empl_dno;
    end;

    close cur;
    deallocate cur;
end;
```

### _e)_

```sql
CREATE FUNCTION dbo.get_name_location (@employee_ssn NVARCHAR(9))
RETURNS TABLE
AS
RETURN (
    SELECT p.Pname AS project_name, p.Plocation AS project_location
    FROM project p
    JOIN works_on w ON p.Pnumber = w.Pno
    WHERE w.Essn = @employee_ssn
);
```

### _f)_

```sql
create function dbo.getEmployeesAboveAverageSalary(@dno int)
returns table
as
return
(
    select
        e.*
    from
        employee e
    where
        e.dno = @dno
        and e.salary > (
            select avg(salary)
            from employee
            where dno = @dno
            )
);
--------------------------------
select * from dbo.getEmployeesAboveAverageSalary(1);
```

### _g)_

```
... Write here your answer ...
```

### _h)_

```sql
create trigger delete_department on department
after delete
as
begin
    if not exists (select * from information_schema.tables where table_schema = 'dbo' and table_name = 'deleted_department')
    begin
        create table department_deleted (
            dnumber int,
            dname nvarchar(30),
            mgr_ssn char(9),
            mgr_start_date date
        );
    end;

    insert into dbo.departament_deleted(dnumber, dname, mgr_ssn, mgr_start_date)
    select dnumber, dname, mgr_ssn, mgr_start_date from deleted;
end;
```

### _i)_

```
... Write here your answer ...
```
