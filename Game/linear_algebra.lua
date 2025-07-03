--# selene: allow(unscoped_variables)
Vector2 = {}
function Vector2.new(a, b)
    local new = {}
    if type(a) == "table" then
        new = {x = a.x, y = a.y}
    elseif type(a) == "number" then
        new = {x = a, y = b}
    else
        game_log.error("linear_algebra", "Vector2.new() got passed a non-number or table, returning 0 vector")
        return Vector2.new(0, 0)
    end
    new.typeof = "Vector2"
    local mt = {
        __add = Vector2.add,
        __unm = Vector2.unm,
        __mul = Vector2.mul,
        __div = Vector2.div,
        __sub = Vector2.sub,
        __tostring = Vector2.tostr,
    }
    setmetatable(new, mt)
    return new
end

function Vector2.add(a, b)
    return Vector2.new(a.x + b.x, a.y + b.y)
end

function Vector2.sub(a, b)
    return Vector2.new(a.x - b.x, a.y - b.y)
end

function Vector2.mul(a, n)
    if type(n) ~= "number" then
        game_log.error("linear_algebra", "Vector2.mul() got passed a non-number for scalar, returning 0 vector, might break things")
        return Vector2.new(0, 0)
    end
    return Vector2.new(a.x * n, a.y * n)
end

function Vector2.div(a, n)
    if type(n) ~= "number" then
        game_log.error("linear_algebra", "Vector2.div() got passed a non-number for scalar, returning 0 vector, might break things")
        return Vector2.new(0, 0)
    end
    return Vector2.new(a.x / n, a.y / n)
end

function Vector2.dot(a, b)
    return a.x * b.x + a.y * b.y
end

function Vector2.unm(v)
    return Vector2.new(-v.x, -v.y)
end

function Vector2.len(v)
    return math.sqrt(v.x * v.x + v.y * v.y)
end

function Vector2.normalize(v)
    local len = Vector2.len(v)
    if len == 0 then
        game_log.error("linear_algebra", "Vector2.normalize() got passed a zero vector")
        return Vector2.new(0, 0)
    end
    return Vector2.new(v.x / len, v.y / len)
end

function Vector2.tostr(v)
    return "(" .. v.x .. ", " .. v.y .. ")"
end

Vector3 = {}
function Vector3.new(a, b, c)
    local new = {}
    if type(a) == "table" then
        new = {x = a.x, y = a.y, z = a.z}
    elseif type(a) == "number" then
        new = {x = a, y = b, z = c}
    else
        game_log.error("linear_algebra", "Vector3.new() got passed a non-number or table, returning 0 vector")
        return Vector3.new(0, 0, 0)
    end
    new.typeof = "Vector3"
    local mt = {
        __add = Vector3.add,
        __unm = Vector3.unm,
        __mul = Vector3.mul,
        __div = Vector3.div,
        __sub = Vector3.sub,
        __tostring = Vector3.tostr,
    }
    setmetatable(new, mt)
    return new
end

function Vector3.add(a, b)
    return Vector3.new(a.x + b.x, a.y + b.y, a.z + b.z)
end

function Vector3.sub(a, b)
    return Vector3.new(a.x - b.x, a.y - b.y, a.z - b.z)
end

function Vector3.mul(a, n)
    if type(n) ~= "number" then
        game_log.error("linear_algebra", "Vector3.mul() got passed a non-number for scalar, returning 0 vector, might break things")
        return Vector3.new(0, 0, 0)
    end
    return Vector3.new(a.x * n, a.y * n, a.z * n)
end

function Vector3.div(a, n)
    if type(n) ~= "number" then
        game_log.error("linear_algebra", "Vector3.div() got passed a non-number for scalar, returning 0 vector, might break things")
        return Vector3.new(0, 0, 0)
    end
    return Vector3.new(a.x / n, a.y / n, a.z / n)
end

function Vector3.dot(a, b)
    return a.x * b.x + a.y * b.y + a.z * b.z
end

function Vector3.unm(v)
    return Vector3.new(-v.x, -v.y, -v.z)
end

function Vector3.len(v)
    return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
end

function Vector3.normalize(v)
    local len = Vector3.len(v)
    if len == 0 then
        game_log.error("linear_algebra", "Vector3.normalize() got passed a zero vector")
        return Vector3.new(0, 0, 0)
    end
    return Vector3.new(v.x / len, v.y / len, v.z / len)
end

function Vector3.tostr(v)
    return "(" .. v.x .. ", " .. v.y .. ", " .. v.z .. ")"
end

Matrix2x2 = {}
function Matrix2x2.new(m11, m12, m21, m22)
    local new = {}
    if type(m11) ~= "number" then
        game_log.error("linear_algebra", "Matrix2x2.new() got passed a non-number for m11, returning 0 matrix")
        return Matrix2x2.new(0, 0, 0, 0)
    end
    if type(m12) ~= "number" then
        game_log.error("linear_algebra", "Matrix2x2.new() got passed a non-number for m12, returning 0 matrix")
        return Matrix2x2.new(0, 0, 0, 0)
    end
    if type(m21) ~= "number" then
        game_log.error("linear_algebra", "Matrix2x2.new() got passed a non-number for m21, returning 0 matrix")
        return Matrix2x2.new(0, 0, 0, 0)
    end
    if type(m22) ~= "number" then
        game_log.error("linear_algebra", "Matrix2x2.new() got passed a non-number for m22, returning 0 matrix")
        return Matrix2x2.new(0, 0, 0, 0)
    end
    new = {
        [1]={m11, m12},
        [2]={m21, m22},
        typeof = "Matrix2x2"
    }
    local mt = {
        __add = Matrix2x2.add,
        __unm = Matrix2x2.unm,
        __mul = Matrix2x2.mul,
        __div = Matrix2x2.div,
        __sub = Matrix2x2.sub,
        __tostring = Matrix2x2.tostr,
    }
    setmetatable(new, mt)
    return new
end

function Matrix2x2.add(a, b)
    return Matrix2x2.new(a[1][1] + b[1][1], a[1][2] + b[1][2],
                         a[2][1] + b[2][1], a[2][2] + b[2][2])
end

function Matrix2x2.sub(a, b)
    return Matrix2x2.new(a[1][1] - b[1][1], a[1][2] - b[1][2],
                         a[2][1] - b[2][1], a[2][2] - b[2][2])
end

function Matrix2x2.mul(a, b)
    local new = {}
    if typeof(a) == "Matrix2x2" and typeof(b) == "Matrix2x2" then
        new = Matrix2x2.new(a[1][1] * b[1][1] + a[1][2] * b[2][1],
                            a[1][1] * b[1][2] + a[1][2] * b[2][2],
                            a[2][1] * b[1][1] + a[2][2] * b[2][1],
                            a[2][1] * b[1][2] + a[2][2] * b[2][2])
    elseif typeof(a) == "Matrix2x2" and typeof(b) == "Vector2" then
        new = Vector2.new(a[1][1] * b.x + a[1][2] * b.y,
                          a[2][1] * b.x + a[2][2] * b.y)
    elseif typeof(a) == "Matrix2x2" and typeof(b) == "number" then
        new = Matrix2x2.new(a[1][1] * b, a[1][2] * b,
                            a[2][1] * b, a[2][2] * b)
    else
        game_log.error("linear_algebra", "Matrix2x2.mul() got passed a non-matrix2x2 or non-vector2, returning 0 matrix")
        return Matrix2x2.new(0, 0, 0, 0)
    end
    return new
end

function Matrix2x2.det(a)
    return a[1][1] * a[2][2] - a[1][2] * a[2][1]
end

function Matrix2x2.inv(a)
    local det = Matrix2x2.det(a)
    if det == 0 then
        game_log.error("linear_algebra", "Matrix2x2.inv() got passed a singular matrix, returning 0 matrix")
        return Matrix2x2.new(0, 0, 0, 0)
    end
    return Matrix2x2.new(a[2][2] / det, -a[1][2] / det,
                         -a[2][1] / det, a[1][1] / det)
end

function Matrix2x2.div(a, b)
    if typeof(b) == "Matrix2x2" then
        return Matrix2x2.mul(a, Matrix2x2.inv(b))
    elseif typeof(b) == "number" then
        return Matrix2x2.new(a[1][1] / b, a[1][2] / b,
                             a[2][1] / b, a[2][2] / b)
    else
        game_log.error("linear_algebra", "Matrix2x2.div() got passed a non-matrix2x2 or non-number, returning 0 matrix")
        return Matrix2x2.new(0, 0, 0, 0)
    end
end

function Matrix2x2.tostr(a)
    return "(" .. a[1][1] .. ", " .. a[1][2] .. ")" ..
           "(" .. a[2][1] .. ", " .. a[2][2] .. ")"
end

Matrix3x3 = {}
function Matrix3x3.new(m11, m12, m13, m21, m22, m23, m31, m32, m33)
    local new = {}
    if type(m11) ~= "number" then
        game_log.error("linear_algebra", "Matrix3x3.new() got passed a non-number for m11, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    if type(m12) ~= "number" then
        game_log.error("linear_algebra", "Matrix3x3.new() got passed a non-number for m12, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    if type(m13) ~= "number" then
        game_log.error("linear_algebra", "Matrix3x3.new() got passed a non-number for m13, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    if type(m21) ~= "number" then
        game_log.error("linear_algebra", "Matrix3x3.new() got passed a non-number for m21, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    if type(m22) ~= "number" then
        game_log.error("linear_algebra", "Matrix3x3.new() got passed a non-number for m22, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    if type(m23) ~= "number" then
        game_log.error("linear_algebra", "Matrix3x3.new() got passed a non-number for m23, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    if type(m31) ~= "number" then
        game_log.error("linear_algebra", "Matrix3x3.new() got passed a non-number for m31, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    if type(m32) ~= "number" then
        game_log.error("linear_algebra", "Matrix3x3.new() got passed a non-number for m32, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    if type(m33) ~= "number" then
        game_log.error("linear_algebra", "Matrix3x3.new() got passed a non-number for m33, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    new = {
        [1]={m11, m12, m13},
        [2]={m21, m22, m23},
        [3]={m31, m32, m33},
        typeof = "Matrix3x3"
    }
    local mt = {
        __add = Matrix3x3.add,
        __unm = Matrix3x3.unm,
        __mul = Matrix3x3.mul,
        __div = Matrix3x3.div,
        __sub = Matrix3x3.sub,
        __tostring = Matrix3x3.tostr,
    }
    setmetatable(new, mt)
    return new
end

function Matrix3x3.add(a, b)
    return Matrix3x3.new(a[1][1] + b[1][1], a[1][2] + b[1][2], a[1][3] + b[1][3],
                         a[2][1] + b[2][1], a[2][2] + b[2][2], a[2][3] + b[2][3],
                         a[3][1] + b[3][1], a[3][2] + b[3][2], a[3][3] + b[3][3])
end

function Matrix3x3.sub(a, b)
    return Matrix3x3.new(a[1][1] - b[1][1], a[1][2] - b[1][2], a[1][3] - b[1][3],
                         a[2][1] - b[2][1], a[2][2] - b[2][2], a[2][3] - b[2][3],
                         a[3][1] - b[3][1], a[3][2] - b[3][2], a[3][3] - b[3][3])
end

function Matrix3x3.mul(a, b)
    local new = {}
    if typeof(a) == "Matrix3x3" and typeof(b) == "Matrix3x3" then
        new = Matrix3x3.new(a[1][1] * b[1][1] + a[1][2] * b[2][1] + a[1][3] * b[3][1],
                            a[1][1] * b[1][2] + a[1][2] * b[2][2] + a[1][3] * b[3][2],
                            a[1][1] * b[1][3] + a[1][2] * b[2][3] + a[1][3] * b[3][3],
                            a[2][1] * b[1][1] + a[2][2] * b[2][1] + a[2][3] * b[3][1],
                            a[2][1] * b[1][2] + a[2][2] * b[2][2] + a[2][3] * b[3][2],
                            a[2][1] * b[1][3] + a[2][2] * b[2][3] + a[2][3] * b[3][3],
                            a[3][1] * b[1][1] + a[3][2] * b[2][1] + a[3][3] * b[3][1],
                            a[3][1] * b[1][2] + a[3][2] * b[2][2] + a[3][3] * b[3][2],
                            a[3][1] * b[1][3] + a[3][2] * b[2][3] + a[3][3] * b[3][3])
    elseif typeof(a) == "Matrix3x3" and typeof(b) == "Vector3" then
        new = Vector3.new(a[1][1] * b.x + a[1][2] * b.y + a[1][3] * b.z,
                          a[2][1] * b.x + a[2][2] * b.y + a[2][3] * b.z,
                          a[3][1] * b.x + a[3][2] * b.y + a[3][3] * b.z)
    elseif typeof(a) == "Matrix3x3" and typeof(b) == "number" then
        new = Matrix3x3.new(a[1][1] * b, a[1][2] * b, a[1][3] * b,
                            a[2][1] * b, a[2][2] * b, a[2][3] * b,
                            a[3][1] * b, a[3][2] * b, a[3][3] * b)
    else
        game_log.error("linear_algebra", "Matrix3x3.mul() got passed a non-matrix3x3 or non-vector3, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    return new
end

function Matrix3x3.det(a)
    return a[1][1] * a[2][2] * a[3][3] + a[1][2] * a[2][3] * a[3][1] + a[1][3] * a[2][1] * a[3][2] -
           a[1][3] * a[2][2] * a[3][1] + a[1][1] * a[2][3] * a[3][2] + a[1][2] * a[2][1] * a[3][3]
end

function Matrix3x3.inv(a)
    local det = Matrix3x3.det(a)
    if det == 0 then
        game_log.error("linear_algebra", "Matrix3x3.inv() got passed a singular matrix, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
    return Matrix3x3.new((a[2][2] * a[3][3] - a[2][3] * a[3][2]) / det,
                         (-a[2][1] * a[3][3] + a[2][3] * a[3][1]) / det,
                         (a[2][1] * a[3][2] - a[2][2] * a[3][1]) / det,
                         (-a[1][2] * a[3][3] + a[1][3] * a[3][2]) / det,
                         (a[1][1] * a[3][3] - a[1][3] * a[3][1]) / det,
                         (-a[1][1] * a[3][2] + a[1][2] * a[3][1]) / det,
                         (a[1][2] * a[2][3] - a[1][3] * a[2][2]) / det,
                         (-a[1][1] * a[2][3] + a[1][3] * a[2][1]) / det,
                         (a[1][1] * a[2][2] - a[1][2] * a[2][1]) / det)
end

function Matrix3x3.div(a, b)
    if typeof(b) == "Matrix3x3" then
        return Matrix3x3.mul(a, Matrix3x3.inv(b))
    elseif typeof(b) == "number" then
        return Matrix3x3.new(a[1][1] / b, a[1][2] / b, a[1][3] / b,
                             a[2][1] / b, a[2][2] / b, a[2][3] / b,
                             a[3][1] / b, a[3][2] / b, a[3][3] / b)
    else
        game_log.error("linear_algebra", "Matrix3x3.div() got passed a non-matrix3x3 or non-number, returning 0 matrix")
        return Matrix3x3.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
    end
end

function Matrix3x3.tostr(a)
    return "(" .. a[1][1] .. ", " .. a[1][2] .. ", " .. a[1][3] .. ")" ..
           "(" .. a[2][1] .. ", " .. a[2][2] .. ", " .. a[2][3] .. ")" ..
           "(" .. a[3][1] .. ", " .. a[3][2] .. ", " .. a[3][3] .. ")"
end

Matrix2x2.identity = Matrix2x2.new(1, 0, 0, 1)
Matrix3x3.identity = Matrix3x3.new(1, 0, 0, 0, 1, 0, 0, 0, 1)