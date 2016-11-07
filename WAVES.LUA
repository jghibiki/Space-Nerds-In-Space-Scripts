-- IDEAS
-- Scale difficulty based on the number of player ships

jeutral =  0;
ally = 1;
enemy = 2;

CRUISER = 0;
DESTROYER = 1;
FREIGHTER = 2;
TANKER = 3;
TRANSPORT = 4;
BATTLESTAR = 5;
STARSHIP = 6;
ASTEROIDMINER = 7;
SCIENCE = 8;
SCOUT = 9;
DRAGONHAWK = 10;
SKORPIO = 11;
DISRUPTOR = 12;
RESEARCH_VESSEL = 13;

violent_ships = { 0, 1, 6, 9, 10, 11, 12 }
enemies = {};

-- create reward
reward_id = add_commodity("flux capacity", "gigawatts", 100.0, 0.5, 1.0, 0.0, 0.0, 0.0, 0.0)
--add_commodity("The Answer to Life, The Universe, and Everything", "numbers", 42.0, 0, 1.0, 0.1, 0.1, 0.1, 0)

-- clear everything out of the universe except player ships
clear_all();

-- announcement function
function announce(message)
    text_to_speech(player_ids[1], message)
end


-- Where the player starts
startx = 101000;
starty = 101000;
startz = 201000;

player_ids = get_player_ship_ids();
player_name = "Unknown Player"
if (player_ids[1]) then
    move_object(player_ids[1], startx, starty, startz);
    player_name = get_object_name(player_ids[1]);
    reset_player_ship(player_ids[1]);
    set_faction(player_ids[1], ally); -- set player faction to neutral so only zarkons fight
end

-- create planet
planet_x = startx + 50000
planet_y = starty 
planet_z = startz
planet_radius = 5000
planet_security = 0
planet_health_start = 500
planet_health = planet_health_start
planet_first_hit = 0
planet_cities = { "MERIDIAN", "PRYOSBURG", "KENNERSVILLE", "PARAKKA", "BRAKKENFEL" }
planet_destroyed_city_count = 0
planet_id = add_planet("Home", planet_x, planet_y, planet_z, planet_radius, planet_security)

function planet_hit_callback(target_id, attacker_id)
    if planet_id == target_id then
        planet_health = planet_health - 1
        print("Planet hit. Current Health " .. planet_health)

        if planet_health == (planet_health_start - 1) and planet_first_hit == 0 then
            planet_first_hit = 1
            complain_about_first_hit()
        end

        if (planet_health % 100) == 0 then
            destroy_a_city()
        end

        if planet_health == 0 then
            print("Challenge Failed!")
            lose_challenge()
        end
    end
end

register_callback("object-hit-event", "planet_hit_callback")

function complain_about_first_hit()
    comms_transmission(planet_id, "PLEASE HELP!")
    comms_transmission(planet_id, "WE HAVE DISCOVERED THE FORWARD SCOUT OF AN")
    comms_transmission(planet_id, "INVASION FLEET. OUR DEFENCES ARE LIMITED AS")
    comms_transmission(planet_id, "WE ARE A NON-VIOLENT RACE. PLEASE HELP")
    comms_transmission(planet_id, "DEFEND US FROM THIS INVATION. YOU WILL BE")
    comms_transmission(planet_id, "REWARDED GREATLY FOR YOUR AID.")

    show_timed_text(-1, 10, "PLEASE HELP!\n" ..
                                  "WE HAVE DISCOVERED THE FORWARD SCOUT OF AN\n" ..
                                  "INVASION FLEET. OUR DEFENCES ARE LIMITED AS\n" ..
                                  "WE ARE A NON-VIOLENT RACE. PLEASE HELP\n" ..
                                  "DEFEND US FROM THIS INVATION. YOU WILL BE\n" ..
                                  "REWARDED GREATLY FOR YOUR AID.")
end

function destroy_a_city()
    planet_destroyed_city_count = planet_destroyed_city_count + 1
    message = "THE INVASION FLEET HAS DESTROYED SECTOR " .. planet_cities[planet_destroyed_city_count] .. "!"
    announce(message)
    comms_transmission(planet_id, message)
end

function lose_challenge()
    if wave > 0 then
        wave = current_wave - 1
    end
    show_timed_text(player_ids[1], 10, "GAME OVER!\n" ..
                                       "You were unable defend the panet from \n" ..
                                       "the invasion force.\n" ..
                                       "You were able to protect it from " .. wave .. 
                                       "\nwaves of invasion forces.")

    clear_all()
end


-- create fleet
function createFleet(fleet, ship_count, ship_name, ship_type, x, y, z, faction_id, radius)
    for i = 1, ship_count do

        if ship_type == -1 then
            type_index = math.random(7)
            ship_type = violent_ships[type_index]
        end 

        deriv_x = math.random(radius * 2) - radius + x
        deriv_y = math.random(radius * 2) - radius + y
        deriv_z = math.random(radius * 2) - radius + z
        id = add_ship(ship_name .. i, deriv_x, deriv_y, deriv_z, ship_type, faction_id, -1)
        ai_push_attack(id, planet_id)
        table.insert(fleet, id)
    end
end

enemy_fleet = {}
enemy_fleet_count = 0
enemy_fleet_live_count = 0
enemies_destroyed = 0

-- create starbase for refueling

sb_x = planet_x
sb_y = planet_y + 5000 * 2
sb_z = planet_z
sb = add_starbase(sb_x, sb_y, sb_z, 0)


-- create waves
current_wave = 0

function enemy_death_callback(id)
    print("object killed")
    for i = 1, enemy_fleet_count do
        if id == enemy_fleet[i] then
            print("enemy killed")
            enemy_fleet_live_count = enemy_fleet_live_count - 1
            enemies_destroyed = enemies_destroyed + 1
        end
    end

    if enemy_fleet_live_count == 0 then
        print("Last enemy in wave killed")
        current_wave = current_wave + 1
        advance_wave()
    end
end

register_callback("object-death-event", "enemy_death_callback")

function advance_wave()
    if current_wave == 0 then
        print("Starting Wave 1")
        wave1()
    elseif current_wave == 1 then
        print("Starting Wave 2")
        wave2()
    elseif current_wave == 2 then
        print("Starting Wave 3")
        wave3()
    elseif current_wave == 3 then
        print("Starting Wave 4")
        wave4()
    elseif current_wave == 4 then
        print("Starting Wave 5")
        wave5()
    elseif current_wave == 5 then
        print("Starting Wave 6")
        wave6()
    elseif current_wave == 6 then
        print("Starting Wave 7")
        wave7()
    elseif current_wave == 7 then
        print("Starting Wave 8")
        wave8()
    elseif current_wave == 8 then
        print("Starting Wave 9")
        wave9()
    else
        print("Win!")
        win()
    end
end

function wave1()
    show_timed_text(player_ids[1], 10, "Wave 1\n5 Scouts")
    announce("Warning. 5 Scouts Incoming")
    enemy_fleet_count = 5
    enemy_fleet_live_count = 5
    enemy_fleet = {}
    createFleet(enemy_fleet, 5, "Enemy Scout",  SCOUT, startx, starty, startz, enemy, 100*100)
end

function wave2()
    show_timed_text(player_ids[1], 10, "Wave 2\n6 Battlestars\n2 Destroyer")
    announce("Warning. Cruiser Incoming")
    enemy_fleet_count = 8
    enemy_fleet_live_count = 8
    enemy_fleet = {}
    createFleet(enemy_fleet, 6, "Enemy BattleStar",  BATTLESTAR, startx, starty, startz, enemy, 300*100)
    createFleet(enemy_fleet, 2, "Enemy Destroyer",  DESTROYER, startx, starty, startz, enemy, 300*100)
end
    
function wave3()
    show_timed_text(player_ids[1], 10, "Wave 3\n10 Battlestars\n4 Destroyers")
    announce("Warning. 10 BattleStars and 4 Destroyers Incoming")
    enemy_fleet_count = 14
    enemy_fleet_live_count = 14
    enemy_fleet = {}
    createFleet(enemy_fleet, 10, "Enemy Battlestar", BATTLESTAR, startx, starty, startz, enemy, 300*100)
    createFleet(enemy_fleet, 4, "Enemy Destroyer", DESTROYER, startx, starty, startz, enemy, 300*100)
end

function wave4()
    show_timed_text(player_ids[1], 10, "Wave 4\n15 Destroyers")
    announce("Warning. 15 Destroyers Incoming")
    enemy_fleet_count = 15
    enemy_fleet_live_count = 15
    enemy_fleet = {}
    createFleet(enemy_fleet, 15, "Enemy Destroyers", DESTROYER, startx, starty, startz, enemy, 300*100)
end

function wave5()
    show_timed_text(player_ids[1], 10, "Wave 5\n5 Dragonhawk\n10 Destroyer")
    announce("Warning. 5 Dragon Hawks and 10 Destroyers Incoming")
    enemy_fleet_count = 15
    enemy_fleet_live_count = 15
    enemy_fleet = {}
    createFleet(enemy_fleet, 5, "Enemy Dragonhawk", DRAGONHAWK, startx, starty, startz, enemy, 300*100)
    createFleet(enemy_fleet, 10, "Enemy Destroyer", DESTROYER, startx, starty, startz, enemy, 300*100)
end

function wave6()
    show_timed_text(player_ids[1], 10, "Wave 6\n10 Dragonhawks\n15 Destroyers")
    announce("Warning. 10 Dragon Hawks and 15 Destroyers Incoming")
    enemy_fleet_count = 25
    enemy_fleet_live_count = 25
    enemy_fleet = {}
    createFleet(enemy_fleet, 10, "Enemy Dragonhawk", DRAGONHAWK, startx, starty, startz, enemy, 300*100)
    createFleet(enemy_fleet, 15, "Enemy Destroyer", DESTROYER, startx, starty, startz, enemy, 300*100)
end

function wave7()
    show_timed_text(player_ids[1], 10, "Wave 7\n10 Dragonhawks\n5 Vanquishers")
    announce("Warning. 10 Dragon Hawks and 5 Vanquisher Incoming")
    enemy_fleet_count = 15
    enemy_fleet_live_count = 15
    enemy_fleet = {}
    createFleet(enemy_fleet, 10, "Enemy Dragonhawk", DRAGONHAWK, startx, starty, startz, enemy, 300*100)
    createFleet(enemy_fleet, 5, "Enemy Vanquisher", VANQUISHER, startx, starty, startz, enemy, 300*100)
end

function wave8()
    show_timed_text(player_ids[1], 10, "Wave 8\n15 Dragonhawks\n10 Vanquishers")
    announce("Warning. 15 Dragon Hawks and 10 Vanquishers Incoming")
    enemy_fleet_count = 25
    enemy_fleet_live_count = 25
    enemy_fleet = {}
    createFleet(enemy_fleet, 15, "Enemy Dragonhawk", DRAGONHAWK, startx, starty, startz, enemy, 300*100)
    createFleet(enemy_fleet, 10, "Enemy Vanquisher", VANQUISHER, startx, starty, startz, enemy, 300*100)
end

function wave9()
    show_timed_text(player_ids[1], 10, "Wave 9\n10 Dragonhawks\n10 Vanquishers\n10 Enforcers")
    announce("Warning. 10 Dragon Hawks, 10 Vanquishers, and 10 Enforcers Incoming")
    enemy_fleet_count = 30
    enemy_fleet_live_count = 30
    enemy_fleet = {}
    createFleet(enemy_fleet, 10, "Enemy Dragonhawk", DRAGONHAWK, startx, starty, startz, enemy, 300*100)
    createFleet(enemy_fleet, 10, "Enemy Vanquisher", VANQUISHER, startx, starty, startz, enemy, 300*100)
    createFleet(enemy_fleet, 10, "Enemy Enforcer", ENFORCER, startx, starty, startz, enemy, 300*100)
end

function win()
    show_timed_text(player_ids[1], 10, "We are saved!\n" ..
                                       "You, our glorious saviors have saved our home.\n" ..
                                       "We as promised we shall reward you generously\n" ..
                                       "with love." ..
                                       "Stats:\n" ..
                                       " - Ships Destroyed: " .. enemies_destroyed)
    n = lookup_commodity("gold ore");
    player_ids = get_player_ship_ids();
    print(n)
    print(reward_id)
    print(player_ids[i])
    set_commodity_contents(player_ids[i], n, 42, 7)

end


advance_wave()
