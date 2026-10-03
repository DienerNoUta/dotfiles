function audio --wraps='wfas --connect 192.168.0.4' --description 'alias audio=wfas --connect 192.168.0.4'
    wfas --connect 192.168.0.5 $argv
end
