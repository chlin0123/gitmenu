" GITmenu.vim : Vim menu for using GIT			vim:tw=0:sw=2:ts=8
" Author : Chi-hsien Lin				vim600:fdm=marker
" License : LGPL
"
" Tested with Vim 7.4
" Modified from Throsten Maerz's cvsmenu (https://www.vim.org/scripts/script.php?script_id=58)
"
" Change Log:
" [12/30/2016]
"  - Added git support

"#############################################################################
" Settings
"#############################################################################
" global variables : may be set in ~/.vimrc	{{{1

" this *may* interfere with :help (inhibits highlighting)
" disable autocheck, if this happens to you.
if ($GITOPT == '')
"  let $GITOPT='-z9'
endif

if ($GITCMD == '')
  let $GITCMD='git'
endif

if !exists("g:GITforcedirectory")
  let g:GITforcedirectory = 0		" 0:off 1:once 2:forever
endif
if !exists("g:GITqueryrevision")
  let g:GITqueryrevision = 0		" 0:fast update 1:query for revisions
endif
if !exists("g:GITdumpandclose")
  let g:GITdumpandclose = 2		" 0:new buffer 1:statusline 2:autoswitch
endif
if !exists("g:GITsortoutput")
  let g:GITsortoutput = 1		" sort git output (group conflicts,updates,...)
endif
if !exists("g:GITcompressoutput")
  let g:GITcompressoutput = 1		" show extended output only if error
endif
if !exists("g:GITtitlebar")
  let g:GITtitlebar = 1			" notification output to titlebar
endif
if !exists("g:GITstatusline")
  let g:GITstatusline = 1		" notification output to statusline
endif
if !exists("g:GITautocheck")
  let g:GITautocheck = 1		" do local status on every read/write
endif
if !exists("g:GITeasylogmessage")
  let g:GITeasylogmessage = 1		" make editing log message easier
endif
if !exists("g:GITofferrevision")
  let g:GITofferrevision = 1		" offer current revision on queries
endif
if !exists("g:GITsavediff")
  let g:GITsavediff = 1			" save settings when using :diff
endif
if !exists("g:GITdontswitch")
  let g:GITdontswitch = 0		" don't switch to diffed file
endif
if !exists("g:GITdefaultmsg")
  let g:GITdefaultmsg = ''		" message to use for commands below
endif
if !exists("g:GITusedefaultmsg")
  let g:GITusedefaultmsg = 'aj'		" a:Add, i:Commit, j:Join in, p:Import
endif
if !exists("g:GITallowemptymsg")
  let g:GITallowemptymsg = 'a'          " a:Add, i:Commit, j:Join in, p:Import
endif
if !exists("g:GITfullstatus")
  let g:GITfullstatus = 0		" display all fields for fullstatus
endif
if !exists("g:GITreloadaftercommit")
  let g:GITreloadaftercommit = 1	" reload file to update GIT keywords
endif
if !exists("g:GITlongrev")
  let g:GITlongrev = 0			" print long annotate rev
endif
if !exists("g:GITshortannotate")
  let g:GITshortannotate = 1		" shorten annotate output
endif
if !exists("g:GITspacesinannotate")
  let g:GITspacesinannotate = 1		" spaces to add in annotated source
endif
if !exists("g:GITcmdencoding")
  let g:GITcmdencoding = ''		" the encoding of GIT(NT) commands
endif
if !exists("g:GITfileencoding")
  let g:GITfileencoding = ''		" the encoding of files in GIT
endif
if !exists("g:GITdontconvertfor")
  let g:GITdontconvertfor = ''		" commands that need no conversion
endif
if !exists("g:GITusetmpfolder")
  let g:GITusetmpfolder = 1		" save diff tmp files in /tmp folder instead of current folder
endif

" problems with :help on console
if !(has("gui_running"))
  let g:GITautocheck = 0
endif


" script variables	{{{1
if has('unix')				" path separator
  let s:sep='/'
else
  let s:sep='\'
endif
let s:script_path=expand('<sfile>:p:h')	" location of this script
let s:script_name=expand('<sfile>:p:t')	" should be 'gitmenu.vim'
let s:GITentries='GIT'.s:sep.'Entries'	" location of 'GIT/Entries' file
let s:gitmenuhttp="http://ezytools.git.sourceforge.net/ezytools/VimTools/"
let s:gitmenugit=":pserver:anonymous@ezytools.git.sourceforge.net:/gitroot/ezytools"
let s:GITdontupdatemapping = 0		" don't GITUpdateMapping (internal!)
let s:GITupdatequeryonly = 0		" update -n (internal!)
let s:GITorgtitle = &titlestring	" backup of original title
let g:orgpath = getcwd()
let g:GITleavediff = 0
let g:GITdifforgbuf = 0

if exists("loaded_gitmenu")
  aunmenu GIT
endif

"-----------------------------------------------------------------------------
" Menu entries		{{{1
"-----------------------------------------------------------------------------
" Spaces after items to inhibit translation (no one wants a 'git Differenz':)
" as well as to prevent the hot keys from being altered
" <esc> in Keyword menus to avoid expansion
" use only TAB between menu item and command (used for MakeLeaderMapping)

amenu &GIT.In&fo\ 						:call GITShowInfo()<cr>
"amenu &GIT.Settin&gs\ .In&fo\ (buffer)\ 			:call GITShowInfo(1)<cr>
"amenu &GIT.Settin&gs\ .Show\ &mappings\ 			:call GITShowMapping()<cr>
"amenu &GIT.Settin&gs\ .-SEP1-					:
"amenu &GIT.Settin&gs\ .&Autocheck\ .&Enable\ 			:call GITSetAutocheck(1)<cr>
"amenu &GIT.Settin&gs\ .&Autocheck\ .&Disable\ 			:call GITSetAutocheck(0)<cr>
"amenu &GIT.Settin&gs\ .&Target\ .File\ in\ &buffer\ 		:call GITSetForceDir(0)<cr>
"amenu &GIT.Settin&gs\ .&Target\ .&Directory\ 			:call GITSetForceDir(2)<cr>
"amenu &GIT.Settin&gs\ .&Diff\ .Stay\ in\ &original\ 		:call GITSetDontSwitch(1)<cr>
"amenu &GIT.Settin&gs\ .&Diff\ .Switch\ to\ &diffed\ 		:call GITSetDontSwitch(0)<cr>
"amenu &GIT.Settin&gs\ .&Diff\ .-SEP1-				:
"amenu &GIT.Settin&gs\ .&Diff\ .&Autorestore\ prev\.mode\ 	:call GITSetSaveDiff(1)<cr>
"amenu &GIT.Settin&gs\ .&Diff\ .&No\ autorestore\ 		:call GITSetSaveDiff(0)<cr>
"amenu &GIT.Settin&gs\ .&Diff\ .-SEP2-				:
"amenu &GIT.Settin&gs\ .&Diff\ .Re&store\ pre-diff\ mode\ 	:call GITRestoreDiffMode()<cr>
"amenu &GIT.Settin&gs\ .Revision\ &queries\ .&Enable\ 		:call GITSetQueryRevision(1)<cr>
"amenu &GIT.Settin&gs\ .Revision\ &queries\ .&Disable\ 		:call GITSetQueryRevision(0)<cr>
"amenu &GIT.Settin&gs\ .Revision\ &queries\ .-SEP1-		:
"amenu &GIT.Settin&gs\ .Revision\ &queries\ .&Offer\ current\ rev\ 	:call GITSetOfferRevision(1)<cr>
"amenu &GIT.Settin&gs\ .Revision\ &queries\ .&Hide\ current\ rev\ 	:call GITSetOfferRevision(0)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .N&otifcation.Enable\ &statusline\ 	:call GITSetStatusline(1)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .N&otifcation.Disable\ status&line\ 	:call GITSetStatusline(0)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .N&otifcation.-SEP1-			:
"amenu &GIT.Settin&gs\ .&Output\ .N&otifcation.Enable\ &titlebar\ 	:call GITSetTitlebar(1)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .N&otifcation.Disable\ title&bar\ 	:call GITSetTitlebar(0)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .-SEP1-				:
"amenu &GIT.Settin&gs\ .&Output\ .To\ new\ &buffer\ 		:call GITSetDumpAndClose(0)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .&Notify\ only\ 		:call GITSetDumpAndClose(1)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .&Autoswitch\ 			:call GITSetDumpAndClose(2)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .-SEP2-				:
"amenu &GIT.Settin&gs\ .&Output\ .&Compressed\ 			:call GITSetCompressOutput(1)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .&Full\ 			:call GITSetCompressOutput(0)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .-SEP3-				:
"amenu &GIT.Settin&gs\ .&Output\ .&Sorted\ 			:call GITSetSortOutput(1)<cr>
"amenu &GIT.Settin&gs\ .&Output\ .&Unsorted\ 			:call GITSetSortOutput(0)<cr>
"amenu &GIT.Settin&gs\ .-SEP2-					:
"amenu &GIT.Settin&gs\ .&Install\ .&Install\ updates\ 		:call GITInstallUpdates()<cr>
"amenu &GIT.Settin&gs\ .&Install\ .&Download\ updates\ 		:call GITDownloadUpdates()<cr>
"amenu &GIT.Settin&gs\ .&Install\ .Install\ buffer\ as\ &help\ 	:call GITInstallAsHelp()<cr>
"amenu &GIT.Settin&gs\ .&Install\ .Install\ buffer\ as\ &plugin\ 	:call GITInstallAsPlugin()<cr>
"amenu &GIT.&Keyword\ .&Author\ 					a$Author<esc>a$<esc>
"amenu &GIT.&Keyword\ .&Date\ 					a$Date<esc>a$<esc>
"amenu &GIT.&Keyword\ .&Header\ 					a$Header<esc>a$<esc>
"amenu &GIT.&Keyword\ .&Id\ 					a$Id<esc>a$<esc>
"amenu &GIT.&Keyword\ .&Name\ 					a$Name<esc>a$<esc>
"amenu &GIT.&Keyword\ .Loc&ker\ 					a$Locker<esc>a$<esc>
"amenu &GIT.&Keyword\ .&Log\ 					a$Log<esc>a$<esc>
"amenu &GIT.&Keyword\ .RCS&file\ 				a$RCSfile<esc>a$<esc>
"amenu &GIT.&Keyword\ .&Revision\ 				a$Revision<esc>a$<esc>
"amenu &GIT.&Keyword\ .&Source\ 					a$Source<esc>a$<esc>
"amenu &GIT.&Keyword\ .S&tate\ 					a$State<esc>a$<esc>
"amenu &GIT.Director&y\ .&Log\ 					:call GITlog_dir()<cr>
"amenu &GIT.Director&y\ .&Status\ 				:call GITstatus_dir()<cr>
"amenu &GIT.Director&y\ .S&hort\ status\ 			:call GITshortstatus_dir()<cr>
"amenu &GIT.Director&y\ .Lo&cal\ status\ 			:call GITLocalStatus_dir()<cr>
"amenu &GIT.Director&y\ .-SEP1-					:
"amenu &GIT.Director&y\ .&Query\ update\ 			:call GITqueryupdate_dir()<cr>
"amenu &GIT.Director&y\ .&Update\ 				:call GITupdate_dir()<cr>
"amenu &GIT.Director&y\ .-SEP2-					:
"amenu &GIT.Director&y\ .&Add\ 					:call GITadd_dir()<cr>
"amenu &GIT.Director&y\ .Comm&it\ 				:call GITcommit_dir()<cr>
"amenu &GIT.Director&y\ .-SEP3-					:
"amenu &GIT.Director&y\ .Re&move\ from\ repositoy\ 		:call GITremove_dir()<cr>
"amenu &GIT.E&xtra\ .&Create\ patchfile\ .&Context\ 		:call GITdiffcontext()<cr>
"amenu &GIT.E&xtra\ .&Create\ patchfile\ .&Standard\ 		:call GITdiffstandard()<cr>
"amenu &GIT.E&xtra\ .&Create\ patchfile\ .&Uni\ 			:call GITdiffuni()<cr>
amenu &GIT.E&xtra\ .Diff\ to\ &revision\ 			:call GITdifftorev()<cr>
"amenu &GIT.E&xtra\ .&Log\ to\ revision\ 			:call GITlogtorev()<cr>
"amenu &GIT.E&xtra\ .-SEP1-					:
"amenu &GIT.E&xtra\ .Check&out\ revision\ 			:call GITcheckoutrevision()<cr>
"amenu &GIT.E&xtra\ .&Update\ to\ revision\ 			:call GITupdatetorev()<cr>
"amenu &GIT.E&xtra\ .&Merge\ in\ revision\ 			:call GITupdatemergerev()<cr>
"amenu &GIT.E&xtra\ .Merge\ in\ revision\ di&ffs\ 		:call GITupdatemergediff()<cr>
"amenu &GIT.E&xtra\ .-SEP2-					:
"amenu &GIT.E&xtra\ .Comm&it\ to\ revision\ 			:call GITcommitrevision()<cr>
"amenu &GIT.E&xtra\ .Im&port\ to\ revision\ 			:call GITimportrevision()<cr>
"amenu &GIT.E&xtra\ .&Join\ in\ to\ revision\ 			:call GITjoininrevision()<cr>
"amenu &GIT.E&xtra\ .-SEP3-					:
"amenu &GIT.E&xtra\ .GIT\ lin&ks\ 				:call GITOpenLinks()<cr>
"amenu &GIT.E&xtra\ .&Get\ file\ 				:call GITGet()<cr>
"amenu &GIT.E&xtra\ .Get\ file\ (pass&word)\ 			:call GITGet('','','io')<cr>
"amenu &GIT.-SEP1-						:
"amenu &GIT.Ad&min\ .Log&in\ 					:call GITlogin()<cr>
"amenu &GIT.Ad&min\ .Log&out\ 					:call GITlogout()<cr>
"amenu &GIT.D&elete\ .Re&move\ from\ repository\ 		:call GITremove()<cr>
"amenu &GIT.D&elete\ .Re&lease\ workdir\ 			:call GITrelease()<cr>
"amenu &GIT.&Tag\ .&Create\ tag\ 				:call GITtag()<cr>
"amenu &GIT.&Tag\ .&Remove\ tag\ 				:call GITtagremove()<cr>
"amenu &GIT.&Tag\ .Create\ &branch\ 				:call GITbranch()<cr>
"amenu &GIT.&Tag\ .-SEP1-					:
"amenu &GIT.&Tag\ .Cre&ate\ tag\ by\ module\ 			:call GITrtag()<cr>
"amenu &GIT.&Tag\ .Rem&ove\ tag\ by\ module\ 			:call GITrtagremove()<cr>
"amenu &GIT.&Tag\ .Create\ branc&h\ by\ module\ 			:call GITrbranch()<cr>
"amenu &GIT.&Watch/Edit\ .&Watchers\ 				:call GITwatchwatchers()<cr>
"amenu &GIT.&Watch/Edit\ .Watch\ &add\ 				:call GITwatchadd()<cr>
"amenu &GIT.&Watch/Edit\ .Watch\ &remove\ 			:call GITwatchremove()<cr>
"amenu &GIT.&Watch/Edit\ .Watch\ o&n\ 				:call GITwatchon()<cr>
"amenu &GIT.&Watch/Edit\ .Watch\ o&ff\ 				:call GITwatchoff()<cr>
"amenu &GIT.&Watch/Edit\ .-SEP1-					:
"amenu &GIT.&Watch/Edit\ .&Editors\ 				:call GITwatcheditors()<cr>
"amenu &GIT.&Watch/Edit\ .Edi&t\ 				:call GITwatchedit()<cr>
"amenu &GIT.&Watch/Edit\ .&Unedit\ 				:call GITwatchunedit()<cr>
"amenu &GIT.-SEP2-						:
amenu &GIT.&Diff\ 						:call GITdiff()<cr>
amenu &GIT.Diffto&Parent\					:call GITdifftoparent()<cr>
amenu &GIT.A&nnotate\ 						:call GITannotate()<cr>
"amenu &GIT.Histo&ry\ 						:call GIThistory()<cr>
amenu &GIT.&Log\ 						:call GITlog()<cr>
amenu &GIT.&Status\ 						:call GITstatus()<cr>
"amenu &GIT.S&hort\ status\ 					:call GITshortstatus()<cr>
"amenu &GIT.Lo&cal\ status\ 					:call GITLocalStatus()<cr>
"amenu &GIT.-SEP3-						:
"amenu &GIT.Check&out\ 						:call GITcheckout()<cr>
"amenu &GIT.&Query\ update\ 					:call GITqueryupdate()<cr>
"amenu &GIT.&Update\ 						:call GITupdate()<cr>
"amenu &GIT.Re&vert\ changes\ 					:call GITrevertchanges()<cr>
"amenu &GIT.-SEP4-						:
"amenu &GIT.&Add\ 						:call GITadd()<cr>
"amenu &GIT.Comm&it\ 						:call GITcommit()<cr>
"amenu &GIT.Im&port\ 						:call GITimport()<cr>
"amenu &GIT.&Join\ in\ 						:call GITjoinin()<cr>

" create key mappings from this script		{{{1
" key mappings : <Leader> (mostly '\' ?), then same as menu hotkeys
" e.g. <ALT>ci = \ci = GIT.Commit
function! GITMakeLeaderMapping()
  silent! call GITMappingFromMenu(s:script_path.s:sep.s:script_name,',')
endfunction

function! GITMappingFromMenu(filename,...)
  if !filereadable(a:filename)
    return
  endif
  if a:0 == 0
    let leader = '<Leader>'
  else
    let leader = a:1
  endif
  " create mappings from &-chars
  new
  exec 'read '.GITEscapePath(a:filename)
  " leave only amenu defs
  exec 'g!/^\s*amenu/d'
  " delete separators and blank lines
  exec 'g/\.-SEP/d'
  exec 'g/^$/d'
  " count entries
  let entries=line("$")
  " extract menu entries, put in @m
  exec '%s/^\s*amenu\s\([^'."\t".']*\).\+/\1/eg'
  exec '%y m'
  " extract mappings from '&'
  exec '%s/&\(\w\)[^&]*/\l\1/eg'
  " create cmd, delete to @k
  exec '%s/^\(.*\)$/nmap '.leader.'\1 :em /eg'
  exec '%d k'
  " restore menu, delete '&'
  normal "mP
  exec '%s/&//eg'
  " visual block inserts failed, when called from script (vim60at)
  " append keymappings
  normal G"kP
  " merge keys/commands, execute
  let curlin=0
  while curlin < entries
    let curlin = curlin + 1
    call setline(curlin,getline(curlin + entries).getline(curlin).'<cr>')
    exec getline(curlin)
  endwhile
  set nomodified
  bwipeout
endfunction

"-----------------------------------------------------------------------------
" escape user message	{{{1
"-----------------------------------------------------------------------------
function! GITEscapeMessage(msg)
  if has('unix')
    let result = escape(a:msg,'"`\')
  else
    let result = escape(a:msg,'"')
    if &shell =~? 'cmd\.exe'
      let result = substitute(result,'\([&<>|^]\)','^\1','g')
    endif
  endif
  return result
endfunction

"-----------------------------------------------------------------------------
" escape file path	{{{1
"-----------------------------------------------------------------------------
function! GITEscapePath(path)
  if has('unix')
    return escape(a:path,' \')
  else
    return a:path
  endif
endfunction

"-----------------------------------------------------------------------------
" show git info		{{{1
"-----------------------------------------------------------------------------
" Param : ToBuffer (bool)
function! GITShowInfo(...)
  if a:0 == 0
    let tobuf = 0
  else
    let tobuf = a:1
  endif
  call GITChDir(expand('%:p:h'))
  " show GIT info from directory
  let gitroot='GIT'.s:sep.'Root'
  let gitrepository='GIT'.s:sep.'Repository'
  silent! exec 'split '.gitroot
  let root=getline(1)
  bwipeout
  silent! exec 'split '.gitrepository
  let repository=getline(1)
  bwipeout
  unlet gitroot gitrepository
  " show settings
  new
  let zbak=@z
  let @z = ''
    \."\n\"GITmenu $Revision: 1.150 $"
    \."\n\"Current directory : ".expand('%:p:h')
    \."\n\"Current Root : ".root
    \."\n\"Current Repository : ".repository
    \."\nlet $GITROOT\t\t= \'"			.$GITROOT."\'"			."\t\" Set environment var to gitroot"
    \."\nlet $GIT_RSH\t\t= \'"			.$GIT_RSH."\'"			."\t\" Set environment var to rsh/ssh"
    \."\nlet $GITOPT\t\t= \'"			.$GITOPT."\'"			."\t\" Set git options (see git --help-options)"
    \."\nlet $GITCMDOPT\t\t= \'"		.$GITCMDOPT."\'"		."\t\" Set git command options"
    \."\nlet $GITCMD\t\t\= '"			.$GITCMD."\'"			."\t\" Set git command"
    \."\nlet g:GITforcedirectory\t= "		.g:GITforcedirectory		."\t\" Refer to directory instead of current file"
    \."\nlet g:GITqueryrevision\t= "		.g:GITqueryrevision		."\t\" Query for revisions (0:no 1:yes)"
    \."\nlet g:GITdumpandclose\t= "		.g:GITdumpandclose		."\t\" Output to: 0=buffer 1=notify 2=autoswitch"
    \."\nlet g:GITsortoutput\t= "		.g:GITsortoutput		."\t\" Toggle sorting output (0:no sorting)"
    \."\nlet g:GITcompressoutput\t= "		.g:GITcompressoutput		."\t\" Show extended output only if error"
    \."\nlet g:GITtitlebar\t= "			.g:GITtitlebar			."\t\" Notification on titlebar"
    \."\nlet g:GITstatusline\t= "		.g:GITstatusline		."\t\" Notification on statusline"
    \."\nlet g:GITautocheck\t= "		.g:GITautocheck			."\t\" Get local status when file is read/written"
    \."\nlet g:GITeasylogmessage\t= "		.g:GITeasylogmessage		."\t\" Ease editing the GIT log message in Vim"
    \."\nlet g:GITofferrevision\t= "		.g:GITofferrevision		."\t\" Offer current revision on queries"
    \."\nlet g:GITsavediff\t= "			.g:GITsavediff			."\t\" Save settings when using :diff"
    \."\nlet g:GITdontswitch\t= "		.g:GITdontswitch		."\t\" Don't switch to diffed file"
    \."\nlet g:GITdefaultmsg\t= \'"		.g:GITdefaultmsg."\'"		."\t\" Message to use for commands below"
    \."\nlet g:GITusedefaultmsg\t= \'"		.g:GITusedefaultmsg."\'"	."\t\" a:Add, i:Commit, j:Join in, p:Import"
    \."\nlet g:GITallowemptymsg\t= \'"		.g:GITallowemptymsg."\'"	."\t\" a:Add, i:Commit, j:Join in, p:Import"
    \."\nlet g:GITfullstatus\t= "		.g:GITfullstatus		."\t\" Display all fields for fullstatus"
    \."\nlet g:GITreloadaftercommit = "		.g:GITreloadaftercommit		."\t\" Reload file to update GIT keywords"
    \."\nlet g:GITshortannotate = "		.g:GITshortannotate		."\t\" Shorten annotate"
    \."\nlet g:GITspacesinannotate = "		.g:GITspacesinannotate		."\t\" Spaces to add in annotated source"
    \."\nlet g:GITcmdencoding = \'"		.g:GITcmdencoding."\'"		."\t\" The encoding of GIT(NT) commands"
    \."\nlet g:GITfileencoding = \'"		.g:GITfileencoding."\'"		."\t\" The encoding of files in GIT"
    \."\nlet g:GITdontconvertfor = \'"		.g:GITdontconvertfor."\'"	."\t\" Commands that need no conversion"
    \."\nlet g:GITusetmpfolder = \'"		.g:GITusetmpfolder."\'"		."\t\" Save diff tmp files in /tmp folder instead of current folder"
    \."\n\"----------------------------------------"
    \."\n\" Change above values to your needs."
    \."\n\" To execute a line, put the cursor on it and press <shift-cr> or doubleclick."
    \."\n\" Site: http://ezytools.git.sourceforge.net/ezytools/VimTools/"
  normal "zP
  let @z=zbak
  normal dd
  if tobuf == 0
    silent! exec '5,$g/^"/d'
    " dont dump this to titlebar
    let titlebak = g:GITtitlebar
    let g:GITtitlebar = 0
    call GITDumpAndClose()
    let g:GITtitlebar = titlebak
    unlet titlebak
  else
    map <buffer> q :bd!<cr>
    map <buffer> <s-cr> :exec getline('.')<cr>:set nomod<cr>:echo getline('.')<cr>
    map <buffer> <2-LeftMouse> <s-cr>
    set syntax=vim
    set nomodified
  endif
  call GITRestoreDir()
  unlet root repository tobuf
endfunction

"-----------------------------------------------------------------------------
" syntax, MakeRO/RW		{{{1
"-----------------------------------------------------------------------------

function! GITUpdateSyntax()
  syn match gitupdateMerge	'^M .*$'
  syn match gitupdatePatch	'^P .*$'
  syn match gitupdateConflict	'^C .*$'
  syn match gitupdateDelete	'^D .*$'
  syn match gitupdateUnknown	'^? .*$'
  syn match gitcheckoutUpdate	'^U .*$'
  syn match gitimportNew	'^N .*$'
  syn match gittagNew		'^T .*$'
  hi link gittagNew		Special
  hi link gitimportNew		Special
  hi link gitcheckoutUpdate	Special
  hi link gitupdateMerge	Special
  hi link gitupdatePatch	Constant
  hi link gitupdateConflict	WarningMsg
  hi link gitupdateDelete	Statement
  hi link gitupdateUnknown	Comment

  syn match gitstatusUpToDate	'^File:\s.*\sStatus: Up-to-date$'
  syn match gitstatusLocal	'^File:\s.*\sStatus: Locally.*$'
  syn match gitstatusNeed	'^File:\s.*\sStatus: Need.*$'
  syn match gitstatusConflict	'^File:\s.*\sStatus: File had conflict.*$'
  syn match gitstatusUnknown	'^File:\s.*\sStatus: Unknown$'
  hi link gitstatusUpToDate	Type
  hi link gitstatusLocal	Constant
  hi link gitstatusNeed		Identifier
  hi link gitstatusConflict	Warningmsg
  hi link gitstatusUnknown	Comment

  syn match gitlocalstatusUnknown	'^unknown:.*'
  syn match gitlocalstatusUnchanged	'^unchanged:.*'
  syn match gitlocalstatusMissing	'^missing:.*'
  syn match gitlocalstatusModified	'^modified:.*'
  hi link gitlocalstatusUnknown		Comment
  hi link gitlocalstatusUnchanged	Type
  hi link gitlocalstatusMissing		Identifier
  hi link gitlocalstatusModified	Constant

  syn match gitmergeConflict		'rcsmerge: warning: conflicts during merge'
  hi link gitmergeConflict		WarningMsg

  syn match gitdate	/^\s*\d\+\s\+\w\{-} \d\{4}\-\d\{2}\-\d\{2} /	contains=gituser nextgroup=gituser
  syn match gituser	/^\s*\d\+\s\+\w\{-} /				contained contains=gitver nextgroup=gitver
  syn match gitver	/^\s*\d\+/					contained
  hi link gitdate	Identifier
  hi link gituser	Type
  hi link gitver	Constant

  if !filereadable($VIM.s:sep.'syntax'.s:sep.'rcslog')
    syn match gitlogRevision	/^r\d\+/			contained nextgroup=gitlogUser
    syn match gitlogUser	/| \w\+ |/hs=s+2,he=e-2		contained nextgroup=gitlogDate
    syn match gitlogDate	/ \d\{4}-\d\{2}-\d\{2}/hs=s+1	contained
    syn region gitlogInfo	start='^r\d' end='$' contains=gitlogRevision,gitlogUser,gitlogUser
    hi link gitlogRevision	Constant
    hi link gitlogUser		Type
    hi link gitlogDate		Identifier
  endif
endfunction

function! GITAddConflictSyntax()
  syn region GITConflictOrg start="^<<<<<<<" end="^====" contained
  syn region GITConflictNew start="===$" end="^>>>>>>>" contained
  syn region GITConflict start="^<<<<<<<" end=">>>>>>>.*" contains=GITConflictOrg,GITConflictNew keepend
"  hi link GITConflict Special
  hi link GITConflictOrg DiffChange
  hi link GITConflictNew DiffAdd
endfunction

function! GITMakeRO()
  set nomodified
  set readonly
  setlocal nomodifiable
endfunction

function! GITMakeRW()
  set noreadonly
  setlocal modifiable
endfunction

function! GITSetScratch()
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
endfunction

" output window: open file under cursor by <doubleclick> or <shift-cr>
function! GITUpdateMapping()
  nmap <buffer> <2-LeftMouse> :call GITFindFile()<cr>
  nmap <buffer> <S-CR> :call GITFindFile()<cr>
  nmap <buffer> q :bd!<cr>
  nmap <buffer> ? :call GITShowMapping()<cr>
  nmap <buffer> <Leader>a :call GITFindFile()<cr>:call GITadd()<cr>
  nmap <buffer> <Leader>d :call GITFindFile()<cr>:call GITdiff()<cr>
  nmap <buffer> <Leader>i :call GITFindFile()<cr>:call GITcommit()<cr>
  nmap <buffer> <Leader>u :call GITFindFile()<cr>:call GITupdate()<cr>
  nmap <buffer> <Leader>s :call GITFindFile()<cr>:call GITstatus()<cr>
  nmap <buffer> <Leader>h :call GITFindFile()<cr>:call GITshortstatus()<cr>
  nmap <buffer> <Leader>c :call GITFindFile()<cr>:call GITlocalstatus()<cr>
  nmap <buffer> <Leader>v :call GITFindFile()<cr>:call GITrevertchanges()<cr>
endfunction

function! GITShowMapping()
  echo 'Mappings in output buffer :'
  echo '<2-LeftMouse> , <SHIFT-CR>      : open file in new buffer'
  echo 'q                               : close output buffer'
  echo '?                               : show this help'
  echo '<Leader>a                       : open file and GITadd'
  echo '<Leader>d                       : open file and GITdiff'
  echo '<Leader>i                       : open file and GITcommit'
  echo '<Leader>u                       : open file and GITupdate'
  echo '<Leader>s                       : open file and GITstatus'
  echo '<Leader>h                       : open file and GITshortstatus'
  echo '<Leader>c                       : open file and GITlocalstatus'
  echo '<Leader>v                       : open file and GITrevertchanges'
endfunction

function! GITFindFile()
  let curdir = getcwd()
  exec 'cd '.GITEscapePath(g:workdir)
  normal 0W
  exec 'cd '.GITEscapePath(curdir)
  unlet curdir
endfunction

"-----------------------------------------------------------------------------
" sort output		{{{1
"-----------------------------------------------------------------------------

" move all lines matching "searchstr" to top
function! GITMoveToTop(searchstr)
  silent exec 'g/'.a:searchstr.'/m0'
endfunction

" only called by GITshortstatus
function! GITSortStatusOutput()
  " allow changes
  call GITMakeRW()
  call GITMoveToTop('Status: Unknown$')
  call GITMoveToTop('Status: Needs Checkout$')
  call GITMoveToTop('Status: Needs Merge$')
  call GITMoveToTop('Status: Needs Patch$')
  call GITMoveToTop('Status: Locally Removed$')
  call GITMoveToTop('Status: Locally Added$')
  call GITMoveToTop('Status: Locally Modified$')
  call GITMoveToTop('Status: File had conflicts on merge$')
endfunction

" called by GITDoCommand
function! GITSortOutput()
  " allow changes
  call GITMakeRW()
  " localstatus
  call GITMoveToTop('^unknown:')
  call GITMoveToTop('^unchanged:')
  call GITMoveToTop('^missing:')
  call GITMoveToTop('^modified:')
  " org git
  call GITMoveToTop('^? ')	" unknown
  call GITMoveToTop('^T ')	" tag
  call GITMoveToTop('^D ')	" delete
  call GITMoveToTop('^N ')	" new
  call GITMoveToTop('^U ')	" update
  call GITMoveToTop('^M ')	" merge
  call GITMoveToTop('^P ')	" patch
  call GITMoveToTop('^C ')	" conflict
endfunction

"-----------------------------------------------------------------------------
" status variables		{{{1
"-----------------------------------------------------------------------------

function! GITSaveOpts()
  let s:GITROOTbak            = $GITROOT
  let s:GIT_RSHbak            = $GIT_RSH
  let s:GITOPTbak             = $GITOPT
  let s:GITCMDOPTbak          = $GITCMDOPT
  let s:GITCMDbak             = $GITCMD
  let s:GITforcedirectorybak  = g:GITforcedirectory
  let s:GITqueryrevisionbak   = g:GITqueryrevision
  let s:GITdumpandclosebak    = g:GITdumpandclose
  let g:GITsortoutputbak	= g:GITsortoutput
  let g:GITcompressoutputbak	= g:GITcompressoutput
  let g:GITtitlebarbak		= g:GITtitlebar
  let g:GITstatuslinebak	= g:GITstatusline
  let g:GITautocheckbak		= g:GITautocheck
  let g:GITofferrevisionbak	= g:GITofferrevision
  let g:GITsavediffbak		= g:GITsavediff
  let g:GITdontswitchbak	= g:GITdontswitch
endfunction

function! GITRestoreOpts()
  let $GITROOT                = s:GITROOTbak
  let $GIT_RSH                = s:GIT_RSHbak
  let $GITOPT                 = s:GITOPTbak
  let $GITCMDOPT              = s:GITCMDOPTbak
  let $GITCMD                 = s:GITCMDbak
  let g:GITforcedirectory     = s:GITforcedirectorybak
  let g:GITqueryrevision      = s:GITqueryrevisionbak
  let g:GITdumpandclose       = s:GITdumpandclosebak
  let g:GITsortoutput		= g:GITsortoutputbak
  let g:GITcompressoutput	= g:GITcompressoutputbak
  let g:GITtitlebar		= g:GITtitlebarbak
  let g:GITstatusline		= g:GITstatuslinebak
  let g:GITautocheck		= g:GITautocheckbak
  let g:GITofferrevision	= g:GITofferrevisionbak
  let g:GITsavediff		= g:GITsavediffbak
  let g:GITdontswitch		= g:GITdontswitchbak
  unlet g:GITsortoutputbak g:GITcompressoutputbak g:GITtitlebarbak
  unlet g:GITstatuslinebak g:GITautocheckbak g:GITofferrevisionbak
  unlet g:GITsavediffbak g:GITdontswitchbak
  unlet s:GITROOTbak s:GIT_RSHbak s:GITOPTbak s:GITCMDOPTbak s:GITCMDbak
  unlet s:GITforcedirectorybak s:GITqueryrevisionbak s:GITdumpandclosebak
endfunction

" set scope : file or directory, inform user
function! GITSetForceDir(value)
  let g:GITforcedirectory=a:value
  if g:GITforcedirectory==1
    echo 'GIT:Using current DIRECTORY once'
  elseif g:GITforcedirectory==2
    echo 'GIT:Using current DIRECTORY'
  else
    echo 'GIT:Using current buffer'
  endif
endfunction

" Set output to statusline, close output buffer
function! GITSetDumpAndClose(value)
  if a:value > 1
    echo 'GIT:output to status(file) and buffer(dir)'
  elseif a:value > 0
    echo 'GIT:output to statusline'
  else
    echo 'GIT:output to buffer'
  endif
  let g:GITdumpandclose = a:value
endfunction

" enable/disable revs/branchs queries
function! GITSetQueryRevision(value)
  if a:value > 0
    echo 'GIT:Enabled revision queries'
  else
    echo 'GIT:Not asking for revisions'
  endif
  let g:GITqueryrevision = a:value
endfunction

" Sort output (group conflicts,updates,...)
function! GITSetSortOutput(value)
  if a:value > 0
    echo 'GIT:sorting output'
  else
    echo 'GIT:unsorted output'
  endif
  let g:GITsortoutput = a:value
endfunction

" compress output to one line
function! GITSetCompressOutput(value)
  if a:value > 0
    echo 'GIT:compressed output'
  else
    echo 'GIT:full output'
  endif
  let g:GITcompressoutput = a:value
endfunction

" output to statusline
function! GITSetStatusline(value)
  if a:value > 0
    echo 'GIT:output to statusline'
  else
    echo 'GIT:no output to statusline'
  endif
  let g:GITstatusline = a:value
endfunction

" output to titlebar
function! GITSetTitlebar(value)
  if a:value > 0
    echo 'GIT:output to titlebar'
  else
    echo 'GIT:no output to titlebar'
  endif
  let g:GITtitlebar = a:value
endfunction

" show local status (autocheck)
function! GITSetAutocheck(value)
  if a:value > 0
    echo 'GIT:autochecking each file'
  else
    echo 'GIT:autocheck disabled'
  endif
  let g:GITautocheck = a:value
endfunction

" show current revision as default, when asking for it
function! GITSetOfferRevision(value)
  if a:value > 0
    echo 'GIT:offering current revision'
  else
    echo 'GIT:not offering current revision'
  endif
  let g:GITofferrevision = a:value
endfunction

" GITDiff : activate original or checked-out
function! GITSetDontSwitch(value)
  if a:value > 0
    echo 'GIT:switching to compared file'
  else
    echo 'GIT:stay in original when diffing'
  endif
  let g:GITdontswitch = a:value
endfunction

" save settings when using :diff
function! GITSetSaveDiff(value)
  if a:value > 0
    echo 'GIT:saving settings for :diff'
  else
    echo 'GIT:not saving settings for :diff'
  endif
  let g:GITsavediff = a:value
endfunction

function! GITChDir(path)
  let g:orgpath = getcwd()
  let g:workdir = expand("%:p:h")
  exec 'cd '.GITEscapePath(a:path)
endfunction

function! GITRestoreDir()
  if isdirectory(g:orgpath)
    exec 'cd '.GITEscapePath(g:orgpath)
  endif
endfunction

"}}}
"#############################################################################
" GIT commands
"#############################################################################
"-----------------------------------------------------------------------------
" GIT call		{{{1
"-----------------------------------------------------------------------------

" return > 0 if is win 95-me
function! GITIsW9x()
  return has("win32") && (match($COMSPEC,"command\.com") > -1)
endfunction

function! GITDoCommand(cmd,...)
  " needs to be called from orgbuffer
  let isfile = GITUsesFile()
  " change to buffers directory
  call GITChDir(expand('%:p:h'))
  " get file/directory to work on (if not given)
  if a:0 < 1
    if g:GITforcedirectory > 0
      let filename=''
    else
      let filename=expand('%:p:t')
    endif
  else
    let filename = a:1
  endif
  " problem with win98se : system() gives an error
  " cannot open 'F:\WIN98\TEMP\VIo9134.TMP'
  " piping the password also seems to fail (maybe caused by git.exe)
  " Using 'exec' creates a confirm prompt - only use this s**t on w9x
  if GITIsW9x()
    let tmp=tempname()
    silent exec '!'.$GITCMD.' '.$GITOPT.' '.a:cmd.' '.$GITCMDOPT.' '.filename.'>'.tmp
    exec 'split '.tmp
    let dummy=delete(tmp)
    unlet tmp dummy
  else
    let regbak=@z
    let cntenc=''
    let cmd=a:cmd
    if has('iconv') && g:GITcmdencoding != ''
      let cmd=iconv(cmd, &encoding, g:GITcmdencoding)
      let filename=iconv(filename, &encoding, g:GITcmdencoding)
      let cntenc=g:GITcmdencoding
    endif
    if &shell =~? 'cmd\.exe'
      let shellxquotebak=&shellxquote
      let &shellxquote='"'
    endif
    let @z=system($GITCMD.' '.$GITOPT.' '.cmd.' '.$GITCMDOPT.' '.filename)
    if &shell =~? 'cmd\.exe'
      let &shellxquote=shellxquotebak
      unlet shellxquotebak
    endif
    let gitcmd=matchstr(a:cmd,'\(^\| \)\zs\w\+\>')
    if (gitcmd == 'annotate' || gitcmd == 'update')
	  \&& g:GITfileencoding != ''
      let cntenc=g:GITfileencoding
    endif
    if has('iconv') && cntenc != ''
	  \&& ','.g:GITdontconvertfor.',' !~ ','.gitcmd.','
      let @z=iconv(@z, cntenc, &encoding)
    endif
    new
    silent normal "zP
    let @z=regbak
    unlet regbak cntenc cmd gitcmd
  endif
  call GITProcessOutput(isfile, filename, a:cmd)
  call GITRestoreDir()
  unlet filename
endfunction

" also jumped in by GITLocalStatus
function! GITProcessOutput(isfile,filename,cmd)
  " delete leading and trainling blank lines
  while getline(1) == '' && line("$") > 1
    silent exec '0d'
  endwhile
  while getline("$") == '' && line("$") > 1
    silent exec '$d'
  endwhile
  " group conflicts, updates, ....
  if g:GITsortoutput > 0
    silent call GITSortOutput()
  endif
  " compress output ?
  if g:GITcompressoutput > 0
    if (g:GITdumpandclose > 0) && a:isfile
      silent call GITCompressOutput(a:cmd)
    endif
  endif
  " move to top
  normal gg
  setlocal nowrap
  " reset single shot flag
  if g:GITforcedirectory == 1
    let g:GITforcedirectory = 0
  endif
  call GITMakeRO()
  if (g:GITdumpandclose == 1) || ((g:GITdumpandclose == 2) && a:isfile)
    call GITDumpAndClose()
  else
    if s:GITdontupdatemapping == 0
      call GITUpdateMapping()
    endif
    call GITUpdateSyntax()
  endif
  let s:GITdontupdatemapping = 0
endfunction

" return: 1=file 0=dir
function! GITUsesFile()
  let filename=expand("%:p:t")
  if    ((g:GITforcedirectory == 0) && (filename != ''))
"   \ || ((g:GITforcedirectory > 0) && (filename == ''))
    return 1
  else
    return 0
  endif
  unlet filename
endfunction

" compress output
function! GITCompressOutput(cmd)
    " commit
    if match(a:cmd,"commit") > -1
      let v:errmsg = ''
      silent! exec '/^git \[commit aborted]:'
      " only compress, if no error found
      if v:errmsg != ''
	silent! exec 'g!/^new revision:/d'
      endif
    " skip localstatus
    elseif match(a:cmd,"localstatus") > -1
    " status
    elseif match(a:cmd,"status") > -1
      silent! exec 'g/^=\+$/d'
      silent! exec 'g/^$/d'
      silent! exec '%s/.*Status: //'
      silent! exec '%s/^\s\+Working revision:\s\+\([0-9.]*\).*/W:\1/'
      silent! exec '%s/^\s\+Repository revision:\s\+\([0-9.]*\).*/R:\1/'
      silent! exec '%s/^\s\+Sticky Tag:\s\+/T:/'
      silent! exec '%s/^\s\+Sticky Date:\s\+/D:/'
      silent! exec '%s/^\s\+Sticky Options:\s\+/O:/'
      silent! normal ggJJJJJJ
    endif
endfunction

" get version
function! GITver()
  let rev=system($GITCMD.' --version | cat | head -1 | grep --color=none -o "[0-9]\.[0-9]\.[0-9]"')
  return rev
endfunction

"#############################################################################
" following commands read from STDIN. Call GIT directly
"#############################################################################

"-----------------------------------------------------------------------------
" GIT login / logout (password prompt)		{{{1
"-----------------------------------------------------------------------------

function! GITlogin(...)
  if a:0 == 0
    let pwpipe = ''
  else
    let pwpipe = 'echo'
    if !has("unix")
      if a:1 == ''
        let pwpipe = pwpipe . '.'
      endif
    endif
    if a:1 != ''
      if has("unix")
	" Piping works well because the clean escaping scenario, but I
	" have not found an environment where GIT actually accepts the
	" password from the pipe.  I am keeping this just in case it
	" works somewhere.
        let pwpipe = pwpipe . ' "' . escape(a:1,'!#%"`\') . '"'
      else
	" I failed to find a way to escape strings here for Windows
	" command lines without requiring a special external program.
	" So your password may not contain some special symbols like
	" `&', `|', and `"'.
        let pwpipe = pwpipe . ' '  . escape(a:1,'!#%')
      endif
    endif
    let pwpipe = pwpipe . '|'
  endif
  if has("unix")
    " show password prompt
    exec '!'.pwpipe.$GITCMD.' '.$GITOPT.' login '.$GITCMDOPT
  else
    " shell is opened in win32 (dos?)
    silent! exec '!'.pwpipe.$GITCMD.' '.$GITOPT.' login '.$GITCMDOPT
  endif
endfunction

function! GITlogout()
  silent! exec '!'.$GITCMD.' '.$GITOPT.' logout '.$GITCMDOPT
endfunction

"-----------------------------------------------------------------------------
" GIT release (confirmation prompt)		{{{1
"-----------------------------------------------------------------------------

function! GITrelease()
  let localtoo=input('Release: Also delete local file [y]: ')
  if (localtoo=='y') || (localtoo=='')
    let localtoo='-d '
  else
    let localtoo=''
  endif
  let releasedir=expand('%:p:h')
  call GITChDir(releasedir.s:sep.'..')
  " confirmation prompt -> dont use GITDoCommand
  if has("unix")
    " show confirmation prompt
    exec '!'.$GITCMD.' '.$GITOPT.' release '.localtoo.releasedir.' '.$GITCMDOPT
  else
    silent! exec '!'.$GITCMD.' '.$GITOPT.' release '.localtoo.releasedir.' '.$GITCMDOPT
  endif
  call GITRestoreDir()
  unlet localtoo releasedir
endfunction

"#############################################################################
" from here : use GITDoCommand wrapper
"#############################################################################

"-----------------------------------------------------------------------------
" GIT diff (diffsplit)		{{{1
"-----------------------------------------------------------------------------

function! GITdiff(...)
  let bak=@z
  let file=expand("%")
  call GITBackupDiffMode()
  call GITSwitchDiffMode()
  let @z=str2nr(system($GITCMD.' status '.file.' | wc -l'))
  if (@z==0)
    let @z=system('cat '.file)
  else
    let rev = (a:0 == 0) ? ' ' : a:1.' '
    "let @z=system($GITCMD.' diff '.rev.file.' | patch -R -s -o - '.file)
    let @z=system($GITCMD.' diff '.rev.file.' | patch -R -s -o - '.file.' | dos2unix')
    unlet rev
  endif
  vne
  call GITSetScratch()
  call GITMakeRW()
  silent normal "zPGddgg
  call GITMakeRO()
  difft
  let @z=bak
  unlet file bak
  silent! nmap <unique> <buffer> q :bd<cr>:call GITSwitchDiffMode()<cr>
endfunction

" diff to parent (HEAD^)
function! GITdifftoparent()
   call GITdiff("HEAD^")
endfunction

" diff to a specific revision
function! GITdifftorev()
  " Force revision input
  let rev=GITInputRev('Revision: ')
  if rev==''
    echo "GIT diff to revision: aborted"
    return
  endif
  call GITdiff(rev)
  unlet rev
endfunction

"-----------------------------------------------------------------------------
" GIT diff / patchfile		{{{1
"-----------------------------------------------------------------------------
function! GITgetdiff(parm)
  call GITSaveOpts()
  let g:GITdumpandclose = 0
  let g:GITtitlebar = 1			" Notification output to titlebar
  " query revision
  let rev=GITInputRev('Revision (optional): ')
  if rev!=''
    let rev=' -r '.rev.' '
  endif
  call GITDoCommand('diff '.a:parm.rev)
  set syntax=diff
  call GITRestoreOpts()
  unlet rev
endfunction

function! GITdiffcontext()
  call GITgetdiff('-c')
endfunction

function! GITdiffstandard()
  call GITgetdiff('')
endfunction

function! GITdiffuni()
  call GITgetdiff('-u')
endfunction

"-----------------------------------------------------------------------------
" GIT annotate / log / status / history		{{{1
"-----------------------------------------------------------------------------

function! GITannotate()
  call GITSaveOpts()
  let g:GITdumpandclose = 0
  let g:GITtitlebar = 0
  let s:GITdontupdatemapping = 1
"  if !exists('b:GITentry')
"    call GITGetLocalStatus()
"  endif
"  if exists('b:GITentry')
"    let $GITCMDOPT='-r ' . GITSubstr(b:GITentry,'/',2) . ' '
"  endif
  if g:GITlongrev == 1 " print long annotate rev
    let $GITCMDOPT='-l '
  endif
  call GITDoCommand('annotate',expand('%:p:t'))
  if g:GITshortannotate == 1 " shorten annotate output
    call GITMakeRW()
    exec '%s/^\(\x\+\)\t\+(\(.\{5}\).\+\(\d\{4}-\d\{2}-\d\{2}\) \(\d\{2}:\d\{2}:\d\{2}\)\s\W\d\{4}\W\+\d\+)/\1 \2 \3	/g'	
    call GITMakeRO()
    exec '0'
  endif
" if g:GITspacesinannotate > 0	" insert spaces to make TABs align better
"   let spaces = ''
"   let space_cnt = g:GITspacesinannotate
"   while space_cnt > 0
"     let spaces = spaces . ' '
"     let space_cnt = space_cnt - 1
"   endwhile
"   call GITMakeRW()
"   normal m`
"   exec 'silent! :%s/):/):' . spaces . '/e'
"   normal ``
"   exec '%s/\d\d:\d\d:\d\d .\d\{4} (.\{-}) //'
"   exec '0'
"   call GITMakeRO()
"   unlet spaces space_cnt
" endif
  wincmd _
  call GITRestoreOpts()
  silent! nmap <unique> <buffer> q :bwipeout<cr>
endfunction

function! GITstatus()
  let bak=@z
  let @z=system($GITCMD.' status -s')
  new
  call GITSetScratch()
  call GITMakeRW()
  silent normal "zPGddgg
  call GITMakeRO()
  " go through each files
  let append = ''
  let i = 1
  while i <= line("$")
     let tmp = getline(i)
     let status = matchstr(tmp, '^..')
     let filename = matchstr(tmp, '\S\+$')
     " TODO test renaming "->"
     let rename = matchstr(tmp, ' \S+ ->')
     call setqflist([{'filename': filename, 'lnum': 1, 'text': status.rename}], append)
     let i += 1
     let append = 'a'
  endwhile
  bd
  cw
  let @z=bak
endfunction

function! GITstatus_dir()
  call GITSetForceDir(1)
  call GITstatus()
endfunction

function! GIThistory()
  call GITSaveOpts()
  let g:GITdumpandclose = 0
  let s:GITdontupdatemapping = 1
  call GITDoCommand('history')
  call GITRestoreOpts()
  silent! nmap <unique> <buffer> q :bwipeout<cr>
endfunction

function! GITlog()
  call GITSaveOpts()
  let g:GITdumpandclose = 0
  if g:GITqueryrevision > 0
    if g:GITofferrevision > 0
      let default = '1.1:'.GITSubstr(b:GITentry,'/',2)
    else
      let default = ''
    endif
    let rev=input('Revisions (optional): ',default)
  else
    let rev=''
  endif
  if rev!=''
    let rev=' -r'.rev.' '
  endif
  let s:GITdontupdatemapping = 1
  call GITDoCommand('log'.rev)
  call GITRestoreOpts()
  silent! nmap <unique> <buffer> q :bwipeout<cr>
endfunction

function! GITlog_dir()
  call GITSetForceDir(1)
  call GITlog()
endfunction

" log between specific revisions
function! GITlogtorev()
  let querybak=g:GITqueryrevision
  let g:GITqueryrevision = 1
  call GITlog()
  let g:GITqueryrevision=querybak
  unlet querybak
endfunction

"-----------------------------------------------------------------------------
" GIT watch / edit : common		{{{1
"-----------------------------------------------------------------------------

function! GITQueryAction()
  let action=input('Action (e)dit, (u)nedit, (c)ommit, (a)ll, [n]one: ')
  if action == 'e'
    let action = '-a edit '
  elseif action == 'u'
    let action = '-a unedit '
  elseif action == 'a'
    let action = '-a all '
  else
    let action = ''
  endif
  return action
endfunction

"-----------------------------------------------------------------------------
" GIT edit		{{{1
"-----------------------------------------------------------------------------

function! GITwatcheditors()
  call GITDoCommand('editors')
endfunction

function! GITwatchedit()
  let action=GITQueryAction()
  call GITDoCommand('edit '.action)
  unlet action
endfunction

function! GITwatchunedit()
  "call GITDoCommand('unedit')
  " Do not use the original method of GITDoCommand since `git unedit'
  " may prompt to revert changes if gitnt is used.
  silent! exec '!'.$GITCMD.' '.$GITOPT.' unedit '.$GITCMDOPT.' '.file
  unlet filename
endfunction

"-----------------------------------------------------------------------------
" GIT watch		{{{1
"-----------------------------------------------------------------------------

function! GITwatchwatchers()
  call GITDoCommand('watchers')
endfunction

function! GITwatchadd()
  let action=GITQueryAction()
  call GITDoCommand('watch add '.action)
  unlet action
endfunction

function! GITwatchremove()
  call GITDoCommand('watch remove')
endfunction

function! GITwatchon()
  call GITDoCommand('watch on')
endfunction

function! GITwatchoff()
  call GITDoCommand('watch off')
endfunction

"-----------------------------------------------------------------------------
" GIT tag		{{{1
"-----------------------------------------------------------------------------

function! GITDoTag(usertag,tagopt)
  " force tagname input
  let tagname = GITEscapeMessage(input('tagname: '))
  if tagname==''
    echo 'GIT tag: aborted'
    return
  endif
  " if rtag, force module instead local copy
  if a:usertag > 0
    let tagcmd = 'rtag '
    let module = input('Enter module name: ')
    if module == ''
      echo 'GIT rtag: aborted'
      return
    endif
    let target = module
    unlet module
  else
    let tagcmd = 'tag '
    let target = ''
  endif
  " g:GITqueryrevision ?
  " tag by date, revision or local
  let tagby=input('Tag by (d)ate, (r)evision (default:none): ')
  if (tagby == 'd')
    let tagby='-D '
    let tagwhat=input('Enter date: ')
  elseif tagby == 'r'
    let tagby='-r '
    let tagwhat=GITInputRev('Revision (optional): ')
  else
    let tagby = ''
  endif
  " input date / revision
  if tagby != ''
    if tagwhat == ''
      echo 'GIT tag: aborted'
      return
    else
      let tagwhat = tagby.tagwhat.' '
    endif
  else
    let tagwhat = ''
  endif
  " check if working file is unchanged (if not rtag)
  if a:usertag == 0
    let checksync=input('Override sync check [n]: ')
    if (checksync == 'n') || (checksync == '')
      let checksync='-c '
    else
      let checksync=''
    endif
  else
    let checksync=''
  endif
  call GITDoCommand(tagcmd.' '.a:tagopt.checksync.tagwhat.tagname,target)
  unlet checksync tagname tagcmd tagby tagwhat target
endfunction

" tag local copy (usertag=0)
function! GITtag()
  call GITDoTag(0,'')
endfunction

function! GITtagremove()
  call GITDoTag(0,'-d ')
endfunction

function! GITbranch()
  call GITDoTag(0,'-b ')
endfunction

" tag module (usertag=1)
function! GITrtag()
  call GITDoTag(1,'')
endfunction

function! GITrtagremove()
  call GITDoTag(1,'-d ')
endfunction

function! GITrbranch()
  call GITDoTag(1,'-b ',)
endfunction

"-----------------------------------------------------------------------------
" GIT update / query update		{{{1
"-----------------------------------------------------------------------------

function! GITupdate()
  " ask for revisions to merge/join (if wanted)
  if g:GITqueryrevision > 0
    let rev=GITInputRev('Revision (optional): ')
    if rev!=''
      let rev='-r '.rev.' '
    endif
    let mergerevstart=GITInputRev('Merge from 1st Revision (optional): ')
    if mergerevstart!=''
      let mergerevstart='-j '.mergerevstart.' '
    endif
    let mergerevend=GITInputRev('Merge from 2nd Revision (optional): ')
    if mergerevend!=''
      let mergerevend='-j '.mergerevend.' '
    endif
  else
    let rev = ''
    let mergerevstart = ''
    let mergerevend = ''
  endif
  " update or query
  if s:GITupdatequeryonly > 0
    " git server (v1.11.15): -z option causes error message when
    " invoking "update" with -n parameter.
    let gitoptbak = $GITOPT
    let oldkeyword = &iskeyword
    set iskeyword=!-~
    let removpat = '\<-z[ \t]*[0-9]\>'      " remove the '-z #' option
    let removidx = match($GITOPT,removpat)
    let mlen = strlen(matchstr($GITOPT,removpat))
    let &iskeyword = oldkeyword
    if removidx >= 0
      let $GITOPT = strpart($GITOPT,0,removidx).strpart($GITOPT,removidx+mlen)
    endif
    call GITDoCommand('-n update -P '.rev.mergerevstart.mergerevend)
    let $GITOPT = gitoptbak
    unlet gitoptbak oldkeyword removpat removidx mlen
  else
    call GITDoCommand('update '.rev.mergerevstart.mergerevend)
  endif
  unlet rev mergerevstart mergerevend
endfunction

function! GITupdate_dir()
  call GITSetForceDir(1)
  call GITupdate()
endfunction

function! GITqueryupdate()
  let s:GITupdatequeryonly = 1
  call GITupdate()
  let s:GITupdatequeryonly = 0
endfunction

function! GITqueryupdate_dir()
  call GITSetForceDir(1)
  call GITqueryupdate()
endfunction

function! GITupdatetorev()
  " Force revision input
  let rev=GITInputRev('Revision: ')
  if rev==''
    echo "GIT Update to revision: aborted"
    return
  endif
  let rev='-r '.rev.' '
  " save old state
  call GITSaveOpts()
  let $GITCMDOPT=rev
  " call update
  call GITupdate()
  " restore options
  call GITRestoreOpts()
  unlet rev
endfunction

function! GITupdatemergerev()
  " Force revision input
  let mergerevstart=GITInputRev('Merge from 1st Revision: ')
  if mergerevstart==''
    echo "GIT merge revision: aborted"
    return
  endif
  let mergerevstart='-j '.mergerevstart.' '
  " save old state
  call GITSaveOpts()
  let $GITCMDOPT=mergerevstart
  " call update
  call GITupdate()
  " restore options
  call GITRestoreOpts()
  unlet mergerevstart
endfunction

function! GITupdatemergediff()
  " Force revision input
  let mergerevstart=GITInputRev('Merge from 1st Revision: ')
  if mergerevstart==''
    echo "GIT merge revision diffs: aborted"
    return
  endif
  let mergerevend=GITInputRev('Merge from 2nd Revision: ')
  if mergerevend==''
    echo "GIT merge revision diffs: aborted"
    return
  endif
  let mergerevstart='-j '.mergerevstart.' '
  let mergerevend='-j '.mergerevend.' '
  " save old state
  call GITSaveOpts()
  let $GITCMDOPT=mergerevstart.mergerevend
  " call update
  call GITupdate()
  " restore options
  call GITRestoreOpts()
endfunction

"-----------------------------------------------------------------------------
" GIT remove (request confirmation)		{{{1
"-----------------------------------------------------------------------------

function! GITremove()
  " remove from rep. also local ?
  if g:GITforcedirectory>0
    let localtoo=input('Remove: Also delete local DIRECTORY [y]: ')
  else
    let localtoo=input('Remove: Also delete local file [y]: ')
  endif
  if (localtoo=='y') || (localtoo=='')
    let localtoo='-f '
  else
    let localtoo=''
  endif
  " force confirmation
  let confrm=input('Remove: confirm with "y": ')
  if confrm!='y'
    echo 'GIT remove: aborted'
    return
  endif
  call GITDoCommand('remove '.localtoo)
  unlet localtoo
endfunction

function! GITremove_dir()
  call GITSetForceDir(1)
  call GITremove()
endfunction

"-----------------------------------------------------------------------------
" GIT add		{{{1
"-----------------------------------------------------------------------------

function! GITadd()
  if (g:GITusedefaultmsg =~ 'a') && ((g:GITallowemptymsg =~ 'a') || (g:GITdefaultmsg != ''))
    let message = g:GITdefaultmsg
  else
    " force message input
    let message = GITEscapeMessage(input('Message: '))
  endif
  if (g:GITallowemptymsg !~ 'a') && (message == '')
    echo 'GIT add: aborted'
    return
  endif
  call GITDoCommand('add -m "'.message.'"')
  unlet message
endfunction

function! GITadd_dir()
  call GITSetForceDir(1)
  call GITadd()
endfunction

"-----------------------------------------------------------------------------
" GIT commit		{{{1
"-----------------------------------------------------------------------------

function! GITcommit()
  if (&modified || expand('%') == '') && (g:GITforcedirectory == 0)
    echo 'GIT commit: file not saved!'
    return
  endif
  if (g:GITusedefaultmsg =~ 'i') && (g:GITdefaultmsg != '')
    let message = g:GITdefaultmsg
  else
    " force message input
    let message = GITEscapeMessage(input('Message: '))
  endif
  if (g:GITallowemptymsg !~ 'i') && (message == '')
    echo 'GIT commit: aborted'
    return
  endif
  " query revision (if wanted)
  if g:GITqueryrevision > 0
    let rev=GITInputRev('Revision (optional): ')
  else
    let rev=''
  endif
  if rev!=''
    let rev='-r '.rev.' '
  endif
  if g:GITforcedirectory > 0
    let forcedir=1
  else
    let forcedir=0
  endif
  if g:GITreloadaftercommit > 0 && forcedir == 0
    checktime
    " Using 'FileChangedShell' is a trick to avoid the Vim prompt to
    " reload the file
    exec 'au FileChangedShell * let $GITOPT=$GITOPT'
  endif
  call GITDoCommand('commit -m "'.message.'" '.rev)
  if g:GITreloadaftercommit > 0 && forcedir == 0
    checktime
    exec 'au! FileChangedShell *'
    let laststatus=g:GITlaststatus
    edit
    redraw!
    echo laststatus
    let g:GITlaststatus=laststatus
    unlet laststatus
  endif
  unlet message rev forcedir
endfunction

function! GITcommit_dir()
  call GITSetForceDir(1)
  call GITcommit()
endfunction

function! GITcommitrevision()
  let querybak=g:GITqueryrevision
  let g:GITqueryrevision=1
  call GITcommit()
  let g:GITqueryrevision=querybak
endfunction

"-----------------------------------------------------------------------------
" GIT join in		{{{1
"-----------------------------------------------------------------------------

function! GITjoinin(...)
  if a:0 == 1
    let message = a:1
  elseif g:GITusedefaultmsg =~ 'j' && g:GITdefaultmsg != ''
    let message = g:GITdefaultmsg
  else
    " force message input
    let message = GITEscapeMessage(input('Message: '))
    if (g:GITallowemptymsg !~ 'j') && (message == '')
      echo 'GIT add/commit: aborted'
      return
    endif
  endif
  " query revision (if wanted)
  if g:GITqueryrevision > 0
    let rev=GITInputRev('Revision (optional): ')
  else
    let rev=''
  endif
  if rev!=''
    let rev='-r '.rev.' '
  endif
  call GITDoCommand('add -m "'.message.'"')
  call GITDoCommand('commit -m "'.message.'" '.rev)
  call GITLocalStatus()
  unlet message rev
endfunction

function! GITjoininrevision()
  let querybak=g:GITqueryrevision
  let g:GITqueryrevision=1
  call GITjoinin()
  let g:GITqueryrevision=querybak
endfunction

"-----------------------------------------------------------------------------
" GIT import		{{{1
"-----------------------------------------------------------------------------

function! GITimport()
  if (g:GITusedefaultmsg =~ 'p') && (g:GITdefaultmsg != '')
    let message = g:GITdefaultmsg
  else
    " force message input
    let message = GITEscapeMessage(input('Message: '))
  endif
  if (g:GITallowemptymsg !~ 'p') && (message == '')
    echo 'GIT import: aborted'
    return
  endif
  " query branch (if wanted)
  if g:GITqueryrevision > 0
    let rev=input('Branch (optional): ')
  else
    let rev=''
  endif
  if rev!=''
    let rev='-b '.rev.' '
  endif
  " query vendor tag
  let vendor=input('Vendor tag: ')
  if vendor==''
    echo 'GIT import: aborted'
    return
  endif
  " query release tag
  let release=input('Release tag: ')
  if release==''
    echo 'GIT import: aborted'
    return
  endif
  " query module
  let module=input('Module: ')
  if module==''
    echo 'GIT import: aborted'
    return
  endif
  " only works on directories
  call GITDoCommand('import -m "'.message.'" '.rev.module.' '.vendor.' '.release)
  unlet message rev vendor release
endfunction

function! GITimportrevision()
  let querybak=g:GITqueryrevision
  let g:GITqueryrevision=1
  call GITimport()
  let g:GITqueryrevision=querybak
endfunction

"-----------------------------------------------------------------------------
" GIT checkout		{{{1
"-----------------------------------------------------------------------------

function! GITcheckout()
  let destdir=expand('%:p:h')
  let destdir=input('Checkout to: ',destdir)
  if destdir==''
    return
  endif
  let module=input('Module name: ')
  if module==''
    echo 'GIT checkout: aborted'
    return
  endif
  " query revision (if wanted)
  if g:GITqueryrevision > 0
    let rev=GITInputRev('Revision (optional): ')
  else
    let rev=''
  endif
  if rev!=''
    let rev='-r '.rev.' '
  endif
  call GITChDir(destdir)
  call GITDoCommand('checkout '.rev.module)
  call GITRestoreDir()
  unlet destdir module rev
endfunction

function! GITcheckoutrevision()
  let querybak=g:GITqueryrevision
  let g:GITqueryrevision=1
  call GITcheckout()
  let g:GITqueryrevision=querybak
endfunction
"}}}
"#############################################################################
" extended commands
"#############################################################################
"-----------------------------------------------------------------------------
" revert changes, shortstatus		{{{1
"-----------------------------------------------------------------------------

function! GITrevertchanges()
  let filename=expand("%:p:t")
  call GITChDir(expand("%:p:h"))
  if filename == ''
    echo 'Revert changes:only on files'
    return
  endif
  if delete(filename) != 0
    echo 'Revert changes:could not delete file'
    return
  endif
  call GITSaveOpts()
  "let $GITCMDOPT='-A '
  call GITupdate()
  call GITRestoreOpts()
  call GITRestoreDir()
endfunction

" get status info, compress it (one line/file), sort by status
function! GITshortstatus()
  let isfile = GITUsesFile()
  " save flags
  let filename = expand("%:p:t")
  let savedump = g:GITdumpandclose
  let forcedirbak = g:GITforcedirectory
  " output needed
  let g:GITdumpandclose=0
  silent call GITstatus()
  call GITMakeRW()
  silent call GITCompressStatus()
  if g:GITsortoutput > 0
    silent call GITSortStatusOutput()
  endif
  normal gg
  call GITMakeRO()
  " restore flags
  let g:GITdumpandclose = savedump
  if forcedirbak == 1
    let g:GITforcedirectory = 0
  else
    let g:GITforcedirectory = forcedirbak
  endif
  if   (g:GITdumpandclose == 1) || ((g:GITdumpandclose == 2) && isfile)
    call GITDumpAndClose()
  endif
  unlet savedump forcedirbak filename isfile
endfunction

function! GITshortstatus_dir()
  call GITSetForceDir(1)
  call GITshortstatus()
endfunction

"-----------------------------------------------------------------------------
" tools: output processing, input query		{{{1
"-----------------------------------------------------------------------------

" Dump output to statusline, close output buffer
function! GITDumpAndClose()
  " collect in reg. z first, otherwise func
  " will terminate, if user stops output with "q"
  let curlin=1
  let regbak=@z
  let @z = getline(curlin)
  while curlin < line("$")
    let curlin = curlin + 1
    let @z = @z . "\n" . getline(curlin)
  endwhile
  " appends \n on winnt
  "exec ":1,$y z"
  set nomodified
  bwipeout
  if g:GITstatusline
    redraw
    " statusline may be cleared otherwise
    let g:GITlaststatus=@z
    echo @z
  endif
  if g:GITtitlebar
    let cleantitle = substitute(@z,'\t\|\r\|\s\{2,\}',' ','g')
    let cleantitle = substitute(cleantitle,"\n",' ',"g")
    let &titlestring = '%t%( %M%) (%<%{expand("%:p:h")}) - '.cleantitle
    let b:GITbuftitle = &titlestring
    unlet cleantitle
  endif
  let @z=regbak
endfunction

" leave only leading line with status info (for GITshortstatus)
function! GITCompressStatus()
  exec 'g!/^File:\|?/d'
endfunction

" delete stderr ('checking out...')
" GIT checkout ends with ***************(15)
function! GITStripHeader()
  call GITMakeRW()
  silent! exec '1,/^\*\{15}$/d'
endfunction

function! GITInputRev(...)
  if !exists("b:GITentry")
    let b:GITentry = ''
  endif
  if a:0 == 1
    let query = a:1
  else
    let query = ''
  endif
  if g:GITofferrevision > 0
    let default = GITSubstr(b:GITentry,'/',2)
  else
    let default = ''
  endif
  return input(query,default)
endfunction

"-----------------------------------------------------------------------------
" quick get file.		{{{1
"-----------------------------------------------------------------------------

function! GITGet(...)
  " Params :
  " 0:ask file,rep
  " 1:filename
  " 2:repository
  " 3:string:i=login,o=logout
  " 4:string:login password
  " save flags, do not destroy GITSaveOpts
  let gitoptbak=$GITCMDOPT
  let outputbak=g:GITdumpandclose
    let rep=''
    let log=''
  " eval params
  if     a:0 > 2	" file,rep,logflag[,logpw]
    let fn  = a:1
    let rep = a:2
    let log = a:3
  elseif a:0 > 1	" file,rep
    let fn  = a:1
    let rep = a:2
  elseif a:0 > 0	" file: (use current rep)
    let fn  = a:1
  endif
  if fn == ''		" no name:query file and rep
    let rep=input("GITROOT: ")
    let fn=input("Filename: ")
  endif
  " still no filename : abort
  if fn == ''
    echo "GIT Get: aborted"
  else
    " prepare param
    if rep != ''
      let $GITOPT = '-d'.rep
    endif
    " no output windows
    let g:GITdumpandclose=0
    " login
    if match(log,'i') > -1
      if (a:0 == 4)	" login with pw (if given)
        call GITlogin(a:4)
      else
        call GITlogin()
      endif
    endif
    " get file
"    call GITDoCommand('checkout -p',fn)
    call GITDoCommand('checkout',fn)
    " delete stderr ('checking out...')
    if !GITIsW9x()
      call GITStripHeader()
    endif
    set nomodified
    " logout
    if match(log,'o') > -1
      call GITlogout()
    endif
  endif
  " restore flags, cleanup
  let g:GITdumpandclose=outputbak
  let $GITOPT=gitoptbak
  unlet fn rep outputbak gitoptbak
endfunction

"-----------------------------------------------------------------------------
" Download help and install		{{{1
"-----------------------------------------------------------------------------

function! GITInstallUpdates()
  if confirm("Install updates: Close all buffers, first !","&Cancel\n&Ok") < 2
    echo 'GIT Install updates: aborted'
    return
  endif
  call GITDownloadUpdates()
  if match(getline(1),'^\*gitmenu.txt\*') > -1
    call GITInstallAsHelp('gitmenu.txt')
    let helpres="Helpfile installed"
  else
    let helpres="Error: Helpfile not installed"
  endif
  bwipeout
  redraw
  if match(getline(1),'^" GITmenu.vim :') > -1
    call GITInstallAsPlugin('gitmenu.vim')
    let plugres="Plugin installed"
  else
    let plugres="Error: Plugin not installed"
  endif
  bwipeout
  redraw
  echo helpres."\n".plugres
  echo "Changes take place in next vim session"
endfunction

function! GITDownloadUpdates()
  call GITGet('VimTools/gitmenu.vim',s:gitmenugit,'i','')
  call GITGet('VimTools/gitmenu.txt',s:gitmenugit,'o','')
endfunction

function! GITInstallAsHelp(...)
  " ask for name to save as (if not given)
  if (a:0 == 0) || (a:1 == '')
    let dest=input('Help file name (clear to abort): ','gitmenu.txt')
  else
    let dest=a:1
  endif
  " abort if still no filename
  if dest==''
    echo 'GIT Install help: aborted'
  else
    " create directory like "~/.vim/doc" if needed
    call GITAssureLocalDirs()
    " copy to local doc dir
    exec 'w! '.s:localvimdoc.'/'.dest
    " create tags
    exec 'helptags '.s:localvimdoc
  endif
  unlet dest
endfunction

function! GITInstallAsPlugin(...)
  " ask for name to save as
  if (a:0 == 0) || (a:1 == '')
    let dest=input('Plugin file name (clear to abort): ','gitmenu.vim')
  else
    let dest=a:1
  endif
  " abort if still no filename
  if dest==''
    echo 'GIT Install plugin: aborted'
  else
    " copy to plugin dir
    exec 'w! '.s:script_path.s:sep.dest
  endif
  unlet dest
endfunction

"-----------------------------------------------------------------------------
" user directories / GITLinks		{{{1
"-----------------------------------------------------------------------------

function! GITOpenLinks()
  let links=s:localvim.s:sep.'gitlinks.vim'
  call GITAssureLocalDirs()
  if !filereadable(links)
    let @z = "\" ~/gitlinks.vim\n"
      \ . "\" move to a command and press <shift-cr> to execute it\n"
      \ . "\" (one-liners only).\n\n"
      \ . "nmap <buffer> <s-cr> :exec getline('.')<cr>\n"
      \ . "finish\n\n"
      \ . "\" add modifications below here\n\n"
      \ . "\" look for a new Vim\n"
      \ . "\" login, get latest Vim README.txt, logout\n"
      \ . "call GITGet('vim/README.txt', ':pserver:anonymous@git.vim.org:/gitroot/vim', 'io', '')\n\n"
      \ . "\" manual gitmenu update (-> GIT.Settings.Install buffer as...)\n"
      \ . "\" login, get latest version of gitmenu.vim\n"
      \ . "call GITGet('VimTools/gitmenu.vim',':pserver:anonymous@ezytools.git.sourceforge.net:/gitroot/ezytools','i','')\n"
      \ . "\" get latest gitmenu.txt, logout\n"
      \ . "call GITGet('VimTools/gitmenu.vim',':pserver:anonymous@ezytools.git.sourceforge.net:/gitroot/ezytools','o','')\n\n"
      \ . "\" Get some help on this\n"
      \ . "help GITFunctions"
    call GITChDir(s:localvim)
    new
    normal "zP
    exec ':x '.links
    call GITRestoreDir()
  endif
  if !filereadable(links)
    echo 'GITLinks: cannot access '.links
    return
  endif
  exec ':sp '.links
  exec ':so %'
  unlet links
endfunction

function! GITAssureLocalDirs()
  if !isdirectory(s:localvimdoc)
    silent! exec '!mkdir '.s:localvimdoc
  endif
endfunction

function! GITGetFolderNames()
  let s:localvim=s:script_path.s:sep.'..'
  let s:localvimdoc=s:localvim.s:sep.'doc'
endfunction

"-----------------------------------------------------------------------------
" LocalStatus : read from GIT/Entries		{{{1
"-----------------------------------------------------------------------------

function! GITLocalStatus()
  " needs to be called from orgbuffer
  let isfile = GITUsesFile()
  " change to buffers directory
  call GITChDir(expand('%:p:h'))
  if g:GITforcedirectory>0
    let filename=expand('%:p:h')
  else
    let filename=expand('%:p:t')
  endif
  let regbak=@z
  let @z = GITCompare(filename)
  new
  " seems to be a vim bug : when executed as autocommand when doing ':help',
  " vim echoes 'not modifiable'
  set modifiable
  normal "zP
  call GITProcessOutput(isfile, filename, '*localstatus')
  let @z=regbak
  call GITRestoreDir()
  unlet filename
endfunction

function! GITLocalStatus_dir()
  call GITSetForceDir(1)
  call GITLocalStatus()
endfunction

" get info from GIT/Entries about given/current buffer/dir
function! GITCompare(...)
  " return, if no GIT dir
  if !filereadable(s:GITentries)
    echo 'No '.s:GITentries.' !'
    return
  endif
  " eval params
  if (a:0 == 1) && (a:1 != '')
    if filereadable(a:1)
      let filename = a:1
      let dirname  = ''
    else
      let filename = ''
      let dirname  = a:1
    endif
  else
    let filename = expand("%:p:t")
    let dirname  = expand("%:p:h")
  endif
  let result = ''
  if filename == ''
    let result = GITGetLocalDirStatus(dirname)
  else
    let result = GITGetLocalStatus(filename)
  endif  " filename given
  return result
endfunction

" get info from GIT/Entries about given file/current buffer
function! GITGetLocalStatus(...)
  if a:0 == 0
    let filename = expand("%:p:t")
  else
    let filename = a:1
  endif
  if filename == ''
    return 'error:no filename'
  endif
  if a:0 > 1
    let entry=a:2
  else
    let entry=GITGetEntry(filename)
  endif
  let b:GITentry=entry
  let status = ''
  if entry == ''
    if isdirectory(filename)
      let status = "unknown:   <DIR>\t".filename"
    else
      let status = 'unknown:   '.filename
    endif
  else
    let entryver  = GITSubstr(entry,'/',2)
    let entryopt  = GITSubstr(entry,'/',4)
    let entrytag  = GITSubstr(entry,'/',5)
    let entrytime = GITtimeToStr(entry)
    if (!GITUsesFile()) || (g:GITfullstatus > 0)
      let status = filename."\t".entryver." ".entrytime." ".entryopt." ".entrytag
    else
      let status = entryver." ".entrytag." ".entryopt
    endif
    if !filereadable(filename)
      if isdirectory(filename)
        let status = 'directory: '.filename
      else
	if entry[0] == 'D'
          let status = "missing:   <DIR>\t".filename
	else
          let status = 'missing:   '.status
	endif
      endif
    else
      if entrytime == GITFiletimeToStr(filename)
	let status = 'unchanged: '.status
      else
	let status = 'modified:  '.status
      endif " time identical
    endif " file exists
    if GITUsesFile()
      let status = substitute(status,':','','g')
      let status = substitute(status,'\s\{2,}',' ','g')
    endif
  endif  " entry found
  unlet entry
  return status
endfunction

" get info on all files from GIT/Entries and given/current directory
" opens GIT/Entries only once, passing each entryline to GITGetLocalStatus
function! GITGetLocalDirStatus(...)
  let zbak = @z
  let ybak = @y
  if a:0 == 0
    let dirname = expand("%:p:h")
  else
    let dirname = a:1
  endif
  call GITChDir(dirname)
  let @z = glob("*")
  new
  silent! exec 'read '.s:GITentries
  let entrycount = line("$") - 1
  normal k"zP
  if (line("$") == entrycount) && (getline(entrycount) == '')
    " empty directory
    set nomodified
    return
  endif
  let filecount = line("$") - entrycount
  " collect status of all found files in @y
  let @y = ''
  let curlin = 0
  while curlin < filecount
    let curlin = curlin + 1
    let fn=getline(curlin)
    if fn != 'GIT'
      let search=escape(fn,'.')
      let v:errmsg = ''
      " find GITEntry
      silent! exec '/^D\?\/'.search.'\//'
      if v:errmsg == ''
        let entry = getline(".")
	" clear found file from GIT/Entries
	silent! exec 's/.*//eg'
      else
	let entry = ''
      endif
      " fetch info
      let @y = @y . GITGetLocalStatus(fn,entry) . "\n"
    endif
  endwhile
  " process files from GIT/Entries
  let curlin = filecount
  while curlin < line("$")
    let curlin = curlin + 1
    let entry = getline(curlin)
    let fn=GITSubstr(entry,'/',1)
    if fn != ''
      let @y = @y . GITGetLocalStatus(fn,entry) . "\n"
    endif
  endwhile
  set nomodified
  let result = @y
  bwipeout
  call GITRestoreDir()
  let @z = zbak
  let @y = ybak
  unlet zbak ybak
  return result
endfunction

" return info about filename from 'GIT/Entries'
function! GITGetEntry(filename)
  let result = ''
  if a:filename != ''
    silent! exec 'split '.s:GITentries
    let v:errmsg = ''
    let search=escape(a:filename,'.')
    silent! exec '/^D\?\/'.search.'\//'
    if v:errmsg == ''
      let result = getline(".")
    endif
    set nomodified
    silent! bwipeout
  endif
  return result
endfunction

" extract and convert timestamp from GITEntryItem
function! GITtimeToStr(entry)
  return GITAsctimeToStr(GITSubstr(a:entry,'/',3))
endfunction
" get and convert filetime
" include local time zone info
function! GITFiletimeToStr(filename)
  let time=getftime(a:filename)-(GMTOffset() * 60*60)
  return strftime('%Y-%m-%d %H:%M:%S',time)
endfunction

" entry format : ISO C asctime()
function! GITAsctimeToStr(asctime)
  let mon=strpart(a:asctime, 4,3)
  let DD=GITLeadZero(strpart(a:asctime, 8,2))
  let hh=GITLeadZero(strpart(a:asctime, 11,2))
  let nn=GITLeadZero(strpart(a:asctime, 14,2))
  let ss=GITLeadZero(strpart(a:asctime, 17,2))
  let YY=strpart(a:asctime, 20,4)
  let MM=GITMonthIdx(mon)
  " GIT/WinNT : no date given for merge-results
  if MM == ''
    let result = ''
  else
    let result = YY.'-'.MM.'-'.DD.' '.hh.':'.nn.':'.ss
  endif
  unlet YY MM DD hh nn ss mon
  return result
endfunction

" append a leading zero
function! GITLeadZero(value)
  let nr=substitute(a:value,' ','','g')
  if nr =~ '0.'                         " Already has a leading zero
    return nr
  endif
  if nr < 10
    let nr = '0' . nr
  endif
  return nr
endfunction

" return month (leading zero) from cleartext
function! GITMonthIdx(month)
  if match(a:month,'Jan') > -1
    return '01'
  elseif match(a:month,'Feb') > -1
    return '02'
  elseif match(a:month,'Mar') > -1
    return '03'
  elseif match(a:month,'Apr') > -1
    return '04'
  elseif match(a:month,'May') > -1
    return '05'
  elseif match(a:month,'Jun') > -1
    return '06'
  elseif match(a:month,'Jul') > -1
    return '07'
  elseif match(a:month,'Aug') > -1
    return '08'
  elseif match(a:month,'Sep') > -1
    return '09'
  elseif match(a:month,'Oct') > -1
    return '10'
  elseif match(a:month,'Nov') > -1
    return '11'
  elseif match(a:month,'Dec') > -1
    return '12'
  else
    return
endfunction

" divide string by sep, return field[index] .start at 0.
function! GITSubstr(string,separator,index)
  let sub = ''
  let idx = 0
  let bst = 0
  while bst < strlen(a:string) && idx <= a:index
    if a:string[bst] == a:separator
      let idx = idx + 1
    else
      if (idx == a:index)
        let sub = sub . a:string[bst]
      endif
    endif
    let bst = bst + 1
  endwhile
  unlet idx bst
  return sub
endfunction

"Get difference between local time and GMT
"strftime() returns the adjusted time
"->strftime(0) GMT=00:00:00, GMT+1=01:00:00
"->midyear=summertime: strftime(182*24*60*60)=02:00:00 (GMT+1)
"linux bug:wrong CEST information before 1980
"->use 331257600 = 01.07.80 00:00:00
function! GMTOffset()
  let winter1980 = (10*365+2)*24*60*60      " = 01.01.80 00:00:00
  let summer1980 = winter1980+182*24*60*60  " = 01.07.80 00:00:00
  let summerhour = strftime("%H",summer1980)
  let summerzone = strftime("%Z",summer1980)
  let winterhour = strftime("%H",winter1980)
  let winterday  = strftime("%d",winter1980)
  let curzone    = strftime("%Z",localtime())
  if curzone == summerzone
    let result = summerhour
  else
    let result = winterhour
  endif
  if result =~ '0.'                     " Leading zero will cause the number
    let result = strpart(result, 1)     " be regarded as octals
  endif
  " GMT - x : invert sign
  if winterday == 31
    let result = result - 24
  endif
  unlet curzone winterday winterhour summerzone summerhour summer1980 winter1980
  return result
endfunction

"-----------------------------------------------------------------------------
" Autocommand : set title, restore diffmode		{{{1
"-----------------------------------------------------------------------------

" restore title
function! GITBufEnter()
  " set/reset title
  if g:GITtitlebar
    if !exists("b:GITbuftitle")
      let &titlestring = s:GITorgtitle
    else
      let &titlestring = b:GITbuftitle
    endif
  endif
endfunction

" show status, add syntax
function! GITBufRead()
  " query status if wanted, file and GITdir exist
  if (g:GITautocheck > 0)
   \ && (expand("%:p:t") != '')
   \ && filereadable(expand("%:p:h").s:sep.s:GITentries)
    call GITLocalStatus()
  endif
  " highlight conflicts on every file
  call GITAddConflictSyntax()
endfunction

" show status
function! GITBufWrite()
  " query status if wanted, file and GITdir exist
  if (g:GITautocheck > 0)
   \ && (expand("%:p:t") != '')
   \ && filereadable(expand("%:p"))
   \ && filereadable(expand("%:p:h").s:sep.s:GITentries)
    call GITLocalStatus()
  endif
endfunction

" save pre diff settings
function! GITDiffEnter()
  let g:GITdifforgbuf = bufnr('%')
  let g:GITbakdiff		= &diff
  let g:GITbakscrollbind	= &scrollbind
  let g:GITbakwrap		= &wrap
  let g:GITbakfoldcolumn	= &foldcolumn
  let g:GITbakfoldenable	= &foldenable
  let g:GITbakfoldlevel		= &foldlevel
  let g:GITbakfoldmethod	= &foldmethod
endfunction

" restore pre diff settings
function! GITDiffLeave()
  call setwinvar(bufwinnr(g:GITdifforgbuf), '&diff'	  , g:GITbakdiff	)
  call setwinvar(bufwinnr(g:GITdifforgbuf), '&scrollbind' , g:GITbakscrollbind	)
  call setwinvar(bufwinnr(g:GITdifforgbuf), '&wrap'	  , g:GITbakwrap	)
  call setwinvar(bufwinnr(g:GITdifforgbuf), '&foldcolumn' , g:GITbakfoldcolumn	)
  call setwinvar(bufwinnr(g:GITdifforgbuf), '&foldenable' , g:GITbakfoldenable	)
  call setwinvar(bufwinnr(g:GITdifforgbuf), '&foldlevel'  , g:GITbakfoldlevel	)
  call setwinvar(bufwinnr(g:GITdifforgbuf), '&foldmethod' , g:GITbakfoldmethod	)
endfunction

" save original settings
function! GITBackupDiffMode()
  let g:GITorgdiff		= &diff
  let g:GITorgscrollbind	= &scrollbind
  let g:GITorgwrap		= &wrap
  let g:GITorgfoldcolumn	= &foldcolumn
  let g:GITorgfoldenable	= &foldenable
  let g:GITorgfoldlevel		= &foldlevel
  let g:GITorgfoldmethod	= &foldmethod
endfunction

" restore original settings
function! GITRestoreDiffMode()
  let &diff			= g:GITorgdiff
  let &scrollbind		= g:GITorgscrollbind
  let &wrap			= g:GITorgwrap
  let &foldcolumn		= g:GITorgfoldcolumn
  let &foldenable		= g:GITorgfoldenable
  let &foldlevel		= g:GITorgfoldlevel
  let &foldmethod		= g:GITorgfoldmethod
endfunction

" this is useful for mapping
function! GITSwitchDiffMode()
  if &diff
    call GITRestoreDiffMode()
  else
    diffthis
  endif
endfunction

" remember restoring prediff mode
function! GITDiffPrepareLeave()
  if match(expand("<afile>:e"),'dif','i') > -1
    " diffed buffer gets unloaded twice by :vert diffs
    " only react to the second unload
    let g:GITleavediff = g:GITleavediff + 1
    " restore prediff settings (see GITPrepareLeave)
    if (g:GITsavediff > 0) && (g:GITleavediff > 1)
      call GITDiffLeave()
      let g:GITleavediff = 0
    endif
  endif
endfunction

" edit GIT log message
function! GITCheckLogMsg()
  if &filetype == 'git' && g:GITeasylogmessage > 0
    let reg_bak=@"
    normal ggyy
    " insert an empty line if the first line begins with 'GIT:'
    if @" =~ '^GIT:'
      exec "normal i\<CR>\<C-O>k"
      set nomodified
    endif
    let @"=reg_bak
    " make <CR> save the log message and quit
    nmap <buffer> <CR> :x<CR>
    startinsert
  endif
endfunction

"-----------------------------------------------------------------------------
" finalization		{{{1
"-----------------------------------------------------------------------------

call GITGetFolderNames()		" vim user directories
call GITMakeLeaderMapping()		" create keymappings from menu shortcuts
call GITBackupDiffMode()		" save pre :diff settings

" provide direct access to GIT commands, using dumping and sorting from this script
command! -nargs=+ -complete=expression -complete=file -complete=function -complete=var GIT call GITDoCommand(<q-args>)

" highlight conflicts on every file
au BufRead * call GITBufRead()
" update status on write
au BufWritePost * call GITBufWrite()
" set title
au BufEnter * call GITBufEnter()
" restore prediff settings
au BufWinLeave *.dif call GITDiffPrepareLeave()
" insert an empty line and start in insert mode for the GIT log message
au BufRead git*,\d\+ call GITCheckLogMsg()

if !exists("loaded_gitmenu")
  let loaded_gitmenu=1
endif


"}}}
