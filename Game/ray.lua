p.c = obj.class("Ray", nil, {
    new = function(self, look, len)
        self.origin = ga_get_viewer_offset()
        self.level = ga_get_viewer_level()
        self.dir = look
        self.len = len or 256
        return self
    end,
    cast = function(self)
        local function c(l) ga_vis_test_level(self.level, self.origin, std.vec_add(self.origin, std.vec_scale(self.look, l))) end
        local l = self.len
        local l0 = 0.01
        local result = 0
        if not c(l) then
            result = 1 -- no blocks in the ray's length
        end
        while result == 0 do -- dangerous!
            local mid = c((l0+l)/2)
            if mid then
                l = (l0+l)/2
            else
                l0 = (l0+l)/2
            end
            if l-l0 < 0.01 then
                result = 2
                break
            end
        end
        if result == 2 then
            self.hit = true
            self.hit_pos = std.vec_add(self.origin, std.vec_scale(self.look, l0))
            self.bp = std.lp_to_bp(std.vec_add(self.origin, std.vec_scale(self.look, l)))
        end
        return self
    end
})