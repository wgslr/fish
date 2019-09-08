# Defined in /tmp/fish.bREUQM/dockerrm.fish @ line 2
function dockerrm
	docker ps -aq | xargs -t --no-run-if-empty docker rm -f;
    docker volume ls -q | grep '[a-z0-9]{64}$' -P | xargs -t --no-run-if-empty docker volume rm;
end
