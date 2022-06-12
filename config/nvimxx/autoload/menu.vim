let g:menu = {
      \ 'checkbox_col_pos': 6,
      \ 'checkbox_item_prefix': '    ',
      \ 'checkbox_symbol_on': '',
      \ 'checkbox_symbol_off': '',
      \ 'win_pos': 'bottom'
      \ }

function menu#generate_items()
  let items = [g:menu.checkbox_item_prefix . 'List of commands']
  call add(items, '')

  for cmd in g:menu_commands
    if get(cmd, 'job_id', -1) == -1
      call add(items, g:menu.checkbox_item_prefix . '['. g:menu.checkbox_symbol_off . '] - ' . cmd['text'])
    else
      call add(items, g:menu.checkbox_item_prefix . '[' . g:menu.checkbox_symbol_on . '] - ' . cmd['text'])
    endif
  endfor
  return items
endfunction

function menu#get_item(id, property)
  for cmd in g:menu_commands
    if get(cmd, a:property, -1) == a:id
      return cmd
    endif
  endfor
  return {}
endfunction

function menu#open()
  if len(g:menu_commands) == 0
    return
  endif
  let g:menu.commands = g:menu_commands
  let items = menu#generate_items()
  let opts = menu#create_win_option()
  let g:menu.buf = nvim_create_buf(v:false, v:true)
  let g:menu.win = nvim_open_win(g:menu.buf, v:true, opts)
  call nvim_buf_set_lines(g:menu.buf, 0, -1, v:true, items)

  setlocal
        \ buftype=nofile
        \ nobuflisted
        \ bufhidden=hide
        \ nonumber
        \ norelativenumber
        \ signcolumn=no
        \ nomodifiable

  autocmd CursorMoved <buffer> call menu#move_to_checkbox()
  autocmd BufLeave <buffer> ++once call menu#close()
  nmap <silent> <buffer> <Enter> :call menu#toggle_item()<cr>
  nmap <silent> <buffer> <Space> :call menu#toggle_item(1)<cr>
  nmap <silent> <buffer> o : call menu#open_output_buf()<cr>
  " nmap <silent> <buffer> <c-Up>: call menu#move_to_top()<cr>
  " move to the first item of the list
  call setpos('.', [0, 3, g:menu.checkbox_col_pos])
endfunction

function menu#move_to_checkbox()
  let curpos = getcurpos()
  let linenr = curpos[1]
  let colnr = curpos[2]
  if linenr <= 2
    call setpos('.', [0, 3, g:menu.checkbox_col_pos])
    return
  endif
  if linenr > 1 && linenr <= line('$')
    if colnr != g:menu.checkbox_col_pos
      call setpos('.', [0, linenr, g:menu.checkbox_col_pos])
    endif
  endif
  let g:menu.cur_line_nr = linenr
endfunction

function menu#toggle_item(...)
  let is_not_background_process = get(a:, 0, 0)
  let current_item_index = line('.') - 3
  let selected_item = g:menu.commands[current_item_index]
  if get(selected_item, 'job_id', -1) == -1
    call menu#run_command(selected_item, is_not_background_process)
  else
    call jobstop(selected_item.job_id)
    let selected_item.job_id = -1
  endif
  call menu#redraw()
endfunction

function menu#open_output_buf()
  let current_item_index = line('.') - 3
  let selected_item = g:menu.commands[current_item_index]
  " if selected item is running a job
  if get(selected_item, 'job_id', -1) != -1
    let selected_item.bufnr = menu#create_output_buf(selected_item)
  else
    echo "no job running on selected item"
  endif
endfunction

function menu#redraw()
  if get(g:menu, 'buf', -1) == -1
    return
  endif
  let items = menu#generate_items()
  call nvim_buf_set_option(g:menu.buf, 'modifiable', v:true)
  call nvim_buf_set_lines(g:menu.buf, 0, -1, v:true, items)
  call nvim_buf_set_option(g:menu.buf, 'modifiable', v:false)
endfunction

function menu#buf_is_open()
  if get(g:menu, 'buf', -1) != -1 && get(g:menu, 'win', -1) != -1
    return v:true
  else
    return v:false
  endif
endfunction

let s:job_std = {}
function s:job_std.on_exit(job_id, data, event)
  " echo a:data
  let item = menu#get_item(a:job_id, 'job_id')
  if empty(item) == 0
    let item.job_id = -1
    call menu#redraw()
  endif
  if a:data != 0
    echo self.item.text . " command exited with return code: " . a:data
  endif
endfunction

function s:job_std.on_stderr(job_id, data, event)
  " echo a:data
  let execution_stopped = len(a:data) == 1
  if execution_stopped == 1
    if menu#buf_is_open() == v:true
      let item = menu#get_item(a:job_id, 'job_id')
      if empty(item) == 0
        let item.job_id = -1
        call menu#redraw()
      endif
    endif
  endif
endfunction

function s:job_std.on_stdout(job_id, data, event)
  " echo a:data
  if get(self.item, 'bufnr', -1) != -1 && nvim_buf_is_loaded(self.item.bufnr)
    call appendbufline(self.item.bufnr, '$', a:data)
  endif
endfunction

function menu#run_command(item, ...)
  let is_not_background_process = get(a:, 1, 0)
  let opts = extend(copy(s:job_std), {
        \ 'name': a:item.text,
        \ 'item': a:item
        \ })

  if get(a:item, 'cwd', '') != ''
    let opts.cwd = getcwd() . '/' . a:item.cwd
  endif
  
  if get(g:, 'use_internal_term', 0) && is_not_background_process
    call remove(opts, 'on_stdout')
    call remove(opts, 'on_stderr')
    call menu#close()
    execute 'tabnew'
    let a:item.job_id = termopen(a:item.cmd, opts)
  elseif is_not_background_process
    let a:item.job_id = jobstart(['bash', '-c', 'urxvt -e sh -c "' . a:item.cmd . ' && bash"'], opts)
  else
    let a:item.job_id = jobstart(['bash', '-c', a:item.cmd], opts)
  endif
  return a:item.job_id
endfunction

function menu#close()
  if get(g:menu, 'win', -1) != -1
    call nvim_win_close(g:menu.win, v:true)
  endif
  let g:menu.buf = -1
  let g:menu.win = -1
  let g:menu.win_pos = 'bottom'
endfunction

function menu#repaint()
  if get(g:menu, 'win', -1) != -1
    call menu#close()
    call menu#open()
  endif
endfunction

function menu#create_win_option()
  let height = &lines / 2
  let offset = height - 1
  let width = &columns
  let opts = {
        \   'relative': 'editor',
        \   'row': offset,
        \   'col': height,
        \   'height': offset,
        \   'width': width
        \ }
  return opts
endfunction

function menu#create_output_buf(item)
  let opts = menu#create_win_option()
  let bufnr = nvim_create_buf(v:false, v:true)
  call nvim_open_win(bufnr, v:true, opts)
  setlocal
        \ buftype=nofile
        \ nobuflisted
        \ bufhidden=hide
        \ nonumber
        \ norelativenumber
        \ signcolumn=no
  autocmd QuitPre <buffer> ++once call menu#output_buf_closed()
  return bufnr
endfunction

function menu#output_buf_closed()
  let item = menu#get_item(bufnr('$'), 'bufnr')
  if empty(item) == 0
    let item.bufnr = -1
  endif
endfunction

function menu#move_to_top()
  let win_id = get(g:menu, 'win', -1)
  if win_id != -1 && get(g:menu, 'win_pos', '') != "top"
    let config = {
          \   'relative': 'editor',
          \   'col': &lines / 2,
          \   'row': 1,
          \   'height': &lines / 2,
          \   'width': &columns
          \ }
    call nvim_win_set_config(win_id, config)
  endif
endfunction
