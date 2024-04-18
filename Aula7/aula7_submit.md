# BD: Guião 7


## ​7.2 
 
### *a)*

```
O cenário apresentado encontra-se na primeira forma normal, já que não é encontrado nenhum tuplo de dados na base de dados, sendo todos os atríbutos atómicos. 
Não se pode dizer o mesmo da segunda forma normal pois encontramos não-chave que não dependem completamente da/das chaves primárias. Neste caso para um atríbuto não-chave depender completamente completamente das suas chaves primárias tem de depender dos atríbutos 'Titulo_Livro' e 'Nome_Autor', algo que não acontece com a dependência " 'Nome_Autor' -> 'Afiliacao_Autor' " que só precisa de um deles, ou seja não está na formal normal 2.
Para além disso, a base de dados também não está na terceira forma normal, já que apresenta atríbutos não-chave transitivamente dependentes, algo que podemos ver na dependência " 'Editor' -> 'Endereco_Editor' ". 
```

### *b)* 

```
Para a Segunda Forma Normal
Livro = {<u>Titulo_Livro</u>, <u>Nome_Autor</u>, Tipo_Livro, Preco, NoPagina, Editor, Endereco_Editor, Ano_Publicacao} 
Autor = {<u>Nome_Autor</u>, Afiliacao_Autor}

Para a Terceira Forma Normal
Livro = {<u>Titulo_livro</u>, <u>Nome_Autor</u>, Editor, Tipo_Livro, NoPaginas, Ano_Publicacao}
Autor = {<u>Nome_Autor</u>, Afiliacao_Autor}
Editor = {<u>Editor</u>, Endereco_Editor}
PrecoLivro = {<u>Tipo_Livro</u>, <u>NoPagina</u>, Preco}
```




## ​7.3
 
### *a)*

```
A chave de R vai ser o subconjunto de atríbutos {A, B}. 
De todas as chaves candidatas esta é a escolhida pois com A e B conseguimos chegar a qualquer um dos outros atríbutos da relação, de acordo com as dependências apresentadas no enunciado. 
```


### *b)* 

```
R1 = {A, B, C}
R2 = {A, D, E, I, J}
R3 = {B, F, G, H}
```


### *c)* 

```
R1 = {<u>A</u>, <u>B</u>, C}
R2 = {<u>A</u>, D, E}
R3 = {<u>D</u>, I, J}
R4 = {<u>B</u>, F}
R5 = {<u>F</u>, G, H}
```


## ​7.4
 
### *a)*

```
... Write here your answer ...
```


### *b)* 

```
... Write here your answer ...
```


### *c)* 

```
... Write here your answer ...
```



## ​7.5
 
### *a)*

```
... Write here your answer ...
```

### *b)* 

```
... Write here your answer ...
```


### *c)* 

```
... Write here your answer ...
```

### *d)* 

```
... Write here your answer ...
```
