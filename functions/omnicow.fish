function omnicow
    argparse --stop-nonopt h/help -- $argv
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
        '  omnicow [OPTIONS...]' \
        '  omnicow [SUBCOMMAND]' \
        '' \
        'Options (all options from cowsay are also valid):' \
        '  -h, --help  Print help information' \
        '' \
        'Subcommands:' \
        '  db  Manage the omnicow database'
end
