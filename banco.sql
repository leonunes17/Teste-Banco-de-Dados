-- criando a tabela demonstrações contábeis
create table demonstracoes_contabeis (
	id serial primary key,
    data_ref date,
    reg_ans int not null,
    cd_conta_contabil varchar(30),
    descricao varchar(250),
    vl_saldo_inicial numeric,
    vl_saldo_final numeric
);

-- criando a tabela auxiliar para transformação dos dados de valores de saldo iniciais e finais 
create table auxiliar (
	data_ref date,
    reg_ans int not null,
    cd_conta_contabil varchar(30),
    descricao varchar(250),
    vl_saldo_inicial varchar(30),
    vl_saldo_final varchar(30)
);

-- criando a tabela de relatórios cadop
create table relatorio_cadop (
	registro_ans int primary key,
    cnpj varchar(15),
    razao_social varchar(300),
    nome_fantasia varchar(200),
    modalidade varchar(50),
    logradouro varchar(200),
    numero varchar(50),
    complemento varchar(200),
    bairro varchar(100),
    cidade varchar(50),
    uf varchar(5),
    cep varchar(10),
    ddd varchar(5),
    telefone varchar(50),
    fax varchar(15),
    endereco_eletronico varchar(100),
    representante varchar(180),
    cargo_representante varchar(100),
    regiao_de_comercializacao varchar(5),
    data_registro_ans date
);


-- importando os dados do arquivo csv de relatórios para a tabela 'relatorio_cadop' com encoding UTF-8
COPY relatorio_cadop FROM 'C:\Relatorio_cadop.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

-- importando os dados de demonstrações contabeis de todos os trimestres para a tabela auxiliar
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\1T2022.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\1T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\4T2022.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\2T2022.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\2T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\3T2022.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\3T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

-- transformando os dados das varíaveis de saldo inicial e final 
update auxiliar set vl_saldo_inicial = replace(vl_saldo_inicial, ',', '.');
update auxiliar set vl_saldo_final = replace(vl_saldo_final, ',', '.');

-- inserindo os dados da tabela auxiliar na tabela de demonstracoes_contabeis e utilizando o 'cast' para mudar o tipo dos dados de saldo para numérico
insert into demonstracoes_contabeis (data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) 
select data_ref, reg_ans, cd_conta_contabil, descricao, cast(vl_saldo_inicial as numeric), cast(vl_saldo_final as numeric) 
from auxiliar;

-- adicionando nova coluna para as despesas na tabela 
alter table demonstracoes_contabeis
add column despesas numeric;

-- atribuindo na coluna o valor das despesas
update demonstracoes_contabeis
set despesas = vl_saldo_final - vl_saldo_inicial;

-- 10 operadoras com maiores despesas em "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre.
select rc.razao_social, sum(dc.despesas)
from relatorio_cadop as rc
inner join demonstracoes_contabeis as dc on rc.registro_ans = dc.reg_ans
where dc.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
and dc.data_ref between '2023-04-01' and '2023-07-01'
group by rc.razao_social
order by sum(dc.despesas) desc
limit 10;

-- 10 operadoras com maiores despesas nessa categoria no último ano 
select rc.razao_social, sum(dc.despesas)
from relatorio_cadop as rc
inner join demonstracoes_contabeis as dc on rc.registro_ans = dc.reg_ans
where dc.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
and dc.data_ref between '2023-01-01' and '2023-07-01'
group by rc.razao_social
order by sum(dc.despesas) desc
limit 10;
