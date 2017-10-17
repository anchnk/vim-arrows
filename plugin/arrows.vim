" arrows.vim - Tmux-like window resizing with arrow keys for vim
"
"              Originally forked from: http://stackoverflow.com/a/36653470
"              Thanks to @limeth

if !exists('g:vim_arrows_resize_amount')
  let g:vim_arrows_resize_amount = 1
endif

function! IsEdgeWindowSelected(direction)
  let l:curwindow = winnr()
  exec "wincmd ".a:direction
  let l:result = l:curwindow == winnr()

  if (!l:result)
    " Go back to the previous window
    exec l:curwindow."wincmd w"
  endif

  return l:result
endfunction

function! GetAction(direction)
  let l:keys = ['h', 'j', 'k', 'l']
  let l:actions = ['vertical resize -', 'resize +', 'resize -', 'vertical resize +']
  return get(l:actions, index(l:keys, a:direction))
endfunction

function! GetOpposite(direction)
  let l:keys = ['h', 'j', 'k', 'l']
  let l:opposites = ['l', 'k', 'j', 'h']
  return get(l:opposites, index(l:keys, a:direction))
endfunction

function! TmuxResize(direction, amount)
  " v >
  if (a:direction == 'j' || a:direction == 'l')
    if IsEdgeWindowSelected(a:direction)
      let l:opposite = GetOpposite(a:direction)
      let l:curwindow = winnr()
      exec 'wincmd '.l:opposite
      let l:action = GetAction(a:direction)
      exec l:action.a:amount
      exec l:curwindow.'wincmd w'
      return
    endif
    " < ^
  elseif (a:direction == 'h' || a:direction == 'k')
    let l:opposite = GetOpposite(a:direction)
    if IsEdgeWindowSelected(l:opposite)
      let l:curwindow = winnr()
      exec 'wincmd '.a:direction
      let l:action = GetAction(a:direction)
      exec l:action.a:amount
      exec l:curwindow.'wincmd w'
      return
    endif
  endif

  let l:action = GetAction(a:direction)
  exec l:action.a:amount
endfunction

nnoremap <silent> <left> :call TmuxResize('h', g:vim_arrows_resize_amount)<cr>
nnoremap <silent> <down> :call TmuxResize('j', g:vim_arrows_resize_amount)<cr>
nnoremap <silent> <up> :call TmuxResize('k', g:vim_arrows_resize_amount)<cr>
nnoremap <silent> <right> :call TmuxResize('l', g:vim_arrows_resize_amount)<cr>
