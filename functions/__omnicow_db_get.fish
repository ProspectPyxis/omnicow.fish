function __omnicow_db_get
    argparse --stop-nonopt h/help -- $argv
    if set --query $_flag_help
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
