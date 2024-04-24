--[[pod_format="raw",created="2024-04-23 02:13:39",modified="2024-04-23 02:16:16",revision=19]]
function require(name)
   if _modules == nil then
        _modules={}
    end

    local already_imported = _modules[name]
    if already_imported ~= nil then
        return already_imported
    end

    local filename = fullpath(name..'.lua')
    local src = fetch(filename)

    if type(src) ~= "string" then
        notify("could not include "..filename)
        stop()
        return
    end

    -- https://www.lua.org/manual/5.4/manual.html#pdf-load
    -- chunk name (for error reporting), mode ("t" for text only -- no binary chunk loading), _ENV upvalue
    -- @ is a special character that tells debugger the string is a filename
    local func,err = load(src, "@"..filename, "t", _ENV)
    -- syntax error while loading
    if not func then
        send_message(3, {event="report_error", content = "*syntax error"})
        send_message(3, {event="report_error", content = tostr(err)})

        stop()
        return
    end

    local module = func()
    _modules[name]=module

    return module
end