local P = {}

local api = require(base_module .. "api")

function test()
    if AC_DEBUG_MODE == 1 then
        api.alert.speak("Scenario 1 Loaded")
    end
    print("Scenario 1 Loaded")
end
P.test = test

function init()
    print("Initializing Scenario 1")
end
P.init = init

function start()
    print("Staring Scenario 1")
end
P.start = start


return P -- important!!!
