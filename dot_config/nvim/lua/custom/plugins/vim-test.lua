return {
	'vim-test/vim-test',
	dependencies = {
		"preservim/vimux",
	},
	vim.keymap.set('n', '<leader>tt', ':TestNearest<cr>', { desc = 'Run nearest test' }),
	vim.keymap.set('n', '<leader>tT', ':TestFile<cr>', { desc = 'Run test file' }),
	vim.keymap.set('n', '<leader>ta', ':TestSuite<cr>', { desc = 'Run test suite' }),
	vim.keymap.set('n', '<leader>tl', ':TestLast<cr>', { desc = 'Run last test' }),
	vim.keymap.set('n', '<leader>tg', ':TestVisit<cr>', { desc = 'Go to test' }),
	vim.cmd('let test#strategy = "vimux"'),
}
