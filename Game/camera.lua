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
local old_pos = ga_get_viewer_offset()
local old_look = ga_get_sys_v("game.player.camera.look")
local old_up = ga_get_sys_v("game.player.camera.up")
local x_res_start = 8
local y_res_start = 4
local upscale = 1
local upscale_timer = 0
local data = {}
function p.tick()
    win_hud.add_element(0, function(wid)
        if upscale < 500 then upscale_timer = upscale_timer - 1 end
        if upscale_timer <= 0 then upscale = upscale * 2 end
        local not_moving = std.dist(old_pos, ga_get_viewer_offset()) < 0.0001 and std.dist(old_look, ga_get_sys_v("game.player.camera.look")) == 0 and std.dist(old_up, ga_get_sys_v("game.player.camera.up")) == 0
        if not not_moving then upscale = 1 end
        local x_res = x_res_start * upscale
        local y_res = y_res_start * upscale
        if not_moving and upscale_timer > 0 then
            --[[for x = 1, x_res do
                for y = 1, y_res do
                    if not data[x] then break end
                    ga_win_quad_color_alpha(wid, (x-1)/x_res, (y-1)/y_res, x/x_res, y/y_res, std.vec(0,0,0), data[x][y] or 1)
                end
            end]]
            if upscale > 10 then
                for _,v in ipairs(data) do
                    ga_win_quad_color_alpha(wid, v[1], v[2], v[3], v[4], v[5], v[6] or 1)
                end
            end
        else
            old_pos = ga_get_viewer_offset()
            old_look = ga_get_sys_v("game.player.camera.look")
            old_up = ga_get_sys_v("game.player.camera.up")
            data = {}
            -- copied from Sebastian Lague's code. thanks Sebastian Lague!
            local look = Vector3.new(ga_get_sys_v("game.player.camera.look"))
            local left = Vector3.new(ga_get_sys_v("game.player.camera.left"))
            local right = -left
            local up = Vector3.new(ga_get_sys_v("game.player.camera.up"))

            local plane_height = math.tan(math.rad(ga_get_sys_f("display.camera_params.vfov") / 2)) * 2
            local plane_width = plane_height * ga_get_sys_f("display.camera_params.a_ratio.value")

            local bottom_left_local = Vector3.new(-plane_width / 2, -plane_height / 2, 1)
            for x = 1, x_res do
                for y = 1, y_res do
                    local point_local = bottom_left_local + Vector3.new(plane_width * x/x_res, plane_height * y/y_res, 0)
                    local point = Vector3.new(ga_get_viewer_offset()) + right * point_local.x + up * point_local.y + look * point_local.z
                    local dir = std.normalize(point - ga_get_viewer_offset())

                    local r = ray.c(dir, nil, nil, 56)

                    r:cast()

                    local col = std.vec(0,0,0)
                    local alpha = r.hit and r.length/64 or 0.875
                    ga_win_quad_color_alpha(wid, (x-1)/x_res, (y-1)/y_res, x/x_res, y/y_res, col, alpha)
                    if data[#data] and math.abs(data[#data][3]-x/x_res) < 0.001 and std.dist(data[#data][5], col) < 0.001 and math.abs(data[#data][6]-alpha) < 0.01 then
                        data[#data][4] = data[#data][4] + 1/y_res
                    else
                        data[#data+1] = {(x-1)/x_res, (y-1)/y_res, x/x_res, y/y_res, col, alpha}
                    end
                end
            end
        end
        if upscale_timer <= 0 or not not_moving then upscale_timer = math.min(100,2*upscale) end
    end)
end

function p.__update_discrete_pre()
    p.tick()
end
