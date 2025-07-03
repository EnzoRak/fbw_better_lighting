-- obj.lua (by EnzoRak)
-- version 1
-- Made for Fractal Block World.

-- this is part of lua_library_collection (at https://github.com/EnzoRak/lua_library_collection)
-- it is recommended to keep it up to date, and to report any bugs or suggestions to the github page

-- TODO add actual documentation

--[[
obj.lua is a library for creating objects to emulate object oriented programming.
]]

-- debugging settings
local exit_on_error = true

-- utils do not use in other files
p.util = {}
function p.util.handle_args(correct_types, caller, ...)
    local args = {...}
    if #args ~= #correct_types then
        ga_print("*** Error: obj." .. caller .. ": incorrect number of arguments (expected " .. #correct_types .. ", got " .. #args .. ")")
        if exit_on_error then ga_exit_with_error() end
        return
    end

    for i = 1, #correct_types do
        local arg = args[i]
        local correct_type = correct_types[i]
        if type(correct_type) == "string" then
            if type(arg) ~= correct_type then
                ga_print("*** Error: obj." .. caller .. ": incorrect argument type on argument " .. i .. ": expected " .. correct_type .. ", got " .. type(arg))
                if exit_on_error then ga_exit_with_error() end
                return
            end
        elseif type(correct_type) == "table" then
            local valid = false
            for j = 1, #correct_type do
                if type(arg) == correct_type[j] then
                    valid = true
                    break
                end
            end
            if not valid then
                ga_print("*** Error: obj." .. caller .. ": incorrect argument type on argument " .. i .. ": expected " .. table.concat(correct_type, ", or ") .. ", got " .. type(arg))
                if exit_on_error then ga_exit_with_error() end
                return
            end
        end
    end
end

p.classes = {}
p.classes_raw = {}

function p.class(name, parent, data)
    p.util.handle_args({"string", {"string", "nil"}, "table"}, "class", name, parent, data)

    p.classes_raw[name] = {parent = parent, data = data}

    local ret = {} -- the class
    local mt = {} -- the metatable

    local special_methods_unconverted = {"tostring", "add", "sub", "mul", "div", "pow", "unm", "eq", "lt", "le", "band", "bor", "bxor", "bnot", "shl", "shr", "concat", "len", "pairs", "ipairs", "index", "newindex"}
    local special_methods = {}
    for i = 1, #special_methods_unconverted do
        special_methods["__" .. special_methods_unconverted[i]] = true
    end

    if parent then 
        for i,v in pairs(p.classes_raw[parent].data) do
            ret[i] = v
        end
    end
    for i,v in pairs(data) do
        ret[i] = v
    end


    for i,v in pairs(ret) do
        if special_methods[i] then
            mt[i] = v
            ret[i] = nil
        end
    end

    if ret.typeof then ga_print("*** Warning: obj.class: class " .. name .. " has a typeof entry, this will be overridden") end
    ret.typeof = name
    if not ret.new then
        ga_print("*** Warning: obj.class: class " .. name .. " has no 'new' method, this class will be removed")
        p.classes[name] = nil
        p.classes_raw[name] = nil
        return
    end

    mt.__call = function(self, ...) return ret.new(p.class(name, parent, data), ...) end

    setmetatable(ret, mt)

    p.classes[name] = ret

    return ret
end

function typeof(obj)
    if type(obj) == "table" and obj.typeof then return obj.typeof end
    return type(obj)
end