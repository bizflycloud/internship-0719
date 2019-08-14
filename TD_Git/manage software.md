# Manage Software

**APT**

> Advanced Packaging Tool is a tool made for managing packages, it provides an efficient way of handling package in a way “pleasant for end users”.

**APT_COMMANDS**

|apt commands|the command it replace|command's function|
|:---------------|:---------:|-----------------:|
|apt install|apt-get install|Installs a pakage|
|apt remove|apt-get remove|Removes a package|
|apt purge|apt-get purge|Removes package with configuration|
|apt update|apt-get update|Refreshes repository index|
|apt upgrade|apt-get upgrade|Upgrades all upgradable packages|
|apt autoremove|apt-get autoremove|Removes unwanted packages|
|apt full-upgrade|apt-get dist-upgrade|Upgrades packages with auto-handling of dependencies|
|apt search|apt-cache search|Searches for the program|
|apt show|apt-cache show|Shows package details|
|apt list||Lists packages with criteria (installed, upgradable etc)|
|apt edit-sources||Edits sources list|


**RPM**

> RedHat Package Manager is an open packaging system, which runs on Red Hat Enterprise Linux as well as other Linux and UNIX systems

1. `rpm –checksig (package name)` Checking package-signature
2. `rpm -ivh (package name)` install package with hash while unpacking files and view the progress
3. `rpm  --nodeps (package name)` ignoring dependencies if you sure that nothing’s missing
4. `rpm -q (pkg name)` query
5. `rpm -ql (pkg name)` list all installed files of pkg
6. `rpm -qa –last` list all recently installed pkg
7. `rpm -U (pkg name)` upgrade 
8. `rpm -e  (pkg name)` remove 
9. `rpm -qf (file dir)` query file in pkg
10. `rpm -qi (pkg name)` query 

**System file types**

1. ext2: ext improvement 16GB - 2TB
2. ext3: ext 2 added performance improvement 16GB - 2TB
3. ext4: performance improvement besides proving additional features 16GB-16TB
4. jfs : an alternative to ext4 and , when cpu power’s limited, jfs comes handy

**File system consistency check** (used to check, optionally repair filesystems)

*- fsck runs at boot time when:

	*a file system’s marked as “dirty”- its written state is inconsistent with data that was 			scheduled to be written
	
	*a file system has been mounted for times without being checked.

==>fsck can be run manually on unmounted filesystems by a superuser.
	
>*fsck command itseft to interacts a matching filesys - fsck command regardless of filesys types and it has 3 mode: 
		
		*check errors, prompt the user interactively to resolve individual problems 
		
		*check errors, fix automatically 
		
		*check errors, just display errors on stdo
	