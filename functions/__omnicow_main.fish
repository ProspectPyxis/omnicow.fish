function __omnicow_main
    # Always attempt to generate the cowfile before running
    __omnicow_db_generate

    # Argparse is broken for our purposes, so writing a custom argv parser is necessary
    # argparse --name omnicow --ignore-unknown --exclusive 'say,think' say think E default-eyes A no-exclude "max-height=" "max-width=" -- $argv
    string match --quiet -- --say $argv
    and string match --quiet -- --think $argv
    and begin
        printf "omnicow: say think: options cannot be used together\n\n" >&2
        __omnicow_help >&2
        return 1
    end

    set argv (string join -- ' ' $argv)

    set argv (string replace --all -- --say '' $argv)
    and set -l _flag_say

    set argv (string replace --all -- --think '' $argv)
    and set -l _flag_think

    set argv (string replace --all --regex -- '-E|--default-eyes' '' $argv)
    and set -l _flag_default_eyes

    set argv (string replace --all --regex -- '-A|--no-exclude' '' $argv)
    and set -l _flag_no_exclude

    string match --quiet --regex -- '--max-width[ =](?<_flag_max_width>\d+)' $argv
    and set argv (string replace --all --regex -- '--max-width[ =]\d+' '' $argv)

    string match --quiet --regex -- '--max-height[ =](?<_flag_max_height>\d+)' $argv
    and set argv (string replace --all --regex -- '--max-height[ =]\d+' '' $argv)

    set argv (string split --no-empty -- ' ' $argv)

    # List valid cowfiles
    set -l cowfiles
    if set --query _flag_no_exclude
        set cowfiles $COWPATH/*.cow
    else
        set cowfiles (string match --invert --all --regex (string join '|' $omnicow_exclude_cowfiles) $COWPATH/*.cow)
    end

    # Pick a command
    set -l cow_cmd
    if set --query _flag_say
        set cow_cmd cowsay
    else if set --query _flag_think
        set cow_cmd cowthink
    else
        set cow_cmd (random choice cowsay cowthink)
    end

    eval $cow_cmd -f (random choice $cowfiles) $argv
end
