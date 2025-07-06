function p.__render(wid)
    camera.draw(wid)
end

function p.__process_input(wid)
    if ga_win_key_pressed(wid, "P") then
        ga_window_push("menu_shader_mod")
    end
end