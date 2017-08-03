local P = {}

math.randomseed( os.time() )

------------------------------------------
------------------------------------------
-- Constants
------------------------------------------
------------------------------------------
P._ = {}

P._.base_module = "share.snis.luascripts.acm."

P._.x_known_dim = 600000.0
P._.y_known_dim = P._.x_known_dim --* 0.2 -- the original y_known dim was limited to 20% of x_known_dim
P._.z_known_dim = P._.x_known_dim

P._.universe_limit = P._.x_known_dim * 2.0
P._.universe_center_x = P._.x_known_dim/2.0
P._.universe_center_y = P._.y_known_dim/2.0
P._.universe_center_z = P._.z_known_dim/2.0

P._.default_ship_limit_max = 150
P._.default_ship_limit_min = 75

P._.default_planet_limit_max = 30
P._.default_planet_limit_min = 15

P._.default_starbase_limit_max = 30
P._.default_starbase_limit_min = 20

P._.default_asteroid_limit_max = 300
P._.default_asteroid_limit_min = 100

------------------------------------------
------------------------------------------
-- Object collections 
------------------------------------------
------------------------------------------

P.entities = {}


------------------------------------------
------------------------------------------
-- Creation APIs
------------------------------------------
------------------------------------------

P.create = {}

function create_fleet(fleet, ship_count, ship_name, ship_type, x, y, z, faction_id, radius)
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
P.create.fleet = create_fleet

function create_random_universe()
    P.create.universe(-1)
end
P.create.random_universe = create_random_universe

function create_universe(universe_type)
    -- universe types
    -- -1: ramdom: chooses a random universe type
    -- 0: split: split universe into 3rds with the middle third a no-man's land (aka two factions)
    -- 1: quartered: split universe into 8ths with 4 clusters separated by no-man's land
    -- 2: dense center: densely packed center surrounded by dense space
    -- 3: bulls eye: dense exterior ring surrounding a cluster in the center
    -- 4: doughnut: one dense ring
    -- 5: 2 arm spiral: two dense arms spiraling around the center of the universe
    -- 6: 3 arm spiral: three dense arms spiraling around the center of the universe
    -- 7: 4 arm spiral: four dense arms spiraling around the center of the universe
    -- 8: fill: evenly spread distribution
    -- 9: many random dense: many randomly placed dense clusters
    -- 10: few random dense: few randomly placed dense clusters
    -- 11: many random sparse: many randomly placed sparse clusters
    -- 12: few random sparse: few randomly placed sparse clusters
    -- 13: unknown: random distribution in unknown space and sparse distroution in known space
    clear_all();
    P.helper.reset_player()
    
    if universe_type == -1 then
        universe_type = math.random(13)
    end

    if universe_type == 0 then
        P.create.universe_0()
    elseif universe_type == 1 then
        P.create.universe_1()
    elseif universe_type == 2 then
        P.create.universe_2()
    elseif universe_type == 3 then
        P.create.universe_3()
    elseif universe_type == 4 then
        P.create.universe_4()
    elseif universe_type == 5 then
        P.create.universe_5()
    elseif universe_type == 6 then
        P.create.universe_6()
    elseif universe_type == 7 then
        P.create.universe_7()
    elseif universe_type == 8 then
        P.create.universe_8()
    elseif universe_type == 9 then
        P.create.universe_9()
    elseif universe_type == 10 then
        P.create.universe_10()
    elseif universe_type == 11 then
        P.create.universe_11()
    elseif universe_type == 12 then
        P.create.universe_12()
    elseif universe_type == 13 then
        P.create.universe_13()
    else
        print("Unsupported universe type.")
    end

end
P.create.universe = create_universe

function create_universe_0()
    -- 0: split: split universe into 3rds with the middle third a no-man's land (aka two factions)
    local thirds = P._.x_known_dim/3

    -- side 1 
    local first_third_1 = 0
    local first_third_2 = thirds
    local first_third_faction = 1

    -- no mans land
    local second_third_1 = first_third_2
    local second_third_2 = second_third_1 + thirds

    -- side 2
    local third_third_1 = second_third_2 
    local third_third_2 = third_third_1 + thirds
    local thir_third_faction = 2

    -- number of objects to generate for each side
    local num_planets = math.random(P._.default_planet_limit_min, P._.default_planet_limit_max)/2
    local num_ships = math.random(P._.default_ship_limit_min, P._.default_ship_limit_max)/2
    local num_starbases = math.random(P._.default_starbase_limit_min, P._.default_starbase_limit_max)/2

    -- generating first third planets
    first_third_planets = {}

    for i = 1, num_planets do
        planet_name = P.helper.get_random_planet_name()
        planet_x = math.random(thirds) 
        planet_y = math.random(P._.y_known_dim)
        planet_z = math.random(P._.z_known_dim)
        planet_radius = math.random(6000)
        planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
        planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(first_third_planets, planet_id)
    end

    -- generating third third planets
    third_third_planets= {}

    for i = 1, num_planets do
        planet_name = P.helper.get_random_planet_name()
        planet_x = math.random(thirds) + third_third_1
        planet_y = math.random(P._.y_known_dim)
        planet_z = math.random(P._.z_known_dim)
        planet_radius = math.random(6000)
        planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
        planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(third_third_planets, planet_id)
    end

    -- generating first third ships 
    first_third_ships = {}

    for i = 1, num_ships do
        ship_name = "A Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(thirds)
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(P._.z_known_dim)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, first_third_faction, 1)
        table.insert(first_third_ships, ship_id)
    end


    -- generating third third ships 
    third_third_ships = {}

    for i = 1, num_ships do
        ship_name = "B Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(thirds) + third_third_1
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(P._.z_known_dim)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, first_third_faction, 1)
        table.insert(third_third_ships, ship_id)
    end

    -- generating first third starbases
    starbase_name_counter = 0
    first_third_starbases = {}
    
    for i = 1, num_starbases do
        local starbase_x = math.random(thirds)
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(P._.z_known_dim)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(first_third_starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end
    
    -- generating third third 
    third_third_starbases = {}
    
    for i = 1, num_starbases do
        local starbase_x = math.random(thirds) + third_third_1
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(P._.z_known_dim)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(third_third_starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    -- generating asteroids
    for i = 1, 300 do
        local asteroid_x = math.random(P._.x_known_dim)
        local asteroid_y = math.random(P._.y_known_dim)
        local asteroid_z = math.random(P._.z_known_dim)
        add_asteroid(asteroid_x, asteroid_y, asteroid_z)
        local carbon = math.random()
        local silicates = math.random()
        local nickeliron = math.random()
        local preciousmetals = math.random()
        local asteroid_id = add_asteroid(asteroid_x, asteroid_y, asteroid_z)
        set_asteroid_minerals(asteroid_id, carbon, silicates, nickeliron, preciousmetals)
    end

    for i = 1, 300 do
        local asteroid_x = math.random(thirds) + second_third_1
        local asteroid_y = math.random(P._.y_known_dim)
        local asteroid_z = math.random(P._.z_known_dim)
        local asteroid_v = math.random()
        local carbon = math.random()
        local silicates = math.random()
        local nickeliron = math.random()
        local preciousmetals = math.random()
        local asteroid_id = add_asteroid(asteroid_x, asteroid_y, asteroid_z)
        set_asteroid_minerals(asteroid_id, carbon, silicates, nickeliron, preciousmetals)
    end

    -- add nebula
    for i = 1, 2 do
        local nebula_x = math.random(P._.x_known_dim)
        local nebula_y = math.random(P._.y_known_dim)
        local nebula_z = math.random(P._.z_known_dim)

        for i = 1, 10 do
            local deriv_x = nebula_x + (math.random(50000, 500000)/2)
            local deriv_y = nebula_y + (math.random(50000, 500000)/2)
            local deriv_z = nebula_z + (math.random(50000, 500000)/2)
            local nebula_r = math.random(100000)
            add_nebula("Nebula", deriv_x, deriv_y, deriv_z, nebula_r)
        end
    end

end
P.create.universe_0 = create_universe_0

function create_universe_1()
    -- 1: quartered: split universe into 8ths with 4 clusters separated by no-man's land

    local thirds_x = P._.x_known_dim/3
    local thirds_z = P._.z_known_dim/3

    local one_one_x1 = 0
    local one_one_x2 = one_one_x1 + thirds_x
    local one_one_z1 = 0
    local one_one_z2 = one_one_z1 + thirds_z

    local one_two_x1 = one_one_x2
    local one_two_x2 = one_two_x1 + thirds_x
    local one_two_z1 = one_one_z1
    local one_two_z2 = one_one_z2

    local one_three_x1 = one_two_x2
    local one_three_x2 = one_three_x1 + thirds_x
    local one_three_z1 = one_one_z1
    local one_three_z2 = one_one_z2

    local two_one_x1 = one_one_x1
    local two_one_x2 = one_one_x2
    local two_one_z1 = one_one_z2
    local two_one_z2 = two_one_z1 + thirds_z

    local two_two_x1 = one_two_x1
    local two_two_x2 = one_two_x2
    local two_two_z1 = two_one_z1
    local two_two_z2 = two_one_z2

    local two_three_x1 = one_three_x1
    local two_three_x2 = one_three_x2
    local two_three_z1 = two_two_z1
    local two_three_z2 = two_one_z2 

    local three_one_x1 = one_one_x1
    local three_one_x2 = one_one_x2
    local three_one_z1 = two_one_z2
    local three_one_z2 = three_one_z1 + thirds_z
    
    local three_two_x1 = one_two_x1
    local three_two_x2 = one_two_x2
    local three_two_z1 = three_one_z1
    local three_two_z2 = three_one_z2

    local three_three_x1 = one_three_x1
    local three_three_x2 = one_three_x2
    local three_three_z1 = three_one_z1
    local three_three_z2 = three_one_z2

    -- calculate distributions
    local num_planets = math.random(P._.default_planet_limit_min, P._.default_planet_limit_max)/4
    local num_ships = math.random(P._.default_ship_limit_min, P._.default_ship_limit_max)/4
    local num_starbases = math.random(P._.default_starbase_limit_min, P._.default_starbase_limit_max)/4
    starbase_name_counter = 0

    -- generate q1 planets
    q1_planets= {}

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(one_one_x1, one_one_x2) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(one_one_z1, one_one_z2)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
        local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(q1_planets, planet_id)
    end

    q1_ships= {}
    q1_faction = 1

    for i = 1, num_ships do
        ship_name = "Q1 Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(one_one_x1, one_one_x2)
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(one_one_z1, one_one_z2)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, q1_faction, 1)
        table.insert(q1_ships, ship_id)
    end

    q1_starbases = {}
    
    for i = 1, num_starbases do
        local starbase_x = math.random(one_one_x1, one_one_x2)
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(one_one_z1, one_one_z2)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(q1_starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    -- generate q2 planets, ships an SB
    q2_planets= {}

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(one_three_x1, one_three_x2) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(one_three_z1, one_three_z2)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
        local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(q2_planets, planet_id)
    end

    q2_ships= {}
    q2_faction = 2

    for i = 1, num_ships do
        ship_name = "Q2 Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(one_three_x1, one_three_x2)
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(one_one_z1, one_one_z2)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, q1_faction, 1)
        table.insert(q2_ships, ship_id)
    end

    q2_starbases = {}
    
    for i = 1, num_starbases do
        local starbase_x = math.random(one_three_x1, one_three_x2)
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(one_three_z1, one_three_z2)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(q2_starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end
    
    -- generate q3 planets
    q3_planets= {}

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(three_one_x1, three_one_x2) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(three_one_z1, three_one_z2)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
        local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(q3_planets, planet_id)
    end

    q3_ships= {}
    q3_faction = 3

    for i = 1, num_ships do
        ship_name = "Q3 Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(three_one_x1, three_one_x2)
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(three_one_x1, three_one_z2)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, q3_faction, 1)
        table.insert(q3_ships, ship_id)
    end

    q3_starbases = {}
    
    for i = 1, num_starbases do
        local starbase_x = math.random(three_one_x1, three_one_x2)
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(three_one_z1, three_one_z2)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(q3_starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end
    
    -- generate q4 planets
    q4_planets= {}

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(three_three_x1, three_three_x2) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(three_three_z1, three_three_z2)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
        local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(q4_planets, planet_id)
    end

    q4_ships= {}
    q4_faction = 4

    for i = 1, num_ships do
        ship_name = "Q4 Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(three_three_x1, three_three_x2)
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(three_one_z1, three_one_z2)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, q4_faction, 1)
        table.insert(q4_ships, ship_id)
    end

    q4_starbases = {}
    
    for i = 1, num_starbases do
        local starbase_x = math.random(three_three_x1, three_three_x2)
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(three_three_z1, three_three_z2)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(q3_starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    -- add asteroids
    for i = 1, 100 do
        local asteroid_x = math.random(two_one_x1, two_one_x2)
        local asteroid_y = math.random(P._.y_known_dim)
        local asteroid_z = math.random(two_one_z1, two_one_z2)
        local asteroid_v = math.random()
        local carbon = math.random()
        local silicates = math.random()
        local nickeliron = math.random()
        local preciousmetals = math.random()
        local asteroid_id = add_asteroid(asteroid_x, asteroid_y, asteroid_z)
        set_asteroid_minerals(asteroid_id, carbon, silicates, nickeliron, preciousmetals)
    end


    for i = 1, 100 do
        local asteroid_x = math.random(two_two_x1, two_two_x2)
        local asteroid_y = math.random(P._.y_known_dim)
        local asteroid_z = math.random(two_two_z1, two_two_z2)
        local asteroid_v = math.random()
        local carbon = math.random()
        local silicates = math.random()
        local nickeliron = math.random()
        local preciousmetals = math.random()
        local asteroid_id = add_asteroid(asteroid_x, asteroid_y, asteroid_z)
        set_asteroid_minerals(asteroid_id, carbon, silicates, nickeliron, preciousmetals)
    end

    for i = 1, 100 do
        local asteroid_x = math.random(two_three_x1, two_three_x2)
        local asteroid_y = math.random(P._.y_known_dim)
        local asteroid_z = math.random(two_three_z1, two_three_z2)
        local asteroid_v = math.random()
        local carbon = math.random()
        local silicates = math.random()
        local nickeliron = math.random()
        local preciousmetals = math.random()
        local asteroid_id = add_asteroid(asteroid_x, asteroid_y, asteroid_z)
        set_asteroid_minerals(asteroid_id, carbon, silicates, nickeliron, preciousmetals)
    end

    -- add nebula
    for i = 1, 5 do
        local deriv_x = math.random(one_two_x1, one_two_x2)
        local deriv_y = math.random(5000, 50000)
        local deriv_z = math.random(one_two_z1, one_two_z2)
        local nebula_r = math.random(100000)
        add_nebula("Nebula", deriv_x, deriv_y, deriv_z, nebula_r)
    end

    for i = 1, 5 do
        local deriv_x = math.random(two_two_x1, two_two_x2)
        local deriv_y = math.random(5000, 50000)
        local deriv_z = math.random(two_two_z1, two_two_z2)
        local nebula_r = math.random(100000)
        add_nebula("Nebula", deriv_x, deriv_y, deriv_z, nebula_r)
    end

    for i = 1, 5 do
        local deriv_x = math.random(three_two_x1, three_two_x2)
        local deriv_y = math.random(5000, 50000)
        local deriv_z = math.random(three_two_z1, three_two_z2)
        local nebula_r = math.random(100000)
        add_nebula("Nebula", deriv_x, deriv_y, deriv_z, nebula_r)
    end

end
P.create.universe_1 = create_universe_1

function create_universe_2()
    -- 2: dense center: densely packed center surrounded by dense space

    -- generate counts
    local num_planets = math.random(P._.default_planet_limit_min, P._.default_planet_limit_max)
    local num_ships = math.random(P._.default_ship_limit_min, P._.default_ship_limit_max)
    local num_starbases = math.random(P._.default_starbase_limit_min, P._.default_starbase_limit_max)
    starbase_name_counter = 0

    -- geneaate planets 
    planets= {}

    local range = 100000

    local center_x_plus = P._.universe_center_x + range
    local center_x_minus = P._.universe_center_x - range

    local center_y_plus = P._.universe_center_y + range
    local center_y_minus = P._.universe_center_y - range

    local center_z_plus = P._.universe_center_z + range
    local center_z_minus = P._.universe_center_z - range

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(center_x_minus, center_x_plus) 
        local planet_y = math.random(center_y_minus, center_y_plus)
        local planet_z = math.random(center_z_minus, center_z_plus)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
        local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(planets, planet_id)
    end

    ships= {}
    faction = 1

    for i = 1, num_ships do
        ship_faction = math.random(13)
        ship_name = "Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(center_x_minus, center_x_plus) 
        ship_y = math.random(center_y_minus, center_y_plus)
        ship_z = math.random(center_z_minus, center_z_plus)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, ship_faction, 1)
        table.insert(ships, ship_id)
    end

    starbases = {}
    
    for i = 1, num_starbases do
        local starbase_x = math.random(center_x_minus, center_x_plus) 
        local starbase_y = math.random(center_y_minus, center_y_plus)
        local starbase_z = math.random(center_z_minus, center_z_plus)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    -- add asteroids

    for i = 1, 300 do
        local asteroid_x = math.random(P._.x_known_dim)
        local asteroid_y = math.random(P._.y_known_dim)
        local asteroid_z = math.random(P._.z_known_dim)
        local asteroid_v = math.random()
        local carbon = math.random()
        local silicates = math.random()
        local nickeliron = math.random()
        local preciousmetals = math.random()
        local asteroid_id = add_asteroid(asteroid_x, asteroid_y, asteroid_z)
        set_asteroid_minerals(asteroid_id, carbon, silicates, nickeliron, preciousmetals)
    end

    -- add nebula
    for i = 1, 3 do
        local nebula_x = math.random(P._.x_known_dim/2)
        local nebula_y = math.random(P._.y_known_dim/2)
        local nebula_z = math.random(P._.z_known_dim/2)

        for i = 1, 5 do
            local deriv_x = nebula_x + math.random(25000, 250000)
            local deriv_y = nebula_y + math.random(25000, 250000)
            local deriv_z = nebula_z + math.random(25000, 250000)
            local nebula_r = math.random(100000)
            add_nebula("Nebula", deriv_x, deriv_y, deriv_z, nebula_r)
        end
    end

end
P.create.universe_2 = create_universe_2

function create_universe_3()
    -- 3: bulls eye: dense exterior ring surrounding a cluster in the center
    local num_planets = math.random(P._.default_planet_limit_min, P._.default_planet_limit_max)/5
    local num_ships = math.random(P._.default_ship_limit_min, P._.default_ship_limit_max)/5
    local num_starbases = math.random(P._.default_starbase_limit_min, P._.default_starbase_limit_max)/5
    starbase_name_counter = 0

    -- geneaate planets 
    planets= {}

    local range = 50000

    -- generate eye
    local center_x_plus = P._.universe_center_x + range
    local center_x_minus = P._.universe_center_x - range

    local center_y_plus = P._.universe_center_y + range
    local center_y_minus = P._.universe_center_y - range

    local center_z_plus = P._.universe_center_z + range
    local center_z_minus = P._.universe_center_z - range

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(center_x_minus, center_x_plus) 
        local planet_y = math.random(center_y_minus, center_y_plus)
        local planet_z = math.random(center_z_minus, center_z_plus)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
        local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(planets, planet_id)
    end

    -- generate ring
    tenths_x = P._.x_known_dim/10
    tenths_z = P._.z_known_dim/10

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(tenths_x*2, tenths_x*3) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(tenths_z*2, tenths_z*8)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
       local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(planets, planet_id)
    end

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(tenths_x*7, tenths_x*8) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(tenths_z*2, tenths_z*8)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
       local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(planets, planet_id)
    end

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(tenths_x*3, tenths_x*7) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(tenths_z*2, tenths_z*3)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
       local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(planets, planet_id)
    end

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(tenths_x*3, tenths_x*7) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(tenths_z*7, tenths_z*8)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
       local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(planets, planet_id)
    end

    ships= {}

    -- eye ships
    for i = 1, num_ships do
        ship_faction = math.random(13)
        ship_name = "Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(center_x_minus, center_x_plus) 
        ship_y = math.random(center_y_minus, center_y_plus)
        ship_z = math.random(center_z_minus, center_z_plus)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, ship_faction, 1)
        table.insert(ships, ship_id)
    end

    -- ring ships

    for i = 1, num_ships do
        ship_faction = math.random(13)
        ship_name = "Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(tenths_x*2, tenths_x*3) 
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(tenths_z*2, tenths_z*8)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, ship_faction, 1)
        table.insert(ships, ship_id)
    end

    for i = 1, num_ships do
        ship_faction = math.random(13)
        ship_name = "Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(tenths_x*7, tenths_x*8) 
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(tenths_z*2, tenths_z*8)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, ship_faction, 1)
        table.insert(ships, ship_id)
    end

    for i = 1, num_ships do
        ship_faction = math.random(13)
        ship_name = "Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(tenths_x*3, tenths_x*7) 
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(tenths_z*2, tenths_z*3)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, ship_faction, 1)
        table.insert(ships, ship_id)
    end

    for i = 1, num_ships do
        ship_faction = math.random(13)
        ship_name = "Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(tenths_x*3, tenths_x*7) 
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(tenths_z*7, tenths_z*8)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, ship_faction, 1)
        table.insert(ships, ship_id)
    end

    -- add starbases

    starbases = {}
    
    -- eye starbases
    for i = 1, num_starbases do
        local starbase_x = math.random(center_x_minus, center_x_plus) 
        local starbase_y = math.random(center_y_minus, center_y_plus)
        local starbase_z = math.random(center_z_minus, center_z_plus)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    -- ring starbases
    for i = 1, num_starbases do
        local starbase_x = math.random(tenths_x*2, tenths_x*3) 
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(tenths_z*2, tenths_z*8)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    for i = 1, num_starbases do
        local starbase_x = math.random(tenths_x*7, tenths_x*8) 
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(tenths_z*2, tenths_z*8)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    for i = 1, num_starbases do
        local starbase_x = math.random(tenths_x*3, tenths_x*7) 
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(tenths_z*7, tenths_z*8)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    for i = 1, num_starbases do
        local starbase_x = math.random(tenths_x*3, tenths_x*7) 
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(tenths_z*7, tenths_z*8)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    -- add asteroids

    for i = 1, 300 do
        local asteroid_x = math.random(P._.x_known_dim)
        local asteroid_y = math.random(P._.y_known_dim)
        local asteroid_z = math.random(P._.z_known_dim)
        local asteroid_v = math.random()
        local carbon = math.random()
        local silicates = math.random()
        local nickeliron = math.random()
        local preciousmetals = math.random()
        local asteroid_id = add_asteroid(asteroid_x, asteroid_y, asteroid_z)
        set_asteroid_minerals(asteroid_id, carbon, silicates, nickeliron, preciousmetals)
    end

    -- add nebula
    for i = 1, 3 do
        local nebula_x = math.random(P._.x_known_dim/2)
        local nebula_y = math.random(P._.y_known_dim/2)
        local nebula_z = math.random(P._.z_known_dim/2)

        for i = 1, 5 do
            local deriv_x = nebula_x + math.random(25000, 250000)
            local deriv_y = nebula_y + math.random(25000, 250000)
            local deriv_z = nebula_z + math.random(25000, 250000)
            local nebula_r = math.random(100000)
            add_nebula("Nebula", deriv_x, deriv_y, deriv_z, nebula_r)
        end
    end

end
P.create.universe_3 = create_universe_3

function create_universe_4()
    -- 4: doughnut: one dense ring
    local num_planets = math.random(P._.default_planet_limit_min, P._.default_planet_limit_max)/4
    local num_ships = math.random(P._.default_ship_limit_min, P._.default_ship_limit_max)/4
    local num_starbases = math.random(P._.default_starbase_limit_min, P._.default_starbase_limit_max)/4
    starbase_name_counter = 0

    -- geneaate planets 
    planets= {}

    tenths_x = P._.x_known_dim/10
    tenths_z = P._.z_known_dim/10

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(tenths_x*2, tenths_x*3) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(tenths_z*2, tenths_z*8)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
       local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(planets, planet_id)
    end

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(tenths_x*7, tenths_x*8) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(tenths_z*2, tenths_z*8)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
       local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(planets, planet_id)
    end

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(tenths_x*3, tenths_x*7) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(tenths_z*2, tenths_z*3)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
       local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(planets, planet_id)
    end

    for i = 1, num_planets do
        local planet_name = P.helper.get_random_planet_name()
        local planet_x = math.random(tenths_x*3, tenths_x*7) 
        local planet_y = math.random(P._.y_known_dim)
        local planet_z = math.random(tenths_z*7, tenths_z*8)
        local planet_radius = math.random(6000)
        local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
       local planet_id = add_planet(planet_name, planet_x, planet_y, planet_z, planet_radius, planet_security)
        table.insert(planets, planet_id)
    end

    -- ships

    ships= {}

    for i = 1, num_ships do
        ship_faction = math.random(13)
        ship_name = "Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(tenths_x*2, tenths_x*3) 
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(tenths_z*2, tenths_z*8)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, ship_faction, 1)
        table.insert(ships, ship_id)
    end

    for i = 1, num_ships do
        ship_faction = math.random(13)
        ship_name = "Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(tenths_x*7, tenths_x*8) 
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(tenths_z*2, tenths_z*8)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, ship_faction, 1)
        table.insert(ships, ship_id)
    end

    for i = 1, num_ships do
        ship_faction = math.random(13)
        ship_name = "Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(tenths_x*3, tenths_x*7) 
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(tenths_z*2, tenths_z*3)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, ship_faction, 1)
        table.insert(ships, ship_id)
    end

    for i = 1, num_ships do
        ship_faction = math.random(13)
        ship_name = "Ship " .. i
        ship_type = math.random(14)-1
        ship_x = math.random(tenths_x*3, tenths_x*7) 
        ship_y = math.random(P._.y_known_dim)
        ship_z = math.random(tenths_z*7, tenths_z*8)
        ship_id = add_ship(ship_name, ship_x, ship_y, ship_z, ship_type, ship_faction, 1)
        table.insert(ships, ship_id)
    end

    -- starbases

    starbases = {}
    
    for i = 1, num_starbases do
        local starbase_x = math.random(tenths_x*2, tenths_x*3) 
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(tenths_z*2, tenths_z*8)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    for i = 1, num_starbases do
        local starbase_x = math.random(tenths_x*7, tenths_x*8) 
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(tenths_z*2, tenths_z*8)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    for i = 1, num_starbases do
        local starbase_x = math.random(tenths_x*3, tenths_x*7) 
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(tenths_z*7, tenths_z*8)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    for i = 1, num_starbases do
        local starbase_x = math.random(tenths_x*3, tenths_x*7) 
        local starbase_y = math.random(P._.y_known_dim)
        local starbase_z = math.random(tenths_z*7, tenths_z*8)
        local starbase_id = add_starbase(starbase_x, starrbase_y, starbase_z, starbase_name_counter)
        table.insert(starbases, starbase_id)
        starbase_name_counter = starbase_name_counter + 1
    end

    -- add asteroids

    for i = 1, 300 do
        local asteroid_x = math.random(P._.x_known_dim)
        local asteroid_y = math.random(P._.y_known_dim)
        local asteroid_z = math.random(P._.z_known_dim)
        local asteroid_v = math.random()
        local carbon = math.random()
        local silicates = math.random()
        local nickeliron = math.random()
        local preciousmetals = math.random()
        local asteroid_id = add_asteroid(asteroid_x, asteroid_y, asteroid_z)
        set_asteroid_minerals(asteroid_id, carbon, silicates, nickeliron, preciousmetals)
    end

    for i = 1, 500 do
        local asteroid_x = math.random(tenths_x*3, tenths_x*7)
        local asteroid_y = math.random(P._.y_known_dim)
        local asteroid_z = math.random(tenths_z*3, tenths_z*7)
        local asteroid_v = math.random()
        local carbon = math.random()
        local silicates = math.random()
        local nickeliron = math.random()
        local preciousmetals = math.random()
        local asteroid_id = add_asteroid(asteroid_x, asteroid_y, asteroid_z)
        set_asteroid_minerals(asteroid_id, carbon, silicates, nickeliron, preciousmetals)
    end

    -- add nebula
    for i = 1, 3 do
        local nebula_x = math.random(P._.x_known_dim/2)
        local nebula_y = math.random(P._.y_known_dim/2)
        local nebula_z = math.random(P._.z_known_dim/2)

        for i = 1, 5 do
            local deriv_x = nebula_x + math.random(25000, 250000)
            local deriv_y = nebula_y + math.random(25000, 250000)
            local deriv_z = nebula_z + math.random(25000, 250000)
            local nebula_r = math.random(100000)
            add_nebula("Nebula", deriv_x, deriv_y, deriv_z, nebula_r)
        end
    end
end
P.create.universe_4 = create_universe_4

function create_universe_5()
    -- 5: 2 arm spiral: two dense arms spiraling around the center of the universe
    -- use fibbonachi seq to generate spread from center
    -- multiply spread for current step by current fibbonachi value
    -- generate random number of items in range of spread
    -- shift x and y of items by some offset that increases steadily with each step to create spiral
	
	local fibonacci_items = P.helper.fibonacci(10)
	
	local u_center_x = P._.universe_center_x
	local u_center_y = P._.universe_center_y
	local u_center_z = P._.universe_center_z
	
    local range_start_x = u_center_x
	local range_start_y = u_center_y
	local range_start_z = u_center_z
	
	planets = {}
	starbases = {}
	nebuli = {}
	asteroids = {}
	ships = {}
	
	starbase_name_counter = 1
	
    local y = range_start_y

    for i=1, 100 do
        local z = 0
        local x = 0
        local j = math.random(0, 4)

        if j == 0 then
            x = range_start_x - math.random(5000, 50000)
            z = range_start_z - math.random(5000, 50000)
        elseif j == 1 then
            x = range_start_x + math.random(5000, 50000)
            z = range_start_z - math.random(5000, 50000)
        elseif j == 2 then
            x = range_start_x - math.random(5000, 50000)
            z = range_start_z + math.random(5000, 50000)
        else
            x = range_start_x + math.random(5000, 50000)
            z = range_start_z + math.random(5000, 50000)
        end

        local obj_type = math.random()
        
        if obj_type < .01 then
            -- obj type starbase
            local starbase_id = add_starbase(x, y, z, starbase_name_counter)
            table.insert(starbases, starbase_id)
            starbase_name_counter = starbase_name_counter + 1
        elseif obj_type < .15 then
            -- obj type planet
            local planet_name = P.helper.get_random_planet_name()
            local planet_radius = math.random(6000)
            local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
            local planet_id = add_planet(planet_name, x, y, z, planet_radius, planet_security)
            table.insert(planets, planet_id)
        elseif obj_type < .30 then
            -- obj type nebula
            local radius = math.random(6000)
            local name = tostring(math.random(0, 999999999))
            local nebula_id = add_nebula(name, x, y, z, radius)
            table.insert(nebuli, nebula_id)
        else
            -- obj type asteroid
            local asteroid_id = add_asteroid(x, y, z)
            table.insert(asteroids, asteroid_id)
         end
    
    end

    n = 100
    a = 0.5
    b = 0.6

    for i=1, n do
        -- a point between 0 and 1 normally distributed
        point = (math.sqrt( -2 * math.log(math.random())) * math.cos(2 * math.pi * math.random()) / 2)

        x1 = a * math.exp(b*point) * math.cos(point)
        z1 = a * math.exp(b*point) * math.sin(point)

        x2 = a * math.exp(b*point) * math.cos(point + math.pi)
        z2 = a * math.exp(b*point) * math.sin(point + math.pi)

        x1 = range_start_x + (range_start_x * x1 + math.random(5000, 50000))
        z1 = range_start_z + (range_start_z * z1 + math.random(5000, 50000))

        x2 = range_start_x + (range_start_x * x2 + math.random(5000, 50000))
        z2 = range_start_z + (range_start_z * z2 + math.random(5000, 50000))

        xzs = { {x1, z1}, {x2, z2} }

        for k, v in pairs(xzs) do
            local x = v[1]
            local z = v[2]

            local obj_type = math.random()
            
            if obj_type < .05 then
                -- obj type starbase
                local starbase_id = add_starbase(x, y, z, starbase_name_counter)
                table.insert(starbases, starbase_id)
                starbase_name_counter = starbase_name_counter + 1
            elseif obj_type < .15 then
                -- obj type planet
                local planet_name = P.helper.get_random_planet_name()
                local planet_radius = math.random(6000)
                local planet_security = math.random(3)-1 -- 0:low, 1:medium, 2:high
                local planet_id = add_planet(planet_name, x, y, z, planet_radius, planet_security)
                table.insert(planets, planet_id)
            elseif obj_type < .30 then
                -- obj type nebula
                local radius = math.random(6000)
                local name = tostring(math.random(0, 999999999))
                local nebula_id = add_nebula(name, x, y, z, radius)
                table.insert(nebuli, nebula_id)
            else
                -- obj type asteroid
                local asteroid_id = add_asteroid(x, y, z)
                table.insert(asteroids, asteroid_id)
            end
        end
	end

    P.entities.planets = planets
end
P.create.universe_5 = create_universe_5

function create_universe_6()
    -- 6: 3 arm spiral: three dense arms spiraling around the center of the universe
end
P.create.universe_6 = create_universe_6

function create_universe_7()
    -- 7: 4 arm spiral: four dense arms spiraling around the center of the universe
end
P.create.universe_7 = create_universe_7

function create_universe_8()
    -- 8: fill: evenly spread distribution
end
P.create.universe_8 = create_universe_8

function create_universe_9()
    -- 9: many random dense: many randomly placed dense clusters
end
P.create.universe_9 = create_universe_9

function create_universe_10()
    -- 10: few random dense: few randomly placed dense clusters
end
P.create.universe_10 = create_universe_10

function create_universe_11()
    -- 11: many random sparse: many randomly placed sparse clusters
end
P.create.universe_11 = create_universe_11

function create_universe_12()
    -- 12: few random sparse: few randomly placed sparse clusters
end
P.create.universe_12 = create_universe_12

function create_universe_13()
    -- 13: unknown: random distribution in unknown space and sparse distroution in known space
end
P.create.universe_13 = create_universe_13

------------------------------------------
------------------------------------------
-- Alerts API
------------------------------------------
------------------------------------------
P.alert = {}

function speak(msg)
    -- very naiive only says it to the first player (aka first player ship)
    player_ids = get_player_ship_ids()
    text_to_speech(player_ids[1], msg);
end
P.alert.speak = speak

function notify(msg)
    -- very naiive only says it to the first player (aka first player ship)
    player_ids = get_player_ship_ids()
    show_timed_text(player_ids[1], 10, msg)
end
P.alert.notify = notify


------------------------------------------
------------------------------------------
-- Helper Utilities API
------------------------------------------
------------------------------------------
P.helper = {}

function get_player_name()
    -- Very naiive gets the first "Unkown Player"
    player_ids = get_player_ship_ids();
    player_name = "Unknown Player"
    if (player_ids[1]) then
        player_name = get_object_name(player_ids[1]);
    end
    return player_name
end
P.helper.get_player_name = get_player_name

function reset_player()
    -- naiively resets only the first player
	player_ids = get_player_ship_ids();
	reset_player_ship(player_ids[1]);
end
P.helper.reset_player = reset_player

function get_random_planet_name()
    num_names = 150
    names = {
        "Qascielara",
        "Iepraocarro",
        "Afliea",
        "Eblosie",
        "Qeiliv",
        "Suonov",
        "Drazoria",
        "Glaqulia",
        "Slade DO4",
        "Slion 10",
        "Ostoater",
        "Tuwhayruta",
        "Ruplippe",
        "Uplov",
        "Wuowei",
        "Veayama",
        "Smaulea",
        "Thotunides",
        "Swinda J0",
        "Spone R94",
        "Fashoacury",
        "Upluarilia",
        "Gastiea",
        "Afrao",
        "Heyturn",
        "Heirilia",
        "Sheustea",
        "Stratustea",
        "Fliri 9PGK",
        "Streshan 74502",
        "Uskemia",
        "Nuchoiclite",
        "Nogrorix",
        "Publora",
        "Toamia",
        "Coetune",
        "Freianov",
        "Ploehiri",
        "Storia 4DS",
        "Glorix 21",
        "Osciyria",
        "Nogluecury",
        "Rutharth",
        "Duwholla",
        "Einerth",
        "Puoyama",
        "Plobania",
        "Sweepra",
        "Spara PD1K",
        "Drora WI7P",
        "Kascayvis",
        "Masmupra",
        "Voflion",
        "Pathapus",
        "Onus",
        "Kaycarro",
        "Whuonerth",
        "Glodonia",
        "Whars D08L",
        "Trurn 7S",
        "Ablualara",
        "Wudroebos",
        "Vuflomia",
        "Ecrov",
        "Uotania",
        "Oyrilia",
        "Cloqunope",
        "Clogoter",
        "Chorix Z44",
        "Scars I5T",
        "Dadrierilia",
        "Neclialia",
        "Buscinda",
        "Xutrone",
        "Iutov",
        "Fopra",
        "Sputoria",
        "Smalaria",
        "Gloth FEC",
        "Glosie V5Qeplaiter",
        "Juwhahines",
        "Upreron",
        "Publolla",
        "Bothea",
        "Ceyclite",
        "Fluuria",
        "Thahonope",
        "Frorix 82P",
        "Crurn ILV9",
        "Tusniegantu",
        "Qawhuyyama",
        "Cescion",
        "Efleon",
        "Vuturn",
        "Oycarro",
        "Spewugawa",
        "Preqohiri",
        "Sleshan UN8",
        "Fryke N9C",
        "Hawhoiruta",
        "Bopreter",
        "Dustade",
        "Wuspippe",
        "Koruta",
        "Jietis",
        "Flamabos",
        "Snefuter",
        "Chyria LD6K",
        "Strides 52OD",
        "Qudroater",
        "Sudruyliv",
        "Zaspiri",
        "Suthyria",
        "Xeucarro",
        "Haelia",
        "Staqeturn",
        "Droolia",
        "Fronoe EIU",
        "Stion W0I",
        "Gusteytov",
        "Egrenus",
        "Owhosie",
        "Xetrone",
        "Qeyter",
        "Waeter",
        "Swadutera",
        "Scunaclite",
        "Plars ATO",
        "Skao II6",
        "Lugrienus",
        "Gawheutania",
        "Yapleon",
        "Uscyke",
        "Biyyama",
        "Leuturn",
        "Flahunus",
        "Smakuphus",
        "Preshan Y21",
        "Plars 5EI",
        "Esleinides",
        "Soproeyama",
        "Qeslolla",
        "Qobrion",
        "Lepra",
        "Ciyter",
        "Skaonus",
        "Streyaclite",
        "Prarth UZN9",
        "Skolla 9I5"
    }
    return names[math.random(num_names)]
end
P.helper.get_random_planet_name = get_random_planet_name
	
function fibonacci(n)
	a, b = 0, 1
	items = { b }
	for i = 1, n do
		a, b = b, a + b
		table.insert(items, b)
	end
	return items
end
P.helper.fibonacci = fibonacci


------------------------------------------
------------------------------------------
-- Special Utilities 
------------------------------------------
------------------------------------------
P.__ = {}


function force_module_reload(module)
    print("Forcing " .. module .. " to be reloadable.")
    package.loaded[P._.base_module .. module] = nil
end
P.__.force_module_reload = force_module_reload

function test_api_load()
    player_name = P.helper.get_player_name()
    player_ids = get_player_ship_ids()
    text_to_speech(player_ids[1], "Auto Campeign A P I Loaded Successfully.")
end
P.__.test_api_load = test_api_load

function debug_packages()
 for k,v in pairs(package.loaded) do print(k, v) end 
end
P.__.debug_packages = debug_packages


	






return P -- veriy important!!
