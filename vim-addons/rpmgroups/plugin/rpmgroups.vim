" File: rpmgroups.vim
" Summary: This is a plugin for vim to ...
" Author: yetist <wuxiaotian@redflag-linux.com>
" URL: http://git.linux-ren.org/qomo-toolkit
" License: 
" 
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
" 
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
" 
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.
" Version: 2010-07-12 16:39:19
" Usage: when editing spec file in insert mode, type "\" and "g", will show a
" popupmenu to select a RPM GROUP.
" Customization:
"

func! CompleteRPMGroups()
    let mylist=[]
    call add(mylist, "Amusements/Games")
    call add(mylist, "Amusements/Graphics")
    call add(mylist, "Applications/Archiving")
    call add(mylist, "Applications/Communications")
    call add(mylist, "Applications/Databases")
    call add(mylist, "Applications/Editors")
    call add(mylist, "Applications/Emulators")
    call add(mylist, "Applications/Engineering")
    call add(mylist, "Applications/File")
    call add(mylist, "Applications/Internet")
    call add(mylist, "Applications/Multimedia")
    call add(mylist, "Applications/Productivity")
    call add(mylist, "Applications/Publishing")
    call add(mylist, "Applications/System")
    call add(mylist, "Applications/Text")
    call add(mylist, "Development/Debuggers")
    call add(mylist, "Development/Languages")
    call add(mylist, "Development/Libraries")
    call add(mylist, "Development/System")
    call add(mylist, "Development/Tools")
    call add(mylist, "Documentation")
    call add(mylist, "System Environment/Base")
    call add(mylist, "System Environment/Daemons")
    call add(mylist, "System Environment/Kernel")
    call add(mylist, "System Environment/Libraries")
    call add(mylist, "System Environment/Shells")
    call add(mylist, "User Interface/Desktops")
    call add(mylist, "User Interface/X")
    call add(mylist, "User Interface/X Hardware Support")
    let line = getline('.')
    let end = col('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    let base=strpart(getline("."), start, end-start)

    let res=[]
    for m in mylist
      if m =~ '^' . base
	call add(res, m)
      endif
    endfor
    call complete(start+1, res)
   return ''
endfunc
au Filetype spec inoremap \g <C-R>=CompleteRPMGroups()<CR>
