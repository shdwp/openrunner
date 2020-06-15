--- @class __input
--- @field cursorX number
--- @field cursorY number
__input = {}

--- @return boolean
function __input:keyDown(n) end

--- @return boolean
function __input:keyPressed(k) end

---  @type __input
Input = nil

--- @class Vec3
--- @field x number
--- @field y number
--- @field z number
_vec3 = {}

--- @class Camera
--- @field position Vec3
--- @field direction Vec3
_camera = {}

--- @class __debug
__debug = {}

--- @type __debug
Debug = nil
