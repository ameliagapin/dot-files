"set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "Monoterm"
hi Boolean         ctermfg=13
hi Character       ctermfg=3
hi Number          ctermfg=13
hi String          ctermfg=3
hi Conditional     ctermfg=9               cterm=bold
hi Constant        ctermfg=13              cterm=bold
hi Cursor                     ctermbg=15
hi iCursor                    ctermbg=15
hi Debug           ctermfg=5               cterm=bold
hi Define          ctermfg=12
hi Delimiter       ctermfg=8
hi DiffAdd         ctermfg=14 ctermbg=7
hi DiffChange      ctermfg=8  ctermbg=0
hi DiffDelete      ctermfg=6  ctermbg=0
hi DiffText                   ctermbg=7    cterm=italic,bold

hi Directory       ctermfg=10              cterm=bold
hi Error           ctermfg=6  ctermbg=0
hi ErrorMsg        ctermfg=9  ctermbg=0    cterm=bold
hi Exception       ctermfg=10              cterm=bold
hi Float           ctermfg=13
hi FoldColumn      ctermfg=7
hi Folded          ctermfg=7
hi Function        ctermfg=10
hi Identifier      ctermfg=2
hi Ignore          ctermfg=8
hi IncSearch       ctermfg=11

hi Keyword         ctermfg=9               cterm=bold
hi Label           ctermfg=3               cterm=none
hi Macro           ctermfg=11              cterm=italic
hi SpecialKey      ctermfg=12              cterm=italic

hi MatchParen                  ctermbg=2   cterm=bold
hi ModeMsg         ctermfg=3
hi MoreMsg         ctermfg=3
hi Operator        ctermfg=9

" complete menu
hi Pmenu           ctermfg=15  ctermbg=0
hi PmenuSel        ctermfg=15  ctermbg=8
"hi PmenuSbar
hi PmenuThumb      ctermfg=12

hi PreCondit       ctermfg=10              cterm=bold
hi PreProc         ctermfg=10
hi Question        ctermfg=12
hi Repeat          ctermfg=9               cterm=bold
hi Search          ctermbg=7
" marks
hi SignColumn      ctermfg=10  ctermbg=0
hi SpecialChar     ctermfg=9               cterm=bold
hi SpecialComment  ctermfg=7               cterm=bold
hi Special         ctermfg=12              cterm=italic
if has("spell")
    hi SpellBad    ctermfg=9               cterm=undercurl
    hi SpellCap    ctermfg=14              cterm=undercurl
    hi SpellLocal  ctermfg=4               cterm=undercurl
    hi SpellRare                           cterm=undercurl
endif
hi Statement       ctermfg=9               cterm=bold
hi StatusLine      ctermfg=7
hi StatusLineNC    ctermfg=8
hi StorageClass    ctermfg=2               cterm=italic
hi Structure       ctermfg=12
hi Tag             ctermfg=9               cterm=italic
hi Title           ctermfg=1
hi Todo                                    cterm=bold

hi Typedef         ctermfg=12
hi Type            ctermfg=12              cterm=none
hi Underlined      ctermfg=8               cterm=underline

hi VertSplit       ctermfg=8               cterm=bold
hi VisualNOS                     ctermbg=7
hi Visual                        ctermbg=7
" hi WarningMsg    ctermbg=#333333         cterm=bold
hi WildMenu        ctermfg=12
" hi Normal        ctermfg=1     ctermbg=7
hi Comment         ctermfg=8               cterm=italic
hi CursorLine                    ctermbg=0 cterm=NONE
hi CursorLineNr    ctermfg=8     ctermbg=0
hi CursorColumn                  ctermbg=0
hi ColorColumn                   ctermbg=0
hi LineNr          ctermfg=7
hi NonText         ctermfg=7
hi SpecialKey      ctermfg=7
