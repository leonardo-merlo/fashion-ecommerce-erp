-- Migration 031: insumos de cor fixa usados nas fichas técnicas das bolsas
--
-- Versão de demonstração: a marca e as fichas são fictícias. As receitas
-- (bill_of_materials) ficam em supabase/seed.sql, porque dependem dos produtos
-- de exemplo, que só existem depois do seed.
--
-- Cortes com o mesmo nome são o mesmo insumo entre bolsas ("Frente" da lona
-- serve a Aurora e a Brisa) — o que muda é a cor, declarada na variante. Por
-- isso os insumos de corte não entram aqui: cada um existe por cor.
--
-- Todos entram como 'bruta': o ateliê não controla o rolo de lona/couro a
-- montante, então um corte em falta aparece como item a repor, não como item a
-- produzir a partir de outro insumo.

-- ─── Aplicações (cor fixa) ───────────────────────────────────────────────────
INSERT INTO public.raw_materials (name, type, category, type_specific, color, unit, stock_quantity, minimum_stock) VALUES
  ('Aurora A', 'bruta', 'Aplicações', 'Aurora A', NULL, 'unidade', 0, 0),
  ('Aurora B', 'bruta', 'Aplicações', 'Aurora B', NULL, 'unidade', 0, 0),
  ('Brisa A',  'bruta', 'Aplicações', 'Brisa A',  NULL, 'unidade', 0, 0);

-- ─── Metais ──────────────────────────────────────────────────────────────────
INSERT INTO public.raw_materials (name, type, category, type_specific, color, unit, stock_quantity, minimum_stock) VALUES
  ('Rebite',          'bruta', 'Metais', 'Rebite',          NULL, 'unidade', 0, 0),
  ('Argola G',        'bruta', 'Metais', 'Argola G',        NULL, 'unidade', 0, 0),
  ('Mosquetão G',     'bruta', 'Metais', 'Mosquetão G',     NULL, 'unidade', 0, 0),
  ('Cursor diamante', 'bruta', 'Metais', 'Cursor diamante', NULL, 'unidade', 0, 0),
  ('Ímã',             'bruta', 'Metais', 'Ímã',             NULL, 'unidade', 0, 0);

-- ─── Aviamentos ──────────────────────────────────────────────────────────────
INSERT INTO public.raw_materials (name, type, category, type_specific, color, unit, stock_quantity, minimum_stock) VALUES
  ('Fecho metro 30 cm',      'bruta', 'Aviamentos', 'Fecho metro 30 cm',      NULL, 'unidade', 0, 0),
  ('Fecho padrão 18 cm',     'bruta', 'Aviamentos', 'Fecho padrão 18 cm',     NULL, 'unidade', 0, 0),
  ('Viés 1 metro',           'bruta', 'Aviamentos', 'Viés 1 metro',           NULL, 'unidade', 0, 0),
  ('Viés 2,5 cm',            'bruta', 'Aviamentos', 'Viés 2,5 cm',            NULL, 'metro',   0, 0),
  ('Etiqueta bordada',       'bruta', 'Aviamentos', 'Etiqueta bordada',       NULL, 'unidade', 0, 0),
  ('Etiqueta de composição', 'bruta', 'Aviamentos', 'Etiqueta de composição', NULL, 'unidade', 0, 0);
