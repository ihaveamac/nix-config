# this will break if an extension includes a folder called "share"...
linkRepoFiles () {
	find -L $out/share/php/$pname -maxdepth 1 -print0 | while read -d $'\0' f; do
		ln -s "$f" $out/$(basename "$f")
	done
}
postFixupHooks+=(linkRepoFiles)
