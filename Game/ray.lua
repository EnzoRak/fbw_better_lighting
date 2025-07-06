--local cache = {} -- huge cache

p.c = obj.class("Ray", nil, {
    new = function(self, look, origin, level, len)
        self.origin = origin or ga_get_viewer_offset()
        self.level = level or ga_get_viewer_level()
        self.look = look
        self.len = len or 256
        return self
    end,
    cast = function(self)
        --local cache_key = self.level .. "_" .. std.vec_to_str(self.origin) .. "_" .. std.vec_to_str(self.look) .. "_" .. self.len
        --[[if cache[cache_key] then
            local c = cache[cache_key]
            if c.result == 2 then
                self.hit = true
                self.hit_pos = c.hit_pos
                self.bp = c.bp
                self.normal = c.normal
                self.length = c.length
            end
            return self
        end]]
        --local function c(l) return ga_vis_test_level(self.level, self.origin, std.vec_add(self.origin, std.vec_scale(self.look, l))) end
        local function c(l, l0) return ga_vis_test_level(self.level, std.vec_add(self.origin, std.vec_scale(self.look, l0)), std.vec_add(self.origin, std.vec_scale(self.look, l))) end
        local l = self.len
        local l0 = 0
        local result = 0
        if ga_vis_test_level(self.level, self.origin, std.vec_add(self.origin, std.vec_scale(self.look, l))) then
            result = 1 -- no blocks in the ray's length
            --cache[cache_key] = {result = 1}
            return self
        end
        while result == 0 do -- dangerous!
            local midpos = (l0+l)*0.5
            local mid = c(midpos, l0)
            --ga_print("vec length: "..l..", mid: "..mid..", midpoint: "..(l0+l)/2)
            if mid then
                l0 = midpos
            else
                l = midpos
            end
            if l-l0 < 0.05 then
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
                if std.dist_linf(std.side_int_to_vec(i),pos) < std.dist_linf(std.side_int_to_vec(closest),pos) then
                    closest = i
                end
            end
            self.normal = std.side_int_to_vec(closest)
            self.length = l
            --[[cache[cache_key] = {
                result = 2,
                hit = true,
                hit_pos = self.hit_pos,
                bp = self.bp,
                normal = self.normal,
                length = self.length
            }]]
        end
        return self
    end
})