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

CDOTA_Unit_Hero_AntiMage = {
 attackRate = 1.45,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.6},

CDOTA_Unit_Hero_Axe = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 290,
 turnRate = 0.6,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Bane = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 400,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.6,
 attackBackswing = 0.7},

CDOTA_Unit_Hero_Bloodseeker = {
 attackRate = 1.7,
 attackPoint = 0.43,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.5,
 attackBackswing = 0.74},

CDOTA_Unit_Hero_CrystalMaiden = {
 attackRate = 1.7,
 attackPoint = 0.55,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 280,
 turnRate = 0.5,
 attackBackswing = 0},

CDOTA_Unit_Hero_DrowRanger = {
 attackRate = 1.7,
 attackPoint = 0.7,
 attackRange = 625,
 projectileSpeed = 1250,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Earthshaker = {
 attackRate = 1.7,
 attackPoint = 0.467,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.863},

CDOTA_Unit_Hero_Juggernaut = {
 attackRate = 1.6,
 attackPoint = 0.33,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.6,
 attackBackswing = 0.84},

CDOTA_Unit_Hero_Mirana = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 300,
 turnRate = 0.4,
 attackBackswing = 0.7},

CDOTA_Unit_Hero_Nevermore = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 500,
 projectileSpeed = 1200,
 movementSpeed = 305,
 turnRate = 1.0,
 attackBackswing = 0.54},

CDOTA_Unit_Hero_Morphling = {
 attackRate = 1.6,
 attackPoint = 0.5,
 attackRange = 350,
 projectileSpeed = 1300,
 movementSpeed = 285,
 turnRate = 0.6,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_PhantomLancer = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 290,
 turnRate = 0.6,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Puck = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 550,
 projectileSpeed = 900,
 movementSpeed = 295,
 turnRate = 0.4,
 attackBackswing = 0.8},

CDOTA_Unit_Hero_Pudge = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 285,
 turnRate = 0.5,
 attackBackswing = 1.17},

CDOTA_Unit_Hero_Razor = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 475,
 projectileSpeed = 2000,
 movementSpeed = 295,
 turnRate = 0.4,
 attackBackswing = 0.7},

CDOTA_Unit_Hero_SandKing = {
 attackRate = 1.7,
 attackPoint = 0.53,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.47},

CDOTA_Unit_Hero_StormSpirit = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 480,
 projectileSpeed = 1100,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Sven = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Tiny = {
 attackRate = 1.7,
 attackPoint = 0.49,
 attackRange = 128,
 movementSpeed = 285,
 turnRate = 0.5,
 attackBackswing = 1},

CDOTA_Unit_Hero_VengefulSpirit = {
 attackRate = 1.7,
 attackPoint = 0.33,
 attackRange = 400,
 projectileSpeed = 1500,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.64},

CDOTA_Unit_Hero_Windrunner = {
 attackRate = 1.5,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1250,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Zuus = {
 attackRate = 1.7,
 attackPoint = 0.633,
 attackRange = 350,
 projectileSpeed = 1100,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.366},

CDOTA_Unit_Hero_EarthSpirit = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.6,
 attackBackswing = 0.65},
 
CDOTA_Unit_Hero_Legion_Commander = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 128,
 movementSpeed = 320,
 turnRate = 0.5,
 attackBackswing = 0.64},

CDOTA_Unit_Hero_EmberSpirit = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Terrorblade = {
 attackRate = 1.5,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.6},

CDOTA_Unit_Hero_Kunkka = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Lina = {
 attackRate = 1.7,
 attackPoint = 0.75,
 attackRange = 635,
 projectileSpeed = 900,
 movementSpeed = 295,
 turnRate = 0.5,
 attackBackswing = 0.78},

CDOTA_Unit_Hero_Phoenix = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 500,
 projectileSpeed = 1100,
 movementSpeed = 285,
 turnRate = 1.0,
 attackBackswing = 0.633},

CDOTA_Unit_Hero_Lich = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 550,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.54},

CDOTA_Unit_Hero_Lion = {
 attackRate = 1.7,
 attackPoint = 0.43,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.74},

CDOTA_Unit_Hero_ShadowShaman = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 500,
 projectileSpeed = 900,
 movementSpeed = 285,
 turnRate = 0.4,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Slardar = {
 attackRate = 1.7,
 attackPoint = 0.36,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.64},

CDOTA_Unit_Hero_Tidehunter = {
 attackRate = 1.7,
 attackPoint = 0.6,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.4,
 attackBackswing = 0.56},

CDOTA_Unit_Hero_WitchDoctor = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1200,
 movementSpeed = 305,
 turnRate = 0.4,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Riki = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Enigma = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 500,
 projectileSpeed = 900,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.77},

CDOTA_Unit_Hero_Tinker = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 500,
 projectileSpeed = 900,
 movementSpeed = 305,
 turnRate = 0.6,
 attackBackswing = 0.65},

CDOTA_Unit_Hero_Sniper = {
 attackRate = 1.7,
 attackPoint = 0.17,
 attackRange = 550,
 projectileSpeed = 3000,
 movementSpeed = 290,
 turnRate = 0.6,
 attackBackswing = 0.7},

CDOTA_Unit_Hero_Necrolyte = {
 attackRate = 1.7,
 attackPoint = 0.53,
 attackRange = 550,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.77},

CDOTA_Unit_Hero_Warlock = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 1200,
 movementSpeed = 295,
 turnRate = 0.4,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Beastmaster = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.4,
 attackBackswing = 0.7},

CDOTA_Unit_Hero_QueenOfPain = {
 attackRate = 1.7,
 attackPoint = 0.56,
 attackRange = 550,
 projectileSpeed = 1500,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.41},

CDOTA_Unit_Hero_Venomancer = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 450,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 0.4,
 attackBackswing = 0.7},
 
CDOTA_Unit_Hero_FacelessVoid = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.56},

CDOTA_Unit_Hero_SkeletonKing = {
 attackRate = 1.7,
 attackPoint = 0.56,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.4,
 attackBackswing = 0.44},

CDOTA_Unit_Hero_DeathProphet = {
 attackRate = 1.7,
 attackPoint = 0.56,
 attackRange = 600,
 projectileSpeed = 1000,
 movementSpeed = 280,
 turnRate = 0.5,
 attackBackswing = 0.51},

CDOTA_Unit_Hero_PhantomAssassin = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.4,
 attackBackswing = 0.7},

CDOTA_Unit_Hero_Pugna = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 320,
 turnRate = 0.5,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_TemplarAssassin = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 140,
 projectileSpeed = 900,
 movementSpeed = 305,
 turnRate = 0.7,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Viper = {
 attackRate = 1.7,
 attackPoint = 0.33,
 attackRange = 575,
 projectileSpeed = 1200,
 movementSpeed = 285,
 turnRate = 0.4,
 attackBackswing = 1},

CDOTA_Unit_Hero_Luna = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 330,
 projectileSpeed = 900,
 movementSpeed = 330,
 turnRate = 0.4,
 attackBackswing = 0.46},

CDOTA_Unit_Hero_DragonKnight = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 0.4,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Dazzle = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 500,
 projectileSpeed = 1200,
 movementSpeed = 305,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Rattletrap = {
 attackRate = 1.7,
 attackPoint = 0.33,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.6,
 attackBackswing = 0.64},

CDOTA_Unit_Hero_Leshrac = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.77},

CDOTA_Unit_Hero_Furion = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1125,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.77},

CDOTA_Unit_Hero_Life_Stealer = {
 attackRate = 1.7,
 attackPoint = 0.39,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 1.0,
 attackBackswing = 0.44},

CDOTA_Unit_Hero_DarkSeer = {
 attackRate = 1.7,
 attackPoint = 0.59,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.58},

CDOTA_Unit_Hero_Clinkz = {
 attackRate = 1.7,
 attackPoint = 0.7,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 300,
 turnRate = 0.4,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Omniknight = {
 attackRate = 1.7,
 attackPoint = 0.433,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.6,
 attackBackswing = 0.567},

CDOTA_Unit_Hero_Enchantress = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 550,
 projectileSpeed = 900,
 movementSpeed = 310,
 turnRate = 0.4,
 attackBackswing = 0.7},

CDOTA_Unit_Hero_Huskar = {
 attackRate = 1.6,
 attackPoint = 0.4,
 attackRange = 400,
 projectileSpeed = 1400,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_NightStalker = {
 attackRate = 1.7,
 attackPoint = 0.55,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.5,
 attackBackswing = 0.56},

CDOTA_Unit_Hero_Broodmother = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.5,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_BountyHunter = {
 attackRate = 1.7,
 attackPoint = 0.59,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.6,
 attackBackswing = 0.59},

CDOTA_Unit_Hero_Weaver = {
 attackRate = 1.7,
 attackPoint = 0.64,
 attackRange = 425,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.36},

CDOTA_Unit_Hero_Jakiro = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 400,
 projectileSpeed = 1100,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Batrider = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 375,
 projectileSpeed = 900,
 movementSpeed = 290,
 turnRate = 1.0,
 attackBackswing = 0.54},

CDOTA_Unit_Hero_Chen = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 600,
 projectileSpeed = 1100,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Spectre = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.4,
 attackBackswing = 0.7},

CDOTA_Unit_Hero_DoomBringer = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 150,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.7},

CDOTA_Unit_Hero_AncientApparition = {
 attackRate = 1.7,
 attackPoint = 0.45,
 attackRange = 600,
 projectileSpeed = 1250,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Ursa = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.5,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_SpiritBreaker = {
 attackRate = 1.7,
 attackPoint = 0.6,
 attackRange = 128,
 movementSpeed = 290,
 turnRate = 0.4,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Gyrocopter = {
 attackRate = 1.7,
 attackPoint = 0.2,
 attackRange = 375,
 projectileSpeed = 3000,
 movementSpeed = 315,
 turnRate = 0.6,
 attackBackswing = 0.97},

CDOTA_Unit_Hero_Alchemist = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.65},

CDOTA_Unit_Hero_Invoker = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 280,
 turnRate = 0.5,
 attackBackswing = 0.7},

CDOTA_Unit_Hero_Silencer = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 600,
 projectileSpeed = 1000,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Obsidian_Destroyer = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 450,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.54},

CDOTA_Unit_Hero_Lycan = {
 attackRate = 1.7,
 attackPoint = 0.55,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.5,
 attackBackswing = 0.55},

CDOTA_Unit_Hero_Brewmaster = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.65},

CDOTA_Unit_Hero_Shadow_Demon = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 500,
 projectileSpeed = 900,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_LoneDruid = {
 attackRate = 1.7,
 attackPoint = 0.33,
 attackRange = 550,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.53},

CDOTA_Unit_Hero_ChaosKnight = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 325,
 turnRate = 0.5,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Meepo = {
 attackRate = 1.7,
 attackPoint = 0.38,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.5,
 attackBackswing = 0.6},

CDOTA_Unit_Hero_Treant = {
 attackRate = 1.9,
 attackPoint = 0.6,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.4},

CDOTA_Unit_Hero_Ogre_Magi = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Undying = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.6,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Rubick = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1125,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.77},

CDOTA_Unit_Hero_Disruptor = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1200,
 movementSpeed = 300,
 turnRate = 0.6,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_Nyx_Assassin = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.54},

CDOTA_Unit_Hero_Naga_Siren = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 320,
 turnRate = 0.5,
 attackBackswing = 0.5},

CDOTA_Unit_Hero_KeeperOfTheLight = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.85},

CDOTA_Unit_Hero_Wisp = {
 attackRate = 1.7,
 attackPoint = 0.15,
 attackRange = 575,
 projectileSpeed = 1200,
 movementSpeed = 295,
 turnRate = 0.7,
 attackBackswing = 0.4},

CDOTA_Unit_Hero_Visage = {
 attackRate = 1.7,
 attackPoint = 0.46,
 attackRange = 600,
 projectileSpeed = 900,
 movementSpeed = 295,
 turnRate = 0.5,
 attackBackswing = 0.54},

CDOTA_Unit_Hero_Slark = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.5,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Medusa = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 600,
 projectileSpeed = 1200,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.6},

CDOTA_Unit_Hero_TrollWarlord = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 500,
 projectileSpeed = 1200,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Centaur = {
 attackRate = 1.7,
 attackPoint = 0.3,
 attackRange = 128,
 movementSpeed = 300,
 turnRate = 0.5,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Magnataur = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.84},

CDOTA_Unit_Hero_Shredder = {
 attackRate = 1.7,
 attackPoint = 0.36,
 attackRange = 128,
 movementSpeed = 290,
 turnRate = 0.5,
 attackBackswing = 0.64},

CDOTA_Unit_Hero_Bristleback = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 295,
 turnRate = 1.0,
 attackBackswing = 0.3},

CDOTA_Unit_Hero_Tusk = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 128,
 movementSpeed = 305,
 turnRate = 0.5,
 attackBackswing = 0.64},

CDOTA_Unit_Hero_Skywrath_Mage = {
 attackRate = 1.7,
 attackPoint = 0.4,
 attackRange = 600,
 projectileSpeed = 1000,
 movementSpeed = 315,
 turnRate = 0.5,
 attackBackswing = 0.78},

CDOTA_Unit_Hero_Elder_Titan = {
 attackRate = 1.7,
 attackPoint = 0.35,
 attackRange = 128,
 movementSpeed = 315,
 turnRate = 0.4,
 attackBackswing = 0.97},

CDOTA_Unit_Hero_Abaddon = {
 attackRate = 1.7,
 attackPoint = 0.56,
 attackRange = 128,
 movementSpeed = 310,
 turnRate = 0.5,
 attackBackswing = 0.41},
 
 CDOTA_Unit_Hero_Techies = {
 attackRate = 1.7,
 attackPoint = 0.5,
 attackRange = 700,
 projectileSpeed = 900,
 movementSpeed = 270,
 turnRate = 0.5,
 attackBackswing = 0.5},
 
 CDOTA_Unit_Hero_Oracle = {
 attackRate = 1.4,
 attackPoint = 0.3,
 attackRange = 620,
 projectileSpeed = 900,
 movementSpeed = 305,
 turnRate = 0.4,
 attackBackswing = 0.7},
 
 CDOTA_Unit_Hero_Winter_Wyvern = {
 attackRate = 1.7,
 attackPoint = 0.25,
 attackRange = 620,
 projectileSpeed = 700,
 movementSpeed = 305,
 turnRate = 0.4,
 attackBackswing = 0.8},
 
 CDOTA_Unit_SpiritBear = {{
 attackRate = 1.75,
 attackPoint = 0.43,
 attackRange = 620,
 attackBackswing = 0.67},{
 attackRate = 1.65,
 attackPoint = 0.43,
 attackRange = 620,
 attackBackswing = 0.67},{
 attackRate = 1.55,
 attackPoint = 0.43,
 attackRange = 620,
 attackBackswing = 0.67},{
 attackRate = 1.45,
 attackPoint = 0.43,
 attackRange = 620,
 attackBackswing = 0.67}},
 
 CDOTA_BaseNPC_Creep_Lane = {{
 attackRate = 1,
 attackPoint = 0.467,
 attackRange = 100,
 attackBackswing = 0.633},{
 attackRate = 1,
 attackPoint = 0.5,
 attackRange = 500,
 projectileSpeed = 900,
 attackBackswing = 0.5}},
 
 CDOTA_BaseNPC_Creep_Siege = {
 attackRate = 2.7,
 attackPoint = 0.7,
 attackRange = 690,
 projectileSpeed = 1100,
 attackBackswing = 0.3},
 
CDOTA_BaseNPC_Venomancer_PlagueWard = {{
 attackRate = 1.5,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 1900,
 attackBackswing = 0.7},{
 attackRate = 1.5,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 1900,
 attackBackswing = 0.7},{
 attackRate = 1.5,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 1900,
 attackBackswing = 0.7},{
 attackRate = 1.5,
 attackPoint = 0.3,
 attackRange = 600,
 projectileSpeed = 1900,
 attackBackswing = 0.7}},
 
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
 
CDOTA_BaseNPC_Invoker_Forged_Spirit = {
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
 
 }
