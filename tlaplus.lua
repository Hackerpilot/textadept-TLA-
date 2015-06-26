local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'tlaplus'}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Translation

local translation = token(l.PREPROCESSOR, '\\*' * l.space^0 * (P('BEGIN') + P('END')) * l.space^1 * 'TRANSLATION' * l.nonnewline_esc^0)

-- Comments.
local line_comment_a = '\\*' * l.nonnewline_esc^0
local line_comment_b = '----' * l.nonnewline_esc^0
local line_comment_c = '====' * l.nonnewline_esc^0
local nested_comment = l.nested_pair('(*', '*)')
local comment = token(l.COMMENT, line_comment_a + line_comment_b + line_comment_c
	+ nested_comment)

local dq_str = l.delimited_range('"')
local string = token(l.STRING, dq_str)

local number = token(l.NUMBER, l.dec_num)

local keyword = token(l.KEYWORD, word_match{
  'ASSUME', 'ASSUMPTION', 'AXIOM', 'CASE', 'CHOOSE', 'CONSTANT', 'CONSTANTS',
  'DOMAIN', 'ELSE', 'ENABLED', 'EXCEPT', 'EXTENDS', 'IF', 'IN', 'INSTANCE',
  'LET', 'LOCAL', 'MODULE', 'OTHER', 'UNION', 'SUBSET', 'THEN', 'THEOREM',
  'UNCHANGED', 'VARIABLE', 'VARIABLES', 'WITH',
})

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

local latex_operators = token(l.FUNCTION, '\\' * word_match{
  'land', 'lnot', 'neg', 'in', 'leq', 'll', 'prec', 'preceq',
  'subset', 'subseteq', 'sqsubset', 'sqsubseteq', 'cap', 'intersect',
  'sqcap', 'oplus', 'ominus', 'odot', 'otimes', 'slash', 'E',
  'EE', 'lor', 'equiv', 'notin', 'geq', 'gg', 'succ', 'succeq', 'supseteq',
  'supset', 'sqsupset', 'sqsupseteq', 'cup', 'union', 'sqcup', 'uplus', 'X',
  'times', 'wr', 'propto', 'A', 'AA', 'div', 'cdot', 'o', 'circ', 'bullet',
  'star', 'bigcirc', 'sim', 'simeq', 'asymp', 'approx', 'cong', 'doteq'
})

local plain_operators = token(l.OPERATOR, S('@!%*+-^`_/\\|:=<>[]{}().;'))

local definition = token(l.TYPE, l.word) * #(l.space^0 * ('(' * (l.any - ')')^0 * P(')'))^-1 * l.space^0 * '==')

local constants = token(l.CONSTANT, word_match{'TRUE', 'FALSE', 'defaultInitValue'})

M._rules = {
  {'whitespace', ws},
  {'string', string},
  {'keyword', keyword},
  {'type', definition},
  {'constant', constants},
  {'preprocessor', translation},
  {'identifier', identifier},
  {'comment', comment},
  {'number', number},
  {'function', latex_operators},
  {'operator', plain_operators}
}

local pluscal = l.load('pluscal')
local pluscal_start = P('(*') * l.space^0 * P('--')
local pluscal_end = P('}') * l.space^0 * P('*)')
l.embed_lexer(M, pluscal, pluscal_start, pluscal_end)

return M
