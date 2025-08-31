
# 📘 Dicionário de Dados — Proposta 2

Este dicionário detalha os campos, tipos e restrições da estrutura de banco de dados **proposta_2**.

---

## **Tabela:** `tipo_plano`
| Campo         | Tipo       | Nulo | PK | FK | Descrição |
|--------------|-----------|------|----|----|-----------|
| tipo_plano_id | SERIAL  | Não  | ✅  |    | Identificador do tipo |
| codigo       | VARCHAR(50) | Não | | | Código único |
| descricao    | VARCHAR(200) | Não | | | Descrição do tipo |
| ativo        | BOOLEAN | Não | | | Ativo/inativo |

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
| plano_id     | SERIAL             | Não  | ✅  |    | ID do plano |
| operadora_id | INTEGER           | Não  |    | ✅  | FK para `operadora.operadora_id` |
| codigo_plano | VARCHAR(50)      | Não  |    |    | Código único |
| nome         | VARCHAR(200)    | Não  |    |    | Nome do plano |
| tipo_plano_id | INTEGER | Sim | | ✅ | FK para `tipo_plano.tipo_plano_id` |
| ativo        | BOOLEAN         | Não  |    |    | Indica se o plano está ativo |
| criado_em    | TIMESTAMP WITH TIME ZONE | Não | | | Data/hora de criação |

---

## **Tabela:** `profissional`
| Campo                    | Tipo       | Nulo | PK | FK | Descrição |
|------------------------|-----------|------|----|----|-----------|
| profissional_id       | UUID | Não | ✅ | | Identificador |
| nome                  | VARCHAR(200) | Não | | | Nome |
| registro_profissional | VARCHAR(50) | Não | | | Registro |
| uf_registro_profissional | CHAR(2) | Não | | | UF |
| email                 | VARCHAR(200) | Sim | | | Email |
| telefone              | VARCHAR(30) | Sim | | | Telefone |
| situacao              | VARCHAR(50) | Não | | | Situação |
| planos_aceitos        | JSONB | Não | | | Lista de planos aceitos |
| criado_em             | TIMESTAMP WITH TIME ZONE | Não | | | Data criação |

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
## Exemplo de dado tipo json que pode ser gravado na tabela `profissional`:

```json
{
  "plano_id": 123,
  "operadora_id": 45,
  "numero_carteira": "ABC123",
  "data_inicio": "2024-01-01",
  "data_fim": null,
  "coparticipacao": 10.50,
  "dados_especificos": { "plano_Regional": true, "observacao": "Atende apenas 3 especialidades" }
}
```
