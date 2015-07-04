--[[

		Save as HeroInfo.lua into Ensage\Scripts\libs.

		Structure:
		if not heroInfo["HeroName"].projectileSpeed -- Melee hero.
			heroInfo["HeroName"].attackRate == Hero's Base Attack Rate
			heroInfo["HeroName"].attackPoint == Hero's Base Attack Point
			heroInfo["HeroName"].attackRange == Hero's Base Attack Range
			heroInfo["HeroName"].movementSpeed == Hero's Base Movement Speed
			heroInfo["HeroName"].turnRate == Hero's Base Turning Rate
			heroInfo["HeroName"].attackBackswing = Hero's attack backswing
			
		if heroInfo["HeroName"].projectileSpeed -- Ranged hero.
			heroInfo["HeroName"].attackRate == Hero's Base Attack Rate
			heroInfo["HeroName"].attackPoint == Hero's Base Attack Point
			heroInfo["HeroName"].attackRange == Hero's Base Attack Range
			heroInfo["HeroName"].projectileSpeed == Hero's Attack's Projectile Speed
			heroInfo["HeroName"].movementSpeed == Hero's Base Movement Speed
			heroInfo["HeroName"].turnRate == Hero's Base Turning Rate
			heroInfo["HeroName"].attackBackswing = Hero's attack backswing

		Note:
		Hero names with spaces in them have the space replaced with '_'.
			
--]]

heroInfo = {

npc_dota_hero_antimage = {
 attackRate = 1.45,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.6},

npc_dota_hero_axe = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 290,
 turnRate = 0.6,
 attackBackswing = 0.5},

npc_dota_hero_bane = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 400,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.6,
 attackBackswing = 0.7},

npc_dota_hero_bloodseeker = {
 attackRate = 1.7,
 attackPoint = 0.43,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.5,
 attackBackswing = 0.74},

npc_dota_hero_crystal_maiden = {
 attackRate = 1.7,
 attackPoint = 0.55,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 280,
 turnRate = 0.5,
 attackBackswing = 0},

npc_dota_hero_drow_ranger = {
 attackRate = 1.7,
 attackPoint = 0.7,
 attackRange = 625,
 projectileSpeed = 1250,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_earthshaker = {
 attackRate = 1.7,
 attackPoint = 0.467,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.863},

npc_dota_hero_juggernaut = {
 attackRate = 1.6,
 attackPoint = 0.33,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.6,
 attackBackswing = 0.84},

npc_dota_hero_mirana = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 300,
 turnRate = 0.4,
 attackBackswing = 0.7},

npc_dota_hero_nevermore = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 500,
 projectileSpeed = 1200,
 movementSpeed = 305,
 turnRate = 1.0,
 attackBackswing = 0.54},

npc_dota_hero_morphling = {
 attackRate = 1.6,
 attackPoint = 0.5,
 attackRange = 350,
 projectileSpeed = 1300,
 movementSpeed = 285,
 turnRate = 0.6,
 attackBackswing = 0.5},

npc_dota_hero_phantom_lancer = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 290,
 turnRate = 0.6,
 attackBackswing = 0.5},

npc_dota_hero_puck = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 550,
 projectileSpeed = 900,
 movementSpeed = 295,
 turnRate = 0.4,
 attackBackswing = 0.8},

npc_dota_hero_pudge = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 285,
 turnRate = 0.5,
 attackBackswing = 1.17},

npc_dota_hero_razor = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 475,
 projectileSpeed = 2000,
 movementSpeed = 295,
 turnRate = 0.4,
 attackBackswing = 0.7},

npc_dota_hero_sand_king = {
 attackRate = 1.7,
 attackPoint = 0.53,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.47},

npc_dota_hero_storm_spirit = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 480,
 projectileSpeed = 1100,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_sven = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_tiny = {
 attackRate = 1.7,
 attackPoint = 0.49,
 attackRange = 128,
 movementSpeed = 285,
 turnRate = 0.5,
 attackBackswing = 1},

npc_dota_hero_vengefulspirit = {
 attackRate = 1.7,
 attackPoint = 0.33,
 attackRange = 400,
 projectileSpeed = 1500,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.64},

npc_dota_hero_windrunner = {
 attackRate = 1.5,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1250,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_zuus = {
 attackRate = 1.7,
 attackPoint = 0.633,
 attackRange = 350,
 projectileSpeed = 1100,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.366},

npc_dota_hero_earth_spirit = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.6,
 attackBackswing = 0.65},
 
npc_dota_hero_legion_commander = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 128,
 movementSpeed = 320,
 turnRate = 0.5,
 attackBackswing = 0.64},

npc_dota_hero_ember_spirit = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_terrorblade = {
 attackRate = 1.5,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.6},

npc_dota_hero_kunkka = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_lina = {
 attackRate = 1.7,
 attackPoint = 0.75,
 attackRange = 635,
 projectileSpeed = 1000,
 movementSpeed = 295,
 turnRate = 0.5,
 attackBackswing = 0.78},

npc_dota_hero_phoenix = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 500,
 projectileSpeed = 1100,
 movementSpeed = 285,
 turnRate = 1.0,
 attackBackswing = 0.633},

npc_dota_hero_lich = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 550,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.54},

npc_dota_hero_lion = {
 attackRate = 1.7,
 attackPoint = 0.43,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.74},

npc_dota_hero_shadow_shaman = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 500,
 projectileSpeed = 900,
 movementSpeed = 285,
 turnRate = 0.4,
 attackBackswing = 0.5},

npc_dota_hero_slardar = {
 attackRate = 1.7,
 attackPoint = 0.36,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.64},

npc_dota_hero_tidehunter = {
 attackRate = 1.7,
 attackPoint = 0.6,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.4,
 attackBackswing = 0.56},

npc_dota_hero_witch_doctor = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1200,
 movementSpeed = 305,
 turnRate = 0.4,
 attackBackswing = 0.5},

npc_dota_hero_riki = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_enigma = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 500,
 projectileSpeed = 900,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.77},

npc_dota_hero_tinker = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 500,
 projectileSpeed = 900,
 movementSpeed = 305,
 turnRate = 0.6,
 attackBackswing = 0.65},

npc_dota_hero_sniper = {
 attackRate = 1.7,
 attackPoint = 0.17,
 attackRange = 550,
 projectileSpeed = 3000,
 movementSpeed = 290,
 turnRate = 0.6,
 attackBackswing = 0.7},

npc_dota_hero_necrolyte = {
 attackRate = 1.7,
 attackPoint = 0.53,
 attackRange = 550,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.77},

npc_dota_hero_warlock = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 1200,
 movementSpeed = 295,
 turnRate = 0.4,
 attackBackswing = 0.3},

npc_dota_hero_beastmaster = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.4,
 attackBackswing = 0.7},

npc_dota_hero_queenofpain = {
 attackRate = 1.7,
 attackPoint = 0.56,
 attackRange = 550,
 projectileSpeed = 1500,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.41},

npc_dota_hero_venomancer = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 450,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 0.4,
 attackBackswing = 0.7},
 
npc_dota_hero_faceless_void = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.56},

npc_dota_hero_skeleton_king = {
 attackRate = 1.7,
 attackPoint = 0.56,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.4,
 attackBackswing = 0.44},

npc_dota_hero_death_prophet = {
 attackRate = 1.7,
 attackPoint = 0.56,
 attackRange = 600,
 projectileSpeed = 1000,
 movementSpeed = 280,
 turnRate = 0.5,
 attackBackswing = 0.51},

npc_dota_hero_phantom_assassin = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.4,
 attackBackswing = 0.7},

npc_dota_hero_pugna = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 320,
 turnRate = 0.5,
 attackBackswing = 0.5},

npc_dota_hero_templar_assassin = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 140,
 projectileSpeed = 900,
 movementSpeed = 305,
 turnRate = 0.7,
 attackBackswing = 0.5},

npc_dota_hero_viper = {
 attackRate = 1.7,
 attackPoint = 0.33,
 attackRange = 575,
 projectileSpeed = 1200,
 movementSpeed = 285,
 turnRate = 0.4,
 attackBackswing = 1},

npc_dota_hero_luna = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 330,
 projectileSpeed = 900,
 movementSpeed = 330,
 turnRate = 0.4,
 attackBackswing = 0.46},

npc_dota_hero_dragon_knight = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 0.4,
 attackBackswing = 0.5},

npc_dota_hero_dazzle = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 500,
 projectileSpeed = 1200,
 movementSpeed = 305,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_rattletrap = {
 attackRate = 1.7,
 attackPoint = 0.33,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.6,
 attackBackswing = 0.64},

npc_dota_hero_leshrac = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.77},

npc_dota_hero_furion = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1125,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.77},

npc_dota_hero_life_stealer = {
 attackRate = 1.7,
 attackPoint = 0.39,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 1.0,
 attackBackswing = 0.44},

npc_dota_hero_dark_seer = {
 attackRate = 1.7,
 attackPoint = 0.59,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.58},

npc_dota_hero_clinkz = {
 attackRate = 1.7,
 attackPoint = 0.7,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 300,
 turnRate = 0.4,
 attackBackswing = 0.3},

npc_dota_hero_omniknight = {
 attackRate = 1.7,
 attackPoint = 0.433,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.6,
 attackBackswing = 0.567},

npc_dota_hero_enchantress = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 550,
 projectileSpeed = 900,
 movementSpeed = 310,
 turnRate = 0.4,
 attackBackswing = 0.7},

npc_dota_hero_huskar = {
 attackRate = 1.6,
 attackPoint = 0.4,
 attackRange = 400,
 projectileSpeed = 1400,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.5},

npc_dota_hero_night_stalker = {
 attackRate = 1.7,
 attackPoint = 0.55,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.5,
 attackBackswing = 0.56},

npc_dota_hero_broodmother = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.5,
 attackBackswing = 0.5},

npc_dota_hero_bounty_hunter = {
 attackRate = 1.7,
 attackPoint = 0.59,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.6,
 attackBackswing = 0.59},

npc_dota_hero_weaver = {
 attackRate = 1.7,
 attackPoint = 0.64,
 attackRange = 425,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.36},

npc_dota_hero_jakiro = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 400,
 projectileSpeed = 1100,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.5},

npc_dota_hero_batrider = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 375,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 1.0,
 attackBackswing = 0.54},

npc_dota_hero_chen = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 600,
 projectileSpeed = 1100,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.5},

npc_dota_hero_spectre = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.4,
 attackBackswing = 0.7},

npc_dota_hero_doom_bringer = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 150,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.7},

npc_dota_hero_ancient_apparition = {
 attackRate = 1.7,
 attackPoint = 0.45,
 attackRange = 600,
 projectileSpeed = 1250,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_ursa = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.5,
 attackBackswing = 0.3},

npc_dota_hero_spirit_breaker = {
 attackRate = 1.7,
 attackPoint = 0.6,
 attackRange = 128,
 movementSpeed = 290,
 turnRate = 0.4,
 attackBackswing = 0.3},

npc_dota_hero_gyrocopter = {
 attackRate = 1.7,
 attackPoint = 0.2,
 attackRange = 375,
 projectileSpeed = 3000,
 movementSpeed = 315,
 turnRate = 0.6,
 attackBackswing = 0.97},

npc_dota_hero_alchemist = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.65},

npc_dota_hero_invoker = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 280,
 turnRate = 0.5,
 attackBackswing = 0.7},

npc_dota_hero_silencer = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 600,
 projectileSpeed = 1000,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.5},

npc_dota_hero_obsidian_destroyer = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 450,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.54},

npc_dota_hero_lycan = {
 attackRate = 1.7,
 attackPoint = 0.55,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.5,
 attackBackswing = 0.55},

npc_dota_hero_brewmaster = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.65},

npc_dota_hero_shadow_demon = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 500,
 projectileSpeed = 900,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.5},

npc_dota_hero_lone_druid = {
 attackRate = 1.7,
 attackPoint = 0.33,
 attackRange = 550,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.53},

npc_dota_hero_chaos_knight = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 325,
 turnRate = 0.5,
 attackBackswing = 0.5},

npc_dota_hero_meepo = {
 attackRate = 1.7,
 attackPoint = 0.38,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.5,
 attackBackswing = 0.6},

npc_dota_hero_treant = {
 attackRate = 1.9,
 attackPoint = 0.6,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.4},

npc_dota_hero_ogre_magi = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_undying = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.6,
 attackBackswing = 0.3},

npc_dota_hero_rubick = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1125,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.77},

npc_dota_hero_disruptor = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1200,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.5},

npc_dota_hero_nyx_assassin = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.54},

npc_dota_hero_naga_siren = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 320,
 turnRate = 0.5,
 attackBackswing = 0.5},

npc_dota_hero_keeper_of_the_light = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.85},

npc_dota_hero_wisp = {
 attackRate = 1.7,
 attackPoint = 0.15,
 attackRange = 575,
 projectileSpeed = 1200,
 movementSpeed = 295,
 turnRate = 0.7,
 attackBackswing = 0.4},

npc_dota_hero_visage = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 295,
 turnRate = 0.5,
 attackBackswing = 0.54},

npc_dota_hero_slark = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.5,
 attackBackswing = 0.3},

npc_dota_hero_medusa = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 600,
 projectileSpeed = 1200,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.6},

npc_dota_hero_troll_warlord = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 500,
 projectileSpeed = 1200,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.3},

npc_dota_hero_centaur = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.3},

npc_dota_hero_magnataur = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.84},

npc_dota_hero_shredder = {
 attackRate = 1.7,
 attackPoint = 0.36,
 attackRange = 128,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.64},

npc_dota_hero_bristleback = {
 attackRate = 1.8,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 1.0,
 attackBackswing = 0.3},

npc_dota_hero_tusk = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.5,
 attackBackswing = 0.64},

npc_dota_hero_skywrath_mage = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1000,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.78},

npc_dota_hero_elder_titan = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.4,
 attackBackswing = 0.97},

npc_dota_hero_abaddon = {
 attackRate = 1.7,
 attackPoint = 0.56,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.5,
 attackBackswing = 0.41},
 
 npc_dota_hero_techies = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 700,
 projectileSpeed = 900,
 movementSpeed = 270,
 turnRate = 0.5,
 attackBackswing = 0.5},
 
 npc_dota_hero_oracle = {
 attackRate = 1.4,
 attackPoint = 0.3,
 attackRange = 620,
 projectileSpeed = 900,
 movementSpeed = 305,
 turnRate = 0.4,
 attackBackswing = 0.7},
 
 npc_dota_hero_winter_wyvern = {
 attackRate = 1.7,
 attackPoint = 0.25,
 attackRange = 620,
 projectileSpeed = 700,
 movementSpeed = 305,
 turnRate = 0.4,
 attackBackswing = 0.8},
 
 npc_dota_lone_druid_bear1 = {
 attackRate = 1.75,
 attackPoint = 0.43,
 attackRange = 620,
 attackBackswing = 0.67},
 
 npc_dota_lone_druid_bear2 = {
 attackRate = 1.65,
 attackPoint = 0.43,
 attackRange = 620,
 attackBackswing = 0.67},
 
 npc_dota_lone_druid_bear3 = {
 attackRate = 1.55,
 attackPoint = 0.43,
 attackRange = 620,
 attackBackswing = 0.67},
 
 npc_dota_lone_druid_bear4 = {
 attackRate = 1.45,
 attackPoint = 0.43,
 attackRange = 620,
 attackBackswing = 0.67},
 
 npc_dota_creep_badguys_melee = {
 attackRate = 1,
 attackPoint = 0.467,
 attackRange = 100,
 attackBackswing = 0.633},
 
 npc_dota_creep_goodguys_melee = {
 attackRate = 1,
 attackPoint = 0.467,
 attackRange = 100,
 attackBackswing = 0.633},
 
 npc_dota_creep_badguys_ranged = {
 attackRate = 1,
 attackPoint = 0.5,
 attackRange = 500,
 projectileSpeed = 900,
 attackBackswing = 0.5},
 
 npc_dota_creep_goodguys_ranged	= {
 attackRate = 1,
 attackPoint = 0.5,
 attackRange = 500,
 projectileSpeed = 900,
 attackBackswing = 0.5},
 
 npc_dota_badguys_siege = {
 attackRate = 2.7,
 attackPoint = 0.7,
 attackRange = 690,
 projectileSpeed = 1100,
 attackBackswing = 0.3},
 
 npc_dota_goodguys_siege = {
 attackRate = 2.7,
 attackPoint = 0.7,
 attackRange = 690,
 projectileSpeed = 1100,
 attackBackswing = 0.3},
 
npc_dota_venomancer_plague_ward_1 = {
 attackRate = 1.5,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 1900,
 attackBackswing = 0.7},
 
npc_dota_venomancer_plague_ward_2 = {
 attackRate = 1.5,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 1900,
 attackBackswing = 0.7},
 
npc_dota_venomancer_plague_ward_3 = {
 attackRate = 1.5,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 1900,
 attackBackswing = 0.7},
 
npc_dota_venomancer_plague_ward_4 = {
 attackRate = 1.5,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 1900,
 attackBackswing = 0.7},
 
npc_dota_badguys_tower1_bot = {
 attackRate = 1,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_badguys_tower1_mid = {
 attackRate = 1,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_badguys_tower1_top = {
 attackRate = 1,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_badguys_tower2_bot = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_badguys_tower2_mid = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_badguys_tower2_top = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_badguys_tower3_bot = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_badguys_tower3_mid = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_badguys_tower3_top = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_badguys_tower4 = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_goodguys_tower1_bot = {
 attackRate = 1,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_goodguys_tower1_mid = {
 attackRate = 1,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_goodguys_tower1_top = {
 attackRate = 1,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_goodguys_tower2_bot = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_goodguys_tower2_mid = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 0.7},
 
npc_dota_goodguys_tower2_top = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_goodguys_tower3_bot = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_goodguys_tower3_mid = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_goodguys_tower3_top = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_goodguys_tower4 = {
 attackRate = 0.95,
 attackPoint = 0,
 attackRange = 700,
 projectileSpeed = 750,
 attackBackswing = 1},
 
npc_dota_invoker_forged_spirit = {
 attackRate = 1.5,
 attackPoint = 0.2,
 attackRange = 700,
 projectileSpeed = 1000,
 attackBackswing = 0.4},
 
npc_dota_lycan_wolf1 = {
 attackRate = 1.25,
 attackPoint = 0.33,
 attackBackswing = 0.64},
 
npc_dota_lycan_wolf2 = {
 attackRate = 1.2,
 attackPoint = 0.33,
 attackBackswing = 0.64},
 
npc_dota_lycan_wolf3 = {
 attackRate = 1.15,
 attackPoint = 0.33,
 attackBackswing = 0.64},
 
npc_dota_lycan_wolf4 = {
 attackRate = 1.1,
 attackPoint = 0.33,
 attackBackswing = 0.64},
 
 npc_dota_brewmaster_earth_1 = {
 attackRate = 1.35,
 attackPoint = 0.3,
 attackBackswing = 0.3},
 
 npc_dota_brewmaster_earth_2 = {
 attackRate = 1.35,
 attackPoint = 0.3,
 attackBackswing = 0.3},
 
 npc_dota_brewmaster_earth_3 = {
 attackRate = 1.35,
 attackPoint = 0.3,
 attackBackswing = 0.3},
 
npc_dota_brewmaster_fire_1 = {
 attackRate = 1.35,
 attackPoint = 0.3,
 attackBackswing = 0.3},
 
 npc_dota_brewmaster_fire_2 = {
 attackRate = 1.35,
 attackPoint = 0.3,
 attackBackswing = 0.3},
 
 npc_dota_brewmaster_fire_3 = {
 attackRate = 1.35,
 attackPoint = 0.3,
 attackBackswing = 0.3},
 
npc_dota_brewmaster_storm_1 = {
 attackRate = 1.5,
 attackPoint = 0.4,
 attackBackswing = 0.77},
 
 npc_dota_brewmaster_storm_2 = {
 attackRate = 1.5,
 attackPoint = 0.4,
 attackBackswing = 0.77},
 
 npc_dota_brewmaster_storm_3 = {
 attackRate = 1.5,
 attackPoint = 0.4,
 attackBackswing = 0.77},
 
 npc_dota_necronomicon_archer_1 = {
 attackRate = 1,
 attackPoint = 0.7,
 attackBackswing = 0.3},
 
 npc_dota_necronomicon_archer_2 = {
 attackRate = 1,
 attackPoint = 0.7,
 attackBackswing = 0.3},
 
 npc_dota_necronomicon_archer_3 = {
 attackRate = 1,
 attackPoint = 0.7,
 attackBackswing = 0.3},
 
 npc_dota_necronomicon_warrior_1 = {
 attackRate = 0.75,
 attackPoint = 0.56,
 attackBackswing = 0.44},
 
 npc_dota_necronomicon_warrior_2 = {
 attackRate = 0.75,
 attackPoint = 0.56,
 attackBackswing = 0.44},
 
 npc_dota_necronomicon_warrior_3 = {
 attackRate = 0.75,
 attackPoint = 0.56,
 attackBackswing = 0.44},
 
 npc_dota_beastmaster_boar = {
 attackRate = 1.25,
 attackPoint = 0.5,
 attackBackswing = 0.47},
 
 npc_dota_beastmaster_greater_boar = {
 attackRate = 1.25,
 attackPoint = 0.5,
 attackBackswing = 0.47},
 
 npc_dota_visage_familiar1 = {
 attackRate = 0.4,
 attackPoint = 0.33,
 attackBackswing = 0.2},
 
 npc_dota_visage_familiar2 = {
 attackRate = 0.4,
 attackPoint = 0.33,
 attackBackswing = 0.2},
 
 npc_dota_visage_familiar3 = {
 attackRate = 0.4,
 attackPoint = 0.33,
 attackBackswing = 0.2},
 
}
