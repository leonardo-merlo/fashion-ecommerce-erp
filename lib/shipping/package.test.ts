import { describe, expect, it } from 'vitest'
import { consolidatePackage } from './package'

const bag = { weightKg: 0.45, widthCm: 12, heightCm: 10, lengthCm: 36, quantity: 1 }
const blouse = { weightKg: 0.22, widthCm: 25, heightCm: 4, lengthCm: 30, quantity: 1 }

describe('consolidating the cart into one parcel', () => {
  it('sums weight and stacks heights, multiplied by quantity', () => {
    const parcel = consolidatePackage([{ ...bag, quantity: 2 }, blouse])
    expect(parcel.weightKg).toBeCloseTo(1.12)
    expect(parcel.heightCm).toBe(24)
  })

  it('uses the largest base among the items', () => {
    const parcel = consolidatePackage([bag, blouse])
    expect(parcel).toMatchObject({ lengthCm: 36, widthCm: 25 })
  })

  it('counts a zero or fractional quantity as at least one whole piece', () => {
    expect(consolidatePackage([{ ...bag, quantity: 0 }]).weightKg).toBeCloseTo(0.45)
    expect(consolidatePackage([{ ...bag, quantity: 2.7 }]).heightCm).toBe(20)
  })

  it('returns an empty parcel for an empty cart', () => {
    expect(consolidatePackage([])).toEqual({ weightKg: 0, widthCm: 0, heightCm: 0, lengthCm: 0 })
  })
})
