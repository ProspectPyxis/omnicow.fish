function __omnicow_db_list
    argparse --name "omnicow db list" --ignore-unknown h/help -- $argv
    if set --query _flag_help
        __omnicow_db_list_help
        return 0
    end

    set argv (string join -- ' ' $argv)

    string match --quiet --regex -- '--max-width[ =](?<_flag_max_width>\d+)' $argv
    and set argv (string replace --all --regex -- '--max-width[ =]\d+' '' $argv)

    string match --quiet --regex -- '--max-height[ =](?<_flag_max_height>\d+)' $argv
    and set argv (string replace --all --regex -- '--max-height[ =]\d+' '' $argv)

    test -n "$(string trim -- $argv)"
    and begin
        printf "omnicow db list: %s: unknown option\n\n" (string split --no-empty -- ' ' $argv)[1] >&2
        __omnicow_db_list_help >&2
        return 1
    end

    set -l max_width_condition ''
    set --query _flag_max_width
    and set max_width_condition ' && $4 <= '$_flag_max_width

    set -l max_height_condition ''
    set --query _flag_max_height
    and set max_height_condition ' && $5 <= '$_flag_max_height

    awk -F',' "\$1 == \"cowfile\"$max_width_condition$max_height_condition {print \$2}" "$omnicow_db_path/$omnicow_db_filename"
end

function __omnicow_db_list_help
    printf %s\n \
        'omnicow db list: List all cowfiles that fulfill certain conditions' \
        '' \
        'Usage: omnicow db list [OPTIONS]' \
        '' \
        'Options:' \
        '  --max-width <MAX_WIDTH>    The maximum allowed width of a cow (inclusive)' \
        '  --max-height <MAX_HEIGHT>  The maximum allowed height of a cow (inclusive)' \
        '  -h, --help                 Print help information'
end
