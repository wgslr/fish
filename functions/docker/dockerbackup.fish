# Defined in /tmp/fish.cwNFxi/dockerbackup.fish @ line 2
function dockerbackup
	set -l image $argv[1]
    set -l zstdargs $argv[2..-1]
	docker pull $image && docker save $image | zstd -T0 - -o (string split '/' $image | tail -n 1).tar.zst $zstdargs
end
