local function throw(self, dir, item)

end

local function attach(object)
    object.animator.endCalls.throw = function() object.animator:setState("idle") end
    object.throw = throw
end

return attach