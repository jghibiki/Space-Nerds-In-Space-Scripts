AC_DEBUG_MODE = 0

clear_all()

player_ids = get_player_ship_ids();
player_name = "Unknown Player"
if (player_ids[1]) then
    move_object(player_ids[1], startx, starty, startz);
    player_name = get_object_name(player_ids[1]);
    reset_player_ship(player_ids[1]);
    print("Playe ids", player_ids[1])
    set_faction(player_ids[1], 1); -- set player faction to neutral so only zarkons fight
end


base_module = "share.snis.luascripts.acm."

-- load API
package.loaded[base_module .. "api"] = nil -- force reload
local api = require(base_module .. "api")
if AC_DEBUG_MODE == 1 then
    api.__.test_api()
end

api.create.universe(5)


-- load random scenario
number_of_scenarios = 1
scenario_to_use = math.random(number_of_scenarios)

scenario_module = base_module .. "scenarios.s" ..  scenario_to_use
package.loaded[scenario_module] = nil -- force reload
local scenario = require(scenario_module)
print("Loadeded scenario " .. scenario_to_use .. " : " .. scenario_module)

scenario.init()
scenario.start()



