# Functions for generating names, mainly file names.

function name
	set DEFAULT_RANDOM 6

    set -l options -x 'd,t' 'd/date' 't/time' 'h/hostname' 's/suffix=' \
        'c/copy' 'p/path=?' 'r/random=?!_validate_int --min 1'  'm/markdown'

    test 0 -eq  (count $argv);
    set -l empty $status

    argparse -n name --max-args=0 $options -- $argv; or return

    # if only suffix is set, still generate random name
    if not set -q _flag_date; and not set -q _flag_time; and not set -q _flag_hostname;
        set -q _flag_random; or set _flag_random $DEFAULT_RANDOM
    end

    set -l acc ""

    if set -q _flag_date;
        test -n "$acc"; and set -a acc "_"
        set -a acc (date +'%Y-%m-%d')
    end
    if set -q _flag_time;
        test -n "$acc"; and set -a acc "_"
        set -a acc (date +'%Y-%m-%dT%H%M%S')
    end

    if set -q _flag_hostname;
        test -n "$acc"; and set -a acc "_"
        set -a acc (hostname)
    end

    if set -q _flag_random; or [ 0 -eq $empty ];
        test -n "$acc"; and set -a acc "_"

        test -n "$_flag_random"; or set _flag_random $DEFAULT_RANDOM
        set -a acc (xxd -p < /dev/urandom | tr -d '\n' | head -c $_flag_random)
    end

    if set -q _flag_suffix;
        set -a acc -- $_flag_suffix
    end

    if set -q _flag_path;
        test -n "$_flag_path"; or set _flag_path (pwd)

        set acc (realpath $_flag_path) / $acc
    end

    set -l result (string join "" $acc)

    if set -q _flag_markdown;
        set -l parts (string split '/' "$result")
        set result "[$parts[-1]]($result)"
    end

    echo -n $result
    if set -q _flag_copy;
        echo -n $result | copy
    end
end
