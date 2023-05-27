# Descrição dos arquivos nessa pasta

Aqui encontram-se todos os arquivos a serem entregados. Todos os arquivos têm o mesmo nome, porém são tipos de arquivo diferentes, e, por isso, contam com extensões diferentes. Devido a esse fator, irei listar diferenciando-os apenas pela extensão, para não causar confusão. Abaixo temos a listagem deles com uma breve descrição.

---

* *.architect*: esse arquivo contém o projeto recriado do banco de dados proposto. Como podemos perceber, é uma extensão de arquivo diferente do usual, e portanto necessita de um programa específico para ser aberto. Nesse caso, recomenda-se o uso do SQL Power Architect, um software de código aberto para projetos de bancos de dados.

Abaixo, temos a foto que serviu como referência para a reprodução do projeto (arquivo *lojas-uvv.png* que também consta nessa pasta:

![referencia_bd](jpdaher/uvv_bd1_cc1ma/pset1/lojas-uvv.png)

* *.pdf*: é um PDF que contém uma foto do projeto recriado no SQL Power Architect (o arquivo *.architect*)

* *.sql*: um script em linguagem SQL (com alguns comandos na linguagem administrativa do postgres) que implementa o projeto que consta no arquivo *.architect*. Esse script deve ser executado em um aplicativo cliente específico, o *psql*, por meio de um superusuário. Caso você execute o script sem se conectar como um superusuário, alguns comandos falharão. Consulte a documentação do *PostgreSQL* clicando [aqui](https://www.postgresql.org/docs/15/index.html) e confira a seção sobre o *psql* clicando [aqui](https://www.postgresql.org/docs/current/app-psql.html).
