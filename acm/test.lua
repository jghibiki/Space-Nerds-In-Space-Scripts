
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

function add_planet(planet_name, obj_x, obj_y, obj_z, planet_radius, planet_security)
    print("Add Planet: x:" .. obj_x .. " y: " .. obj_y .. " z:" .. obj_z .. " radius: " .. planet_radius .. " security: " .. planet_security)
    return 1
end

function add_starbase(starbase_x, starbase_y, starbase_z, starbase_name_counter)
    print("Add Starbase: x: " .. starbase_x .. " y: " .. starbase_y .. " z:" .. starbase_z .. "starbase name id: " .. starbase_name_counter)
    return 1
end

-- load API
package.loaded["api"] = nil -- force reload
local api = require("api")
if AC_DEBUG_MODE == 1 then
    api.__.test_api_load()
end

-- commence testing

api.create.universe_5()
