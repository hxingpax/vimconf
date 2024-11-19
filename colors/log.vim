" Quit if a syntax file is already being loaded
if exists("b:current_syntax")
  finish
endif

" Define the syntax matching patterns
syn match logError "^\d\+:\d\+:\d\+\(\.\d\+\)\?|\(E\|ERROR\|ERR\|error\|err\|Error\)|.\+"
syn match logWarning "^\d\+:\d\+:\d\+\(\.\d\+\)\?|\(W\|WARNING\|WARN\|warning\|war\|Warning\)|.\+"
syn match logDebug "^\d\+:\d\+:\d\+\(\.\d\+\)\?|\(D\|DEBUG\|DEB\|debug\|deb\|Debug\)|.\+"

" Define the highlighting for each pattern
hi def logError ctermfg=Magenta guifg=Magenta
hi def logWarning ctermfg=Yellow guifg=Yellow
hi def logDebug ctermfg=DarkGrey guifg=DarkGrey

" Set the current syntax to 'log'
let b:current_syntax = "log"
