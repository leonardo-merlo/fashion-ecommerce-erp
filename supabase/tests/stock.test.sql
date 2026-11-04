-- Estoque de produto acabado: decrement_stock (venda) e increment_stock.
--
-- Mesmo esquema de production-orders.test.sql: cada teste numa transação
-- desfeita no fim, sobre o banco de scripts/test-db.sh.

\set ON_ERROR_STOP 1
SET client_min_messages = notice;

-- ─── Venda baixa o estoque e audita como 'venda' ─────────────────────────────
BEGIN;
DO $$
DECLARE
  v_variant uuid := '00000000-0000-0000-0000-000000003011';
  v_before  integer;
BEGIN
  SELECT stock_quantity INTO v_before FROM product_variants WHERE id = v_variant;
  PERFORM decrement_stock(v_variant, 2);

  ASSERT (SELECT stock_quantity FROM product_variants WHERE id = v_variant) = v_before - 2,
    'a venda deveria baixar 2 unidades';
  ASSERT EXISTS (
    SELECT 1 FROM stock_adjustments
     WHERE target_id = v_variant AND reason = 'venda'
       AND quantity_before = v_before AND quantity_after = v_before - 2
  ), 'a venda deveria gravar antes e depois na auditoria';
  RAISE NOTICE 'ok  venda baixa o estoque e grava a auditoria';
END $$;
ROLLBACK;

-- ─── Estoque nunca fica negativo ─────────────────────────────────────────────
BEGIN;
DO $$
DECLARE
  v_variant uuid := '00000000-0000-0000-0000-000000001022';
  v_before  integer;
BEGIN
  SELECT stock_quantity INTO v_before FROM product_variants WHERE id = v_variant;

  BEGIN
    PERFORM decrement_stock(v_variant, v_before + 1);
    RAISE EXCEPTION 'a venda acima do estoque deveria ter sido recusada';
  EXCEPTION WHEN others THEN
    IF SQLERRM NOT LIKE 'Estoque insuficiente para variante%' THEN RAISE; END IF;
  END;

  ASSERT (SELECT stock_quantity FROM product_variants WHERE id = v_variant) = v_before,
    'a recusa não pode alterar o estoque';
  RAISE NOTICE 'ok  venda acima do estoque é recusada';
END $$;
ROLLBACK;

-- ─── Devolução soma e registra o motivo ─────────────────────────────────────
BEGIN;
DO $$
DECLARE
  v_variant uuid := '00000000-0000-0000-0000-000000001012';
  v_before  integer;
BEGIN
  SELECT stock_quantity INTO v_before FROM product_variants WHERE id = v_variant;
  PERFORM increment_stock(v_variant, 1, 'devolucao', 'pedido cancelado');

  ASSERT (SELECT stock_quantity FROM product_variants WHERE id = v_variant) = v_before + 1,
    'a devolução deveria somar 1 unidade';
  ASSERT EXISTS (
    SELECT 1 FROM stock_adjustments
     WHERE target_id = v_variant AND reason = 'devolucao' AND delta = 1
  ), 'a devolução deveria ficar na auditoria com o motivo';
  RAISE NOTICE 'ok  devolução soma ao estoque e registra o motivo';
END $$;
ROLLBACK;
