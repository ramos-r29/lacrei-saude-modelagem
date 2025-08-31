
# 📘 Dicionário de Dados — Proposta 1

Este dicionário detalha os campos, tipos e restrições da estrutura de banco de dados **proposta_1**.

---

## **Tabela:** `operadora`
| Campo         | Tipo       | Nulo | PK | FK | Descrição |
|--------------|-----------|------|----|----|-----------|
| operadora_id | SERIAL    | Não  | ✅  |    | Identificador único da operadora |
| nome         | VARCHAR(200) | Não |    |    | Nome da operadora |
| cnpj         | VARCHAR(20)  | Não |    |    | CNPJ único da operadora |
| contato      | JSONB     | Sim  |    |    | Dados de contato em formato JSON |
| criada_em    | TIMESTAMP WITH TIME ZONE | Não |    |    | Data/hora de criação |

---

## **Tabela:** `plano`
| Campo         | Tipo                | Nulo | PK | FK | Descrição |
|--------------|--------------------|------|----|----|-----------|
| plano_id     | SERIAL             | Não  | ✅  |    | Identificador único do plano |
| operadora_id | INTEGER           | Não  |    | ✅  | FK para `operadora.operadora_id` |
| codigo_plano | VARCHAR(50)      | Não  |    |    | Código único do plano dentro da operadora |
| nome         | VARCHAR(200)    | Não  |    |    | Nome do plano |
| tipo_plano   | ENUM(proposta_1.plano_tipo_enum) | Não | | | Tipo do plano |
| ativo        | BOOLEAN         | Não  |    |    | Indica se o plano está ativo |
| criado_em    | TIMESTAMP WITH TIME ZONE | Não | | | Data/hora de criação |

---

## **Tabela:** `profissional`
| Campo                    | Tipo         | Nulo | PK | FK | Descrição |
|-------------------------|-------------|------|----|----|-----------|
| profissional_id         | UUID       | Não  | ✅  |    | Identificador único |
| nome                    | VARCHAR(200) | Não |    |    | Nome completo |
| registro_profissional   | VARCHAR(50) | Não |    |    | Número do registro |
| uf_registro_profissional | CHAR(2) | Não |    |    | UF do registro |
| email                  | VARCHAR(200) | Sim |    |    | E-mail |
| telefone               | VARCHAR(30) | Sim |    |    | Telefone |
| situacao               | ENUM(proposta_1.profissional_situacao_enum) | Não | | | Situação |
| criado_em              | TIMESTAMP WITH TIME ZONE | Não | | | Data/hora de criação |

---

## **Tabela:** `profissional_aceita_plano`
| Campo           | Tipo       | Nulo | PK | FK | Descrição |
|----------------|-----------|------|----|----|-----------|
| profissional_id| UUID      | Não  | ✅  | ✅  | FK para `profissional.profissional_id` |
| plano_id       | INTEGER   | Não  | ✅  | ✅  | FK para `plano.plano_id` |
| numero_carteira| VARCHAR(100) | Sim | | | Número da carteira |
| data_inicio    | DATE     | Não  | | | Data início |
| data_fim       | DATE     | Sim  | | | Data fim |
| coparticipacao | NUMERIC(7,2) | Sim | | | Valor da coparticipação |
| observacoes    | TEXT | Sim | | | Observações |
| criado_em      | TIMESTAMP WITH TIME ZONE | Não | | | Data/hora de criação |

---

## **Tabela:** `consentimento`
| Campo            | Tipo       | Nulo | PK | FK | Descrição |
|-----------------|-----------|------|----|----|-----------|
| consentimento_id| SERIAL   | Não  | ✅  |    | ID do consentimento |
| profissional_id | UUID    | Não  |    | ✅  | FK para `profissional.profissional_id` |
| tipo            | VARCHAR(100) | Não | | | Tipo de consentimento |
| aceito          | BOOLEAN | Não | | | Indica se o consentimento foi aceito |
| data_hora       | TIMESTAMP WITH TIME ZONE | Não | | | Data/hora do consentimento |
| versao_politica | VARCHAR(50) | Sim | | | Versão da política |

---

## Exemplo de dado tipo json que pode ser gravado na tabela `operadora` :

```json
{
    "telefone": {
        "comercial": "+55 (11) 3333-4444",
        "suporte": "+55 (11) 98888-7777"
    },
    "email": {
        "geral": "contato@unimednacional.com.br",
        "suporte": "suporte@unimednacional.com.br"
    },
    "site": "https://www.unimednacional.com.br",
    "endereco": {
        "logradouro": "Av. Paulista",
        "numero": "1234",
        "bairro": "Bela Vista",
        "cidade": "São Paulo",
        "uf": "SP",
        "cep": "01310-100"
    }
}
```

