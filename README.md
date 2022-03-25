# gitmenu
## Summary
gitmenu is a simple tool that allows you to do git diff/annotate/log in vim windows, so it's
extremely easy to check these commonly used info and view/pick up diffs in a vimdiff window.

## Installation
cd ~/.vim/plugin  
git clone https://github.com/chlin0123/gitmenu.git

## Usage
### Quick Guide
| Shortcut | Command                              |
|----------|--------------------------------------|
| ,gd      | git diff                             |
| ,ga      | git annotate                         |
| ,gl      | git log                              |
| ,gp      | git diff HEAD^ (diff to the parent)  |
| q        | close the window                     |

### Windows
After using the above shortcuts, gitmenu will open a horzontal or vertical split window with the requested output. Type
`:h window-move-cursor` in vim to know how to move between windows.
Type 'q' to close the newly opened window

### Working on diffs 
`,gd` and `,gp` opens a new window in diff mode, so you can easily get/move diff chunks between
the modified and original version. You can type `do` to obtain the diff from another window and 
type `dp` to put a diff to another window. (You should only modify the file, not the scratch buffer
gitmenu created for comparison). Type `:h copy-diffs` for more information.

### Additional Tips
You may open both annotate and log windows and find commit log message for a line in the original file.
The common whole word search `*` or `#` doesn't work well because the commit id hash in the annotate 
window is a short version. Try using the non-whole-word seach `g*` and `g#`. Type `:h g*` in your vim
for more details.
