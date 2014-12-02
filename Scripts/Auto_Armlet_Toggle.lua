--<<Auto Armlet Toggle by Sophylax, reworked and updated by Moones v1.5.2>>
require("libs.Utils")
require("libs.ScriptConfig")
require("libs.Animations")
require("libs.HeroInfo")

--[[
 0 1 0 1 0 0 1 1    
 0 1 1 0 1 1 1 1        ____          __        __         
 0 1 1 1 0 0 0 0       / __/__  ___  / /  __ __/ /__ ___ __
 0 1 1 0 1 0 0 0      _\ \/ _ \/ _ \/ _ \/ // / / _ `/\ \ /
 0 1 1 1 1 0 0 1     /___/\___/ .__/_//_/\_, /_/\_,_//_\_\ 
 0 1 1 0 1 1 0 0             /_/        /___/             
 0 1 1 0 0 0 0 1    
 0 1 1 1 1 0 0 0 

			Auto Armlet Toggle  v1.5.2

		This script uses armlet to gain hp when:
		Theres a flying projectile which would kill you or
		theres a hero which is casting ability which would kill you or
		theres a hero which is attacking you and one hit from them would kill you or
		your hero is below a specified health and theres no incoming damage so you wont die by togglig it off. (Default 200 HP)
		When ranged hero shoots on you, any hero is in melee range or you start to attack an enemy hero, the script will auto toggle Armlet ON.

		Changelog:
			v1.5.2:
			 - Armlet will not be now toggle when you are invisible unless somebody is casting AOE ability on you and you would die from it.
			 
			v1.5.1:
			 - Added AutoActivation when you start to attack an enemy hero.
			 
			v1.5:
			 - Updated Calculation.
			 
			v1.4:
			 - Added calculation of incoming damage (projectiles, abilities, attacking heroes)
			 - MinimumHP is now considered only when there is no incoming damage and there are enemy heroes near
			 
			v1.3:
				Added Auto toggle on when ranged hero shoots on you or any hero is in melee range of you.
				
			v1.2:
			 - Reworked for new version
			 
			v1.1:
			 - Tweaked script for the new armlet mechanics again
			 - Removed the configurable armlet delay

			v1.0c:
			 - Tweaked script for the new armlet mechanics
			 - Added key for manual armlet toggling

			v1.0b:
			 - Script now checks armlet cooldown even if it is activated by the user

			v1.0a:
			 - Script now disables itself if the user is under Ice Blast effect
			 - Lowered menu Width

			v1.0:
			 - Release

]]	

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "L", config.TYPE_HOTKEY)
config:SetParameter("MinimumHP", 200)
config:SetParameter("ToggleAlways", false)
config:Load()

hotkey = config.Hotkey
minhp = config.MinimumHP

local xx,yy = 10,client.screenSize.y/25.714
local reg = nil local active = false
local F14 = drawMgr:CreateFont("f14","Tahoma",14,550)
local statusText = drawMgr:CreateText(xx,yy,-1,"Auto armlet toggle: Off",F14)
local incoming_projectiles = {} local incoming_damage = 0 local toggle = false

ARMLET_DELAY = 1000

function Key(msg,code)
    if msg ~= KEY_UP or code ~= hotkey or client.chat then return end
	if not active then
		active = true
		statusText.text = "Auto armlet toggle: On"
		return true
	else
		active = false
		statusText.text = "Auto armlet toggle: Off"
		return true
	end

end

function Tick( tick )
	if not PlayingGame() or client.console or client.paused then return end
	local me = entityList:GetMyHero()
	local player = entityList:GetMyPlayer()
	if not reg then
		script:RegisterEvent(EVENT_KEY,Key)
		reg = true
		incoming_projectiles = {} 
		incoming_damage = 0
	end
	
	local armlet = me:FindItem("item_armlet")
	if not armlet or me:IsStunned() or not armlet:CanBeCasted() or not active then incoming_damage = 0 incoming_projectiles = {} toggle = false return end
	
	local armState = me:DoesHaveModifier("modifier_item_armlet_unholy_strength")
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,visible=true,team=me:GetEnemyTeam()})
	local projectile = entityList:GetProjectiles({target=me})
	if not me.alive then
		incoming_damage = 0
		incoming_projectiles = {}
		toggle = false
		return
	end
	
	if armState and me:DoesHaveModifier("modifier_ice_blast") and SleepCheck() and not me:IsInvisible() then
		me:SafeCastItem("item_armlet")
		Sleep(ARMLET_DELAY)
	end
	
	if player.orderId == Player.ORDER_ATTACKENTITY and player.target and not me:IsInvisible() and player.target.hero and not armState and SleepCheck() and GetDistance2D(player.target,me) < me.attackRange+100 then
		me:SafeCastItem("item_armlet")
		Sleep(ARMLET_DELAY)
	end
	
	if config.ToggleAlways and SleepCheck() and not me:IsInvisible() and (toggle or (#enemies <= 0 and me.health < minhp)) and (math.max(me.health - 475,1) - incoming_damage) > 0 then
		if armState then
			me:SafeCastItem("item_armlet")
			me:SafeCastItem("item_armlet")
			Sleep(ARMLET_DELAY)
		else
			me:SafeCastItem("item_armlet")
			Sleep(ARMLET_DELAY)
		end
		toggle = false
	end
	
	for k,z in ipairs(projectile) do
		if z.target and z.target == me and z.source then
			local spell = z.source:FindSpell(z.name) 
			if spell then
				local dmg = spell:GetDamage(spell.level)
				if dmg <= 0 then dmg = spell:GetSpecialData("damage",spell.level) end
				if not dmg then dmg = ((((z.source.dmgMax + z.source.dmgMin)/2) + z.source.dmgBonus)*((1-me.dmgResist))) end
				if not incoming_projectiles[spell.handle] then
					incoming_projectiles[spell.handle] = {damage = dmg, time = client.gameTime + ((GetDistance2D(me,z.position)-50)/z.speed)}
					incoming_damage = incoming_damage + dmg
				elseif client.gameTime > incoming_projectiles[spell.handle].time then
					incoming_damage = incoming_damage - dmg
					incoming_projectiles[spell.handle] = nil
				end	
				if not me:IsInvisible() and armState and SleepCheck() and (me.health+((-40+me.healthRegen)*(GetDistance2D(me,z.position)/z.speed))) < dmg then
					me:SafeCastItem("item_armlet")
					me:SafeCastItem("item_armlet")
					Sleep(ARMLET_DELAY)
					break
				end
			else
				if not incoming_projectiles[z.source.handle] then																	
					incoming_projectiles[z.source.handle] = {damage = ((((z.source.dmgMax + z.source.dmgMin)/2) + z.source.dmgBonus)*((1-me.dmgResist))), time = client.gameTime + ((GetDistance2D(me,z.position)-50)/z.speed)}
					incoming_damage = incoming_damage + ((((z.source.dmgMax + z.source.dmgMin)/2) + z.source.dmgBonus)*((1-me.dmgResist)))
				elseif client.gameTime > incoming_projectiles[z.source.handle].time then
					incoming_damage = incoming_damage - ((((z.source.dmgMax + z.source.dmgMin)/2) + z.source.dmgBonus)*((1-me.dmgResist)))
					incoming_projectiles[z.source.handle] = nil
				end	
				if not me:IsInvisible() and armState and SleepCheck() and (me.health+((-40+me.healthRegen)*((GetDistance2D(me,z.position)-50)/z.speed))) < ((((z.source.dmgMax + z.source.dmgMin)/2) + z.source.dmgBonus)*((1-me.dmgResist))) then
					me:SafeCastItem("item_armlet")
					me:SafeCastItem("item_armlet")
					Sleep(ARMLET_DELAY) break
				end
			end
		end
		if not armState and SleepCheck() and z.target and z.target == me and z.source and z.source.hero and not me:IsInvisible() then
			me:SafeCastItem("item_armlet")
			Sleep(ARMLET_DELAY) break
		end
	end
	
	for i,v in ipairs(enemies) do			
		if not v:IsIllusion() and not me:DoesHaveModifier("modifier_ice_blast") then
			local distance = GetDistance2D(v,me)						
			for i,z in ipairs(v.abilities) do
				local dmg = z:GetDamage(z.level)
				if dmg <= 0 then dmg = z:GetSpecialData("damage",z.level) end
				if not dmg then dmg = ((((v.dmgMax + v.dmgMin)/2) + v.dmgBonus)*((1-me.dmgResist))) end
				if incoming_projectiles[z.handle] and client.gameTime > incoming_projectiles[z.handle].time then
					incoming_damage = incoming_damage - dmg		
					incoming_projectiles[z.handle] = nil
				end
				if z.abilityPhase and distance <= z.castRange+100 and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0)) == 0 then
					if not incoming_projectiles[z.handle] then
						incoming_damage = incoming_damage + dmg
						incoming_projectiles = {damage = dmg, time = client.gameTime + z:FindCastPoint()+client.latency/1000}
					end
					if (not me:IsInvisible() or z:IsBehaviourType(LuaEntityAbility.BEHAVIOR_POINT)) and armState and SleepCheck() and me.health+((-40+me.healthRegen)*(z:FindCastPoint()-client.latency/1000)) < dmg then
						me:SafeCastItem("item_armlet")
						me:SafeCastItem("item_armlet")
						Sleep(ARMLET_DELAY) break
					end
				end 
			end	
			if distance <= (v.attackRange+100) and Animations.isAttacking(v) and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0)) == 0 then
				if not incoming_projectiles[v.handle] and (Animations.CanMove(v) or v.attackRange < 200) then
					incoming_damage = incoming_damage + ((((v.dmgMax + v.dmgMin)/2) + v.dmgBonus)*((1-me.dmgResist)))
					if heroInfo[v.name].projectileSpeed then
						incoming_projectiles[v.handle] = {damage = ((((v.dmgMax + v.dmgMin)/2) + v.dmgBonus)*((1-me.dmgResist))), time = client.gameTime + Animations.GetAttackTime(v) + ((GetDistance2D(me,v)-50)/heroInfo[v.name].projectileSpeed)}
					else
						incoming_projectiles[v.handle] = {damage = ((((v.dmgMax + v.dmgMin)/2) + v.dmgBonus)*((1-me.dmgResist))), time = client.gameTime + Animations.GetAttackTime(v)}
					end
				elseif incoming_projectiles[v.handle] and client.gameTime > incoming_projectiles[v.handle].time then
					incoming_damage = incoming_damage - ((((v.dmgMax + v.dmgMin)/2) + v.dmgBonus)*((1-me.dmgResist)))
					incoming_projectiles[v.handle] = nil
				end
				if (heroInfo[v.name] and heroInfo[v.name].projectileSpeed and (me.health+((-40+me.healthRegen)*(Animations.GetAttackTime(v) + distance/heroInfo[v.name].projectileSpeed)) < ((((v.dmgMax + v.dmgMin)/2) + v.dmgBonus)*((1-me.dmgResist)))))
				or (me.health+((-40+me.healthRegen)*(Animations.GetAttackTime(v))) < ((((v.dmgMax + v.dmgMin)/2) + v.dmgBonus)*((1-me.dmgResist))))
				then
					if not me:IsInvisible() and armState and SleepCheck() then
						me:SafeCastItem("item_armlet")
						me:SafeCastItem("item_armlet")
						Sleep(ARMLET_DELAY) break
					end
				end
			elseif incoming_projectiles[v.handle] and client.gameTime > incoming_projectiles[v.handle].time then
				incoming_damage = incoming_damage - ((((v.dmgMax + v.dmgMin)/2) + v.dmgBonus)*((1-me.dmgResist)))
				incoming_projectiles[v.handle] = nil
			elseif me.health < minhp and (math.max(me.health - 475,1) - incoming_damage) > 0 then
				toggle = true
			end
			if not armState and SleepCheck() and not me:IsInvisible() then
				if not armState and SleepCheck() and Animations.isAttacking(me) and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0)) == 0 and GetDistance2D(me,v) < me.attackRange+100 then
					me:SafeCastItem("item_armlet")
					Sleep(ARMLET_DELAY) break
				end
				for i,z in ipairs(v.abilities) do
					if not armState and SleepCheck() and z.abilityPhase and distance <= z.castRange+100 and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0)) == 0 then
						me:SafeCastItem("item_armlet")
						Sleep(ARMLET_DELAY) break
					end
				end	
				if not armState and SleepCheck() and (distance <= (250) or (Animations.isAttacking(v) and (math.max(math.abs(FindAngleR(v) - math.rad(FindAngleBetween(v, me))) - 0.20, 0)) == 0 and distance < v.attackRange+100)) then
					me:SafeCastItem("item_armlet")
					Sleep(ARMLET_DELAY)
				end
			end
		end
	end
end

script:RegisterEvent(EVENT_FRAME,Tick)
