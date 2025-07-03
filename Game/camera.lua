p.c = obj.class("Camera", nil, {
    new = function(self, cam_pos, look, left, up)
        self.pos = cam_pos
        self.look = look
        self.left = left
        self.up = up
    end,
    rasterize = function(self)
        local r = ray.c(self.look)
    end
})
