require("libs.Utils")
require("libs.ScriptConfig")

--[[
 0 1 0 1 0 0 1 1    
 0 1 1 0 1 1 1 1        ____          __        __         
 0 1 1 1 0 0 0 0       / __/__  ___  / /  __ __/ /__ ___ __
 0 1 1 0 1 0 0 0      _\ \/ _ \/ _ \/ _ \/ // / / _ `/\ \ /
 0 1 1 1 1 0 0 1     /___/\___/ .__/_//_/\_, /_/\_,_//_\_\ 
 0 1 1 0 1 1 0 0             /_/        /___/             
 0 1 1 0 0 0 0 1    
 0 1 1 1 1 0 0 0 

			Auto Armlet Toggle  v1.2

		This script uses armlet to gain hp when your hero is below a specified health.

		Changelog:
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
config:Load()

hotkey = config.Hotkey
minhp = config.MinimumHP

local xx,yy = 10,client.screenSize.y/25.714
local sleep,reg = nil,nil
local F14 = drawMgr:CreateFont("f14","Tahoma",14,550)
local statusText = drawMgr:CreateText(xx,yy,-1,"Auto armlet toggle: Off",F14)

ARMLET_DELAY = 2000

extraToggle = 0

function Key(msg,code)

    if msg ~= KEY_UP or code ~= hotkey or client.chat then	return end

	if not active then
		sleep = nil
		active = true
		statusText.text = "Auto armlet toggle: On"
		return true
	else
		sleep,active = nil
		statusText.text = "Auto armlet toggle: Off"
		return true
	end

end

function Tick( tick )
	if not client.connected or client.loading or client.console then return end

	local me = entityList:GetMyHero() 
	
	if not me then return end
	
	if not reg then
		script:RegisterEvent(EVENT_KEY,Key)
		reg = true
	end

	local armlet = me:FindItem("item_armlet")

	if not armlet then return end

	local armState = me:DoesHaveModifier("modifier_item_armlet_unholy_strength")

	if active and not me:DoesHaveModifier("modifier_ice_blast") and SleepCheck() then
		if me.health <= minhp + 0 then
			if armState then
				extraToggle = 2
			else
				extraToggle = 1
			end
			Sleep(ARMLET_DELAY)
		end
	end

	if extraToggle > 0 then
		if me:SafeCastItem("item_armlet") then
			extraToggle = extraToggle - 1
		end
	end
	
	for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true})) do	
		if v.team ~= me.team and not v:IsIllusion() then
			if not armState and not me:DoesHaveModifier("modifier_ice_blast") then
					
				local distance = GetDistance2D(v,me)
				local projectile = entityList:GetProjectiles({target=me, source=v})
					
				
				if projectile and distance <= (v.attackRange + 50) then
					for k,z in ipairs(projectile) do
						if armlet.toggled == false then
							me:SafeCastItem("item_armlet")
						end
					end
				end
				if distance <= (178) then
					if armlet.toggled == false then
						me:SafeCastItem("item_armlet")
					end
				end
			end
		end
	end
end

script:RegisterEvent(EVENT_TICK,Tick)
