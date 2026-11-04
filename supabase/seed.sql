-- Seed de demonstração: Ateliê Exemplo (marca fictícia).
--
-- Roda depois de todas as migrations. Monta uma loja que dá para percorrer de
-- ponta a ponta: vitrine com todas as categorias, duas bolsas com ficha técnica
-- completa, cortes em estoque por cor e uma falta proposital para mostrar o
-- bloqueio da ordem de produção.
--
-- UUIDs seguem o padrão '00000000-0000-0000-0000-{n com 12 dígitos}'.
-- Os NCM são ilustrativos: classificação fiscal real é decisão do contador.

-- ─── Loja ────────────────────────────────────────────────────────────────────
UPDATE public.store_settings SET
  store_name            = 'Ateliê Exemplo',
  contact_email         = 'contato@atelieexemplo.com.br',
  contact_phone         = '11999999999',
  cnpj                  = '11222333000181',
  legal_name            = 'ATELIE EXEMPLO LTDA',
  state_registration    = 'ISENTO',
  cnae                  = '1412601',
  tax_regime            = 1,
  fiscal_street         = 'Rua Exemplo',
  fiscal_number         = '100',
  fiscal_district       = 'Centro',
  fiscal_city           = 'Belo Horizonte',
  fiscal_state          = 'MG',
  fiscal_zip            = '30130000',
  origin_same_as_fiscal = true,
  free_shipping_threshold = 400;

-- ─── Produtos ────────────────────────────────────────────────────────────────
INSERT INTO public.products
  (id, name, slug, description, category, subcategory, base_price, wholesale_price,
   is_active, is_featured, is_kids, images, weight_grams, length_cm, width_cm, height_cm,
   measurements, ncm, created_at)
VALUES
('00000000-0000-0000-0000-000000000101', 'Bolsa Aurora', 'bolsa-aurora',
 'Tote em lona com bordado colorido na frente, forro de algodão cru e boca de couro. Cabe o dia inteiro.',
 'bolsas', NULL, 489, 293, true, true, false,
 ARRAY['/images/products/bolsa-aurora.jpg'], 450, 36, 12, 30, NULL, '42022220', now() - interval '12 days'),

('00000000-0000-0000-0000-000000000102', 'Bolsa Brisa', 'bolsa-brisa',
 'Tiracolo em lona com alça de couro e bordado floral. Compacta, com bolso interno e fecho de ímã.',
 'bolsas', NULL, 429, 257, true, true, false,
 ARRAY['/images/products/bolsa-brisa.jpg'], 380, 26, 8, 20, NULL, '42022220', now() - interval '20 days'),

('00000000-0000-0000-0000-000000000103', 'Bolsa Girassol', 'bolsa-girassol',
 'Bolsa de ombro em lona clara com alças trançadas. Leve para o dia a dia.',
 'bolsas', NULL, 389, 233, true, false, false,
 ARRAY['/images/products/bolsa-girassol.jpg'], 360, 32, 10, 26, NULL, '42022220', now() - interval '30 days'),

('00000000-0000-0000-0000-000000000201', 'Vestido Linho', 'vestido-linho',
 'Vestido midi em linho lavado, caimento solto e mangas bufantes.',
 'roupas', 'vestidos', 559, 335, true, true, false,
 ARRAY['/images/products/vestido-linho.jpg'], 320, 35, 5, 30,
 '{"P":"Busto 88cm · Comprimento 112cm","M":"Busto 94cm · Comprimento 114cm","G":"Busto 100cm · Comprimento 116cm"}'::jsonb,
 '62044400', now() - interval '8 days'),

('00000000-0000-0000-0000-000000000202', 'Vestido Terracota', 'vestido-terracota',
 'Chemise em algodão terracota com botões de coco e bordado na gola.',
 'roupas', 'vestidos', 499, 299, true, false, false,
 ARRAY['/images/products/vestido-terracota.jpg'], 300, 35, 5, 30,
 '{"P":"Busto 88cm · Comprimento 98cm","M":"Busto 94cm · Comprimento 100cm","G":"Busto 100cm · Comprimento 102cm"}'::jsonb,
 '62044200', now() - interval '15 days'),

('00000000-0000-0000-0000-000000000203', 'Vestido Verde', 'vestido-verde',
 'Vestido de alças em algodão verde-claro, fresco para o verão.',
 'roupas', 'vestidos', 459, 275, true, false, false,
 ARRAY['/images/products/vestido-verde.jpg'], 260, 35, 5, 30, NULL, '62044200', now() - interval '22 days'),

('00000000-0000-0000-0000-000000000301', 'Bata Bege', 'bata-bege',
 'Bata solta em algodão bege com bordado floral nas mangas.',
 'roupas', 'batas', 329, 197, true, false, false,
 ARRAY['/images/products/bata-bege.jpg'], 220, 30, 5, 25, NULL, '62064000', now() - interval '5 days'),

('00000000-0000-0000-0000-000000000302', 'Bata Branca', 'bata-branca',
 'Bata branca com bordado colorido no peito. Tamanho único.',
 'roupas', 'batas', 349, 209, true, true, false,
 ARRAY['/images/products/bata-branca.jpg'], 220, 30, 5, 25, NULL, '62064000', now() - interval '3 days'),

('00000000-0000-0000-0000-000000000401', 'Vestido Infantil Brisa', 'vestido-infantil-brisa',
 'Vestido infantil em algodão branco, com o mesmo bordado das peças adultas.',
 'roupas', 'vestidos', 259, 155, true, false, true,
 ARRAY['/images/products/infantil-vestido.jpg'], 150, 25, 4, 20,
 '{"4":"Busto 60cm · Comprimento 62cm","6":"Busto 64cm · Comprimento 68cm","8":"Busto 68cm · Comprimento 74cm"}'::jsonb,
 '62094300', now() - interval '10 days'),

('00000000-0000-0000-0000-000000000501', 'Almofada Pássaro', 'almofada-passaro',
 'Capa de almofada 45x45 com pássaro bordado à mão e franjas.',
 'almofadas', NULL, 189, 113, true, false, false,
 ARRAY['/images/products/almofada-passaro.jpg'], 300, 45, 45, 5, NULL, '63049300', now() - interval '18 days'),

('00000000-0000-0000-0000-000000000502', 'Almofada Flores', 'almofada-flores',
 'Capa de almofada 45x45 com flores bordadas em lã.',
 'almofadas', NULL, 199, 119, true, false, false,
 ARRAY['/images/products/almofada-flores.jpg'], 300, 45, 45, 5, NULL, '63049300', now() - interval '25 days'),

('00000000-0000-0000-0000-000000000601', 'Bolsa de Palha (coleção anterior)', 'bolsa-palha',
 'Bolsa de palha trançada com alça de couro. Últimas unidades.',
 'bazar', NULL, 199, NULL, true, false, false,
 ARRAY['/images/products/bolsa-palha.jpg'], 400, 40, 15, 30, NULL, '46021900', now() - interval '60 days')

ON CONFLICT (id) DO NOTHING;

-- ─── Variantes ───────────────────────────────────────────────────────────────
-- color é a cor comercial (a que o cliente vê). As cores de produção de cada
-- peça de corte ficam em variant_cut_colors, mais abaixo.
INSERT INTO public.product_variants (id, product_id, sku, size, color, stock_quantity, created_at)
VALUES
('00000000-0000-0000-0000-000000001011','00000000-0000-0000-0000-000000000101','BOL-AURO-MOST-UNICO','Único','Mostarda',3,now() - interval '12 days'),
('00000000-0000-0000-0000-000000001012','00000000-0000-0000-0000-000000000101','BOL-AURO-MARI-UNICO','Único','Marinho',0,now() - interval '12 days'),
('00000000-0000-0000-0000-000000001021','00000000-0000-0000-0000-000000000102','BOL-BRIS-CAQU-UNICO','Único','Cáqui',4,now() - interval '20 days'),
('00000000-0000-0000-0000-000000001022','00000000-0000-0000-0000-000000000102','BOL-BRIS-VINH-UNICO','Único','Vinho',1,now() - interval '20 days'),
('00000000-0000-0000-0000-000000001031','00000000-0000-0000-0000-000000000103','BOL-GIRA-NATU-UNICO','Único','Natural',5,now() - interval '30 days'),

('00000000-0000-0000-0000-000000002011','00000000-0000-0000-0000-000000000201','VES-LINH-CRU-P','P','Cru',2,now() - interval '8 days'),
('00000000-0000-0000-0000-000000002012','00000000-0000-0000-0000-000000000201','VES-LINH-CRU-M','M','Cru',3,now() - interval '8 days'),
('00000000-0000-0000-0000-000000002013','00000000-0000-0000-0000-000000000201','VES-LINH-CRU-G','G','Cru',1,now() - interval '8 days'),
('00000000-0000-0000-0000-000000002021','00000000-0000-0000-0000-000000000202','VES-TERR-TERR-P','P','Terracota',2,now() - interval '15 days'),
('00000000-0000-0000-0000-000000002022','00000000-0000-0000-0000-000000000202','VES-TERR-TERR-M','M','Terracota',0,now() - interval '15 days'),
('00000000-0000-0000-0000-000000002031','00000000-0000-0000-0000-000000000203','VES-VERD-VERD-M','M','Verde',4,now() - interval '22 days'),

('00000000-0000-0000-0000-000000003011','00000000-0000-0000-0000-000000000301','BAT-BEGE-BEGE-UNICO','Único','Bege',6,now() - interval '5 days'),
('00000000-0000-0000-0000-000000003021','00000000-0000-0000-0000-000000000302','BAT-BRAN-BRAN-UNICO','Único','Branca',5,now() - interval '3 days'),

('00000000-0000-0000-0000-000000004011','00000000-0000-0000-0000-000000000401','INF-BRIS-BRAN-4','4','Branco',3,now() - interval '10 days'),
('00000000-0000-0000-0000-000000004012','00000000-0000-0000-0000-000000000401','INF-BRIS-BRAN-6','6','Branco',2,now() - interval '10 days'),
('00000000-0000-0000-0000-000000004013','00000000-0000-0000-0000-000000000401','INF-BRIS-BRAN-8','8','Branco',0,now() - interval '10 days'),

('00000000-0000-0000-0000-000000005011','00000000-0000-0000-0000-000000000501','ALM-PASS-NATU-45','45x45','Natural',7,now() - interval '18 days'),
('00000000-0000-0000-0000-000000005021','00000000-0000-0000-0000-000000000502','ALM-FLOR-COLO-45','45x45','Colorida',4,now() - interval '25 days'),

('00000000-0000-0000-0000-000000006011','00000000-0000-0000-0000-000000000601','BAZ-PALH-NATU-UNICO','Único','Natural',2,now() - interval '60 days')

ON CONFLICT (sku) DO NOTHING;

-- Fotos por variante (espelha o backfill da migration 025): herdam do produto.
UPDATE public.product_variants v
SET images = p.images
FROM public.products p
WHERE v.product_id = p.id
  AND v.images = '{}'
  AND p.images <> '{}';

-- ─── Paleta de produção ──────────────────────────────────────────────────────
INSERT INTO public.material_colors (category, name, hex, sort_order) VALUES
  ('Corte Lona',  'Mostarda', '#c9a227', 1),
  ('Corte Lona',  'Marinho',  '#1f2f4f', 2),
  ('Corte Lona',  'Cáqui',    '#a8956b', 3),
  ('Corte Lona',  'Vinho',    '#6b1f2a', 4),
  ('Corte Forro', 'Cru',      '#efe6d2', 1),
  ('Corte Couro', 'Caramelo', '#a0612b', 1),
  ('Corte Couro', 'Preto',    '#1c1c1c', 2)
ON CONFLICT (category, name) DO NOTHING;

-- ─── Fichas técnicas (receita por produto) ───────────────────────────────────
-- Itens de corte guardam categoria + peça (a cor vem da variante); os demais
-- apontam o insumo de cor fixa criado na migration 031.
WITH receita(slug, categoria, tipo, qtd) AS (VALUES
  ('bolsa-aurora', 'Corte Lona',  'Frente',                 1.0),
  ('bolsa-aurora', 'Corte Lona',  'Costas',                 1.0),
  ('bolsa-aurora', 'Corte Lona',  'Alça',                   2.0),
  ('bolsa-aurora', 'Corte Forro', 'Frente',                 1.0),
  ('bolsa-aurora', 'Corte Forro', 'Costas',                 1.0),
  ('bolsa-aurora', 'Corte Forro', 'Bolso de dentro',        1.0),
  ('bolsa-aurora', 'Corte Couro', 'Boca de palhaço',        1.0),
  ('bolsa-aurora', 'Aplicações',  'Aurora A',               2.0),
  ('bolsa-aurora', 'Aplicações',  'Aurora B',               1.0),
  ('bolsa-aurora', 'Metais',      'Rebite',                 4.0),
  ('bolsa-aurora', 'Metais',      'Argola G',               2.0),
  ('bolsa-aurora', 'Metais',      'Mosquetão G',            2.0),
  ('bolsa-aurora', 'Aviamentos',  'Fecho metro 30 cm',      1.0),
  ('bolsa-aurora', 'Aviamentos',  'Viés 2,5 cm',            1.5),
  ('bolsa-aurora', 'Aviamentos',  'Etiqueta bordada',       1.0),
  ('bolsa-aurora', 'Aviamentos',  'Etiqueta de composição', 1.0),

  ('bolsa-brisa',  'Corte Lona',  'Frente',                 1.0),
  ('bolsa-brisa',  'Corte Lona',  'Costas',                 1.0),
  ('bolsa-brisa',  'Corte Lona',  'Lateral',                2.0),
  ('bolsa-brisa',  'Corte Forro', 'Frente',                 1.0),
  ('bolsa-brisa',  'Corte Forro', 'Costas',                 1.0),
  ('bolsa-brisa',  'Corte Couro', 'Alça de couro',          1.0),
  ('bolsa-brisa',  'Aplicações',  'Brisa A',                1.0),
  ('bolsa-brisa',  'Metais',      'Cursor diamante',        2.0),
  ('bolsa-brisa',  'Metais',      'Ímã',                    1.0),
  ('bolsa-brisa',  'Aviamentos',  'Fecho padrão 18 cm',     1.0),
  ('bolsa-brisa',  'Aviamentos',  'Etiqueta bordada',       1.0),
  ('bolsa-brisa',  'Aviamentos',  'Etiqueta de composição', 1.0)
)
INSERT INTO public.bill_of_materials
  (product_id, raw_material_id, material_category, material_type, quantity_needed)
SELECT
  p.id,
  CASE WHEN r.categoria LIKE 'Corte %' THEN NULL        ELSE rm.id END,
  CASE WHEN r.categoria LIKE 'Corte %' THEN r.categoria ELSE NULL  END,
  CASE WHEN r.categoria LIKE 'Corte %' THEN r.tipo      ELSE NULL  END,
  r.qtd
FROM receita r
JOIN public.products p ON p.slug = r.slug
LEFT JOIN public.raw_materials rm
  ON rm.category = r.categoria AND rm.type_specific = r.tipo AND rm.color IS NULL
WHERE r.categoria LIKE 'Corte %' OR rm.id IS NOT NULL;

-- ─── Cor de cada peça de corte, por variante ─────────────────────────────────
-- Uma linha por peça da receita: lona na cor comercial, forro sempre cru,
-- couro conforme a variante.
WITH cor(variant_id, lona, couro) AS (VALUES
  ('00000000-0000-0000-0000-000000001011'::uuid, 'Mostarda', 'Caramelo'),
  ('00000000-0000-0000-0000-000000001012'::uuid, 'Marinho',  'Preto'),
  ('00000000-0000-0000-0000-000000001021'::uuid, 'Cáqui',    'Caramelo'),
  ('00000000-0000-0000-0000-000000001022'::uuid, 'Vinho',    'Preto')
)
INSERT INTO public.variant_cut_colors (variant_id, category, material_type, color)
SELECT c.variant_id, b.material_category, b.material_type,
       CASE b.material_category
         WHEN 'Corte Lona'  THEN c.lona
         WHEN 'Corte Forro' THEN 'Cru'
         ELSE c.couro
       END
FROM cor c
JOIN public.product_variants v ON v.id = c.variant_id
JOIN public.bill_of_materials b
  ON b.product_id = v.product_id AND b.material_category IS NOT NULL
ON CONFLICT DO NOTHING;

-- ─── Estoque de cortes ───────────────────────────────────────────────────────
-- Um insumo por (categoria, peça, cor) que alguma variante usa.
INSERT INTO public.raw_materials
  (name, type, category, type_specific, color, unit, stock_quantity, minimum_stock, cost_per_unit)
SELECT DISTINCT vc.material_type, 'bruta', vc.category, vc.material_type, vc.color, 'unidade',
       10, 4,
       CASE vc.category WHEN 'Corte Couro' THEN 18.00 WHEN 'Corte Lona' THEN 9.50 ELSE 4.00 END
FROM public.variant_cut_colors vc;

-- Falta proposital: a Aurora Marinho não tem boca de couro preta suficiente,
-- então uma OP dela fica bloqueada e lista o que comprar.
UPDATE public.raw_materials
SET stock_quantity = 0
WHERE category = 'Corte Couro' AND type_specific = 'Boca de palhaço' AND color = 'Preto';

-- Insumos de cor fixa com saldo para algumas bolsas.
UPDATE public.raw_materials
SET stock_quantity = CASE WHEN unit = 'metro' THEN 12 ELSE 20 END,
    minimum_stock  = CASE WHEN unit = 'metro' THEN 3  ELSE 5  END
WHERE color IS NULL;

-- Um insumo abaixo do mínimo, para o alerta aparecer no painel.
UPDATE public.raw_materials
SET stock_quantity = 2
WHERE category = 'Metais' AND type_specific = 'Mosquetão G';

-- ─── Clientes de atacado (fictícios) ─────────────────────────────────────────
INSERT INTO public.customers (id, type, name, email, phone, cpf_cnpj, address) VALUES
('00000000-0000-0000-0000-000000009001', 'wholesale', 'Boutique Litoral', 'compras@boutiquelitoral.example', '11988887777', '11444777000161',
 '{"street":"Rua das Flores","number":"10","neighborhood":"Centro","city":"Salvador","state":"BA","zip":"40020000"}'::jsonb),
('00000000-0000-0000-0000-000000009002', 'wholesale', 'Empório Serra', 'pedidos@emporioserra.example', '31977776666', '22333444000172',
 '{"street":"Avenida Principal","number":"250","neighborhood":"Centro","city":"Belo Horizonte","state":"MG","zip":"30110000"}'::jsonb)
ON CONFLICT (id) DO NOTHING;
