-- p.c = obj.class("Camera", nil, {
--     new = function(self, cam_pos, look, left, up)
--         self.pos = cam_pos
--         self.look = look
--         self.left = left
--         self.up = up
--         return self
--     end,
--     rasterize = function(self, wid)
--         local r = ray.c(self.look)
--         ga_print("rasterization function")
--         ga_print(r.look)
        
--         return self
--     end
-- })

function p.tick()
    win_hud.add_element(0, function(wid)
        -- copied from Sebastian Lague's code. thanks Sebastian Lague!
        local look = Vector3.new(ga_get_sys_v("game.player.camera.look"))
        local left = Vector3.new(ga_get_sys_v("game.player.camera.left"))
        local right = -left
        local up = Vector3.new(ga_get_sys_v("game.player.camera.up"))

        local plane_height = math.tan(math.rad(ga_get_sys_f("display.camera_params.vfov") / 2)) * 2
        local plane_width = plane_height * ga_get_sys_f("display.camera_params.a_ratio.value")

        local bottom_left_local = Vector3.new(-plane_width / 2, -plane_height / 2, 1)

        for x = 1, 32 do
            for y = 1, 16 do
                --local printCameraVector = std.vec_to_str(ga_get_sys_v("game.player.camera.look"))
                --ga_print("camera vector: " .. printCameraVector)

                --local r = ray.c(ga_get_sys_v("game.player.camera.look"))
                --ga_print("ray vector: " .. std.vec_to_str(r.look))

                --local cam_vec = ga_get_sys_v("game.player.camera.look")

                
                --local ray_vec = cam_vec + { }
                
                local point_local = bottom_left_local + Vector3.new(plane_width * x/16, plane_height * y/16, 0)
                local point = Vector3.new(ga_get_viewer_offset()) + right * point_local.x + up * point_local.y + look * point_local.z
                local dir = std.normalize(point - ga_get_viewer_offset())

                local r = ray.c(dir)

                r:cast()

                if r.hit then
                    ga_win_quad_color_alpha(wid, (x-1)/16, (y-1)/16, x/16, y/16, std.vec(1,1,1), r.length/128)
                end
            end
        end
    end)
end

function p.__update_discrete_pre()
    p.tick()
end
