import { describe, expect, it } from 'vitest'
import { formatCnpj, isValidCep, isValidCnpj, isValidCpf, onlyDigits } from './documento'

describe('CPF validation', () => {
  it('accepts a CPF with valid check digits, formatted or not', () => {
    expect(isValidCpf('529.982.247-25')).toBe(true)
    expect(isValidCpf('52998224725')).toBe(true)
  })

  it('rejects a CPF with a wrong check digit', () => {
    expect(isValidCpf('529.982.247-24')).toBe(false)
  })

  it('rejects repeated digits, which pass the check-digit math', () => {
    expect(isValidCpf('111.111.111-11')).toBe(false)
  })

  it('rejects empty and missing values', () => {
    expect(isValidCpf('')).toBe(false)
    expect(isValidCpf(null)).toBe(false)
  })
})

describe('CNPJ validation', () => {
  it('accepts a CNPJ with valid check digits', () => {
    expect(isValidCnpj('11.444.777/0001-61')).toBe(true)
  })

  it('rejects a CNPJ with a wrong check digit', () => {
    expect(isValidCnpj('11.444.777/0001-62')).toBe(false)
  })

  it('rejects repeated digits', () => {
    expect(isValidCnpj('00.000.000/0000-00')).toBe(false)
  })
})

describe('formatting helpers', () => {
  it('strips everything that is not a digit', () => {
    expect(onlyDigits('11.444.777/0001-61')).toBe('11444777000161')
  })

  it('formats a digits-only CNPJ for display', () => {
    expect(formatCnpj('11444777000161')).toBe('11.444.777/0001-61')
  })

  it('accepts a CEP with or without the hyphen and rejects short ones', () => {
    expect(isValidCep('40020-000')).toBe(true)
    expect(isValidCep('40020000')).toBe(true)
    expect(isValidCep('4002000')).toBe(false)
  })
})
