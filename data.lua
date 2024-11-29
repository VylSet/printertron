data:extend({
  {
    type = "equipment-category",
    name = "printertron-gear"
  }
})

spider_gear_equipment = util.table.deepcopy(data.raw["movement-bonus-equipment"]["exoskeleton-equipment"])
spider_gear_equipment.name = "spider-gear-equipment"
spider_gear_equipment.shape.height = 2
spider_gear_equipment.shape.width = 5
spider_gear_equipment.energy_consumption = "1W"
spider_gear_equipment.movement_bonus = 0.5
spider_gear_equipment.categories = {"printertron-gear"}

spider_engine_equipment = util.table.deepcopy(data.raw["generator-equipment"]["fission-reactor-equipment"])
spider_engine_equipment.name = "spider-engine-equipment"
spider_engine_equipment.power = "2kW"
spider_engine_equipment.shape.height = 2
spider_engine_equipment.shape.width = 5
spider_engine_equipment.categories = {"printertron-gear"}

spider_engine_item = util.table.deepcopy(data.raw["item"]["fission-reactor-equipment"])
spider_engine_item.name = "spider-engine-equipment"
spider_engine_item.place_as_equipment_result = "spider-engine-equipment"
spider_engine_item.order = "a[energy-source]-b"

spider_gear_item = util.table.deepcopy(data.raw["item"]["exoskeleton-equipment"])
spider_gear_item.name = "spider-gear-equipment"
spider_gear_item.place_as_equipment_result = "spider-gear-equipment"
spider_gear_item.order = "d[exoskeleton]-a"

data:extend(
{
  spider_gear_equipment,
  spider_gear_item,
  spider_engine_item,
  spider_engine_equipment
})

-- not sure if I want to return an iron plate or not, leaving it as the result just in case. also doing this in a loop has to be simpler
-- consolidating the data here and the tier entity data in control.lua would probably be good
data.raw["furnace"]["stone-furnace"].minable = {result = "iron-plate", count = 0, mining_time = 0.2}
data.raw["inserter"]["inserter"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
data.raw["inserter"]["long-handed-inserter"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
data.raw["transport-belt"]["transport-belt"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
data.raw["underground-belt"]["underground-belt"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
data.raw["splitter"]["splitter"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
data.raw["pipe"]["pipe"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
data.raw["pipe-to-ground"]["pipe-to-ground"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
data.raw["electric-pole"]["small-electric-pole"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
data.raw["assembling-machine"]["assembling-machine-1"].minable = {result = "iron-plate", count = 0, mining_time = 0.2}
data.raw["inserter"]["burner-inserter"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
data.raw["mining-drill"]["burner-mining-drill"].minable = {result = "iron-plate", count = 0, mining_time = 0.3}
data.raw["straight-rail"]["straight-rail"].minable = {result = "iron-plate", count = 0, mining_time = 0.3}
data.raw["lab"]["lab"].minable = {result = "iron-plate", count = 0, mining_time = 0.2}
data.raw["offshore-pump"]["offshore-pump"].minable = {result = "iron-plate", count = 0, mining_time = 0.2}
data.raw["rail-signal"]["rail-signal"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
data.raw["rail-chain-signal"]["rail-chain-signal"].minable = {result = "iron-plate", count = 0, mining_time = 0.1}
-- tier 2
data.raw["transport-belt"]["fast-transport-belt"].minable = {result = "steel-plate", count = 0, mining_time = 0.1}
data.raw["electric-pole"]["medium-electric-pole"].minable = {result = "steel-plate", count = 0, mining_time = 0.1}
data.raw["electric-pole"]["big-electric-pole"].minable = {result = "steel-plate", count = 0, mining_time = 0.1}
data.raw["inserter"]["fast-inserter"].minable = {result = "steel-plate", count = 0, mining_time = 0.1}
data.raw["assembling-machine"]["assembling-machine-2"].minable = {result = "steel-plate", count = 0, mining_time = 0.2}
data.raw["underground-belt"]["fast-underground-belt"].minable = {result = "steel-plate", count = 0, mining_time = 0.1}
data.raw["mining-drill"]["electric-mining-drill"].minable = {result = "steel-plate", count = 0, mining_time = 0.4}
data.raw["splitter"]["fast-splitter"].minable = {result = "steel-plate", count = 0, mining_time = 0.2}
data.raw["half-diagonal-rail"]["half-diagonal-rail"].minable = {result = "steel-plate", count = 0, mining_time = 0.3}
data.raw["assembling-machine"]["chemical-plant"].minable = {result = "steel-plate", count = 0, mining_time = 0.3}
data.raw["assembling-machine"]["oil-refinery"].minable = {result = "steel-plate", count = 0, mining_time = 0.3}
data.raw["curved-rail-a"]["curved-rail-a"].minable = {result = "steel-plate", count = 0, mining_time = 0.4}
data.raw["curved-rail-b"]["curved-rail-b"].minable = {result = "steel-plate", count = 0, mining_time = 0.4}
data.raw["furnace"]["steel-furnace"].minable = {result = "steel-plate", count = 0, mining_time = 0.4}
data.raw["rail-ramp"]["rail-ramp"].minable = {result = "steel-plate", count = 0, mining_time = 0.3}
data.raw["rail-support"]["rail-support"].minable = {result = "steel-plate", count = 0, mining_time = 0.3}
data.raw["train-stop"]["train-stop"].minable = {result = "steel-plate", count = 0, mining_time = 0.3}
data.raw["pump"]["pump"].minable = {result = "steel-plate", count = 0, mining_time = 0.2}
data.raw["mining-drill"]["pumpjack"].minable = {result = "steel-plate", count = 0, mining_time = 0.4}


local printertron_item = table.deepcopy(data.raw["item-with-entity-data"]["spidertron"])
printertron_item.name = "printertron"
printertron_item.place_result = "printertron"

local printertron_entity = table.deepcopy(data.raw["spider-vehicle"]["spidertron"])
printertron_entity.name = "printertron"
printertron_entity.max_health = 900
printertron_entity.allow_passengers = false
printertron_entity.minable = {result = "printertron", count = 1, mining_time = 3}
-- printertron_entity.torso_bob_speed = 2
-- printertron_entity.spider_engine = {
--   legs = {}
-- }
printertron_entity.guns = {
  "submachine-gun",
  "submachine-gun",
  "submachine-gun",
}

local printertron_grid = table.deepcopy(data.raw["equipment-grid"]["spidertron-equipment-grid"])
printertron_grid.name = "printertron-grid"
printertron_grid.width = 5
printertron_grid.height = 4
printertron_grid.equipment_categories = {"printertron-gear"}
printertron_entity.equipment_grid = "printertron-grid"

local printertron_recipe = {
  type = "recipe",
  name = "printertron",
  icon = "__base__/graphics/icons/spidertron.png",
  icon_size = 64,
  enabled = true,
  energy_required = 3,
  ingredients = {
    {type = "item", name = "iron-plate", amount = 2}
  },
  results = {{type = "item", name = "printertron", amount = 1}}
}

printertron_entity.height = 1.5

-- 138 x 132 x 8x8
printertron_entity.graphics_set.animation.layers[1].filename = "__printertron__/graphics/printertron-sprite.png"
printertron_entity.graphics_set.animation.layers[2].filename = "__printertron__/graphics/clear.png"


data:extend({
  printertron_grid,
  printertron_item,
  printertron_entity,
  printertron_recipe
})



data:extend({
  {
      type = "sprite",
      name = "body-beam",
      filename = "__printertron__/graphics/body-beam.png",  -- Update path to match your mod
      width = 512,    -- Typical beam width
      height = 12,   -- Keep square for easier scaling
      -- We probably don't need shift since we'll be positioning it directly
  }
})

data:extend({
  {
      type = "animation",
      name = "body-beam",
      filename = "__printertron__/graphics/body-beam.png",  -- Update path to match your mod
      width = 64,    
      height = 12,
      frame_count = 8,
      line_length = 8,
      animation_speed = 0.4
  }
})

data:extend({
  {
      type = "animation",  -- or "animation"
      name = "beam-end-light",
      filename = "__printertron__/graphics/laser-end.png",
      priority = "high",
      width = 110,
      height = 62,
      frame_count = 8,
      line_length = 8,
      animation_speed = 0.4,
  }
})

data:extend({
  {
      type = "sprite",
      name = "beam-start",
      filename = "__printertron__/graphics/beam-start.png",  
      width = 32,    
      height = 12,   
  }
})


local tier_1_filament = {
  type = "item",
  name = "tier-1-filament",
  icon = "__printertron__/graphics/filament-yellow.png",
  icon_size = 64,
  subgroup = "intermediate-product",
  order = "a[filament]",
  stack_size = 300
}

-- tier 1 filament recipe of copper and stone
local tier_1_filament_recipe = {
  type = "recipe",
  name = "tier-1-filament",
  enabled = true,
  energy_required = 1,
  ingredients = {
    {type = "item", name = "copper-ore", amount = 1},
    {type = "item", name = "stone", amount = 1}
    
  },
  results = {{type = "item", name = "tier-1-filament", amount = 5}}
}

data:extend({
  tier_1_filament,
  tier_1_filament_recipe
})

local tier_2_filament = {
  type = "item",
  name = "tier-2-filament",
  icon = "__printertron__/graphics/filament-red.png",
  icon_size = 64,
  subgroup = "intermediate-product",
  order = "a[filament]",
  stack_size = 300
}

-- tier 2 filament recipe of steel and stone brick
local tier_2_filament_recipe = {
  type = "recipe",
  name = "tier-2-filament",
  enabled = true,
  energy_required = 1.5,
  ingredients = {
    {type = "item", name = "steel-plate", amount = 1},
    {type = "item", name = "stone-brick", amount = 1}
    
  },
  results = {{type = "item", name = "tier-2-filament", amount = 5}}
}

data:extend({
  tier_2_filament,
  tier_2_filament_recipe
})