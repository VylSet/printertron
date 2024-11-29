local tier_1_entities = {
    ["inserter"] = "electronics",
    ["pipe"] = "steam-power",
    ["underground-belt"] = "logistics",
    ["straight-rail"] = "railway",
    ["pipe-to-ground"] = "steam-power",
    ["offshore-pump"] = "steam-power",
    ["small-electric-pole"] = "electronics",
    ["splitter"] = "logistics",
    ["assembling-machine-1"] = "automation",
    ["long-handed-inserter"] = "automation",
    ["lab"] = "electronics",
    ["rail-chain-signal"] = "automated-rail-transportation",
    ["rail-signal"] = "automated-rail-transportation",
}

local tier_2_entities = {
    ["fast-transport-belt"] = "logistics-2",
    ["medium-electric-pole"] = "electric-energy-distribution-1",
    ["big-electric-pole"] = "electric-energy-distribution-1",
    ["fast-inserter"] = "logistics-2",
    ["assembling-machine-2"] = "automation-2",
    ["fast-underground-belt"] = "logistics-2",
    ["electric-mining-drill"] = "electric-mining-drill",
    ["fast-splitter"] = "logistics-2",
    ["half-diagonal-rail"] = "railway",
    ["chemical-plant"] = "oil-processing",
    ["oil-refinery"] = "oil-processing",
    ["curved-rail-a"] = "railway",
    ["curved-rail-b"] = "railway",
    ["pump"] = "fluid-handling",
    ["steel-furnace"] = "advanced-material-processing",
    ["rail-ramp"] = "elevated-rail",
    ["rail-support"] = "elevated-rail",
    ["train-stop"] = "automated-rail-transportation",
    ["pumpjack"] = "oil-gathering",
}

local current_tier_1_entities = {}
local current_tier_2_entities = {}

local function initialize_research(player)
    researched_technologies = {}
    current_tier_1_entities = {'transport-belt', 'burner-mining-drill', 'stone-furnace', 'burner-inserter'}
    current_tier_2_entities = {} -- no research requirement items get placed here manually beforehand
    for tech_name, tech in pairs(game.forces["player"].technologies) do
        if tech.researched then
            researched_technologies[tech_name] = true
        end
    end
    
    -- Update current tier entities based on research
    for entity_name, required_tech in pairs(tier_1_entities) do
        if researched_technologies[required_tech] then
            table.insert(current_tier_1_entities, entity_name)
        end
    end
    
    for entity_name, required_tech in pairs(tier_2_entities) do
        if researched_technologies[required_tech] then
            table.insert(current_tier_2_entities, entity_name)
        end
    end
end

script.on_event(defines.events.on_research_finished, function(event)
    local research = event.research
    researched_technologies[research.name] = true
    
    -- update current tier entities based on the new research
    for entity_name, required_tech in pairs(tier_1_entities) do
        if required_tech == research.name then
            table.insert(current_tier_1_entities, entity_name)
        end
    end
    
    for entity_name, required_tech in pairs(tier_2_entities) do
        if required_tech == research.name then
            table.insert(current_tier_2_entities, entity_name)
        end
    end
end)

local tick_counter = 0
local printed_ghosts = {}  -- Table to hold data for revived ghosts

local function process_ghosts(entity, ghosts, item_name, entity_name)

    for _, ghost in pairs(ghosts) do
        local obstacles = entity.surface.find_entities_filtered{area=ghost.bounding_box, to_be_deconstructed=true}
        if ghost.valid and ghost.ghost_name == entity_name and #obstacles == 0 then
            if entity.get_item_count(item_name) > 0 then
                entity.remove_item({name = item_name, count = 1})
                
                table.insert(printed_ghosts, { -- store the ghost data with a lifespan for the printing effect
                    ghost_position = ghost.position,
                    entity = entity,
                    lifespan = 108
                })
        
                ghost.revive()
                return true
            end
        end
    end
    return false
end

local function update_printing_lines()
    -- Constants for bobbing animation
    local BASE_HEIGHT = 2
    local BOB_RANGE = 0.06  -- how far up/down from base height
    local BOB_CYCLE = 40   -- ticks for a complete up/down cycle
    
    for i = #printed_ghosts, 1, -1 do
        local data = printed_ghosts[i]
        if data.lifespan > 0 then
            -- local bob_offset = BOB_RANGE * math.sin((game.tick * 2 * math.pi) / BOB_CYCLE)
            -- local bob_offset_derived_from_spidertron_creation_tick = BOB_RANGE * math.sin((game.tick - spidertron_creation_tick * 2 * math.pi) / BOB_CYCLE)
            
            -- rendering.draw_line{
            --     color = {r = 0.9, g = 0.88, b = 1, a = 0.9},
            --     width = 1,
            --     from = {
            --         x = data.entity.position.x,
            --         y = data.entity.position.y - (BASE_HEIGHT + bob_offset)
            --     },
            --     to = {data.ghost_position.x, data.ghost_position.y},
            --     surface = "nauvis",
            --     time_to_live = 1
            -- }
            -- local space_loaded = script.active_mods["space-exploration"]
            -- if data.raw["trivial-smoke"]["smoke-fast"] then
                -- game.print("smoke-fast exists")
                -- local ent = prototypes.entity["copper-stromatolite"]
                -- if prototypes.entity["copper-stromatolite"] then
                -- game.print(ent)

            -- end
            data.entity.surface.create_trivial_smoke{
                -- I should probably check for a SA entity on load, and save it to a variable instead of checking every tick?
                name = prototypes.entity["copper-stromatolite"] and "aquilo-snow-smoke" or "smoke-fast",
                position = {data.ghost_position.x, data.ghost_position.y},
                force = data.entity.force
            }

            local from = {
                x = data.entity.position.x,
                y = data.entity.position.y - BASE_HEIGHT -- - (BASE_HEIGHT + bob_offset)
            }
            local to = {
                x = data.ghost_position.x,
                y = data.ghost_position.y
            }
            
            -- calculate distance for scaling
            local dx = to.x - from.x
            local dy = to.y - from.y
            local distance = math.sqrt(dx * dx + dy * dy)

            -- this can't possibly be the best way to render a fancy laser?
            rendering.draw_sprite{
                sprite = "beam-start",
                -- target from, but x is offset by 2 to center the sprite
                target = {x = from.x, y = from.y},
                orientation = 0.75,
                orientation_target = to,
                oriented_offset = {y = 0 - 0.3, x = 0}, 
                x_scale = 0.6,
                y_scale = 0.45,
                surface = data.entity.surface,
                time_to_live = 1,
                -- render_layer = "object"
                -- tint = {r = 1, g = 0, b = 0, a = 0.8},
            }
            rendering.draw_animation{
                animation = "body-beam",
                target = {x = from.x, y = from.y}, -- Raise the starting position by 1 tile on the y-axis
                orientation_target = {x = to.x, y = to.y },
                orientation = 0.25,
                oriented_offset = {y = -(distance / 2) - 0.3, x = 0},
                x_scale = (distance / 2) - 0.3,
                y_scale = 0.45,
                surface = data.entity.surface,
                time_to_live = 1,
                animation_speed = 0.5
            }

            

            rendering.draw_animation{
                animation = "beam-end-light",
                target = to,
                -- orientation = 0.25,
                animation_speed = 1,
                -- oriented_offset = {25, 124},
                animation_offset = 0,
                render_layer = "object",
                x_scale = 0.6,
                y_scale = 0.6,
                surface = data.entity.surface,
                time_to_live = 1,
                render_layer = "object"
            }

            data.lifespan = data.lifespan - 1
        else
            table.remove(printed_ghosts, i)
        end
    end
end
local tier_1_lookup = {}
for _, name in ipairs(tier_1_entities) do
    tier_1_lookup[name] = true
end

local function print_entities(entity)
    local entity_position = entity.position
    local surface = entity.surface
    tick_counter = tick_counter + 1

    if tick_counter % 2 == 1 then -- Process tier 1 entities on odd ticks
        if entity.get_item_count("tier-1-filament") < 1 then
            return
        end
        
        -- Single query for all ghosts in range
        local ghosts = surface.find_entities_filtered{
            position = entity_position,
            radius = 14,
            name = "entity-ghost"
        }

        -- if ghosts[1] then game.print('found') end
        
        -- Process directly without creating intermediate arrays
        for _, entity_name in ipairs(current_tier_1_entities) do
            -- Find first matching ghost
            local matching_ghosts = surface.find_entities_filtered{
                position = entity_position,
                radius = 14,
                name = "entity-ghost",
                ghost_name = entity_name
            }
            
            if matching_ghosts[1] then
                if process_ghosts(entity, matching_ghosts, "tier-1-filament", entity_name) then
                    return
                end
            end
        end
    else -- Process tier 2 entities on even ticks
        if entity.get_item_count("tier-2-filament") < 1 then
            return
        end
        
        -- Single query for all ghosts in range
        local ghosts = surface.find_entities_filtered{
            position = entity_position,
            radius = 14,
            name = "entity-ghost"
        }
        
        -- Process directly without creating intermediate arrays
        for _, entity_name in ipairs(current_tier_2_entities) do
            -- Find first matching ghost
            local matching_ghosts = surface.find_entities_filtered{
                position = entity_position,
                radius = 14,
                name = "entity-ghost",
                ghost_name = entity_name
            }
            
            if matching_ghosts[1] then
                if process_ghosts(entity, matching_ghosts, "tier-2-filament", entity_name) then
                    return
                end
            end
        end
    end
end

local mined_entities = {}  -- table to hold mined entity data

local function mine_nearby_entities(entity_miner) -- probably not great function name
    local surface = game.surfaces[1]
    local entity_position = entity_miner.position
    for _, entity in pairs(surface.find_entities_filtered{position=entity_position, radius=12, to_be_deconstructed=true}) do
        
        local character_inv 
        if entity_miner.follow_target then 
            character_inv = entity_miner.follow_target.get_main_inventory()
        end
        if entity_miner.get_driver() then -- The engineer is inside the Spidertron 
            character_inv = entity_miner.get_driver().get_main_inventory()
        end
        if entity.valid then -- store entity data and laser lifespan
            table.insert(mined_entities, {
                entity_position = entity.position,
                player = entity_miner,
                lifespan = 48  -- lifespan in ticks
            })
            entity.mine({inventory = character_inv})
            return
        end
    end
end

-- tick function to update laser positions and lifespan
local function update_lasers()
    for i = #mined_entities, 1, -1 do
        local data = mined_entities[i]
        if data.lifespan > 0 then
            rendering.draw_line{ -- draw new laser with updated entity position
                color = {r = 1, g = 0.2, b = 0.2, a = 1},
                width = 1,
                from = {data.player.position.x, data.player.position.y - 3},
                to = {data.entity_position.x, data.entity_position.y},
                surface = "nauvis",
                time_to_live = 1  -- Redraw every tick
            }
            data.lifespan = data.lifespan - 1
        else
            table.remove(mined_entities, i)  -- Remove expired lasers
        end
    end
end

local spidertrons = {} -- this should probably be in storage

local function initialize_spidertrons()
    spidertrons = game.surfaces[1].find_entities_filtered{name = "printertron"}
    -- print name of game.surfaces 1
    -- game.print(spidertrons[1].name)
    -- for _, spidertron in ipairs(spidertrons) do
    --     spidertron.follow_target = game.get_player(storage.spidertron_owners[spidertron.unit_number]).character
    -- end
end

local function remove_spidertron(event)
    if event.entity.name == "printertron" then
        for i, spidertron in ipairs(spidertrons) do
            if spidertron == event.entity then
                table.remove(spidertrons, i)
                break
            end
        end
    end
end

script.on_event(defines.events.on_entity_died, remove_spidertron)
script.on_event(defines.events.on_player_mined_entity, remove_spidertron)

local spiders_initialized = false -- init code runs on first valid tick
script.on_event(defines.events.on_tick, function(event)
    update_lasers()
    update_printing_lines()
    if spiders_initialized == false then
        initialize_spidertrons()
        initialize_research()
        spiders_initialized = true
    end
    for _, spidertron in ipairs(spidertrons) do
        if spidertron.valid then print_entities(spidertron) end
        if game.tick % 2 == 0 then mine_nearby_entities(spidertron) end
    end
end)

script.on_event(defines.events.on_built_entity, function(event)
    local player = game.players[event.player_index]
    local teq = player.force.technologies
    if event.entity.name == "printertron" then
        for _, spider in pairs(spidertrons) do
            if spider.valid and spider.follow_target == player.character then
                event.entity.destroy() -- refund player and destroy placed printertron entity
                player.insert{name = "printertron", count = 1}
                player.print("You already have a printertron following you.")
                return
            end
        end
        table.insert(spidertrons, event.entity)
        assign_spidertron_to_player(event.entity, player)
    end
    if event.entity.name == "printertron" then
        local player = game.get_player(event.player_index)
        local testingg = event.entity.get_spider_legs()
        -- we can use player, but player.character or player.vehicle might work better if the player goes in a vehicle?
        event.entity.follow_target = player.character
        local grid = event.entity.grid
        -- event.entity.color = {r = 1, g = 0.8, b = 0.6} -- event.entity.follow_offset = 2
        if grid and grid.valid then
            local exoskeleton = "exoskeleton-equipment"
            grid.put{name = "spider-gear-equipment"}
            grid.put{name = "spider-engine-equipment"}
        end
    end
end)

local function follow_player(event)
    local player = game.get_player(event.player_index)
    if player and not player.driving then
        local vehicle = event.entity
        if vehicle and vehicle.name == "printertron" then
            event.entity.follow_target = player.character
        end
    end
end

script.on_event(defines.events.on_player_driving_changed_state, follow_player)

script.on_init(function() -- could just build this metadata into the original spidertrons table?
    storage.spidertron_owners = storage.spidertron_owners or {}
end)

script.on_event(defines.events.on_player_used_spidertron_remote, function(event)
    local player = game.get_player(event.player_index)
    for _, spidertron in pairs(spidertrons) do -- find the correct Spidertron to follow the player
        if storage.spidertron_owners[spidertron.unit_number] == player.index then
            spidertron.follow_target = player.character
            break
        end
    end
end)

function assign_spidertron_to_player(spidertron, player) -- runs when spidertrons are created
    storage.spidertron_owners[spidertron.unit_number] = player.index
end

script.on_event(defines.events.on_player_respawned, function(event)
    local player = game.get_player(event.player_index)
    if player and player.character then
        for _, spidertron in pairs(spidertrons) do -- re-apply the follow target for the player's assigned spidertron
            if storage.spidertron_owners[spidertron.unit_number] == player.index then
                spidertron.follow_target = player.character
            end
        end
    end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    initialize_spidertrons()
    game.print('someone ed')
    -- when a player joins, assign them their spidertrons to follow (if they have any)
    local player = game.get_player(event.player_index)
    game.print(player.name)
    if player and player.character then
        game.print(player.index)
        -- print the length of spidertrons table
        game.print(spidertrons[1].name)
        for _, spidertron in pairs(spidertrons) do
            game.print('inside for')
            if storage.spidertron_owners[spidertron.unit_number] == player.index then
                spidertron.follow_target = player.character
            end
        end
    end
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local player = game.get_player(event.player_index)

    if event.entity and event.entity.name == "no-collision-car" then
        event.entity.riding_state = {acceleration = defines.riding.acceleration.accelerating, direction = defines.riding.direction.straight}
    end

end)