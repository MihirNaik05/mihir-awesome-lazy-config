local cmp = require('cmp')

local source = {}

--- @type lsp.CompletionItem[]
local items = {
	{ label = '\\alpha', kind = cmp.lsp.CompletionItemKind.Function, detail = 'α' },
	{ label = '\\beta', kind = cmp.lsp.CompletionItemKind.Function, detail = 'β' },
	{ label = '\\gamma', kind = cmp.lsp.CompletionItemKind.Function, detail = 'γ' },
	{ label = '\\delta', kind = cmp.lsp.CompletionItemKind.Function, detail = 'δ' },
	{ label = '\\epsilon', kind = cmp.lsp.CompletionItemKind.Function, detail = 'ε' },
	{ label = '\\theta', kind = cmp.lsp.CompletionItemKind.Function, detail = 'θ' },
	{ label = '\\lambda', kind = cmp.lsp.CompletionItemKind.Function, detail = 'λ' },
	{ label = '\\pi', kind = cmp.lsp.CompletionItemKind.Function, detail = 'π' },
	{ label = '\\sigma', kind = cmp.lsp.CompletionItemKind.Function, detail = 'σ' },
	{ label = '\\phi', kind = cmp.lsp.CompletionItemKind.Function, detail = 'φ' },
	{ label = '\\omega', kind = cmp.lsp.CompletionItemKind.Function, detail = 'ω' },
	{ label = '\\Delta', kind = cmp.lsp.CompletionItemKind.Function, detail = 'Δ' },
	{ label = '\\Omega', kind = cmp.lsp.CompletionItemKind.Function, detail = 'Ω' },
	{ label = '\\frac', kind = cmp.lsp.CompletionItemKind.Function, detail = 'fraction' },
	{ label = '\\sqrt', kind = cmp.lsp.CompletionItemKind.Function, detail = 'square root' },
	{ label = '\\int', kind = cmp.lsp.CompletionItemKind.Function, detail = 'integral' },
	{ label = '\\sum', kind = cmp.lsp.CompletionItemKind.Function, detail = 'sum' },
	{ label = '\\prod', kind = cmp.lsp.CompletionItemKind.Function, detail = 'product' },
	{ label = '\\partial', kind = cmp.lsp.CompletionItemKind.Function, detail = '∂' },
	{ label = '\\nabla', kind = cmp.lsp.CompletionItemKind.Function, detail = '∇' },
	{ label = '\\infty', kind = cmp.lsp.CompletionItemKind.Function, detail = '∞' },
	{ label = '\\times', kind = cmp.lsp.CompletionItemKind.Function, detail = '×' },
	{ label = '\\cdot', kind = cmp.lsp.CompletionItemKind.Function, detail = '·' },
	{ label = '\\pm', kind = cmp.lsp.CompletionItemKind.Function, detail = '±' },
	{ label = '\\neq', kind = cmp.lsp.CompletionItemKind.Function, detail = '≠' },
	{ label = '\\leq', kind = cmp.lsp.CompletionItemKind.Function, detail = '≤' },
	{ label = '\\geq', kind = cmp.lsp.CompletionItemKind.Function, detail = '≥' },
	{ label = '\\in', kind = cmp.lsp.CompletionItemKind.Function, detail = '∈' },
	{ label = '\\subset', kind = cmp.lsp.CompletionItemKind.Function, detail = '⊂' },
	{ label = '\\cup', kind = cmp.lsp.CompletionItemKind.Function, detail = '∪' },
	{ label = '\\cap', kind = cmp.lsp.CompletionItemKind.Function, detail = '∩' },
	{ label = '\\rightarrow', kind = cmp.lsp.CompletionItemKind.Function, detail = '→' },
	{ label = '\\Rightarrow', kind = cmp.lsp.CompletionItemKind.Function, detail = '⇒' },
	{ label = '\\leftarrow', kind = cmp.lsp.CompletionItemKind.Function, detail = '←' },
	{ label = '\\begin', kind = cmp.lsp.CompletionItemKind.Function, detail = 'environment' },
	{ label = '\\end', kind = cmp.lsp.CompletionItemKind.Function, detail = 'environment' },
}

function source.new()
	return setmetatable({}, { __index = source })
end

function source.get_keyword_pattern()
	return '\\\\\\w\\+'
end

function source:complete(_, callback)
	callback(items)
end

return source
