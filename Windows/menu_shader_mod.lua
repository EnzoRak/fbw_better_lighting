local cursor = {}
local cw = 0
local ch = 0
local txt_col = std.vec(0, 0.5, 0.5)


local menu = 0 -- 0 is pick submenu, 1 is config submenu, 2 is shader submenu
local shader_scroll = 0

local shader_contents = ""

function p.text_selectable(wid, x, y, text, sel_col)
    sel_col = sel_col or std.vec(0, 0.5, 0.5)
    ga_win_txt(wid, x, y, text)
    if cursor.x >= x and cursor.y >= y and cursor.x <= x + cw*#text and cursor.y <= y + ch then
        ga_win_line(wid, x,            y,      x + cw*#text, y,      sel_col)
        ga_win_line(wid, x + cw*#text, y,      x + cw*#text, y + ch, sel_col)
        ga_win_line(wid, x + cw*#text, y + ch, x,            y + ch, sel_col)
        ga_win_line(wid, x,            y + ch, x,            y,      sel_col)
        return ga_win_mouse_pressed(wid, true)
    end
    return false
end


function p.center_x(x,text)
    return x - cw*#text/2
end
function p.center_y(y)
    return y - ch/2
end

function p.set_char_size(wid, w, h)
    cw = w
    ch = h
    ga_win_set_char_size(wid, w, h)
end

function p.set_col(wid, col)
    local txt_col = col
    ga_win_set_front_color(wid, col)
end

function p.__render(wid)
    ga_win_set_background(wid, std.vec(0,0,0), 1)

    cursor = ga_win_get_cursor_pos(wid)

    p.set_col(wid, std.vec(0, 0.5, 0.5))

    if menu == 0 then
        p.set_char_size(wid, 0.02, 0.04)
        if p.text_selectable(wid, 0.44, 0.68, "Config") then
            menu = 1
        end
        if p.text_selectable(wid, 0.43, 0.28, "Shaders") then
            menu = 2
        end
    elseif menu == 1 then
        p.set_char_size(wid, 0.01, 0.02)

        ga_win_txt(wid, p.center_x(0.5,cfg.configs[1]), 0.6, cfg.configs[1])
        ga_win_txt(wid, p.center_x(0.5,tostring(2^cfg.get(1))), 0.6-ch, tostring(2^cfg.get(1)))
        if p.text_selectable(wid, p.center_x(0.4,"-"), 0.6-ch, "-") then
            cfg.set(1, math.max(0,cfg.get(1)-1))
        end
        if p.text_selectable(wid, p.center_x(0.6,"+"), 0.6-ch, "+") then
            cfg.set(1, math.min(5,cfg.get(1)+1))
        end

        ga_win_txt(wid, p.center_x(0.5,cfg.configs[2]), 0.4, cfg.configs[2])
        ga_win_txt(wid, p.center_x(0.5,tostring(2^cfg.get(2))), 0.4-ch, tostring(2^cfg.get(2)))
        if p.text_selectable(wid, p.center_x(0.4,"-"), 0.4-ch, "-") then
            cfg.set(2, math.max(3,cfg.get(2)-1))
        end
        if p.text_selectable(wid, p.center_x(0.6,"+"), 0.4-ch, "+") then
            cfg.set(2, math.min(10,cfg.get(2)+1))
        end
    elseif menu == 2 then
        p.set_char_size(wid, 0.01, 0.02)

        for i = 1, math.min(50,cfg.get_shader_count()-shader_scroll+1) do
            local name = cfg.get_shader_name(i-1+shader_scroll)
            p.set_col(wid, cfg.shader == i-1+shader_scroll and std.vec(0,1,0) or std.vec(0,0.5,0.5))
            if p.text_selectable(wid, p.center_x(0.5,name), 1-i*ch, name, cfg.shader == i-1+shader_scroll and std.vec(0,1,0) or std.vec(0,0.5,0.5)) then
                cfg.shader = i-1+shader_scroll
                ga_package2_set_i("base", "shaders.selected_shader", i-1+shader_scroll)
            end
        end

        p.set_col(wid, std.vec(0,0.5,0.5))

        if p.text_selectable(wid, 0.01, 0.01, "Install Shader") then
            menu = 3
        end
    elseif menu == 3 then
        p.set_char_size(wid, 0.01, 0.02)

        ga_win_txt(wid, p.center_x(0.5,"Copy shader contents to your clipboard"), 0.48, "Copy shader contents to your clipboard")
        if p.text_selectable(wid, 0.48, 0.28, "DONE") then
            shader_contents = ga_paste_from_clipboard()
            menu = 4
        end
    elseif menu == 4 then
        p.set_char_size(wid, 0.01, 0.02)

        ga_win_txt(wid, p.center_x(0.5,"Copy shader name to your clipboard"), 0.48, "Copy shader name to your clipboard")
        if p.text_selectable(wid, 0.48, 0.28, "DONE") then
            cfg.add_shader(ga_paste_from_clipboard(), shader_contents)
            menu = 2
        end
    end
end

function p.__process_input(wid)
    if ga_win_key_pressed(wid, "ESC") then
        if menu == 0 then
            ga_window_pop()
        elseif menu >= 3 then
            menu = 2
        else
            menu = 0
        end
    end
end