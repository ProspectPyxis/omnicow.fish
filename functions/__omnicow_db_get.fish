function __omnicow_db_get
    argparse --stop-nonopt h/help -- $argv
    if set --query _flag_help
        __omnicow_db_get_help
        return
    end

    # If database doesn't exist, create it
    test ! -e $omnicow_db_path/$omnicow_db_filename; and __omnicow_db_generate

    if not set --query argv[2]
        if test $argv[1] = all_files
            # Special case: get list of every file
            grep -m 1 '^allfiles,' $omnicow_db_path/$omnicow_db_filename \
                | awk -F',' '{$1 = ""; print $0}' | string trim
            return
        end

        # One argument; assuming trying to get non-cowfile value
        if not set -l found_value (string match -e "value,$argv[1]" < $omnicow_db_path/$omnicow_db_filename)
            printf "omnicow db get: value $argv[1] not found\n" >&2
            return 1
        end
        printf %s\n $found_value | awk -F',' '{print $3}'
    else
        # More than one argument; assuming trying to get cowfile value
        if not set -l field_index (contains --index $argv[2] md5 width height)
            printf "omnicow db get: no field $argv[2] in cowfile data\n" >&2
            return 1
        end
        if not set -l found_row (string match --regex "^cowfile,.*$argv[1]" --entire < $omnicow_db_path/$omnicow_db_filename)
            printf "omnicow db get: cowfile $argv[1] not found in the database\n" >&2
            return 1
        end
        printf %s\n $found_row | awk -F',' "{print \$$(math $field_index + 2)}"
    end
end

function __omnicow_db_get_help
    printf %s\n \
        'omnicow db get: Query the cowfile database' \
        '' \
        'Usage:' \
        '  omnicow db get [VALUE]' \
        '  omnicow db get [COWFILE] [FIELD]' \
        '' \
        '  If only one argument is given, it is assumed that you are trying to get a value not associated with a cowfile.' \
        '  If two or more arguments are given, it is assumed that you are trying to get a value associated with a cowfile.' \
        '  In the latter case, the first argument is the cowfile\'s name (.cow extension optional), and the second argument is the field to get.' \
        '  Any further arguments are ignored.' \
        '' \
        'Valid values for [VALUE]:' \
        '  all_files   Every cowfile stored in the database.' \
        '  min_width   The minimum width of every cowfile.' \
        '  max_width   The maximum width of every cowfile.' \
        '  min_height  The minimum height of every cowfile.' \
        '  max_height  The maximum height of every cowfile.' \
        '' \
        'Valid values for [FIELD]:' \
        '  md5     The md5 hash of the entire cowfile, including leading comments and extra perl functions.' \
        '  width   The width of the cow.' \
        '  height  The height of the cow.'
end
