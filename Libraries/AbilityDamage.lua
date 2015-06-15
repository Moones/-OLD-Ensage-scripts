require("libs.Utils")
require("libs.Animations2")
--[[
                             ___
                            ( ((
                             ) ))              
  .::.ABILITY DAMAGE LIBRARY/ /( MADE BY MOONES      
 'M .-;-.-.-.-.-.-.-.-.-.-/| ((:::::::::::::::::::::::::::::::::::::::::::::.._
(O ( ( ( ( ( ( ( ( ( ( ( ( |  ))   -============VERSION 0.2============-      _.>
 `M `-;-`-`-`-`-`-`-`-`-`-\| ((::::::::::::::::::::::::::::::::::::::::::::::''
  `::'                      \ \(
        Description:         ) ))
        ------------        (_((                           
		 
         - This library stores damage of all abilities
		 
        Usage:
        ------
        
         AbilityDamage.GetDamage(ability) - Returns full damage of given ability. 
		 
        Changelog:
        ----------
		
		v0.2 - Added temporary table to access damage easily
		
		v0.1 - BETA Release
		
]]--

--Tables with all informations we need to determine actual ability damage
AbilityDamage = {}

AbilityDamage.temporaryTable = {}

AbilityDamage.modifiersSpellList = {	
	modifier_alchemist_acid_spray = { npc = true; npcModifierName = "modifier_alchemist_acid_spray_thinker"; spellName = "alchemist_acid_spray"; AbilityDamage = "damage"; tickInterval = "tick_rate"; startTime = 0; duration = "duration"; };
	modifier_axe_battle_hunger = { spellName = "axe_battle_hunger"; tickInterval = 1; startTime = 1; duration = "duration"; };
	modifier_batrider_firefly = { spellName = "batrider_firefly"; AbilityDamage = "damage_per_second"; tickInterval = "tick_interval"; startTime = 0.1; duration = "duration"; trackbySpellCD = true; bonusDmgModifier = "modifier_batrider_sticky_napalm"; bonusDmgModifierSpellname = "batrider_sticky_napalm"; bonusDmgModifierDamage = "damage";};
	modifier_brewmaster_fire_permanent_immolation_aura = { spellName = "brewmaster_fire_permanent_immolation"; AbilityDamage = "damage"; spellOwner = CDOTA_Unit_Brewmaster_PrimalFire; tickInterval = 1; startTime = 1; };
	modifier_broodmother_poison_sting_dps_debuff = { spellName = "broodmother_poison_sting"; AbilityDamage = "damage_per_second"; tickInterval = 1; startTime = 1; };	
	modifier_cold_feet = { spellName = "ancient_apparition_cold_feet"; AbilityDamage = "damage"; tickInterval = {0.8,0.8,0.9,0.9}; startTime = 0.8; };
	modifier_crystal_maiden_frostbite = { spellName = "crystal_maiden_frostbite"; AbilityDamage = "damage_per_second_tooltip"; tickInterval = 0.5; startTime = 0; duration = "duration"; };
	modifier_cyclone = { AbilityDamage = 50; startTime = 2.5; };
	--<<ONE DAY IM GONNA FINISH THIS>>
}

AbilityDamage.attackModifiersList = {
	antimage_mana_break = { damage = "mana_per_hit"; damageMultiplier = 0.6; manaBurn = true; };
	--venomancer_poison_sting = { tickDamage = "damage"; tickDuration = "duration"; tickInterval = 1; startTime = 0; tick = true; };
	viper_poison_attack = { tickDamage = "damage"; tickDuration = "duration"; tickInterval = 1; startTime = 1; };
	clinkz_searing_arrows = { damage = "damage_bonus"; };
	enchantress_impetus = { damage = "distance_damage_pct"; };
	huskar_burning_spear = { tickDuration = 8; startTime = 1; tickInterval = 1; tick = true; };
	weaver_geminate_attack = { damageMultiplier = 2; cooldown = true; };
	jakiro_liquid_fire = { tickDamage = "damage"; tickInterval = 1; startTime = 0.5; tickDuration = 5; cooldown = true; };
	spectre_desolate = { damage = "bonus_damage"; special = true; };
	silencer_glaives_of_wisdom = { IntToDamage = "intellect_damage_pct"; special = true; };
	obsidian_destroyer_arcane_orb = { manaPercentDamage = "mana_pool_damage_pct"; special = true; };
	--brewmaster_drunken_brawler = { damageMultiplier = "crit_multiplier"; };
	tusk_walrus_punch = { damageMultiplier = "crit_multiplier"; cooldown = true; };
	kunkka_tidebringer = { damageBonus = "damage_bonus"; };
}

--Spells not listed here returns damage from LuaEntityAbility:GetDamage(ability.level)
AbilityDamage.spellList = {
	antimage_mana_void = { damage = "mana_void_damage_per_mana"; };
	axe_battle_hunger = { tickInterval = 1; startTime = 1; tickDuration = "duration"; tick = true; };
	axe_culling_blade = { damage = "kill_threshold"; damageScepter = "kill_threshold_scepter"; };
	bane_fiends_grip = { tickDamage = "fiend_grip_damage"; tickDuration = "fiend_grip_duration"; tickInterval = "fiend_grip_tick_interval"; tickDamageScepter = "fiend_grip_damage_scepter"; tickDurationScepter = "fiend_grip_duration_scepter"; startTime = 0; tick = true; };
	bloodseeker_blood_bath = { damage = "damage"; };
	earthshaker_enchant_totem = { damageMultiplier = "totem_damage_percentage"; };
	earthshaker_echo_slam = { damage = "echo_slam_echo_damage"; range = "echo_slam_echo_range"; };
	juggernaut_blade_fury = { duration = 5; tick = true; };
	juggernaut_omni_slash = { damage = 200; damageMultiplier = "omni_slash_jumps"; damageMultiplierScepter = "omni_slash_jumps_scepter"; };
	lina_laguna_blade = { damage = "damage"; typeScepter = DAMAGE_TYPE_PURE; };
	lion_finger_of_death = { damage = "damage"; damageScepter = "damage_scepter"; };
	mirana_arrow = { maxDamageRange = "arrow_max_stunrange";  maxBonusDamage = "arrow_bonus_damage"; };
	mirana_starfall = { maxDamageRadius = "starfall_secondary_radius"; };
	morphling_adaptive_strike = { damage = "damage_base"; maxDamage = "damage_max"; minDamage = "damage_min"; };
	puck_dream_coil = { damage = "coil_init_damage_tooltip"; };
	pudge_dismember = { tickDamage = "dismember_damage"; damageScepterMultiplierStrenght = "strength_damage_scepter"; tickDuration = 3; startTime = 1; tickInterval = 1; tick = true;};
	shadow_shaman_ether_shock = { damage = "damage"; };
	shadow_shaman_shackles = { damage = "total_damage"; };
	shadow_shaman_mass_serpent_ward = { damage = "damage_min"; damageScepter = "damage_min_scepter"; damageMultiplier = "ward_count"; };
	razor_plasma_field = { minDamage = "damage_min"; maxDamage = "damage_max"; range = "radius"; };
	skeleton_king_hellfire_blast = { tickDuration = "blast_dot_duration"; tickDamage = "blast_dot_damage"; tick = true; };
	storm_spirit_static_remnant = { damage = "static_remnant_damage"; };
	sandking_epicenter = { damage = "epicenter_damage"; damageMultiplier = "epicenter_pulses";  damageMultiplierScepter = "epicenter_pulses_scepter"; };
	tiny_toss = { damage = "toss_damage"; };
	--zuus_static_field = { damage = "damage_health_pct"; };
	zuus_thundergods_wrath = { damage = "damage"; damageScepter = "damage_scepter"; };
	crystal_maiden_frostbite = { damage = "hero_damage_tooltip"; };--tickDamage = "damage_per_second_tooltip"; tickDuration = "duration"; tick = true; tickInterval = 0.5; startTime = 0; };
	crystal_maiden_freezing_field = { damage = "damage"; damageScepter = "damage_scepter"; };
	lich_chain_frost = { damage = "damage"; damageScepter = "damage_scepter"; };
	riki_blink_strike = { damage = "bonus_damage"; };
	riki_backstab = { damage = "damage_multiplier"; };
	enigma_malefice = { damage = "damage"; damageMultiplier = 3; };
	necrolyte_reapers_scythe = { damage = "damage_per_health"; damageScepter = "damage_per_health_scepter"; };
	warlock_shadow_word = { tickDuration = "duration"; tickInterval = "tick_interval"; startTime = 1; tick = true; };
	beastmaster_primal_roar = { damage = "damage"; };
	beastmaster_wild_axes = { damageMultiplier = 2; };
	queenofpain_shadow_strike = { damage = "strike_damage"; tickDamage = "duration_damage"; tickInterval = 3; startTime = 3; tickDuration = 15; };
	queenofpain_sonic_wave = { damage = "damage"; damageScepter = "damage_scepter"; };
	venomancer_venomous_gale = { damage = "strike_damage"; tickDuration = "duration"; tickDamage = "tick_damage"; tickInterval = "tick_interval"; startTime = 3; tick = true; };
	venomancer_poison_nova = { tickDamage = "damage"; tickDuration = "duration"; tickDamageScepter = "damage_scepter"; tickDurationScepter = "duration_scepter"; tickInterval = 1; startTime = 0; tick = true; };
	venomancer_plague_ward = { damage = "ward_damage_tooltip"; }; -- We register atleast one attack from ward.
	templar_assassin_meld = { damage = "bonus_damage"; };
	viper_viper_strike = { tickDamage = "damage"; tickDuration = "duration"; tickInterval = 1; startTime = 1; };
	luna_eclipse = { damageSpell = "luna_lucent_beam"; damageMultiplier = "hit_count"; damageMultiplierScepter = "hit_count_scepter"; };
	dazzle_poison_touch = { startTime = "set_time"; tickInterval = 1; tickDuration = 10; tick = true; };
	rattletrap_battery_assault = { tickDuration = "duration"; tickInterval = "interval"; startTime = 0; tick = true; };
	rattletrap_hookshot = { damage = "damage"; };
	leshrac_diabolic_edict = { tickDuration = 8; tickInterval = 0.25; startTime = 0; };
	leshrac_pulse_nova = { tickDamage = "damage"; tickDamageScepter = "damage_scepter"; tickInterval = 1; startTime = 0; tick = true; };
	furion_wrath_of_nature = { damage = "damage"; damageScepter = "damage_scepter"; };
	life_stealer_infest = { damage = "damage"; };
	dark_seer_vacuum = { damage = "damage"; };
	dark_seer_ion_shell = { tickDamage = "damage_per_second"; tickDuration = "duration"; tickInterval = 1; startTime = 0.1; tick = true; };
	dark_seer_wall_of_replica = { damage = "damage"; };
	omniknight_purification = { damage = "heal"; };
	huskar_life_break = { damage = "health_damage"; damageScepter = "health_damage_scepter"; };
	broodmother_spawn_spiderlings = { damage = "damage"; };
	bounty_hunter_shuriken_toss = { damage = "bonus_damage"; };
	bounty_hunter_wind_walk = { bonusDamage = "bonus_damage"; heroDamage = true; };
	weaver_shukuchi = { damage = "damage"; };
	jakiro_dual_breath = { tickDamage = "burn_damage"; tickDuration = "tooltip_duration"; tickInterval = 0.5; startTime = 0.5; tickDuration = 5; tick = true; };
	jakiro_ice_path = { damage = "damage"; };
	jakiro_macropyre = { tickDamage = "damage"; tickDuration = "duration"; tickInterval = 1; tickDamageScepter = "damage_scepter"; tickDurationScepter = "duration_scepter"; startTime = 0.5; tick = true;  };
	batrider_flamebreak = { damage = "damage"; };
	batrider_sticky_napalm = { damage = "damage"; };
	chen_test_of_faith = { maxDamage = "damage_max"; minDamage = "damage_min"; };
	spectre_spectral_dagger = { damage = "damage"; };
	doom_bringer_scorched_earth = { tickDamage = "damage_per_second"; tickDuration = "duration";  tickInterval = 1; startTime = 1; tick = true; };
	doom_bringer_lvl_death = { damage = "damage"; };
	doom_bringer_doom = { tickDamage = "damage"; tickDuration = "duration"; tickDamageScepter = "damage_scepter"; tickDurationScepter = "duration_scepter"; tickInterval = 1; startTime = 0; tick = true; };
	ancient_apparition_cold_feet = { tickDamage = "damage"; tickInterval = {0.8,0.8,0.9,0.9}; startTime = 0.8; tick = true; tickDuration = 4; };
	ancient_apparition_ice_blast = { tickDuration = "frostbite_duration"; tickDamage = "dot_damage"; bonusDamagePercent = "kill_pct"; tickDurationScepter = "frostbite_duration_scepter"; startTime = 1; tickInterval = 1; tick = true; };
	spirit_breaker_charge_of_darkness = { damageSpell = "spirit_breaker_greater_bash"; damageSpellName = "damage"; };
	spirit_breaker_nether_strike = { damage = "damage"; damageSpell = "spirit_breaker_greater_bash"; damageSpellName = "damage"; };
	gyrocopter_rocket_barrage = { tickInterval = 0.1; startTime = 0.1; tickDuration = 3; tick = true; };
	gyrocopter_homing_missile = { maxDamageRange = "max_distance"; minBonusDamage = "min_damage"; };
	gyrocopter_call_down = { damage = "damage_first"; bonusDamage = "damage_second"; bonusDamageScepter = "damage_second_scepter"; };
	alchemist_unstable_concoction = { damage = "max_damage"; };
	alchemist_unstable_concoction_throw = { damageSpell = "alchemist_unstable_concoction"; damageSpellName = "max_damage"; };
	invoker_cold_snap = { damage = "damage_trigger"; tickDamage = "freeze_damage"; tickInterval = "freeze_cooldown"; tickDuration = "duration"; startTime = 0; spellLevel = "invoker_quas"; tick = true; };
	invoker_tornado = { damage = "base_damage"; bonusDamage = "wex_damage"; spellLevel = "invoker_wex"; };
	invoker_emp = { damage = "mana_burned"; damageMultiplier = 0.5; spellLevel = "invoker_wex"; manaBurn = true; };
	invoker_chaos_meteor = { tickInterval = "damage_interval"; tickDuration = 2.1; tickDamage = "main_damage"; bonusDamage = "burn_dps"; startTime = 0; bonusDamageMultiplier = 3; spellLevel = "invoker_exort"; tick = true; };
	invoker_sun_strike = { damage = "damage"; spellLevel = "invoker_exort"; };
	invoker_forge_spirit = { damage = "spirit_damage"; spellLevel = "invoker_exort"; };
	invoker_ice_wall = { tickDuration = "duration"; tickDamage = "damage_per_second"; tickInterval = 1; startTime = 1; spellLevel = "invoker_exort"; durationspellLevel = "invoker_quas"; tick = true; };
	invoker_deafening_blast = { damage = "damage"; spellLevel = "invoker_exort"; };
	silencer_curse_of_the_silent = { tickDamage = "health_damage"; tickDuration = "tooltip_duration"; tickInterval = 1; startTime = 1; tick = true; };
	silencer_last_word = { damage = "damage"; };
	silencer_global_silence = { spellName = "silencer_curse_of_the_silent"; tickDamage = "health_damage"; tickDuration = "tooltip_duration"; tickInterval = 1; startTime = 1; tick = true; };
	obsidian_destroyer_sanity_eclipse = { damageMultiplier = "damage_multiplier"; differenceTreshold = "int_threshold"; damageMultiplierScepter = "damage_multiplier_scepter"; };
	lycan_summon_wolves = { damage = "wolf_damage"; damageMultiplier = 2; };
	brewmaster_thunder_clap = { damage = "damage"; };
	chaos_knight_chaos_bolt = { minDamage = "damage_min"; maxDamage = "damage_max"; };
	chaos_knight_reality_rift = { damage = "bonus_damage"; };
	meepo_poof = { damageMultiplier = 2; };
	treant_leech_seed = { tickDamage = "leech_damage"; tickInterval = "damage_interval"; startTime = "damage_interval"; tickDuration = "duration"; tick = true;};
	ogre_magi_ignite = { tickDamage = "burn_damage"; tickDuration = "duration"; tickInterval = 1; startTime = 1; tick = true; };
	undying_decay = { damage = "decay_damage"; bonusDamage = 76; };
	undying_soul_rip = { damagePerUnit = "damage_per_unit"; maxUnits = "max_units"; range = "radius"; };
	rubick_fade_bolt = { damage = "damage"; };
	disruptor_thunder_strike = { tickCount = "strikes"; tick = true; };
	disruptor_static_storm = { tickDuration = "duration"; tickDamage = "damage_max"; tickDurationScepter = "duration_scepter"; tickDamageScepter = {280,350,420}; tickInterval = 1; startTime = 0.25; tick = true; };
	nyx_assassin_mana_burn = { damage = "float_multiplier"; manaBurn = true; };
	nyx_assassin_vendetta = { damage = "bonus_damage"; modifier = true; };
	keeper_of_the_light_illuminate = { tickDamage = "damage_per_second"; tickDuration = "max_channel_time"; tickInterval = 1; startTime = 1; tick = true; };
	visage_soul_assumption = { damage = "soul_base_damage"; bonusDamage = "soul_charge_damage"; charges = true; chargesModifier = "modifier_visage_soul_assumption"; };
	wisp_spirits = { damage = "hero_damage"; damageMultiplier = 5; };
	slark_dark_pact = { damage = "total_damage"; };
	slark_pounce = { damage = "pounce_damage"; }; 
	medusa_mystic_snake = { damage = "snake_damage"; };
	troll_warlord_whirling_axes_ranged = { damage = "axe_damage"; };
	troll_warlord_whirling_axes_melee = { damage = "damage"; };
	centaur_hoof_stomp = { damage = "stomp_damage"; };
	centaur_double_edge = { damage = "edge_damage"; };
	centaur_stampede = { damageStrenghtMultiplier = "strength_damage"; };
	magnataur_shockwave = { damage = "shock_damage"; };
	magnataur_skewer = { damage = "skewer_damage"; };
	magnataur_reverse_polarity = { damage = "polarity_damage"; };
	shredder_whirling_death = { damage = "whirling_damage"; };
	shredder_timber_chain = { damage = "damage"; };
	shredder_chakram = { damage = "pass_damage"; damageMultiplier = 2; };
	shredder_chakram_2 = { damage = "pass_damage"; damageMultiplier = 2; };
	bristleback_quill_spray = { damage = "quill_base_damage"; stacks = true; stack_damage = "quill_stack_damage"; maxDamage = "max_damage"; };
	tusk_ice_shards = { damage = "shard_damage"; };
	tusk_snowball = { damage = "snowball_damage"; }; 
	skywrath_mage_arcane_bolt = { damage = "bolt_damage"; IntToDamageMultiplier = "int_multiplier"; };
	skywrath_mage_concussive_shot = { damage = "damage"; };
	skywrath_mage_mystic_flare = { damage = "damage"; };
	abaddon_death_coil = { damage = "target_damage"; };
	abaddon_aphotic_shield = { damage = "damage_absorb"; };
	elder_titan_echo_stomp = { damage = "stomp_damage"; };
	elder_titan_ancestral_spirit = { damage = "pass_damage"; };
	elder_titan_earth_splitter = { damageHealthMultiplier = "damage_pct"; };
	legion_commander_overwhelming_odds = { damage = "damage"; bonusDamageUnit = "damage_per_unit"; bonusDamageHero = "damage_per_hero"; };
	legion_commander_duel = { duration = "duration"; heroDamage = true; };
	ember_spirit_searing_chains = { damage = "total_damage_tooltip"; };
	ember_spirit_sleight_of_fist = { bonusDamage = "bonus_hero_damage"; heroDamage = true; };
	ember_spirit_flame_guard = { tickDamage = "damage_per_second"; tickDuration = "duration"; tickInterval = 1; startTime = 0.2; tick = true; };
	ember_spirit_activate_fire_remnant = { damage = "damage"; };
	earth_spirit_boulder_smash = { damage = "rock_damage"; };
	earth_spirit_rolling_boulder = { damage = "rock_damage"; };
	earth_spirit_geomagnetic_grip = { damage = "rock_damage"; };
	earth_spirit_petrify = { damage = "damage"; };
	earth_spirit_magnetize = {};
	oracle_fortunes_end = { damage = "damage"; };
	oracle_purifying_flames = { damage = "damage"; };	
	phoenix_sun_ray = { tickDamage = "base_dmg"; tickDuration = "tooltip_duration"; tickInterval = 0.2; startTime = 0.2; tick = true; };
	bounty_hunter_jinada = { damageMultiplier = "crit_multiplier"; heroDamage = true; };
	--finished !?
}

AbilityDamage.itemList = {
	item_dagon = { damage = "damage"; level = 1; type = DAMAGE_MAGC; };
	item_dagon_2 = { damage = "damage"; level = 2; type = DAMAGE_MAGC; };
	item_dagon_3 = { damage = "damage"; level = 3; type = DAMAGE_MAGC; };
	item_dagon_4 = { damage = "damage"; level = 4; type = DAMAGE_MAGC; };
	item_dagon_5 = { damage = "damage"; level = 5; type = DAMAGE_MAGC; };
	item_urn_of_shadows = { damage = "soul_damage_amount"; type = DAMAGE_PURE; };
	item_ethereal_blade = { damage = "blast_damage_base"; mult = "blast_agility_multiplier"; type = DAMAGE_MAGC; };
}

function AbilityDamage.CalculateDamage(ability, hpRegen)
	local AbilityDamagetemporaryTable = AbilityDamage.temporaryTable
	local AbilityDamagespellList = AbilityDamage.spellList
	local AbilityDamageitemList = AbilityDamage.itemList
	local AbilityDamageattackModifiersList = AbilityDamage.attackModifiersList
	local spell = AbilityDamagespellList[ability.name]
	local owner = ability.owner
	if ability.level <= 0 and (not spell or not spell.spellLevel or owner:FindSpell(spell.spellLevel).level <= 0) then return 0 end
	local item = AbilityDamageitemList[ability.name]
	local attack_modifier = AbilityDamageattackModifiersList[ability.name]
	local dmg = ability:GetDamage(ability.level)
	if spell then
		if spell.tick then
			local spellLevel = nil
			if spell.spellLevel then
				spellLevel = owner:FindSpell(spell.spellLevel).level
			end
			local level = spellLevel or ability.level
			local tickDuration
			if type(spell.tickDuration) == "table" then
				tickDuration = spell.tickDuration[level]
			elseif spell.durationspellLevel then
				tickDuration = ability:GetSpecialData(""..spell.tickDuration, owner:FindSpell(spell.durationspellLevel).level)
			else
				tickDuration = (((spell.tickDuration) and (ability:GetSpecialData(""..spell.tickDuration, level))) or spell.tickDuration)
			end
			local tickInterval
			if type(spell.tickInterval) == "table" then
				tickInterval = spell.tickInterval[level]
			else
				tickInterval = (((spell.tickInterval) and (ability:GetSpecialData(""..spell.tickInterval, level))) or spell.tickInterval)
			end
			local tickDamage = (((spell.tickDamage) and (ability:GetSpecialData(""..spell.tickDamage, level))) or dmg)
			local startTime = (((spell.startTime) and (ability:GetSpecialData(""..spell.startTime, level))) or spell.startTime)
			local tickCount = ((spell.tickCount) and (ability:GetSpecialData(""..spell.tickCount, level)))
			local damage = ((spell.damage) and (ability:GetSpecialData(""..spell.damage, level)))
			if not damage and tickDamage ~= dmg then
				damage = dmg
			end
			local bonusDamage = ((spell.bonusDamage) and (ability:GetSpecialData(""..spell.bonusDamage, level)))
			if owner:AghanimState() then
				tickDuration = (((spell.tickDurationScepter) and (ability:GetSpecialData(""..spell.tickDurationScepter, level))) or tickDuration)
				tickDamage = (((spell.tickDamageScepter) and (ability:GetSpecialData(""..spell.tickDamageScepter, level))) or tickDamage)
			end
			local finalDamage = 0
			if tickDuration and tickInterval and startTime then
				finalDamage = (((tickDuration - startTime)/tickInterval) or tickCount)*tickDamage
			elseif tickCount then
				finalDamage = tickCount*tickDamage
			end
			if damage then
				finalDamage = finalDamage + damage
			end
			if bonusDamage then
				finalDamage = finalDamage + bonusDamage
			end
			if hpRegen and tickDuration then
				finalDamage = finalDamage - (hpRegen*tickDuration)
			end
			
			return finalDamage
		elseif spell.manaBurn then
			if ability.name == "antimage_mana_void" then
				local Dmg = ability:GetSpecialData(""..spell.damage,ability.level)
				if not AbilityDamagetemporaryTable[ability.name] then
					AbilityDamage.temporaryTable[ability.name] = {}
					AbilityDamage.temporaryTable[ability.name][ability.level] = Dmg
				else
					AbilityDamage.temporaryTable[ability.name][ability.level] = Dmg
				end
				return Dmg
			elseif ability.name == "invoker_emp" then
				local Dmg = ability:GetSpecialData(""..spell.damage,owner:FindSpell(spell.spellLevel).level)
				if not AbilityDamagetemporaryTable[ability.name] then
					AbilityDamage.temporaryTable[ability.name] = {}
					AbilityDamage.temporaryTable[ability.name][owner:FindSpell(spell.spellLevel).level] = Dmg
				else
					AbilityDamage.temporaryTable[ability.name][owner:FindSpell(spell.spellLevel).level] = Dmg
				end
				return Dmg
			end
		else
			local spellLevel = nil
			if spell.spellLevel then
				spellLevel = owner:FindSpell(spell.spellLevel).level
			end
			local level = spellLevel or ability.level
			local damage = (((spell.damage) and (ability:GetSpecialData(""..spell.damage,level))) or dmg or spell.damage)
			if spell.heroDamage then
				damage = owner.dmgMin+owner.dmgBonus
			end
			if ability.name == "centaur_stampede" then
				damage = owner.strengthTotal*ability:GetSpecialData(""..spell.damageStrenghtMultiplier,level)
			end
			if ability.name == "legion_commander_duel" then
				local attackTime = (Animations.getBackswingTime(owner)+Animations.GetAttackTime(owner)) + client.latency/1000
				damage = damage*math.floor(ability:GetSpecialData("duration",level)/attackTime)
			end
			local damageMultiplier = (((spell.damageMultiplier) and (ability:GetSpecialData(""..spell.damageMultiplier, level))) or spell.damageMultiplier)
			local bonusDamage = (((spell.bonusDamage) and (ability:GetSpecialData(""..spell.bonusDamage,level))) or spell.bonusDamage)
			local bonusDamageMultiplier = (((spell.bonusDamageMultiplier) and (ability:GetSpecialData(""..spell.bonusDamageMultiplier, level))) or spell.bonusDamageMultiplier)
			if spell.damageSpell then
				local dmgSpell = owner:FindSpell(spell.damageSpell)
				if damage and type(damage) == "number" then
					damage = damage + (((spell.damageSpellName) and (dmgSpell:GetSpecialData(""..spell.damageSpellName,dmgSpell.level))) or dmgSpell:GetDamage(dmgSpell.level))
				else
					damage = (((spell.damageSpellName) and (dmgSpell:GetSpecialData(""..spell.damageSpellName,dmgSpell.level))) or dmgSpell:GetDamage(dmgSpell.level))
				end
			end		
			if owner:AghanimState() then
				damage = (((spell.damageScepter) and (ability:GetSpecialData(""..spell.damageScepter, level))) or damage)
				bonusDamage = (((spell.bonusDamageScepter) and (ability:GetSpecialData(""..spell.bonusDamageScepter, level))) or bonusDamage)
				damageMultiplier = (((spell.damageMultiplierScepter) and (ability:GetSpecialData(""..spell.damageMultiplierScepter, level))) or damageMultiplier)
			end
			if bonusDamageMultiplier then
				if bonusDamageMultiplier > 100 then 
					bonusDamageMultiplier = bonusDamageMultiplier/100
				end
				bonusDamage = bonusDamage*bonusDamageMultiplier
			end
			if damageMultiplier then
				if damageMultiplier > 100 then 
					damageMultiplier = damageMultiplier/100
				end
				damage = damage*damageMultiplier
			end
			if bonusDamage then
				damage = damage + bonusDamage
			end
			if not AbilityDamagetemporaryTable[ability.name] then
				AbilityDamage.temporaryTable[ability.name] = {}
				AbilityDamage.temporaryTable[ability.name][level] = damage
			else
				AbilityDamage.temporaryTable[ability.name][level] = damage
			end
			return damage
		end
	elseif attack_modifier then
		local spellLevel = nil
		spell = attack_modifier
		if spell.spellLevel then
			spellLevel = owner:FindSpell(spell.spellLevel).level
		end
		if spell.tick then
			local tickDuration = (((spell.tickDuration) and (ability:GetSpecialData(""..spell.tickDuration, ability.level))) or spell.tickDuration)
			local tickInterval
			if type(spell.tickInterval) == "table" then
				tickInterval = spell.tickInterval[ability.level]
			else
				tickInterval = (((spell.tickInterval) and (ability:GetSpecialData(""..spell.tickInterval, ability.level))) or spell.tickInterval)
			end
			local tickDamage = (((spell.tickDamage) and (ability:GetSpecialData(""..spell.tickDamage, ability.level))) or dmg)
			local startTime = (((spell.startTime) and (ability:GetSpecialData(""..spell.startTime, ability.level))) or spell.startTime)
			local tickCount = ((spell.tickCount) and (ability:GetSpecialData(""..spell.tickCount, ability.level)))
			local damage = ((spell.damage) and (ability:GetSpecialData(""..spell.damage, ability.level)))
			local bonusDamageMultiplier = (((spell.bonusDamageMultiplier) and (ability:GetSpecialData(""..spell.bonusDamageMultiplier, level))) or spell.bonusDamageMultiplier)
			if not damage and tickDamage ~= dmg then
				damage = dmg
			end
			local bonusDamage = ((spell.bonusDamage) and (ability:GetSpecialData(""..spell.bonusDamage, ability.level)))
			if owner:AghanimState() then
				tickDuration = (((spell.tickDurationScepter) and (ability:GetSpecialData(""..spell.tickDurationScepter, ability.level))) or tickDuration)
				tickDamage = (((spell.tickDamageScepter) and (ability:GetSpecialData(""..spell.tickDamageScepter, ability.level))) or tickDamage)
			end
			local finalDamage
			if tickDuration and tickInterval and startTime then
				finalDamage = (((tickDuration - startTime)/tickInterval) or tickCount)*tickDamage
			elseif tickCount then
				finalDamage = tickCount*tickDamage
			end
			if damage then
				finalDamage = finalDamage + damage
			end
			if bonusDamageMultiplier then
				if bonusDamageMultiplier > 100 then 
					bonusDamageMultiplier = bonusDamageMultiplier/100
				end
				bonusDamage = bonusDamage*bonusDamageMultiplier
			end
			if bonusDamage then
				finalDamage = finalDamage + bonusDamage
			end
			if hpRegen and tickDuration then
				finalDamage = finalDamage - (hpRegen*tickDuration)
			end
			if not AbilityDamagetemporaryTable[ability.name] then
				AbilityDamage.temporaryTable[ability.name] = {}
				AbilityDamage.temporaryTable[ability.name][level] = finalDamage
			else
				AbilityDamage.temporaryTable[ability.name][level] = finalDamage
			end
			return finalDamage
		else
			local level = spellLevel or ability.level
			local damage = (((spell.damage) and (ability:GetSpecialData(""..spell.damage,level))) or spell.damage or owner.dmgMin)
			local damageMultiplier = (((spell.damageMultiplier) and (ability:GetSpecialData(""..spell.damageMultiplier, level))) or spell.damageMultiplier)
			local bonusDamage = (((spell.bonusDamage) and (ability:GetSpecialData(""..spell.bonusDamage,level))) or spell.bonusDamage)
			local bonusDamageMultiplier = (((spell.bonusDamageMultiplier) and (ability:GetSpecialData(""..spell.bonusDamageMultiplier, level))) or spell.bonusDamageMultiplier)
			if spell.damageSpell then
				local dmgSpell = owner:FindSpell(spell.damageSpell)
				if damage and type(damage) == "number" then
					damage = damage + (((spell.damageSpellName) and (dmgSpell:GetSpecialData(""..spell.damageSpellName,dmgSpell.level))) or dmgSpell:GetDamage(dmgSpell.level))
				else
					damage = (((spell.damageSpellName) and (dmgSpell:GetSpecialData(""..spell.damageSpellName,dmgSpell.level))) or dmgSpell:GetDamage(dmgSpell.level))
				end
			end		
			if bonusDamageMultiplier then
				if bonusDamageMultiplier > 100 then 
					bonusDamageMultiplier = bonusDamageMultiplier/100
				end
				bonusDamage = bonusDamage*bonusDamageMultiplier
			end
			if damageMultiplier and damageMultiplier > 0 then
				if damageMultiplier > 100 then 
					damageMultiplier = damageMultiplier/100
				end
				if damage == owner.dmgMin then
					damage = (damage*damageMultiplier) - damage
				else
					damage = damage*damageMultiplier
				end
			end
			if bonusDamage then
				damage = damage + bonusDamage
			end
			if not spell.cooldown or ability.cd == 0 then
				return damage
			else
				return 0
			end
		end
	elseif item then
		local level = item.level
		local damage
		if level then
			damage = (((item.damage) and (ability:GetSpecialData(""..item.damage,level))))
		else
			damage = (((item.damage) and (ability:GetSpecialData(""..item.damage))))
		end
		if ability.name == "item_ethereal_blade" then
			local atr = owner.primaryAttribute
			if atr == LuaEntityHero.ATTRIBUTE_STRENGTH then atr = owner.strengthTotal
			elseif atr == LuaEntityHero.ATTRIBUTE_AGILITY then atr = owner.agilityTotal
			elseif atr == LuaEntityHero.ATTRIBUTE_INTELLIGENCE then atr = owner.intellectTotal
			end
			-- local str = owner.strengthTotal
			-- local agi = owner.agilityTotal
			-- local int = owner.intellectTotal
			-- local atr = str
			-- if agi > atr then atr = agi end
			-- if int > atr then atr = int end		
			damage = damage + (((item.mult) and (ability:GetSpecialData(""..item.mult))))*atr
		end
		if ability.name ~= "item_ethereal_blade" then
			if not AbilityDamagetemporaryTable[ability.name] then
				AbilityDamage.temporaryTable[ability.name] = {}
				AbilityDamage.temporaryTable[ability.name][ability.level] = damage
			else
				AbilityDamage.temporaryTable[ability.name][ability.level] = damage
			end
		end
		return damage
	elseif dmg then
		if not AbilityDamagetemporaryTable[ability.name] then
			AbilityDamage.temporaryTable[ability.name] = {}
			AbilityDamage.temporaryTable[ability.name][ability.level] = dmg
		else
			AbilityDamage.temporaryTable[ability.name][ability.level] = dmg
		end
		return dmg
	end
	return nil
end

function AbilityDamage.GetDamage(ability, hpRegen)
	local AbilityDamagetemporaryTable = AbilityDamage.temporaryTable
	local AbilityDamagespellList = AbilityDamage.spellList
	local spell = AbilityDamagespellList[ability.name]
	local owner = ability.owner
	if AbilityDamagetemporaryTable[ability.name] then
		if spell and spell.spellLevel then
			local level = owner:FindSpell(spell.spellLevel).level
			if AbilityDamagetemporaryTable[ability.name][level] then
				return AbilityDamagetemporaryTable[ability.name][level]
			end
		elseif AbilityDamagetemporaryTable[ability.name][ability.level] then
			return AbilityDamagetemporaryTable[ability.name][ability.level]
		end
	end
	local damage = AbilityDamage.CalculateDamage(ability, hpRegen)
	if damage then 
		return damage 
	end
	return 0
end

function AbilityDamage.GetDmgType(spell)
	--Recongnizing the type of damage of our spell
	local dmgType = spell.dmgType
	local type = DAMAGE_MAGC
	if dmgType == 1 then
		type = DAMAGE_PHYS
	elseif dmgType == 2 then
		type = DAMAGE_MAGC
	elseif dmgType == 4 then
		type = DAMAGE_PURE
	end
	if spell.name == "abaddon_aphotic_shield" then type = DAMAGE_MAGC end
	if spell.name == "meepo_poof" then type = DAMAGE_MAGC end
	if spell.name == "axe_culling_blade" then type = DAMAGE_PURE end
	if spell.name == "invoker_sun_strike" then type = DAMAGE_PURE end
	if spell.name == "alchemist_unstable_concoction_throw" then type = DAMAGE_PHYS end
	if spell.name == "centaur_stampede" then type = DAMAGE_MAGC end
	if spell.name == "lina_laguna_blade" and entityList:GetMyHero():AghanimState() then type = DAMAGE_PURE end
	if spell.name == "legion_commander_duel" then type = DAMAGE_PHYS end
	return type
end
