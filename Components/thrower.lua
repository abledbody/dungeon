local function throw(self, dir, item)
	item:throw(self, dir)
end

local function attach(object)
    object.animator.endCalls.throw = function() object.animator:setState("idle") end
    object.throw = throw
end

return attach