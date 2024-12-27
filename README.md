# setd-mark
Setd Directory and Mark Bash Script
## Description

This script is a remake of an old set of scripts I made back in 1986 while at DEC (Digital Equipment) for VMS and later ported to unix systems back in the early 1990s.

This script uses the `mark` command to create persistent alphanumeric shortcuts (bookmarks) across sessions using environment variables for a current session access but stored in a file in `.bash_markstore` which is sourced on any new session to restore all such environment variables.  Such shortcuts are then able to be used by the `setd` (and `cd`) commands to allow for quick and easy directory navigation.

## Usage and Example
### Basic usage
To create a new bookmark, `cd` to the directory you wish to bookmark and run the command 
```bash
mark <shortcut>
```
Now you can quickly change to that directory by running the command
```bash
setd <shortcut>
cd <shortcut>
```

You can further use the shortcut as part of a longer path for nested directory access should the shortcut be set to a root of such path
```bash
cd <shortcut root>/<subdirectory>[/][<subdirectory>]...
```

The `setd` command comes complete with bash autocomplete support and unless you comment it out, also redefines `cd` to essentially mimic `setd`.

### Removing shortcuts
You can remove shortcuts by using the commands `unmark` or `mark` with appropriate flag:
```bash
unmark <shortcut>
mark [-r|rm|--remove] <shortcut>
```

### List all shortcuts
If you want to list all of the shortcuts in a tabular format, you can run the command:

```bash
mark [-l|--list]
```

## Additional usage flags for `setd` and `cd`
Besides using short cuts, in reliance on `pushd`, I have also allowed for implementation of a stack which can then be used to quickly move to paths in the list using the usual +0 +1 +2 options.  Plus on top of that, to simply swap between immediately prior directories, use the `-1` flag.  As an example, multiple uses of `cd -1` will take you back and forth between the most recent prior director(ies).  `cd (or setd) -l or -list` will also show the current stack.

## How it works
`mark` maintains environment variables prepended by `MARKDIR_` for each of the shortcuts you create and the directory paths they point to.  Those same shortcuts are also added to a file in your home directory (defaults to `~/.bash_markstore`) that contains a list of all of the shortcut environment variables you made and the paths they point to.  The `setd` and `cd` commands can then make use of these shortcuts in navigating paths and subdirectories using those paths.  In addition `setd` and `cd` have been set up to use `pushd` to allow for stack functionality as well.  Which replaces the original stack I directly had built into these commands 30 years ago to simplify things!

## Installation instructions
To install, simply source the bash script in your main working environment. You can do this by adding either of the following lines to your .bashrc or .bash_profile

### ~/.bashrc
```bash
source ~/path/setd.sh

# OR

. ~/path/setd.sh
```
# Updates
Based on feedback, I will continue to monitor and see if improvement and optimizations can be made to this script.
