import vim

def math():
	return vim.eval('vimtex#syntax#in_mathzone()') == '1'

def comment():
	return vim.eval('vimtex#syntax#in_comment()') == '1'

def env(name):
	[x,y] = vim.eval("vimtex#env#is_inside('" + name + "')")
	return x != '0' and y != '0'
