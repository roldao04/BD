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
females = σ Sex='F' (employee)
γ Dname; avg(Salary) -> avg_salary (females ⨝ department)
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
projects = σ Dlocation != 'Aveiro' ∧ Plocation = 'Aveiro' (project ⨝Dnum=Dnumber dept_location)
π Fname, Address (employee ⨝ Dno=Dnum projects)
```

## ​Problema 5.2

### _a)_

```
table = encomenda ⟗ fornecedor=nif fornecedor
π nome σ fornecedor=null table
```

### _b)_

```
π nome, media (γ codProd;avg(unidades)-> media (item) ⨝ codProd=codigo produto)
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
(π numUtente (paciente)) - (π numUtente (prescricao))
```

### _b)_

```
T = (π numMedico (prescricao)) ⨝ numMedico = numSNS (medico)
γ especialidade; count(numSNS)->numPresc T
```

### _c)_

```
T = (π farmacia (prescricao)) ⨝ farmacia = nome (farmacia)
γ farmacia; count(nome)->numPresc T
```

### _d)_

```
Farmacos_906 = π numReg (σ numReg = 906 (farmaceutica)) ⨝ numReg = numRegFarm (farmaco)
Farmacos_Prescritos = π nome (Farmacos_906 ⨝ nome = nomeFarmaco (presc_farmaco))
π nome (Farmacos_906) - Farmacos_Prescritos
```

### _e)_

```
T = π numPresc, farmacia (prescricao) ⨝ presc_farmaco ⨝ numRegFarm = numReg (farmaceutica)
γ farmacia, nome; count(nome)->num_Farmacos_Vendidos (T)
```

### _f)_

```
T = σ num_dif_medicos > 1 γ numUtente; count(numMedico)->num_dif_medicos (π numUtente, numMedico (prescricao))
π nome, numUtente (paciente) ⨝ T
```
