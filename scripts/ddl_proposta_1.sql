CREATE SCHEMA IF NOT EXISTS proposta_1;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'plano_tipo_enum') THEN
        CREATE TYPE proposta_1.plano_tipo_enum AS ENUM ('individual','coletivo_por_adesao','coletivo_empresarial');
    END IF;
END$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'profissional_situacao_enum') THEN
        CREATE TYPE proposta_1.profissional_situacao_enum AS ENUM ('ativo','inativo','suspenso');
    END IF;
END$$;


CREATE TABLE proposta_1.operadora (
    operadora_id SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cnpj VARCHAR(20) NOT NULL UNIQUE,
    contato JSONB,
    criada_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE TABLE proposta_1.plano (
    plano_id SERIAL PRIMARY KEY,
    operadora_id INTEGER NOT NULL REFERENCES proposta_1.operadora(operadora_id) ON DELETE RESTRICT,
    codigo_plano VARCHAR(50) NOT NULL,
    nome VARCHAR(200) NOT NULL,
    tipo_plano proposta_1.plano_tipo_enum NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT uq_plano_operadora_codigo UNIQUE (operadora_id, codigo_plano)
);

CREATE TABLE proposta_1.profissional (
    profissional_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(200) NOT NULL,
    registro_profissional VARCHAR(50) NOT NULL,
    uf_registro_profissional char(2) NOT NULL,
    email VARCHAR(200),
    telefone VARCHAR(30),
    situacao proposta_1.profissional_situacao_enum NOT NULL DEFAULT 'ativo',
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    CONSTRAINT uq_registro_profissional UNIQUE (registro_profissional, uf_registro_profissional)
);

CREATE TABLE proposta_1.profissional_aceita_plano (
    profissional_id UUID NOT NULL REFERENCES proposta_1.profissional(profissional_id) ON DELETE CASCADE,
    plano_id INTEGER NOT NULL REFERENCES proposta_1.plano(plano_id) ON DELETE RESTRICT,
    numero_carteira VARCHAR(100),
    data_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fim DATE,
    coparticipacao NUMERIC(7,2),
    observacoes TEXT,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    PRIMARY KEY (profissional_id, plano_id)
);

CREATE TABLE proposta_1.consentimento (
    consentimento_id SERIAL PRIMARY KEY,
    profissional_id UUID NOT NULL REFERENCES proposta_1.profissional(profissional_id) ON DELETE CASCADE,
    tipo VARCHAR(100) NOT NULL,
    aceito BOOLEAN NOT NULL,
    data_hora TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    versao_politica VARCHAR(50)
);


CREATE INDEX idx_plano_operadora ON proposta_1.plano USING BTREE(operadora_id);
CREATE INDEX idx_profissional_situacao ON proposta_1.profissional USING BTREE(situacao);
CREATE INDEX idx_prof_aceita_plano_profissional ON proposta_1.profissional_aceita_plano USING BTREE(profissional_id);
CREATE INDEX idx_prof_aceita_plano_plano ON proposta_1.profissional_aceita_plano USING BTREE(plano_id);
