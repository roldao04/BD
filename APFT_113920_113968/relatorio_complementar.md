# Relatório Complementar

## 1. Introdução

Este relatório tem como objetivo complementar o relatório principal, focando se na
na forma como foram feitos os acessos à base de dados.

## 2. Stack

O stack utilizado no backend foi o seguinte:

- Golang (Linguagem principal)
  - Echo (Framework para criação de APIs)
  - Air (Hot reload)
- Templ (Linguagem de template html)
- Htmx (Framework para chamads ajax)
- Tailwind (Framework de css)
  - DaisyUI (Plugin para Tailwind)
- Docker/Docker-compose
- Makefile

### 2.1 Justificação

Decidimos utilizar Go como backend devido à sua integração com templ e htmx e devido
a já termos alguma experiência com a linguagem e com a framework Echo. Além disso,
como o nosso projeto contém muitos dados (atributos de jogadores) a utilização de uma linguagem
dinâmica como python poderia tornar o desenvolvimento mais difícil.

## 3. Como correr o projeto

### 3.1 Requisitos

- Docker
- Docker-compose
- Make

### 3.2 Correr o projeto

**WARNING**: O docker tem de estar a correr para que o projeto inicie.

Para correr o projeto basta correr os seguintes comandos:


```bash
make build
make run
```

**Home Page:** [http://localhost:8080](http://localhost:8080)

## 4. Acessos à base de dados

Na função `main` do file main.go é criado um objeto do tipo `server` ao qual é associado
um outro objeto do tipo `storage` cuja interface é definida no file `storage.go`

Esta interface contém todas as funções utilizadas pela api para aceder à base de dados, sendo
que as suas implementaçõe estão divididas pelos files em `/app/storage/Mssql`.

### 4.1 Ponto de acesso

O driver utilizado para aceder à base de dados foi [go-mssqldb](github.com/microsoft/go-mssqldb).
No file `mssql.go` é declarado o type `Mssql` que implementa a interface `storage` e que contém as
funções necessárias para aceder à base de dados.

```go
type MSqlStorage struct {
   connectionString string
   db               *sql.DB
}

func NewMSqlStorage(username string, password string, host string, port int, databa
   conString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s"

   return &MSqlStorage{connectionString: conString}
   }
}
func (m *MSqlStorage) Start() {
    fmt.Printf("Connecting to SQL Server: %s\n", m.connectionString)
    db, err := sql.Open("sqlserver", m.connectionString)
    if err != nil {
      panic(err)
    }
    fmt.Println("Connected to SQL Server")
    m.db = db
}

func (m *MSqlStorage) Stop() {
   m.db.Close()
   fmt.Println("Disconnected from SQL Server")
}
```

### 4.2 Utilização

Como já foi referido as implementações concretas das funções da interface `storage` estão distribuidas
pelos files em `/app/storage/Mssql`, mais concretamente pelos files:

- [Club.go](app/storage/Mssql/Club.go)
- [Player.go](app/storage/Mssql/Player.go)
- [League.go](app/storage/Mssql/League.go)
- [Nation.go](app/storage/Mssql/Nation.go)

Todas estas funções realizam as mesma operações:

- Query à base de dados;
- Parse dos resultados;
- Retorno dos resultados (excepto em insertions) ou erro.
  - O retorno para a api é feito no formato de um dicionário ou uma lista
    de dicionários na maioria dos casos.

#### 4.2.1 Exemplo de Query

Esta função é utilizada para obter o role de um jogador a partir do seu id.
Utiliza-se esta função como exemplo pois permite demonstrar a forma como são feitas as queries
e não é tão extensa como outras funções.

```go
func (m *MSqlStorage) GetRoleByPlayerId(player_id int) (string, error) {
   rows, err := m.db.Query("SELECT * FROM GetRoleByPlayerId(@player_id)", sql.Named("player_id", player_id))
   if err != nil {
      fmt.Println(err)
      return "", err
   }
   defer rows.Close()

   ...
```

A variável `rows` é um objeto do tipo `Rows` que contém os resultados da query e a
variável `err` é um objeto do tipo `error` que contém o erro, caso exista.
Defer é utilizado para garantir que a função `rows.Close()` é chamada no final da função.

```go
   var role_id int
   var role_name string

   if rows.Next() {
      err := rows.Scan(&role_id, &role_name)
      if err != nil {
         return "", err
      }
   } else {
      return "", fmt.Errorf("player with id %s not found", player_id)     ■ fmt.Errorf format %s has arg player_id of wrong type int
   }

   return role_name, nil
}
```

Neste caso, a função `rows.Next()` é utilizada para verificar se existem resultados e
a função `rows.Scan()` é utilizada para obter os resultados.
