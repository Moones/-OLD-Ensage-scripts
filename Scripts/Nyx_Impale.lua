require("libs.Utils")
require("libs.ScriptConfig")
require("libs.TargetFind")
require("libs.SkillShot")
require("libs.VectorOp")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("ImpaleKey", "D", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey
local impalekey = config.ImpaleKey

victimHandle = nil

local myFont = drawMgr:CreateFont("Nyx","Tahoma",14,550)
local statusText = drawMgr:CreateText(-40,-20,-1,"Stun'em!",myFont);
local active = true
local stun = nil

function ImpaleKey(msg,code)	
	if msg ~= KEY_UP or client.chat then return end

	if code == impalekey and active then     
		if not stun then
			stun = true
			return true
		else
			stun = nil
			return true
		end
	elseif code == key then
		if not active then
			active = true
			statusText.text = "Stun'em!"
			return true
		else
			active = nil
			statusText.text = "   OFF!"
			return true
		end
	end
end

function Main(tick)
	if not IsIngame() or client.console or not SleepCheck() then return end

	local me = entityList:GetMyHero()

	if not me then return end

	if me.classId ~= CDOTA_Unit_Hero_Nyx_Assassin then
		statusText.visible = false
		script:Disable()
		return
	end

	local offset = me.healthbarOffset

	if not statusText.entity then
		statusText.entity = me
		statusText.entityPosition = Vector(0,0,offset)
	end

	local impale = me:GetAbility(1)

	if active then  

		local victim = targetFind:GetLowestEHP(762.5, magic)

		if victim and GetDistance2D(victim,me) < 762.5 then
			statusText.text = "Stun: " .. client:Localize(victim.name)
			if stun and impale.level > 0 and me.alive then stun = nil 
				local speed = 1600  
				local distance = GetDistance2D(victim, me)
				local castPoint = 400+client.latency
				local xyz = SkillShot.SkillShotXYZ(me,victim,speed,castPoint)
				if xyz and distance <= 762.5 then  
					if xyz:GetDistance2D(me) > 762.5 then
						xyz = (xyz - me.position) * 600 / xyz:GetDistance2D(me) + me.position
					end
					me:SafeCastAbility(impale, xyz)
					Sleep(250)
				end
			end 
		else
			statusText.text = "Stun'em!"
		end
	end
end


script:RegisterEvent(EVENT_TICK,Main)
script:RegisterEvent(EVENT_KEY,ImpaleKey)
