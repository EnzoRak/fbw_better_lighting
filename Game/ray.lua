p.c = obj.class("Ray", nil, {
    new = function(self, look)
        self.origin = ga_get_viewer_offset()
        self.dir = look
        return self
    end,
})