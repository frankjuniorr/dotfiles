"  ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"  ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"  ██║   ██║██║██╔████╔██║██████╔╝██║     
"  ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"   ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"    ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"                                         


"				Configurações necessárias para o Eclim
"---------------------------------------------------------------------------------------
"filetype plugin indent on
"set nocompatible

"				Pathogen - Plugin para instalar plugins -
"---------------------------------------------------------------------------------------
"execute pathogen#infect('bundle/{}')
syntax on
filetype plugin indent on

"							Esquema de Cores
"---------------------------------------------------------------------------------------
"colorscheme molokai
"colorscheme twilight256


"							Teclas de Atalhos
"---------------------------------------------------------------------------------------
" [F12] carregar o ~/.vimrc
nmap <F12> :<C-u>source ~/.vimrc <BAR> echo "Vimrc recarregado!" <CR>

" ------ Split
" [ALT + right] mover o foco para o split da direita
map <M-Right> <C-w><right>
" [ALT + left] mover o foco para o split da esquerda 
map <M-Left> <C-w><left>
" [ALT + up] mover o foco para o split de cima 
map <M-Up> <C-w><up>
" [ALT + down] mover o foco para o split de baixo 
map <M-down> <C-w><down>

" ------ Abas
" [CTRL + T] para abrir uma nova aba
map <C-T> :tabnew <CR>
" [CTRL + w] ir para proxima aba
map <C-W> :tabclose <CR>
" [CTRL + PageUp] ir para aba anterior
map <C-PageUp> :tabprevious <CR>
" [CTRL + PageDown] ir para proxima aba
map <C-PageDown> :tabnext <CR>

" [SHIFT + q] aumentar a area de comandos
nmap <S-q> :resize +4 <CR>
" [SHIFT + w] diminuir a area de comandos
nmap <S-w> :resize -4 <CR>

" [CTRL + up] mover a linha para a linha de cima
nmap <C-Up> ddkP
" [CTRL + down] mover a linha para a linha de baixo
nmap <C-Down> ddp

" [SHIFT + h] Tira as cores das ocorrências de busca e recoloca
nno <S-h> :set hls!<bar>set hls?<CR>


								 "Opção do SET
"---------------------------------------------------------------------------------------
set autoindent 									"Identação Automática
set number										" Mostrar numeros das linhas
set ruler 										"Mostra a posição do Cursor
set wildmode=longest,list 						"Completa os Tabs igual ao Bash
set sm 											"Mostra o par de parentese recem fechados
set showcmd 									"Mostra o comando sendo executado
set tabstop=4 									"Numeros de caracteres de Avanço do TAB
set viminfo='10,\"30,:20,%,n~/.viminfo 			"Guarda a Posição do Cursor, podendo copiar uma linha aqui e colar em outro arquivo
set incsearch 									"Busca Incremental
set titleold=bye\ bye
set backup


" Busca colorida em verde
hi IncSearch ctermbg=black ctermfg=green


set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
setlocal laststatus=2

set statusline=%t%m%r%h%w
\%=
\[ASCII=%03b]
\[HEX=%02B]
\[\XY=%04v,%04l]
\[%03P]

" barra de status com fundo branco e texto preto
highlight StatusLine ctermfg=white   ctermbg=black

"Abreviações úteis para a sua sanidade mental, já dizia o Aurelio
"---------------------------------------------------------------------------------------
cab W  w
cab Wq wq
cab wQ wq
cab WQ wq
cab Q  q

" criando um comando para abrir o ~/.vimrc em uma nova tab
cab fvimrc_tab tabnew<CR>:e ~/.vimrc
" criando um comando para abrir o ~/.vimrc em um novo split
cab fvimrc_split vsplit ~/.vimrc

" palavra '@@' para o cabeçalho de scripts em shell
iab @@ !#\bin\bash
