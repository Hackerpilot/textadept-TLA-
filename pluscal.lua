local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'pluscal'}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments
local line_comment_a = '\\*' * l.nonnewline_esc^0
local line_comment_b = '----' * l.nonnewline_esc^0
local line_comment_c = '====' * l.nonnewline_esc^0
local nested_comment = l.nested_pair('(*', '*)')
local comment = token(l.COMMENT, line_comment_a + line_comment_b + line_comment_c
	+ nested_comment)

-- Strings
local string = token(l.STRING, l.delimited_range('"'))

-- Numbers
local number = token(l.NUMBER, l.dec_num)

-- Keywords
local keyword = token(l.KEYWORD, word_match{
  'ASSUME', 'ASSUMPTION', 'AXIOM', 'CASE', 'CHOOSE', 'CONSTANT', 'CONSTANTS',
  'DOMAIN', 'ELSE', 'ENABLED', 'EXCEPT', 'EXTENDS', 'IF', 'IN', 'INSTANCE',
  'LAMBDA', 'LET', 'LOCAL', 'MODULE', 'OTHER', 'UNION', 'SUBSET', 'THEN', 'THEOREM',
  'UNCHANGED', 'VARIABLE', 'VARIABLES', 'WITH', 'assert', 'algorithm', 'await',
  'begin', 'call', 'do', 'either', 'else', 'elsif', 'end', 'goto', 'if', 'macro',
  'or', 'print', 'procedure', 'process', 'return', 'skip', 'then', 'variable',
  'variables', 'when', 'while', 'with', 'define'
})

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

-- Operators
local plain_operators = token(l.OPERATOR, S('@!%*+-^`_/\\|:=<>[]{}().;'))
local latex_operators = token(l.FUNCTION, '\\' * word_match{
  'land', 'lnot', 'neg', 'in', 'leq', 'll', 'prec', 'preceq',
  'subset', 'subseteq', 'sqsubset', 'sqsubseteq', 'cap', 'intersect',
  'sqcap', 'oplus', 'ominus', 'odot', 'otimes', 'slash', 'E',
  'EE', 'lor', 'equiv', 'notin', 'geq', 'gg', 'succ', 'succeq', 'supseteq',
  'supset', 'sqsupset', 'sqsupseteq', 'cup', 'union', 'sqcup', 'uplus', 'X',
  'times', 'wr', 'propto', 'A', 'AA', 'div', 'cdot', 'o', 'circ', 'bullet',
  'star', 'bigcirc', 'sim', 'simeq', 'asymp', 'approx', 'cong', 'doteq'
})

-- Definitions
local definition = token(l.TYPE, l.word) * #(l.space^0 * ('(' * (l.any - ')')^0 * P(')'))^-1 * l.space^0 * '==')

-- Constants
local constants = token(l.CONSTANT, word_match{'TRUE', 'FALSE', 'defaultInitValue'})

M._rules = {
  {'whitespace', ws},
  {'string', string},
  {'keyword', keyword},
  {'type', definition},
  {'constant', constants},
  {'identifier', identifier},
  {'comment', comment},
  {'number', number},
  {'function', latex_operators},
  {'operator', plain_operators}
}

return M
