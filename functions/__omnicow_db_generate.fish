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

    set --query COWPATH; or set -l COWPATH /usr/share/cows
    set -l dbfile $omnicow_db_path/$omnicow_db_filename
    if test -e $dbfile; and not set --query _flag_force; and test (__omnicow_db_get all_files) = (string join ' ' $COWPATH/*.cow)
        return 0
    end

    set -l min_width
    set -l max_width
    set -l min_height
    set -l max_height
    set -l first_file_read false
    printf "allfiles,%s\n" (string join ',' $COWPATH/*.cow) >$dbfile
    for cowfile in $COWPATH/*.cow
        set -l cowfile_md5 (md5sum $cowfile | awk '{print $1}')
        set -l parsed_cow (perl -le '$eyes="oo";$thoughts="\\\\";$tongue="  ";do "'$cowfile'";print $the_cow;')

        set -l width (printf "%s\n" $parsed_cow | wc -L)
        set -l height (printf "%s\n" $parsed_cow | wc -l)
        if not $first_file_read
            set first_file_read true
            set min_width $width
            set max_width $width
            set min_height $height
            set max_height $height
        else
            set min_width (math min $width,$min_width)
            set max_width (math max $width,$max_width)
            set min_height (math min $height,$min_height)
            set max_height (math max $height,$max_height)
        end
        printf "cowfile,%s,%s,%d,%d\n" $cowfile $cowfile_md5 $width $height >>$dbfile
    end
    printf "value,min_width,%d\n" $min_width >>$dbfile
    printf "value,max_width,%d\n" $max_width >>$dbfile
    printf "value,min_height,%d\n" $min_height >>$dbfile
    printf "value,max_height,%d\n" $max_height >>$dbfile
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
