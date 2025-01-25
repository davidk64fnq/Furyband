constructor_powers = 88

SURVEY_AREA = add_spell
		{
			["name"] = 	"Survey area",
			["desc"] = 	"Level [1] Surveys stairs/doors [15] maps area [25] fully map area.",
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	1,
			["level"] = 	1,
			["fail"] = 	35,	
			["random"] =    0,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
			["spell"] = 	function()
					if (get_level(SURVEY_AREA, 50) >= 25) then
						-- enlightenment
						wiz_lite_extra()
					elseif (get_level(SURVEY_AREA, 50) >= 15) then
						--magic map and detect traps
						map_area()
						detect_traps(15 + get_level(SURVEY_AREA, 40, 0))
					elseif (get_level(SURVEY_AREA, 50) >= 5) then
						-- detect doors, traps, stairs
						detect_traps(15 + get_level(SURVEY_AREA, 40, 0))
						detect_stairs(DEFAULT_RADIUS)
						detect_doors(DEFAULT_RADIUS)
					else 
						detect_stairs(DEFAULT_RADIUS)
						detect_doors(DEFAULT_RADIUS)
					end
					return TRUE
			end,
			["info"] = 	function()
                                return " "
                        end,
		}
DISMANTLE = add_spell
		{
			["name"] = 	"Dismantle",
			["desc"] = 	"Dismantles adjacent traps, at lvl [15] it becomes a beam.",
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	4,
			["level"] = 	3,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
			["fail"] = 		10,
				["random"] =    0,
			["spell"] =	function()
					local ret, dir, dam

					if (get_level(DISMANTLE, 50) >= 15) then

						-- Get the direction
						ret, dir = get_aim_dir();
	
						-- Got direction ok?
						if (ret == FALSE) then return FALSE end

						-- fire beam of disarming (like a wand of trap/door destruction
						fire_wall(GF_KILL_TRAP, dir, 1, 1)
					else
						-- player-centered radius 1 ball of disarm trap. (Works like a spell of trap/door destruction)
						fire_ball(GF_KILL_TRAP, 0, 1, 1)
					end
					return TRUE
			end,
			["info"] =	function()
                                return " "
                        end,
		}
SPARKY_SKILLS = add_spell
		{
			["name"] = 	"Sparky Skills",
			["desc"] =	"Casts electric bolt and grants temp resist electricity. Bolt becones a ball at lvl [20].",
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	8,
			["level"] =	7,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
				["random"] =    0,
			["fail"] =	20,
			["spell"] =	function()
					local ret, dir, dam

					-- Get the direction
					ret, dir = get_aim_dir();
	
					-- Got direction ok?
					if (ret == FALSE) then 
						return FALSE
					end

					-- calculate damage  as (skill level * 2) +d20
					dam = get_level(SPARKY_SKILLS, 50)*2 + randint(20)

					-- Fire the bolt/ball.
					if (get_level(SPARKY_SKILLS, 50) >= 20) then
						fire_ball(GF_ELEC, dir, dam, 2)
					else
						fire_bolt(GF_ELEC, dir, dam)
					end
					
					-- grant temp electric resist for 20+(skill level * 3) + d10
					if player.oppose_elec == 0 then set_oppose_elec(randint(10) + 20 + get_level(SPARKY_SKILLS, 20)*3) end
					return TRUE

			end,
			["info"] =	function()
                                return " dam "..(get_level(SPARKY_SKILLS, 50)*2).."+d20  dur "..(20 + get_level(SPARKY_SKILLS, 20)*3).."+1d10"
                        end,
		}
BUILD_DOOR = add_spell
		{
			["name"] = 	"Build door",
			["desc"] = 	"Builds a single door where you stand.",
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	10,
			["level"] = 	9,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
				["random"] =    0,
			["fail"] = 	35,
			["spell"] = 	function()

					-- project a door under the player
					project(0, 0, player.py, player.px, 0, GF_MAKE_DOOR, PROJECT_GRID + PROJECT_ITEM)
					msg_print("You build a door.")
					return TRUE
			end,
			["info"] = 	function()
                                return " "
                        end,
		}
KNOCK_DOWN_WALL = add_spell
		{
			["name"] = 	"Knock down wall",
			["desc"] = 	"Knocks down a single section of wall, at lvl [30] excavates a corridor/chamber.",
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	11,
			["level"] = 	13,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
				["random"] =    0,
			["fail"] = 	35,
			["spell"] = 	function()
					local ret, ret2, dir, which

					-- Get the direction
					ret, dir = get_aim_dir();
	
					-- Got direction ok?
					if (ret == FALSE) then return FALSE end					

					if (get_level(KNOCK_DOWN_WALL, 50) >= 30) then
						-- ask for input
						ret2, which = get_com("[D]ig corridor or [E]xcavate chamber?", 2)

						-- did user press ESC?
						if (ret2 == FALSE) then return FALSE end
						-- which did they choose?
						if (which == strbyte('D')) or (which == strbyte('d')) then
							-- fire a beam
							project_hook(GF_KILL_WALL, dir, 1, PROJECT_BEAM + PROJECT_KILL + PROJECT_GRID + PROJECT_WALL)
							return TRUE
						end 
	
						if (which == strbyte('E')) or (which == strbyte('e')) then 
							fire_ball(GF_KILL_WALL, dir, 1, 3)
							return TRUE
						end

					else
						wall_to_mud(dir)
						return TRUE
					end
			end,
			["info"] = 	function()
                                return " "
                        end,
		}
PLUMBERS_MATE = add_spell
		{
			["name"] = 	"Plumbers Mate",
			["desc"] = 	"Casts a poison bolt and grants temp resist poison. Bolt becomes a ball at lvl [20].",
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	15,
				["random"] =    0,
			["level"] = 	17,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
			["fail"] = 	35,
			["spell"] = 	function()
					local ret, dir, dam

					-- Get the direction
					ret, dir = get_aim_dir();
	
					-- Got direction ok?
					if (ret == FALSE) then 
						return FALSE
					end

					dam = get_level(PLUMBERS_MATE, 50)*2 + 30

					-- Fire the bolt/ball.
					if (get_level(PLUMBERS_MATE, 50) >= 20) then
						fire_ball(GF_POIS, dir, dam, 3)
					else
						fire_bolt(GF_POIS, dir, dam)
					end

					if player.oppose_pois == 0 then 
						set_oppose_pois(randint(10) + 30 + get_level(PLUMBERS_MATE, 20)*3) 
					end
					return TRUE
			end,
			["info"] = 	function()
                                return " dam "..(get_level(PLUMBERS_MATE, 50)*2 + 30).."    dur "..(30 + get_level(PLUMBERS_MATE, 20)*3).."+1d10"
                        end,
		}
BUILD_WALL = add_spell
		{
			["name"] = 	"Build walls",
			["desc"] = 	"Builds walls. Single section first, then at lvl [15] either a long wall or fills in a hole.",
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	17,
			["random"] =    0,
			["level"] = 	19,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
			["fail"] = 	35,
			["spell"] = 	function()
					local which, ret, dir, x, y


					if (get_level(BUILD_WALL, 50) >= 15) then
						ret2, which = get_com("[B]uild straight wall or [F]ill hole?", 2)
						-- corridor?
						if (ret2 == FALSE) then return FALSE end

						-- Get the direction
						ret, dir = get_aim_dir();
	
						-- Got direction ok?
						if (ret == FALSE) then return FALSE end

						if (which == strbyte('B')) or (which == strbyte('b')) then
							-- Fire the bolt/ball.
							project_hook(GF_STONE_WALL, dir, 1, PROJECT_BEAM + PROJECT_KILL + PROJECT_GRID)
							return TRUE
						end 
	
						if (which == strbyte('F')) or (which == strbyte('f')) then 
							fire_ball(GF_STONE_WALL, dir, 1, 3)
							return TRUE
						end
					else
						project(0, 0, player.py, player.px, 0, GF_STONE_WALL, PROJECT_GRID + PROJECT_ITEM)
						msg_print("You build a section of wall.")
						return TRUE
					end
			end,
			["info"] = 	function()
                                return " "
                        end,
		}
BUILD_STAIR = add_spell
		{
			["name"] = 	"Build stairs",
			["desc"] = 	"Builds stairs. But only in a proper dungeon.",
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	26,
			["level"] = 	23,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
				["random"] =    0,
			["fail"] = 	35,
			["spell"] = 	function()

					stair_creation()
					return TRUE
			end,
			["info"] = 	function()
                                return " "
                        end,
		}

NAIL_GUNS = add_spell
		{
			["name"] = 	"Nail guns",
			["desc"] = 	"Fires a shard bolt, then a powerful area ball at lvl [10].",
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	10,
			["level"] = 	31,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
				["random"] =    0,
			["fail"] = 	35,
			["spell"] = 	function()
					local which, ret, dir, dam, repeats, y, x

					dam = 40 + get_level(NAIL_GUNS, 50)*3
					repeats = get_level(NAIL_GUNS)

					if (get_level(NAIL_GUNS, 50) >= 10) then
------------------------------
						ret2, which = get_com("[B]olt  or [A]rea ball?", 2)
						-- did user press ESC?
						if (ret2 == FALSE) then return FALSE end
						-- which did they choose?
						if (which == strbyte('B')) or (which == strbyte('b')) then
						-- Get the direction
						ret, dir = get_aim_dir();
						-- Got direction ok?
						if (ret == FALSE) then return FALSE end
						fire_bolt(GF_SHARDS, dir, dam)
						return TRUE
						end 
						if (which == strbyte('A')) or (which == strbyte('a')) then 
---							fire_ball(GF_KILL_WALL, dir, 1, 3)
						-- fire multiple nails at random grids
						while (repeats > 0) do
							-- initialise tries variable
							tries = 0
							
							while (tries == 0) do
								-- get grid coordinates near(ish) player
								x = player.px - 5 + randint(10)
								y = player.py - 5 + randint(10)
								grid = cave(y, x)
								-- are the coordinates in a wall, or the player?
								if (cave_is(grid, FF1_WALL) ~= 0) or ((x == player.px) and (y == player.py)) then
									-- try again
									tries = 0
								else
									--neither player, nor wall, then stop this 'while'
									tries = 1
								end
							end
							-- fire a nail
							project(0, 0, y, x, dam, GF_SHARDS, PROJECT_JUMP + PROJECT_GRID + PROJECT_ITEM + PROJECT_KILL + PROJECT_THRU)
							-- one less repeat
							repeats = repeats - 1
						end
							return TRUE
						end
-------------------------------
					else
						-- Get the direction
						ret, dir = get_aim_dir();
						-- Got direction ok?
						if (ret == FALSE) then return FALSE end
						fire_bolt(GF_SHARDS, dir, dam)
					end
					return TRUE
			end,
			["info"] = 	function()
                                return " dam "..(40 + get_level(NAIL_GUNS, 50)*3).." "
                        end,
		}

DEMOLITION = add_spell
		{
			["name"] = 	"Demolition",
			["desc"] =	"Destroys entire parts of the dungeon around the player.", 
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	35,
			["level"] = 	37,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
				["random"] =    0,
			["fail"] = 	35,
			["spell"] = 	function()

					msg_print("You call in the demolition men!")
					fire_ball(GF_DISINTEGRATE, 0, 1, 40)
					return TRUE
			end,
			["info"] = 	function()
                                return " "
                        end,
		}
REBUILD_DUNGEON = add_spell
		{
			["name"] = 	"Rebuild entire dungeon",
			["desc"] = 	"Reconstructs whole dungeon level.",
			["school"] =    {SCHOOL_CONST },
			["mana"] = 	40,
			["level"] = 	45,
			["fail"] = 	40,
				["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
				["random"] =    0,
			["spell"] = 	function()

					alter_reality()
					return TRUE
			end,
			["info"] = 	function()
                                return " "
                        end,
		}
	

FIND_HIDDEN = add_spell
{
	["name"] = 	"Find Traps",
	["school"] = 	{SCHOOL_CONST},
	["level"] = 	5,
	["mana"] = 	2,
	["mana_max"] = 	10,
	["fail"] = 	25,
	["random"] =    0,
		["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
	["inertia"] = 	{ 1, 10 },
	["spell"] = 	function()

			local obvious = nil
			obvious = detect_traps(15 + get_level(FIND_HIDDEN, 40, 0))
			if get_level(FIND_HIDDEN, 50) >= 15 then
				obvious = is_obvious(set_tim_invis(10 + randint(20) + get_level(FIND_HIDDEN, 40)), obvious)
			end
			return obvious
	end,
	["info"] = 	function()
			if get_level(FIND_HIDDEN, 50) >= 15 then
				return "rad "..(15 + get_level(FIND_HIDDEN, 40)).." dur "..(10 + get_level(FIND_HIDDEN, 40)).."+d20"
			else
				return "rad "..(15 + get_level(FIND_HIDDEN, 40))
			end
	end,
	["desc"] =	{
			"Detects the traps in a certain radius around you",
			"At level [15] it allows you to sense invisible for a while"
	}
}

MKEY_CONSTRUCT_POWERS = 88
add_mkey
{
        ["mkey"] =      MKEY_CONSTRUCT_POWERS,
        ["fct"] =       function()
             	execute_magic(constructor_powers)
                	energy_use = energy_use + 100;
        end
}

