function __omnicow_db
    argparse --stop-nonopt h/help -- $argv
    if set --query _flag_help
        __omnicow_db_help
    else if not set --query argv[1]
        __omnicow_db_help
        return 1
    else if test $argv[1] = generate -o $argv[1] = gen
        __omnicow_db_generate $argv[2..]
    else if functions --query __omnicow_db_$argv[1]
        __omnicow_db_$argv[1] $argv[2..]
    else
        __omnicow_db_help
        return 1
    end
end

function __omnicow_db_help
    printf %s\n \
        'omnicow db: Manage omnicow database' \
        '' \
        'Usage: omnicow db [OPTIONS] [SUBCOMMAND]' \
        '' \
        'Options:' \
        '  -h, --help  Print help information' \
        '' \
        'Subcommands:' \
        '  gen, generate  Generate or regenerate cowfile database' \
        '  rm             Delete cowfile database' \
        '  get            Query the cowfile database' \
        '  list           List all cowfiles that fulfill certain conditions'
end
