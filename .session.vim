let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/godot/descent
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 ~/Documents/GitHub/website/style.scss
badd +61 scenes/player/player.gd
badd +7 ~/godot/descent/scenes/camera/main_camera.gd
badd +68 scenes/character_select/character_select.gd
badd +5 global/classes/filtered_input_map.gd
badd +1 ~/godot/descent/global/global_particle_manager.gd
badd +18 scenes/player/hud/player_hud_controller.gd
badd +19 scenes/player/hud/hud_layer.gd
badd +16 scenes/entity/entity.gd
badd +12 ~/godot/descent/scenes/player/hud/player_hud.gd
badd +20 scenes/weapon/generic_melee.gd
badd +1 ~/godot/descent/scenes/level/level.gd
badd +48 scenes/world/world.gd
badd +2 global/autoload/world_generation.gd
badd +3 global/classes/resource_pool.gd
badd +104 ~/godot/descent/addons/inspector_extender/attributes/table.gd
badd +77 ~/Documents/Projects/rust/text-adventure/src/main.rs
argglobal
%argdel
$argadd scenes/world/world.gd
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit scenes/world/world.gd
argglobal
balt ~/godot/descent/scenes/level/level.gd
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 57 - ((28 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 57
normal! 020|
tabnext
edit global/classes/resource_pool.gd
argglobal
balt scenes/world/world.gd
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 4 - ((3 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 4
normal! 0
tabnext
edit global/autoload/world_generation.gd
argglobal
balt scenes/world/world.gd
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 2 - ((1 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 2
normal! 0
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
