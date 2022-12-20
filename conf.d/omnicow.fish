if not set --query omnicow_omnicowdb_path
    set --query XDG_DATA_HOME; or set XDG_DATA_HOME $HOME/.local/share
    set -g omnicow_omnicowdb_path $XDG_DATA_HOME/cows
end

set --query omnicow_omnicowdb_filename; or set -g omnicow_omnicowdb_filename "omnicowdb.csv"
