function __omnicow_db_generate
    argparse --name="omnicow db generate" h/help f/force -- $argv
    or begin
        __omnicow_db_generate_help
        return 1
    end
    if set --query $_flag_help
        __omnicow_db_generate_help
        return 0
    end
end

function __omnicow_db_generate_help
    printf %s\n \
        'omnicow db generate: Generate or regenerate cowfile database' \
        '' \
        'Usage: omnicow db generate [OPTIONS]' \
        '' \
        'Options:' \
        '  -f, --force  Force regenerate the database, even if no files have been added or removed' \
        '  -h, --help   Print help information'
end
