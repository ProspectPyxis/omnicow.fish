if not set --query omnicow_db_path
    set --query XDG_DATA_HOME; or set XDG_DATA_HOME $HOME/.local/share
    set -g omnicow_db_path $XDG_DATA_HOME/cows
end

set --query omnicow_db_filename; or set -g omnicow_db_filename "omnicowdb.csv"
