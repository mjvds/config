local C = vim.cmd

-- C('hi EndOfBuffer ctermfg=235')
-- C('hi Normal ctermbg=234')
-- C('hi NormalNC ctermbg=235')
-- C('hi VertSplit cterm=NONE ctermfg=239')
-- C('hi CursorLine cterm=NONE ctermbg=236')
-- C('hi NormalFloat ctermbg=237')
-- C('hi Comment ctermfg=8')
-- C('hi Folded ctermfg=8 ctermbg=236')
-- C('hi Pmenu ctermbg=235 ctermfg=251')
-- C('hi PmenuSel ctermbg=236 ctermfg=250')
-- C('hi TabLineFill ctermbg=234')
-- C('hi TabLine ctermbg=234')
-- C('hi Comment ctermfg=244')

C("hi DiagnosticUnderlineError ctermfg=196")
C("hi DiagnosticUnderlineHint ctermfg=32")
C("hi DiagnosticUnderlineWarning ctermfg=226")
C("hi DiagnosticUnderlineInformation ctermfg=148")
C("hi DiagnosticError ctermfg=196")
C("hi DiagnosticWarning ctermfg=226")
C("hi DiagnosticHint ctermfg=32")
C("hi DiagnosticInformation ctermfg=148")
C("hi LspSignatureActiveParameter cterm=bold")
C("hi MyFloatingPreviewBorder ctermbg=237 ctermfg=233")

C('hi LspSignatureActiveParameter cterm=underline')
C('hi WinSeparator guibg=none guifg=gray')

require 'statusline.my_statusline'
require 'tabline.tabline'
