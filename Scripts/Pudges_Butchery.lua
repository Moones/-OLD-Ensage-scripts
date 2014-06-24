require("libs.Utils")
require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey

sleeptick = 0
targetHandle = nil

local xx,yy = 10,client.screenSize.y/25.714
local myFont = drawMgr:CreateFont("Pudge","Tahoma",14,550)
local statusText = drawMgr:CreateText(xx,yy,-1,"Pudge Script: ON",myFont);
local targetText = drawMgr:CreateText(xx,yy+15,-1,"",myFont);
local reg = nil
local active = true

targetText.visible = false

function Key(msg,code)

    if msg ~= KEY_UP or code ~= key or client.chat then	return end

	if not active then
		active = true
		statusText.text = "Pudge Script: ON"
		return true
	else
		active = nil
		statusText.text = "Pudge Script: OFF"
		return true
	end

end

function Tick( tick )
	if tick < sleeptick or not IsIngame() or client.console or client.paused then
		return
	end

	sleeptick = tick + 100
	
	local me = entityList:GetMyHero()
	local player = entityList:GetMyPlayer()
	if not me or not player then
		return
	end	
	
	local target = entityList:GetEntity(targetHandle)
	local distance = me:GetDistance2D(target)
	local rotRange = 250
	if not target or not target.visible or not target.alive or not me.alive or not active
		or target:IsUnitState(LuaEntityNPC.STATE_MAGIC_IMMUNE) then
			targetHandle = nil
			targetText.visible = false
			statusText.text = "Pudge Script: ON"
			active = true
			script:UnregisterEvent(Tick)
			return
	end
	
	local abilities = me.abilities
	local W = abilities[2]
	local R = abilities[4]
	
	if W.level > 0 and not target:DoesHaveModifier("modifier_pudge_rot") and W.toggled == false then
		me:SafeToggleSpell(W.name)
	end
	
	if R.state ~= LuaEntityAbility.STATE_READY and not (distance > rotRange) then
			return
	end
	
	if R.channelTime > 0 then
		return	
	end
	
	local urn = me:FindItem("item_urn_of_shadows")
	
	if urn and urn.charges ~= 0 and urn.state == -1 and not target:DoesHaveModifier("modifier_item_urn_damage") then 
		me:SafeCastItem(urn.name,target)
	end
	
	if R.level > 0 and R.state == LuaEntityAbility.STATE_READY and (target.health*(target.dmgResist+1)) > ((me.dmgMin + me.dmgBonus)*2) then 
		me:SafeCastSpell(R.name,target)
	end
	
	if R.state ~= LuaEntityAbility.STATE_READY and (distance > rotRange) then
			targetHandle = nil
			targetText.visible = false
			statusText.text = "Pudge Script: ON"
			active = true
			script:UnregisterEvent(Tick)
			return
	end
	
end

function target(tick)
	if not IsIngame() or client.console then
		return
	end
	
	local me = entityList:GetMyHero()
	if not me then
		return
	end
	
	if not reg then
		script:RegisterEvent(EVENT_KEY,Key)
		reg = true
		statusText.visible = true
	end
		
	if me.classId ~= CDOTA_Unit_Hero_Pudge then
		targetText.visible = false
		statusText.visible = false
		script:Disable()
		return
	end
	if active then
		for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_HERO,alive=true,illusion=false})) do
			if v.team ~= me.team then
				if v:DoesHaveModifier("modifier_pudge_meat_hook") then
				targetHandle = v.handle
				targetText.visible = true
				targetText.text = "Killing " .. client:Localize(v.name)
				script:RegisterEvent(EVENT_TICK,Tick)
				end
			end
		end
	end
end

function GameClose()
	if reg then
		script:UnregisterEvent(EVENT_KEY,Key)
		reg = nil
	end
	statusText.visible = false
	targetText.visible = false
	active = nil
end

function Load()
	targetText.visible = false
	statusText.visible = true
	statusText.text = "Pudge Script: ON"
	active = nil
end


script:RegisterEvent(EVENT_TICK,target)
script:RegisterEvent(EVENT_CLOSE,GameClose)
script:RegisterEvent(EVENT_LOAD,Load)
