CREATE SCHEMA IF NOT EXISTS proposta_2;


CREATE TABLE proposta_2.tipo_plano (
    tipo_plano_id SERIAL PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(200) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);


CREATE TABLE proposta_2.operadora (
    operadora_id SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cnpj VARCHAR(20) NOT NULL UNIQUE,
    contato JSONB,
    criada_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE TABLE proposta_2.plano (
    plano_id SERIAL PRIMARY KEY,
    operadora_id INTEGER NOT NULL REFERENCES proposta_2.operadora(operadora_id) ON DELETE RESTRICT,
    codigo_plano VARCHAR(50) NOT NULL,
    nome VARCHAR(200) NOT NULL,
    tipo_plano_id INTEGER REFERENCES proposta_2.tipo_plano(tipo_plano_id),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT uq_plano_operadora_codigo UNIQUE (operadora_id, codigo_plano)
);

CREATE TABLE proposta_2.profissional (
    profissional_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(200) NOT NULL,
    registro_profissional VARCHAR(50) NOT NULL,
    uf_registro_profissional char(2) NOT NULL ,
    email VARCHAR(200),
    telefone VARCHAR(30),
    situacao VARCHAR(50) NOT NULL DEFAULT 'ativo',
    planos_aceitos JSONB NOT NULL DEFAULT '[]'::jsonb,
    criado_em TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now() ,
    CONSTRAINT uq_registro_profissional UNIQUE (registro_profissional, uf_registro_profissional)
);

CREATE TABLE proposta_2.consentimento (
    consentimento_id SERIAL PRIMARY KEY,
    profissional_id UUID NOT NULL REFERENCES proposta_2.profissional(profissional_id) ON DELETE CASCADE,
    tipo VARCHAR(100) NOT NULL,
    aceito BOOLEAN NOT NULL,
    data_hora TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    versao_politica VARCHAR(50)
);

-- Índices
CREATE INDEX idx_plano_operadora_p2 ON proposta_2.plano USING btree(operadora_id);
CREATE INDEX idx_profissional_situacao_p2 ON proposta_2.profissional USING btree(situacao);

-- Índices específicos para jsonb: GIN index para consultas por conteúdo
CREATE INDEX idx_profissional_planos_aceitos_gin ON proposta_2.profissional USING GIN (planos_aceitos jsonb_path_ops);
-- Consultar por plano_id dentro do json:
CREATE INDEX idx_profissional_planos_aceitos_planoid ON proposta_2.profissional USING GIN (planos_aceitos);


-- Trigger que valida formato esperado em planos_aceitos (checa chaves mínimas em cada objeto)
CREATE OR REPLACE FUNCTION proposta_2.fn_validar_planos_aceitos() RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_item jsonb;
BEGIN
    IF NEW.planos_aceitos IS NULL THEN
        NEW.planos_aceitos := '[]'::jsonb;
    END IF;

    FOR v_item IN SELECT * FROM jsonb_array_elements(NEW.planos_aceitos) LOOP
        IF NOT (v_item ? 'plano_id') THEN
            RAISE EXCEPTION 'cada item em planos_aceitos deve conter "plano_id"';
        END IF;
    END LOOP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validar_planos_aceitos
    BEFORE INSERT OR UPDATE ON proposta_2.profissional
    FOR EACH ROW EXECUTE FUNCTION proposta_2.fn_validar_planos_aceitos();