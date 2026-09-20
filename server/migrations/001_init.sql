CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  handle TEXT NOT NULL,
  status TEXT NOT NULL,
  color TEXT NOT NULL,
  mood_name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  reactions JSONB NOT NULL DEFAULT '{"fire":0,"laugh":0,"thumbs_down":0}'
);

CREATE TABLE IF NOT EXISTS note_reactions (
  note_id UUID NOT NULL REFERENCES notes(id) ON DELETE CASCADE,
  user_key TEXT NOT NULL,
  reaction TEXT NOT NULL,
  -- one reaction per user PER NOTE; keying on user_key alone let a new
  -- reaction move the user's existing reaction to a different note
  PRIMARY KEY (note_id, user_key)
);

CREATE INDEX IF NOT EXISTS idx_notes_created_at ON notes (created_at DESC);