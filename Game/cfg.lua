p.configs = {
    "base_upscale",
    "max_upscale"
}

p.shader = 0 -- 0 for no shader

function p.get_shader_code(id)
    id = id or p.shader
    if ga_package2_var_exists("base", "shaders.installed."..id..".code") then
        return base64.decode(ga_package2_get_s("base", "shaders.installed."..id..".code"))
    end
    return ""
end

function p.get_shader_name(id)
    id = id or p.shader
    if ga_package2_var_exists("base", "shaders.installed."..id..".name") then
        return ga_package2_get_s("base", "shaders.installed."..id..".name")
    end
    return "None"
end

function p.add_shader(name, code_str)
    local num = p.get_shader_count()+1
    ga_package2_set_s("base", "shaders.installed."..num..".name", name)
    ga_package2_set_s("base", "shaders.installed."..num..".code", base64.encode(code_str))
end

function p.get_shader_count()
    for i = 1,math.huge do
        if not ga_package2_var_exists("base", "shaders.installed."..i..".name") then
            return i-1
        end
    end
end

function p.get(id)
    if ga_package2_var_exists("base", "shaders." .. p.configs[id]) then
        return ga_package2_get_i("base", "shaders.".. p.configs[id])
    end
    return 0
end

function p.set(id, val)
    if ga_package2_var_exists("base", "shaders." .. p.configs[id]) then
        ga_package2_set_i("base", "shaders." .. p.configs[id], val)
    end
end

function p.__load_game_early()
    ga_package2_init_i("base", "shaders.".. p.configs[1], 0)
    ga_package2_init_i("base", "shaders.".. p.configs[2], 7)
    ga_package2_init_s("base", "shaders.installed.1.name", "Fog")
    ga_package2_init_s("base", "shaders.installed.1.code", "bG9jYWwgciA9IHJheS5jKGRpciwgbmlsLCBuaWwsIDU2KQ0KDQpyOmNhc3QoKQ0KICAgICAgICAgICAgICAgIA0KbG9jYWwgY29sID0gc3RkLnZlYygwLDAsMCkNCmxvY2FsIGFscGhhID0gKHIubGVuZ3RoIG9yIDU2KS82NA0KDQpyZXR1cm4gY29sLGFscGhh")
    ga_package2_init_i("base", "shaders.selected_shader", 0)
    p.shader = ga_package2_get_i("base", "shaders.selected_shader")
end