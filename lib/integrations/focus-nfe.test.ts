import { describe, expect, it } from 'vitest'
import { buildNfePayload, type OrderItemWithProduct } from './focus-nfe'
import type { Emitente } from '@/lib/server/store-identity'
import type { Customer, Order } from '@/lib/types'

const emitenteMg: Emitente = {
  cnpj: '11222333000181',
  inscricaoEstadual: 'ISENTO',
  nome: 'ATELIE EXEMPLO LTDA',
  regimeTributario: 1,
  endereco: {
    street: 'Rua Exemplo',
    number: '100',
    complement: '',
    district: 'Centro',
    city: 'Belo Horizonte',
    state: 'MG',
    zip: '30130000',
  },
}

function buildCustomer(state: string, cpfCnpj = '529.982.247-25'): Customer {
  return {
    id: 'customer-1',
    user_id: null,
    type: 'retail',
    name: 'Cliente Exemplo',
    email: 'cliente@example.com',
    phone: null,
    cpf_cnpj: cpfCnpj,
    address: {
      street: 'Rua das Flores',
      number: '10',
      complement: null,
      neighborhood: 'Centro',
      city: 'Cidade',
      state,
      zip: '40020-000',
    },
    created_at: '2026-11-01T00:00:00Z',
  }
}

function buildOrder(overrides: Partial<Order> = {}): Order {
  return {
    id: 'order-1',
    customer_id: 'customer-1',
    type: 'retail',
    status: 'paid',
    total_amount: 0,
    discount_amount: 0,
    shipping_amount: 0,
    payment_status: 'paid',
    payment_id: null,
    payment_method: 'pix',
    shipping_method: null,
    tracking_code: null,
    coupon_id: null,
    nfe_number: null,
    nfe_url: null,
    nfe_status: 'pending',
    nfe_access_key: null,
    nfe_error: null,
    shipping_error: null,
    buyer_name: null,
    buyer_email: null,
    buyer_phone: null,
    buyer_cpf_cnpj: null,
    buyer_address: null,
    notes: null,
    created_at: '2026-11-01T00:00:00Z',
    updated_at: '2026-11-01T00:00:00Z',
    ...overrides,
  }
}

function buildItem(options: {
  unitPrice: number
  quantity?: number
  cfop?: string | null
  ncm?: string | null
}): OrderItemWithProduct {
  return {
    id: 'item-1',
    order_id: 'order-1',
    product_variant_id: 'variant-1',
    quantity: options.quantity ?? 1,
    unit_price: options.unitPrice,
    created_at: '2026-11-01T00:00:00Z',
    product_variant: {
      id: 'variant-1',
      product_id: 'product-1',
      sku: 'BOL-AURO-MOST-UNICO',
      size: 'Único',
      color: 'Mostarda',
      stock_quantity: 3,
      images: [],
      created_at: '2026-11-01T00:00:00Z',
      product: {
        id: 'product-1',
        name: 'Bolsa Aurora',
        slug: 'bolsa-aurora',
        description: null,
        category: 'bolsas',
        subcategory: null,
        base_price: options.unitPrice,
        wholesale_price: null,
        is_active: true,
        is_featured: false,
        is_affiliate_promo: false,
        is_kids: false,
        images: [],
        weight_grams: 450,
        length_cm: 36,
        width_cm: 12,
        height_cm: 30,
        measurements: null,
        ncm: options.ncm === undefined ? '42022220' : options.ncm,
        cfop: options.cfop ?? null,
        created_at: '2026-11-01T00:00:00Z',
      },
    },
  }
}

describe('CFOP of each item', () => {
  it('uses 5102 when the buyer is in the same state as the fiscal address', () => {
    const payload = buildNfePayload(buildOrder(), [buildItem({ unitPrice: 100 })], buildCustomer('MG'), emitenteMg)
    expect(payload.items[0].cfop).toBe('5102')
  })

  it('uses 6102 when the buyer is in another state', () => {
    const payload = buildNfePayload(buildOrder(), [buildItem({ unitPrice: 100 })], buildCustomer('BA'), emitenteMg)
    expect(payload.items[0].cfop).toBe('6102')
  })

  it('ignores the 6102 product default for an in-state sale', () => {
    const item = buildItem({ unitPrice: 100, cfop: '6102' })
    const payload = buildNfePayload(buildOrder(), [item], buildCustomer('mg '), emitenteMg)
    expect(payload.items[0].cfop).toBe('5102')
  })

  it('keeps a CFOP outside the 5102/6102 pair chosen on the product', () => {
    const item = buildItem({ unitPrice: 100, cfop: '5405' })
    const payload = buildNfePayload(buildOrder(), [item], buildCustomer('BA'), emitenteMg)
    expect(payload.items[0].cfop).toBe('5405')
  })
})

describe('invoice totals', () => {
  it('rounds every amount to cents instead of sending float noise', () => {
    const items = [buildItem({ unitPrice: 138.6, quantity: 3 })]
    const payload = buildNfePayload(buildOrder(), items, buildCustomer('BA'), emitenteMg)
    expect(payload.valor_produtos).toBe(415.8)
  })

  it('adds shipping and subtracts the discount from the products total', () => {
    const order = buildOrder({ shipping_amount: 25.5, discount_amount: 10 })
    const payload = buildNfePayload(order, [buildItem({ unitPrice: 100 })], buildCustomer('BA'), emitenteMg)
    expect(payload.valor_total).toBe(115.5)
  })
})

describe('buyer document', () => {
  it('sends a CPF in cpf_destinatario, digits only', () => {
    const payload = buildNfePayload(buildOrder(), [buildItem({ unitPrice: 100 })], buildCustomer('BA'), emitenteMg)
    expect(payload).toMatchObject({ cpf_destinatario: '52998224725' })
    expect(payload).not.toHaveProperty('cnpj_destinatario')
  })

  it('sends a CNPJ in cnpj_destinatario', () => {
    const customer = buildCustomer('BA', '11.444.777/0001-61')
    const payload = buildNfePayload(buildOrder(), [buildItem({ unitPrice: 100 })], customer, emitenteMg)
    expect(payload).toMatchObject({ cnpj_destinatario: '11444777000161' })
    expect(payload).not.toHaveProperty('cpf_destinatario')
  })
})

describe('emitter fields', () => {
  it('sends the emitter as flat *_emitente fields, the shape the API expects', () => {
    const payload = buildNfePayload(buildOrder(), [buildItem({ unitPrice: 100 })], buildCustomer('BA'), emitenteMg)
    expect(payload).toMatchObject({ cnpj_emitente: '11222333000181', uf_emitente: 'MG' })
    expect(payload).not.toHaveProperty('emitente')
  })
})

describe('preconditions', () => {
  it('throws when a product has no NCM, naming the product', () => {
    const item = buildItem({ unitPrice: 100, ncm: null })
    expect(() => buildNfePayload(buildOrder(), [item], buildCustomer('BA'), emitenteMg)).toThrow(/Bolsa Aurora.*NCM/)
  })

  it('throws when the buyer has no address', () => {
    const customer: Customer = { ...buildCustomer('BA'), address: null }
    expect(() => buildNfePayload(buildOrder(), [buildItem({ unitPrice: 100 })], customer, emitenteMg)).toThrow(
      /endereço/,
    )
  })
})
