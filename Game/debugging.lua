function p.tick()
    win_hud.add_element(170, function(wid)
        ga_win_set_char_size(wid, 0.01, 0.02)
        ga_win_set_front_color_default(wid)
        -- casting a ray.
        local r = ray.c(ga_get_sys_v("game.player.camera.look"))
        r:cast()
        local str = "Ray didnt hit"
        if r.hit then
            str = "bp: " .. std.vec_to_str(r.bp) .. " normal: " .. std.vec_to_str(r.normal)
        end
        ga_win_txt(wid, 0.3, 0.3, str)
        str = "didnt hit"
        if ga_look_object_block_exists() then
            local chunk_id = ga_look_object_block_get_chunk_id()
            if ga_chunk_id_to_level(chunk_id) == ga_get_viewer_level() then
                local bp = ga_chunk_id_and_lbp_to_bp(chunk_id, ga_look_object_block_get_lbp())
                local normal = std.side_int_to_vec(ga_look_object_block_get_normal_side())
                str = "bp: " .. std.vec_to_str(bp) .. " normal: " .. std.vec_to_str(normal)
            end
        end
        ga_win_txt(wid, 0.3, 0.4, str)
    end)
end

function p.__update_discrete_pre()
    --p.tick()
end