-- Ordens de produção: complete_production_order e revert_production_order.
--
-- Roda sobre o banco montado por scripts/test-db.sh (migrations + seed). Cada
-- teste abre uma transação e desfaz no fim, então a ordem não importa. Uma
-- asserção que falha aborta o arquivo com a mensagem do teste.
--
-- Variantes do seed usadas aqui:
--   ...1011  Bolsa Aurora Mostarda — tem todo o material para 1 unidade
--   ...1012  Bolsa Aurora Marinho  — falta a boca de couro preta
--   ...1021  Bolsa Brisa Cáqui     — tem todo o material

\set ON_ERROR_STOP 1
SET client_min_messages = notice;

-- ─── Concluir move os dois estoques e grava a auditoria ──────────────────────
BEGIN;
DO $$
DECLARE
  v_variant      uuid := '00000000-0000-0000-0000-000000001011';
  v_op           uuid := gen_random_uuid();
  v_before       integer;
  v_after        integer;
  v_cut_before   numeric;
  v_cut_after    numeric;
  v_audit_rows   integer;
  v_recipe_rows  integer;
BEGIN
  INSERT INTO production_orders (id, product_variant_id, quantity_requested, status)
  VALUES (v_op, v_variant, 1, 'in_progress');

  SELECT stock_quantity INTO v_before FROM product_variants WHERE id = v_variant;
  SELECT stock_quantity INTO v_cut_before FROM raw_materials
   WHERE category = 'Corte Lona' AND type_specific = 'Frente' AND color = 'Mostarda';

  PERFORM complete_production_order(v_op);

  SELECT stock_quantity INTO v_after FROM product_variants WHERE id = v_variant;
  SELECT stock_quantity INTO v_cut_after FROM raw_materials
   WHERE category = 'Corte Lona' AND type_specific = 'Frente' AND color = 'Mostarda';
  SELECT count(*) INTO v_audit_rows FROM stock_adjustments
   WHERE reason = 'producao_concluida' AND notes = 'OP ' || v_op;
  SELECT count(*) INTO v_recipe_rows FROM resolve_variant_bom(v_variant);

  ASSERT v_after = v_before + 1, 'o produto acabado deveria subir 1 unidade';
  ASSERT v_cut_after = v_cut_before - 1, 'o corte da frente deveria baixar 1 unidade';
  ASSERT v_audit_rows = v_recipe_rows + 1,
    format('esperava uma linha de auditoria por insumo + 1 do produto, veio %s', v_audit_rows);
  ASSERT (SELECT status FROM production_orders WHERE id = v_op) = 'completed',
    'a OP deveria terminar como completed';
  RAISE NOTICE 'ok  concluir OP sobe o acabado, baixa a matéria-prima e audita';
END $$;
ROLLBACK;

-- ─── Estornar devolve cada linha ao valor anterior ──────────────────────────
BEGIN;
DO $$
DECLARE
  v_variant    uuid := '00000000-0000-0000-0000-000000001021';
  v_op         uuid := gen_random_uuid();
  v_before     integer;
  v_cut_before numeric;
BEGIN
  INSERT INTO production_orders (id, product_variant_id, quantity_requested, status)
  VALUES (v_op, v_variant, 1, 'in_progress');
  SELECT stock_quantity INTO v_before FROM product_variants WHERE id = v_variant;
  SELECT stock_quantity INTO v_cut_before FROM raw_materials
   WHERE category = 'Corte Couro' AND type_specific = 'Alça de couro' AND color = 'Caramelo';

  PERFORM complete_production_order(v_op);
  PERFORM revert_production_order(v_op, 'in_progress');

  ASSERT (SELECT stock_quantity FROM product_variants WHERE id = v_variant) = v_before,
    'o estorno deveria devolver o produto acabado ao valor anterior';
  ASSERT (SELECT stock_quantity FROM raw_materials
           WHERE category = 'Corte Couro' AND type_specific = 'Alça de couro' AND color = 'Caramelo') = v_cut_before,
    'o estorno deveria devolver o corte ao valor anterior';
  ASSERT (SELECT status FROM production_orders WHERE id = v_op) = 'in_progress',
    'a OP deveria voltar para o status pedido';
  RAISE NOTICE 'ok  estornar OP devolve os dois estoques';
END $$;
ROLLBACK;

-- ─── Estorno recusado quando o produto acabado já saiu ──────────────────────
BEGIN;
DO $$
DECLARE
  v_variant uuid := '00000000-0000-0000-0000-000000001011';
  v_op      uuid := gen_random_uuid();
  v_stock   integer;
BEGIN
  INSERT INTO production_orders (id, product_variant_id, quantity_requested, status)
  VALUES (v_op, v_variant, 1, 'in_progress');
  PERFORM complete_production_order(v_op);

  -- vende tudo o que há, inclusive a peça recém-produzida
  SELECT stock_quantity INTO v_stock FROM product_variants WHERE id = v_variant;
  PERFORM decrement_stock(v_variant, v_stock);

  BEGIN
    PERFORM revert_production_order(v_op, 'in_progress');
    RAISE EXCEPTION 'o estorno deveria ter sido recusado';
  EXCEPTION WHEN others THEN
    IF SQLERRM = 'o estorno deveria ter sido recusado' THEN RAISE; END IF;
  END;

  ASSERT (SELECT stock_quantity FROM product_variants WHERE id = v_variant) = 0,
    'a recusa não pode deixar o estoque negativo';
  RAISE NOTICE 'ok  estorno recusado quando o produto acabado já foi vendido';
END $$;
ROLLBACK;

-- ─── Falta de material bloqueia a OP sem mover nada ─────────────────────────
BEGIN;
DO $$
DECLARE
  v_variant    uuid := '00000000-0000-0000-0000-000000001012';
  v_op         uuid := gen_random_uuid();
  v_before     integer;
  v_cut_before numeric;
BEGIN
  INSERT INTO production_orders (id, product_variant_id, quantity_requested, status)
  VALUES (v_op, v_variant, 1, 'in_progress');
  SELECT stock_quantity INTO v_before FROM product_variants WHERE id = v_variant;
  SELECT stock_quantity INTO v_cut_before FROM raw_materials
   WHERE category = 'Corte Lona' AND type_specific = 'Frente' AND color = 'Marinho';

  BEGIN
    PERFORM complete_production_order(v_op);
    RAISE EXCEPTION 'a OP deveria ter sido recusada';
  EXCEPTION WHEN others THEN
    IF SQLERRM NOT LIKE 'Materiais insuficientes:%Boca de palhaço (Preto)%' THEN RAISE; END IF;
  END;

  ASSERT (SELECT stock_quantity FROM product_variants WHERE id = v_variant) = v_before,
    'OP recusada não pode mexer no produto acabado';
  ASSERT (SELECT stock_quantity FROM raw_materials
           WHERE category = 'Corte Lona' AND type_specific = 'Frente' AND color = 'Marinho') = v_cut_before,
    'OP recusada não pode baixar nenhum insumo, nem os que tinham saldo';
  RAISE NOTICE 'ok  falta de material recusa a OP e nomeia o insumo, sem baixa parcial';
END $$;
ROLLBACK;

-- ─── Cor de corte indefinida bloqueia a OP ──────────────────────────────────
BEGIN;
DO $$
DECLARE
  v_variant uuid := '00000000-0000-0000-0000-000000001021';
  v_op      uuid := gen_random_uuid();
BEGIN
  UPDATE variant_cut_colors SET color = 'Indefinida'
   WHERE variant_id = v_variant AND category = 'Corte Lona' AND material_type = 'Frente';
  INSERT INTO production_orders (id, product_variant_id, quantity_requested, status)
  VALUES (v_op, v_variant, 1, 'in_progress');

  BEGIN
    PERFORM complete_production_order(v_op);
    RAISE EXCEPTION 'a OP deveria ter sido recusada';
  EXCEPTION WHEN others THEN
    IF SQLERRM NOT LIKE 'Defina a cor da variante antes de produzir:%' THEN RAISE; END IF;
  END;
  RAISE NOTICE 'ok  peça com cor Indefinida recusa a OP';
END $$;
ROLLBACK;

-- ─── Insumo não cadastrado naquela cor bloqueia a OP ────────────────────────
BEGIN;
DO $$
DECLARE
  v_variant uuid := '00000000-0000-0000-0000-000000001021';
  v_op      uuid := gen_random_uuid();
BEGIN
  DELETE FROM raw_materials
   WHERE category = 'Corte Lona' AND type_specific = 'Lateral' AND color = 'Cáqui';
  INSERT INTO production_orders (id, product_variant_id, quantity_requested, status)
  VALUES (v_op, v_variant, 1, 'in_progress');

  ASSERT EXISTS (SELECT 1 FROM resolve_variant_bom(v_variant) WHERE NOT resolved),
    'resolve_variant_bom deveria marcar a lateral como não resolvida';

  BEGIN
    PERFORM complete_production_order(v_op);
    RAISE EXCEPTION 'a OP deveria ter sido recusada';
  EXCEPTION WHEN others THEN
    IF SQLERRM NOT LIKE 'Insumos não cadastrados na cor desta variante:%' THEN RAISE; END IF;
  END;
  RAISE NOTICE 'ok  insumo ausente naquela cor vira pendência de cadastro e recusa a OP';
END $$;
ROLLBACK;

-- ─── OP concluída não conclui de novo ───────────────────────────────────────
BEGIN;
DO $$
DECLARE
  v_variant uuid := '00000000-0000-0000-0000-000000001011';
  v_op      uuid := gen_random_uuid();
  v_after   integer;
BEGIN
  INSERT INTO production_orders (id, product_variant_id, quantity_requested, status)
  VALUES (v_op, v_variant, 1, 'in_progress');
  PERFORM complete_production_order(v_op);
  SELECT stock_quantity INTO v_after FROM product_variants WHERE id = v_variant;

  BEGIN
    PERFORM complete_production_order(v_op);
    RAISE EXCEPTION 'a segunda conclusão deveria ter sido recusada';
  EXCEPTION WHEN others THEN
    IF SQLERRM NOT LIKE 'OP já está completed%' THEN RAISE; END IF;
  END;

  ASSERT (SELECT stock_quantity FROM product_variants WHERE id = v_variant) = v_after,
    'concluir duas vezes não pode somar estoque em dobro';
  RAISE NOTICE 'ok  concluir a mesma OP duas vezes é recusado';
END $$;
ROLLBACK;
