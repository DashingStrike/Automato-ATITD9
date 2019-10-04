

function findImageInWindowVec(image_name, vec)
    srReadScreen()
    local this_loc = findImage("veg_janitor/" .. image_name .. ".png", window_search_box(vec), 4800)
    if not this_loc then
        return false
    end

    return Vector:new { x = this_loc[0] + 0, y = this_loc[1] + 0 }
end

function find_and_click_image(image_name, vec)
    local this_vec = findImageInWindowVec(image_name, vec)
    if this_vec then
        click(this_vec)
    end
    return this_vec
end

function window_search_box(vec)
    return makeBox(vec.x - 10, vec.y - 50, 200, 70)
end
function click(vector, right_click, show_mouse)
    if show_mouse then
        srClickMouse(vector.x, vector.y, right_click)
    else
        safeClick(vector.x, vector.y, right_click)
    end
    lsSleep(10)
end

function moveMouse(vector)
    srSetMousePos(vector.x, vector.y)
    lsSleep(click_delay)
end

function getWaitSpotAt(vector)
    return getWaitSpot(vector.x, vector.y)
end
-- Simple immutable vector class
Vector = {}
function Vector:new(o)
    o.x = o.x or o[1]
    o.y = o.y or o[2]
    return newObject(self, o, true)
end

function Vector:__add(vector)
    local x, y = Vector.getXY(vector)
    return Vector:new { self.x + x, self.y + y }
end

function Vector:__sub(vector)
    local x, y = Vector.getXY(vector)
    return Vector:new { self.x - x, self.y - y }
end

function Vector:__div(divisor)
    return Vector:new { self.x / divisor, self.y / divisor }
end

function Vector:__mul(multiplicand)
    return Vector:new { self.x * multiplicand, self.y * multiplicand }
end

function Vector.getXY(vector)
    return vector.x or vector[1], vector.y or vector[2]
end

function Vector:length()
    return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

function Vector:normalize()
    return self / self:length()
end

function Vector:__tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end

