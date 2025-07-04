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
local x_res_start = 16
local y_res_start = 9
local upscale = 1
local upscale_timer = 0
local data = {}
--[[local ui_elements = {} -- we list ui elements here, to save ray computation time
                       -- instead of manually inputting everything, we will gather it from the calls
local _ga_win_quad = ga_win_quad
function ga_win_quad(wid, x1, y1, x2, y2, tex)
    _ga_win_quad(wid, x1, y1, x2, y2, tex)
    ui_elements[#ui_elements+1] = {x1, y1, x2, y2}
end
local _ga_win_quad_two = ga_win_quad_two
function ga_win_quad_two(wid, x1, y1, x2, y2, tex, tex2, frac)
    _ga_win_quad_two(wid, x1, y1, x2, y2, tex, tex2, frac)
    ui_elements[#ui_elements+1] = {x1, y1, x2, y2}
end]]

function p.draw(wid)
    --if true then return end
    
    if upscale < 100 then upscale_timer = upscale_timer - 1 end
    if upscale_timer <= 0 then upscale = upscale * 2 end
    local not_moving = std.dist_linf(old_pos, ga_get_viewer_offset()) < 0.0001 and std.dist_linf(old_look, ga_get_sys_v("game.player.camera.look")) < 0.0001 and std.dist(old_up, ga_get_sys_v("game.player.camera.up")) < 0.0001
    if not not_moving then upscale = 1 end
    local x_res = x_res_start * upscale
    local y_res = y_res_start * upscale
    if not_moving and upscale_timer > 0 then
        for _,v in ipairs(data) do
            ga_win_quad_color_alpha(wid, v[1], v[2], v[3], v[4], v[5], v[6] or 1)
        end
        ga_win_txt(wid, 0.6, 0.6, "#data " .. #data)
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

        local plane_height = math.tan(math.rad(ga_get_sys_f("display.camera_params.vfov") * 0.5)) * 2
        local plane_width = plane_height * ga_get_sys_f("display.camera_params.a_ratio.value")

        local bottom_left_local = Vector3.new(-plane_width * 0.5, -plane_height * 0.5, 1)
        local x_f = 1/x_res
        local y_f = 1/y_res
        for x = 1, x_res do
            for y = 1, y_res do
                local point_local = bottom_left_local + Vector3.new(plane_width * x * x_f, plane_height * y * y_f, 0)
                local point = Vector3.new(ga_get_viewer_offset()) + right * point_local.x + up * point_local.y + look * point_local.z
                local dir = std.normalize(point - ga_get_viewer_offset())

                --[[for i = 1,#ui_elements do
                    local v = ui_elements[i]
                    if v[1] <= (x-1)*x_f and v[2] <= (y-1)*y_f and v[3] >= x*x_f and v[4] >= y*y_f then -- checking if we are gonna be hidden by the ui element
                        goto continue -- we will be hidden by the ui element, so we will not render this pixel
                    end
                end]]
                
                local r = ray.c(dir, nil, nil, 56)

                r:cast()
                
                local col = std.vec(0,0,0)
                local alpha = (r.length or 56)/64
                ga_win_quad_color_alpha(wid, (x-1)*x_f, (y-1)*y_f, x*x_f, y*y_f, col, alpha)
                if data[#data] and data[#data][3] == x*x_f and data[#data][4] == (y-1)*y_f and math.abs(data[#data][6]-alpha) < 0.015 and std.dist_linf(data[#data][5], col) < 0.006 then
                    data[#data][4] = y*y_f
                else
                    data[#data+1] = {(x-1)*x_f, (y-1)*y_f, x*x_f, y*y_f, col, alpha}
                end
                ::continue::
            end
            if x_res > 100 then ga_print("Rendering... (" .. math.floor(x*x_f*100) .. "%)") end
        end
    end
    if upscale_timer <= 0 or not not_moving then upscale_timer = math.min(300,2*upscale) end
    --ui_elements = {}
end

function p.__load_game_early()
    ga_hud_window_add("shader", -4)
end