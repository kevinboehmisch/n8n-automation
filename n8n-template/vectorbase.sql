-- 1) Alte Objekte entfernen
DROP FUNCTION IF EXISTS match_documents(vector, int, jsonb);
DROP TABLE    IF EXISTS documents;

-- 2) pgvector-Extension (falls nicht bereits aktiv)
CREATE EXTENSION IF NOT EXISTS vector;

-- 3) Neue Tabelle mit 1024-dimensionalem Embedding
CREATE TABLE documents (
  id        bigserial PRIMARY KEY,
  content   text,
  metadata  jsonb,
  embedding vector(1024)
);

-- 4) IVFFlat-Index für schnelle Ähnlichkeitssuche
CREATE INDEX ON documents
USING ivfflat (embedding vector_l2_ops)
WITH (lists = 100);

-- 5) Funktion für 1024-dim-Vektoren anlegen
CREATE OR REPLACE FUNCTION match_documents (
  query_embedding vector(1024),
  match_count    int      DEFAULT NULL,
  filter         jsonb    DEFAULT '{}'
) RETURNS TABLE (
  id         bigint,
  content    text,
  metadata   jsonb,
  similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT
      docs.id        AS id,
      docs.content   AS content,
      docs.metadata  AS metadata,
      1 - (docs.embedding <=> query_embedding) AS similarity
    FROM documents AS docs
    WHERE docs.metadata @> filter
    ORDER BY docs.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

-- Tabelle mit fertigen Ergebnissen hinzufügen
-- erst die Extension für gen_random_uuid(), falls noch nicht installiert
create extension if not exists "pgcrypto";

-- dann die Tabelle anlegen
create table public.quellen (
  id              uuid                     primary key default gen_random_uuid(),
  frage           text                     not null,
  thema           text                     not null,
  url             text                     not null,
  zusammenfassung text,       -- <— Komma hier!
  analysen         text,       -- jetzt klappt die nächste Zeile
  ranking         text,
  "begründung"    text,       -- Umlaut-Spalte in Anführungszeichen
  created_at      timestamp with time zone default now()
);

