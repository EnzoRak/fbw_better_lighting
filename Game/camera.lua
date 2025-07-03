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
    win_hud.add_element(171, function(wid)
        for i = 0, 32, 1 do
            local printCameraVector = std.vec_to_str(ga_get_sys_v("game.player.camera.look"))
            ga_print("camera vector: " .. printCameraVector)

            local r = ray.c(ga_get_sys_v("game.player.camera.look"))
            ga_print("ray vector: " .. std.vec_to_str(r.look))

            local cam_vec = ga_get_sys_v("game.player.camera.look")

            
            local ray_vec = cam_vec + { }
            


            r:cast()
        end
    end)
end

function p.__update_discrete_pre()
    p.tick()
end
