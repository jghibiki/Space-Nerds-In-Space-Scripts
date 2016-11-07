AC_DEBUG_MODE = 1

base_module = "share.snis.luascripts.acm."

-- load API
package.loaded[base_module .. "api"] = nil -- force reload
local api = require(base_module .. "api")
if AC_DEBUG_MODE == 1 then
    api.__.test_api()
end

api.create.universe(4)


-- load random scenario
number_of_scenarios = 1
scenario_to_use = math.random(number_of_scenarios)

scenario_module = base_module .. "scenarios.s" ..  scenario_to_use
package.loaded[scenario_module] = nil -- force reload
local scenario = require(scenario_module)
print("Loadeded scenario " .. scenario_to_use .. " : " .. scenario_module)

scenario.init()
scenario.start()



