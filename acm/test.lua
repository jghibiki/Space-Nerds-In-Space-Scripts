
AC_DEBUG_MODE = 1

-- mock out common SNIS api functions

function get_player_ship_ids()
    return { 1, 2, 3, 4, 5 }
end

function get_object_name(param)
    return "object_name"
end

function text_to_speech(ids, msg)
    print(msg)
end

local testing = {}

testing.planets = {}
testing.starbases = {}
testing.nebuli = {}
testing.asteroids = {}

function add_planet(planet_name, obj_x, obj_y, obj_z, planet_radius, planet_security)
    print("Add Planet: x:" .. obj_x .. " y: " .. obj_y .. " z:" .. obj_z .. " radius: " .. planet_radius .. " security: " .. planet_security)
    local new_planet = {}
    new_planet["x"] = obj_x
    new_planet["y"] = obj_y
    new_planet["z"] = obj_z
    new_planet["radius"] = planet_radius
    new_planet["planet_security"] = planet_security
    table.insert(testing.planets, new_planet)
    return 1
end

function add_starbase(starbase_x, starbase_y, starbase_z, starbase_name_counter)
    print("Add Starbase: x: " .. starbase_x .. " y: " .. starbase_y .. " z:" .. starbase_z .. "starbase name id: " .. starbase_name_counter)
    local new_sb = {}
    new_sb["x"] = starbase_x
    new_sb["y"] = starbase_y
    new_sb["z"] = starbase_z
    new_sb["name_counter"] = starbase_name_counter
    table.insert(testing.starbases, new_sb)
    return 1
end

function add_nebula(name, x, y, z, radius)
    print("Add Nebula: x: " .. x .. " y: " .. " z: " .. z .. " radius: " .. radius)
    local new_nebula = {}
    new_nebula["x"] = x
    new_nebula["y"] = y
    new_nebula["z"] = z
    new_nebula["radius"] = radius
    new_nebula["name"] = name
    table.insert(testing.nebuli, new_nebula)
end

function add_asteroid(x, y, z)
    print("Add asteroid: x: " .. x .. " y: " .. y .. " z: " .. z)
    local new_asteroid = {}
    new_asteroid["x"] = x
    new_asteroid["y"] = y
    new_asteroid["z"] = z
    table.insert(testing.asteroids, new_asteroid)
end

-- load API
package.loaded["api"] = nil -- force reload
local api = require("api")
if AC_DEBUG_MODE == 1 then
    api.__.test_api_load()
end

-- commence testing

api.create.universe_5()

print("Visualizing...")

grid = {}
for i=1, 100 do
    grid[i] = {}
    for j=1, 100 do
        grid[i][j] = "."
    end
end

for k, v in pairs(testing.planets) do
    print(v["x"]/api._.x_known_dim, v["y"]/api._.y_known_dim) 
    x = math.floor((v["x"]/api._.x_known_dim) * 100)
    y = math.floor((v["y"]/api._.y_known_dim) * 100)

    if x < 100 and x > 0 and y > 0 and y < 100 then
        grid[y][x] = "P"
    end
end

for k, v in pairs(testing.starbases) do
    print(v["x"]/api._.x_known_dim, v["y"]/api._.y_known_dim) 
    x = math.floor((v["x"]/api._.x_known_dim) * 100)
    y = math.floor((v["y"]/api._.y_known_dim) * 100)

    if x < 100 and x > 0 and y > 0 and y < 100 then
        grid[y][x] = "S"
    end
end

for k, v in pairs(testing.nebuli) do
    print(v["x"]/api._.x_known_dim, v["y"]/api._.y_known_dim) 
    x = math.floor((v["x"]/api._.x_known_dim) * 100)
    y = math.floor((v["y"]/api._.y_known_dim) * 100)

    if x < 100 and x > 0 and y > 0 and y < 100 then
        grid[y][x] = "N"
    end
end

for k, v in pairs(testing.asteroids) do
    print(v["x"]/api._.x_known_dim, v["y"]/api._.y_known_dim) 
    x = math.floor((v["x"]/api._.x_known_dim) * 100)
    y = math.floor((v["y"]/api._.y_known_dim) * 100)

    if x < 100 and x > 0 and y > 0 and y < 100 then
        grid[y][x] = "A"
    end
end

print("")

for i=1, 100 do
    line = ""
    for j=1, 100 do
        line = line .. grid[i][j]
    end
    print(line)
end
