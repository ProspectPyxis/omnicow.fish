function omnicow
    argparse --stop-nonopt --ignore-unknown h/help -- $argv 2>/dev/null
    if set --query _flag_help
        __omnicow_help
    else if functions --query __omnicow_$argv[1]
        __omnicow_$argv[1] $argv[2..]
    else
        __omnicow_main $argv
    end
end

function __omnicow_help
    printf %s\n \
        'Usage:' \
        '  omnicow [OPTIONS]' \
        '  omnicow [SUBCOMMAND]' \
        '' \
        'Options (all options from cowsay are also valid):' \
        '  --say, --think             Forces the usage of cowsay or cowthink, respectively, rather than picking randomly. These options are mutually exclusive.' \
        '  -E, --default-eyes         Always use the default eyes rather than randomizing.' \
        '  -A, --no-exclude           Do not exclude cowfiles listed in $omnicow_exclude_cowfiles from being picked.' \
        '  --max-width <MAX_WIDTH>    The maximum width of the picked cow.' \
        '  --max-height <MAX_HEIGHT>  The maximum height of the picked cow.' \
        '  -h, --help                 Print help information' \
        '' \
        'Subcommands:' \
        '  db  Manage the omnicow database'
end
