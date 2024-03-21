# BD: Guião 5

## ​Problema 5.1

### _a)_

```
π Ssn, Fname (project ⨝ Dno=Dnum employee)
```

### _b)_

```
cdg = π supervisor_ssn←Ssn (σ Fname='Carlos' ∧ Minit='D' ∧ Lname='Gomes' (employee))
π Fname (employee ⨝ Super_ssn=supervisor_ssn (cdg))
```

### _c)_

```
γ Pnumber, Pname; sum(Hours) -> Hours ((project) ⨝ Pnumber=Pno (works_on))
```

### _d)_

```
Project_Number = π Pnumber (σ Pname = 'Aveiro Digital' ∧ Dnum = 3 (project))
ESSN = π Essn (Project_Number ⨝ Hours > 20 ∧ Pnumber=Pno (works_on))
π Fname (ESSN ⨝ Essn=Ssn (employee))
```

### _e)_

```
π Fname (employee ⟕ Ssn=Essn ∧ Pno=null (works_on))
```

### _f)_

```
... Write here your answer ...
```

### _g)_

```
ThreeOrMoreDependent = σ count_dep>2 (γ Essn; count(Essn) -> count_dep (dependent))
ThreeOrMoreDependent ⨝ Essn = Ssn (employee)
```

### _h)_

```
Managers = π Mgr_ssn (department)
Managers_with_Dependents = π Mgr_ssn (Managers ⨝ Mgr_ssn = Essn (dependent))
Managers - Managers_with_Dependents
```

### _i)_

```
... Write here your answer ...
```

## ​Problema 5.2

### _a)_

```
... Write here your answer ...
```

### _b)_

```
... Write here your answer ...
```

### _c)_

```
... Write here your answer ...
```

### _d)_

```
... Write here your answer ...
```

## ​Problema 5.3

### _a)_

```
... Write here your answer ...
```

### _b)_

```
... Write here your answer ...
```

### _c)_

```
... Write here your answer ...
```

### _d)_

```
... Write here your answer ...
```

### _e)_

```
... Write here your answer ...
```

### _f)_

```
... Write here your answer ...
```
