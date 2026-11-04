import { describe, expect, it } from 'vitest'
import { formatOptionId, parseOptionId } from './option-id'

describe('shipping option id', () => {
  it('round-trips a carrier and service code', () => {
    const id = formatOptionId('correios', '03298')
    expect(parseOptionId(id)).toEqual({ carrier: 'correios', serviceCode: '03298' })
  })

  it('tells apart the same service number from two carriers', () => {
    expect(formatOptionId('correios', '1')).not.toBe(formatOptionId('melhor-envio', '1'))
  })

  it('keeps a separator that belongs to the service code', () => {
    expect(parseOptionId('melhor-envio:a:b')).toEqual({ carrier: 'melhor-envio', serviceCode: 'a:b' })
  })

  it('rejects an unknown carrier coming from the browser', () => {
    expect(parseOptionId('fedex:1')).toBeNull()
  })

  it('rejects values without a carrier or without a service code', () => {
    expect(parseOptionId('1')).toBeNull()
    expect(parseOptionId(':1')).toBeNull()
    expect(parseOptionId('correios:')).toBeNull()
  })
})
