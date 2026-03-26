--------------------------------------------------------------------------------
-- PLUGIN: snacks.nvim
--
-- O QUE É:
-- O snacks.nvim é uma coleção de pequenos plugins utilitários de alta performance,
-- desenvolvida por Folke Lemaitre (criador do LazyVim), focada em melhorias de
-- qualidade de vida e interface para o Neovim.
--
-- O QUE FAZ:
-- Este plugin provê diversas funcionalidades centrais, como:
-- 1. Picker: Um seletor ultra rápido para arquivos, buffers e buscas, com suporte
--    a "fuzzy search" e visualização prévia (preview).
-- 2. Explorer: Um explorador de arquivos lateral otimizado para o teclado.
-- 3. Outros: Dashboard inicial, gerenciamento de notificações, guias de indentação
--    visual e modos de interface como o Zen Mode.
--
-- ONDE É USADO:
-- É o motor principal de navegação no LazyVim, substituindo ou complementando
-- ferramentas como o Telescope para tarefas cotidianas de abertura de arquivos
-- e busca no projeto.
--
-- LISTA DO ATALHO PRINCIPAL:
-- <leader><leader> : Atalho mestre para o localizador de arquivos (Root Dir).
--------------------------------------------------------------------------------

return {
	"folke/snacks.nvim",
	opts = {
		picker = {
			sources = {
				files = {
					hidden = true, -- Ativa a visualização de arquivos ocultos
				},
			},
		},
	},
}
