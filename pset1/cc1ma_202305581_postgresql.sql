--deleta possiveis bancos de dados com o mesmo nome do banco a ser criado.
--esse comando só existe aqui pois não tenho como garantir que não há nenhum outro banco de dados com o mesmo nome na máquina do professor.
--na vida real, esses comandos drop só devem ser executados uma vez, caso contrário o banco seria excluido novamente.
DROP DATABASE IF EXISTS uvv;

--deleta possiveis usuarios com o mesmo nome do usuario a ser criado. assim como o comando acima, é importante para prevenir erros.
DROP USER IF EXISTS joaodaher;

--cria um novo superusuario capaz de criar o nosso banco de dados
CREATE USER joaodaher WITH
CREATEDB 
CREATEROLE 
SUPERUSER
ENCRYPTED
PASSWORD 'senha'
;

--se conecta ao banco de dados administrativo postgres como o usuário que acabou de ser criado
\c 'dbname=postgres user=joaodaher password=senha';

--cria um novo banco de dados chamado uvv, com as caracteristicas abaixo
CREATE DATABASE uvv WITH
OWNER joaodaher
TEMPLATE template0
ENCODING UTF8
LC_COLLATE 'pt_BR.UTF-8'
LC_CTYPE 'pt_BR.UTF-8'
ALLOW_CONNECTIONS TRUE;

--comentario do banco de dados uvv
COMMENT ON DATABASE uvv IS 'dados relacionados a uvv';

--conecta ao banco de dados que acabou de ser criado
\c 'dbname=uvv user=joaodaher password=senha';

--cria o esquema lojas
CREATE SCHEMA lojas;

--define o esquema lojas como padrão do usuário joaodaher
ALTER USER joaodaher
SET SEARCH_PATH TO lojas, "$user", public;

--permite que o usuario joaodaher altere o esquema lojas
GRANT USAGE, CREATE ON SCHEMA lojas TO joaodaher;

--cria a tabela produtos, suas colunas e a primary key
CREATE TABLE lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(512) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT pk_produtos PRIMARY KEY (produto_id),                
                CONSTRAINT check_preco_positivo CHECK (preco_unitario >=0)
);

--comentarios da tabela produtos e suas colunas
COMMENT ON TABLE lojas.produtos IS 'dados dos produtos';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'identifica cada produto de maneira unica';
COMMENT ON COLUMN lojas.produtos.nome IS 'nome do produto';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'preco de uma unidade do produto';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'detalhes do produto';
COMMENT ON COLUMN lojas.produtos.imagem IS 'imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'tipo de dado da imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'caminho para o arquivo da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'charset dos metadados da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'data da ultima atualização da imagem';

--cria a tabela lojas, suas colunas e a primary key
CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT pk_lojas PRIMARY KEY (loja_id),                
                CONSTRAINT check_preenchimento_endereco CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL)
);

--comentarios da tabela lojas e suas colunas
COMMENT ON TABLE lojas.lojas IS 'armazena dados das lojas';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'identifica cada loja de maneira unica';
COMMENT ON COLUMN lojas.lojas.nome IS 'nome da loja';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'site da loja';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'endereco da loja';
COMMENT ON COLUMN lojas.lojas.latitude IS 'latitude da loja';
COMMENT ON COLUMN lojas.lojas.longitude IS 'longitude da loja';
COMMENT ON COLUMN lojas.lojas.logo IS 'imagem da logomarca da loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'indica qual o tipo de dado da logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'indica o caminho para o arquivo da logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'charset dos metadados da logo';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'data de ultima atualizacao da logo';

--cria a tabela estoques, suas colunas e a primary key
CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoques PRIMARY KEY (estoque_id),
                CONSTRAINT check_quantidade_nao_negativa CHECK (quantidade >= 0)
);

--comentarios da tabela estoques e suas colunas
COMMENT ON TABLE lojas.estoques IS 'dados dos estoques';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'identifica cada estoque de maneira unica';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'loja em que esta o estoque';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'produto armazenado no estoque';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'quantidade do produto armazenado';

--cria a tabela clientes, suas colunas e a primary key
CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT pk_clientes PRIMARY KEY (cliente_id),
                CONSTRAINT check_email_valido CHECK (strpos(email, '@') > 0)
);

--comentarios da tabela clientes e suas colunas
COMMENT ON TABLE lojas.clientes IS 'armazena dados dos clientes';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'identifica cada cliente de maneira unica';
COMMENT ON COLUMN lojas.clientes.email IS 'email do cliente';
COMMENT ON COLUMN lojas.clientes.nome IS 'nome do cliente';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'primeiro telefone do cliente';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'segundo telefone do cliente se houver';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'terceiro telefone do cliente se houver';

--cria a tabela envios, suas colunas e a primary key
CREATE TABLE lojas.envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT pk_envios PRIMARY KEY (envio_id),
                CONSTRAINT check_status_valido CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'))
);

--comentarios da tabela envios e suas colunas
COMMENT ON TABLE lojas.envios IS 'dados dos envios';
COMMENT ON COLUMN lojas.envios.envio_id IS 'identifica cada envio de maneira unica';
COMMENT ON COLUMN lojas.envios.loja_id IS 'loja para onde sera o envio';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'cliente que fez o pedido';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'endereco do cliente';
COMMENT ON COLUMN lojas.envios.status IS 'status do envio';

--cria a tabela pedidos, suas colunas e a primary key
CREATE TABLE lojas.pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id),
                CONSTRAINT check_status_pedido_valido CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'))
);

--comentarios da tabela pedidos e suas colunas
COMMENT ON TABLE lojas.pedidos IS 'armazena dados dos pedidos';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'identifica cada pedido de maneira unica';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'data e hora exatas do pedido';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'id do cliente que fez o pedido';
COMMENT ON COLUMN lojas.pedidos.status IS 'status do pedido';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'loja em que foi feito o pedido';

--cria a tabela pedidos_itens, suas colunas e a primary key
CREATE TABLE lojas.pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);

--comentarios da tabela pedidos_itens e suas colunas
COMMENT ON TABLE lojas.pedidos_itens IS 'dados dos itens que estao em um pedido';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'id do pedido de origem';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'id dos produtos que vao no pedido';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'numero que identifica a serie do produto';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'preco do produto';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'quantidade de itens do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'envio que sera feito a partir do pedido';

--cria a foreign key entre as tabelas produtos e estoques
ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--cria a foreign key entre as tabelas produtos e pedidos_itens
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--cria a foreign key entre as tabelas lojas e envios
ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--cria a foreign key entre as tabelas lojas e estoques
ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--cria a foreign key entre as tabelas lojas e pedidos
ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--cria a foreign key entre as tabelas clientes e pedidos
ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--cria a foreign key entre as tabelas clientes e envios
ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--cria a foreign key entre as tabelas envios e pedidos_itens
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--cria a foreign key entre as tabelas pedidos e pedidos_itens
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
