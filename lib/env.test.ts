import { describe, expect, it } from 'vitest'
import { stripInlineComment } from './env'

describe('environment values pasted with an inline comment', () => {
  it('drops a trailing comment the Vercel field kept as part of the value', () => {
    expect(stripInlineComment('homologacao # trocar no lançamento')).toBe('homologacao')
  })

  it('keeps a # glued to the value, as tokens and secrets may contain one', () => {
    expect(stripInlineComment('abc#def123')).toBe('abc#def123')
  })

  it('keeps a value without a comment untouched apart from surrounding spaces', () => {
    expect(stripInlineComment('  producao  ')).toBe('producao')
  })
})
