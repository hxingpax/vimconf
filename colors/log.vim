" Quit if a syntax file is already being loaded
if exists("b:current_syntax")
  finish
endif

" Define the syntax matching patterns
syn match logError "^\d\+:\d\+:\d\+\(\.\d\+\)\?|E|.\+"
syn match logWarning "^\d\+:\d\+:\d\+\(\.\d\+\)\?|W|.\+"
syn match logDebug "^\d\+:\d\+:\d\+\(\.\d\+\)\?|D|.\+"
syn match logTest "^\d\+:\d\+:\d\+\(\.\d\+\)\?|I|.\+"

" Define the highlighting for each pattern
hi def logError ctermfg=Red guifg=Red
hi def logWarning ctermfg=Yellow guifg=Yellow
hi def logDebug ctermfg=DarkGrey guifg=DarkGrey

" Set the current syntax to 'log'
let b:current_syntax = "log"
