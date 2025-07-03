p.c = obj.class("Ray", nil, {
    new = function(self, look, len)
        self.origin = ga_get_viewer_offset()
        self.level = ga_get_viewer_level()
        self.look = look
        self.len = len or 256
        return self
    end,
    cast = function(self)
        local function c(l) return ga_vis_test_level(self.level, self.origin, std.vec_add(self.origin, std.vec_scale(self.look, l))) end
        local l = self.len
        local l0 = 0.01
        local result = 0
        if c(l) then
            result = 1 -- no blocks in the ray's length
        end
        while result == 0 do -- dangerous!
            local mid = c((l0+l)/2)
            --ga_print("vec length: "..l..", mid: "..mid..", midpoint: "..(l0+l)/2)
            if mid then
                l0 = (l0+l)/2
            else
                l = (l0+l)/2
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
            -- figuring out the normal.
            local pos = std.vec_scale(std.vec_sub(self.hit_pos, std.block_center(self.bp)),2)
            local closest = 0
            for i = 1,5 do
                if std.dist(std.side_int_to_vec(i),pos) < std.dist(std.side_int_to_vec(closest),pos) then
                    closest = i
                end
            end
            self.normal = std.side_int_to_vec(closest)
        end
        return self
    end
})