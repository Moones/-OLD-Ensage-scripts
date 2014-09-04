--[[

	-------------------------------------
	    | Techies Script by Moones |
	-------------------------------------
	========== Version 1.0.0 ============
	 
	Description:
	------------
	
		Anti Techies:
			- Detects and shows all mines placed by Techies.
			
		Auto Techies:
			- Auto detonates Remote Mine when enemy is in explosion radius of it.
			
]]--

require("libs.Utils")

local Radiuses = {} local Signs = {} local reg = false local ability = nil local radius = nil local anti_techies = false
local Font = drawMgr:CreateFont("Techies","Tahoma",14,550)

local MinesInfo = {
	npc_dota_techies_land_mine = {
		ability_name = "techies_land_mines";
		radius = "small_radius";
	};
	npc_dota_techies_stasis_trap = {
		ability_name = "techies_stasis_trap";
		radius = "activation_radius";
	};
	npc_dota_techies_remote_mine = {
		ability_name = "techies_remote_mines";
		radius = "radius"
	};
}
		
function Anti_Techies(tick)
	if not PlayingGame() or client.console or not SleepCheck("main") then return end Sleep(500,"main")
	local me = entityList:GetMyHero()
	local Techies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,classId=CDOTA_Unit_Hero_Techies,team=me:GetEnemyTeam(),illusion=false})[1] 
	if not Techies then return end
	local mines = entityList:GetEntities({type=LuaEntity.TYPE_NPC,classId=CDOTA_BaseNPC_Additive,team=me:GetEnemyTeam()})
	for i,v in ipairs(mines) do
		if MinesInfo[v.name] then
			if not Radiuses[v.handle] and v.alive then
				ability = Techies:FindSpell(MinesInfo[v.name].ability_name)
				if ability then
					radius = ability:GetSpecialData(MinesInfo[v.name].radius, ability.level)
					Radiuses[v.handle] = Effect(v.position,"range_display")
					Radiuses[v.handle]:SetVector(1, Vector(radius,0,0))
					Radiuses[v.handle]:SetVector(0, v.position)
					Signs[v.handle] = drawMgr:CreateText(-40,-20,-1,client:Localize(v.name),Font)
					Signs[v.handle].entity = v
				end
			end	
			if not v.alive and Radiuses[v.handle] then
				Radiuses[v.handle] = nil
				Signs[v.handle] = nil
				collectgarbage("collect")
			end				
		end
	end
	if SleepCheck("cleaning") then
		collectgarbage("collect")
		Sleep(60000)
	end
end

function Auto_Techies(tick)
	if not PlayingGame() or client.console or not SleepCheck() then return end	
	local me = entityList:GetMyHero() 
	local mines = entityList:GetEntities({type=LuaEntity.TYPE_NPC,classId=CDOTA_BaseNPC_Additive,team=me.team,alive=true})
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,team = me:GetEnemyTeam(),illusion=false,alive=true,visible=true})
	for i,v in ipairs(mines) do
		if v.name == "npc_dota_techies_remote_mine" then
			ability = me:FindSpell(MinesInfo[v.name].ability_name)
			if ability then
				radius = ability:GetSpecialData(MinesInfo[v.name].radius, ability.level) 
				for k,z in ipairs(enemies) do
					local detonate = me:GetAbility(4)
					if GetDistance2D(v, z) <= radius+25 and detonate and me:CanCast() then
						me:SafeCastAbility(detonate, v.position)
						Sleep(250)
					end
				end	
			end
		end
	end
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me then 
			script:Disable()
		else			
			reg = true
			Radiuses = {}
			Signs = {}
			ability = nil
			radius = nil
			if me.classId == CDOTA_Unit_Hero_Techies then
				anti_techies = false
				script:RegisterEvent(EVENT_TICK, Auto_Techies)
			else
				anti_techies = true
				script:RegisterEvent(EVENT_TICK, Anti_Techies)
			end
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	reg = true
	radius = nil
	ability = nil
	Radiuses = {}
	Signs = {}
	collectgarbage("collect")
	if reg then
		if anti_techies then
			script:UnregisterEvent(Anti_Techies)
		else
			script:UnregisterEvent(Auto_Techies)
		end
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

script:RegisterEvent(EVENT_TICK, Load)	
script:RegisterEvent(EVENT_CLOSE, Close)
