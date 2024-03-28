# Processo Importação e Análise de Dados Contábeis

Este conjunto de instruções SQL tem como objetivo realizar o processamento de dados contábeis e análise de despesas em operadoras de saúde. A seguir está uma explicação detalhada de cada parte do código:

## Criação das Tabelas

- `demonstracoes_contabeis`: Esta tabela é criada para armazenar demonstrações contábeis, como data de referência, registro ANS, código da conta contábil, descrição e valores de saldo inicial e final.

- `auxiliar`: Esta tabela serve como uma tabela auxiliar para transformação dos dados de valores de saldo iniciais e finais.

- `relatorio_cadop`: Esta tabela é criada para armazenar relatórios de operadoras, contendo informações como registro ANS, CNPJ, razão social, modalidade, endereço, etc.

## Importação de Dados

- Os dados do arquivo CSV `Relatorio_cadop.csv` são importados para a tabela `relatorio_cadop`.

- Os dados de demonstrações contábeis de todos os trimestres são importados para a tabela `auxiliar` a partir dos arquivos CSV correspondentes.

## Transformação de Dados

- Os dados das variáveis de saldo inicial e final na tabela `auxiliar` são transformados, substituindo vírgulas por pontos para garantir que possam ser convertidos para o tipo numérico.

## Inserção de Dados

- Os dados da tabela `auxiliar` são inseridos na tabela `demonstracoes_contabeis`, convertendo os valores de saldo para o tipo numérico.

## Análise de Despesas

- Uma nova coluna chamada `despesas` é adicionada à tabela `demonstracoes_contabeis` para armazenar a diferença entre os valores de saldo final e inicial.

- As despesas das operadoras são calculadas e analisadas em duas consultas SQL:

    - As 10 operadoras com maiores despesas em "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre.
    

    - As 10 operadoras com maiores despesas nessa categoria no último ano.

Este readme fornece uma visão geral do processo de processamento de dados contábeis e análise realizado pelo código fornecido. Certifique-se de ajustar os caminhos dos arquivos CSV e adaptar as consultas SQL conforme necessário para o seu ambiente específico.
