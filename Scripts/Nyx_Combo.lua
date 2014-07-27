require("libs.Utils")
require("libs.ScriptConfig")
require("libs.TargetFind")
require("libs.SkillShot")
require("libs.VectorOp")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("ImpaleKey", "D", config.TYPE_HOTKEY)
config:SetParameter("ComboKey", "G", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey
local impalekey = config.ImpaleKey
local combokey = config.ComboKey

sleeptick = 0

victimHandle = nil local castQueue = {} local reg = nil local active = true local stun = nil local victim = nil

local myFont = drawMgr:CreateFont("Nyx","Tahoma",14,550)
local statusText = drawMgr:CreateText(-40,-20,-1,"Nyx'em!",myFont);
local victimText = drawMgr:CreateText(-40,-20,-1,"Nyx'em!",myFont);

function Key(msg,code)	
	if msg ~= KEY_UP or client.chat then return end

	if code == impalekey and active and victim and victim.visible then     
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
			victimText.visible = true
			return true
		else
			active = nil
			statusText.text = "   OFF!"
			victimText.visible = false
			return true
		end
	end
end

function Main(tick)
	if tick < sleeptick or client.paused or not IsIngame() or client.console then return end 
	local me = entityList:GetMyHero() if not me then return end
	local ID = me.classId if ID ~= myhero then GameClose() end
	
	statusText.visible = true
	local offset = me.healthbarOffset
	statusText.entity = me
	statusText.entityPosition = Vector(0,0,offset)

	local impale = me:GetAbility(1)

	if active then  

		victim = targetFind:GetLowestEHP(762.5, magic)
		if IsKeyDown(combokey) or me:DoesHaveModifier("modifier_nyx_assassin_vendetta") then
			victim = targetFind:GetClosestToMouse(100)
		end
		if victim and GetDistance2D(victim,me) < 762.5 then
		
			victimText.visible = true
			victimText.entity = victim
			victimText.entityPosition = Vector(0,0,victim.healthbarOffset)
			
			statusText.text = "Stun: " .. client:Localize(victim.name)
			if stun and impale.level > 0 and me.alive then stun = nil
				ImpaleSkillShot(victim,me,impale)
			end

			for i=1,#castQueue,1 do
				local v = castQueue[1]
				table.remove(castQueue,1)
				local ability = v[2]
				if type(ability) == "string" then
					ability = me:FindItem(ability)
				end
				if ability and me:SafeCastAbility(ability,v[3],false) then
					sleeptick = tick + v[1]
					return
				end
			end
			
			if IsKeyDown(combokey) and victim and not client.chat and not me:DoesHaveModifier("modifier_nyx_assassin_vendetta") then
				
				local manaburn = me:GetAbility(2)
				local manadmg = {3.5,4,4.5,5}
				local dagon = me:FindDagon()
				local ethereal = me:FindItem("item_ethereal_blade")
				local manaboots = me:FindItem("item_arcane_boots")
				
				if impale and impale.state == LuaEntityAbility.STATE_READY then
					ImpaleSkillShot(victim,me,impale)
					sleeptick = tick + 400
				end
				
				if me.mana < me.maxMana*0.5 and manaboots and manaboots.cd == 0 then
					me:SafeCastItem(manaboots.name)
				end
				
				if ethereal and ethereal.cd == 0 then
					table.insert(castQueue,{100,ethereal,victim})
				end
				
				if manaburn and manaburn.state == LuaEntityAbility.STATE_READY and (victim.intellectTotal*manadmg[manaburn.level])/4 < victim.mana then
					table.insert(castQueue,{manaburn:GetCastPoint(manaburn.level)*1000,manaburn,victim})
				end
				
				if dagon and dagon.cd == 0 then
					table.insert(castQueue,{100,dagon,victim})
				end	
			end	
		else
			statusText.text = "Nyx'em!"
			victimText.visible = false
		end
	end
end

function ImpaleSkillShot(victim,me,impale)
	local speed = 1600  
	local distance = GetDistance2D(victim, me)
	local delay = 400+client.latency
	local xyz = SkillShot.SkillShotXYZ(me,victim,delay,speed)
	if xyz and distance <= 762.5 then  
		me:SafeCastAbility(impale, xyz)
	end
end 

function Load()
	if PlayingGame() then
	
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Nyx_Assassin then 
			script:Disable() 
			
		else
		
			reg = true
			active = true
			victim = nil 
			myhero = me.classId
			script:RegisterEvent(EVENT_TICK,Main)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(Load)
			
		end
	end
end

function GameClose()

	statusText.visible = false
	victimText.visible = false
	myhero = nil
	active = true
	victim = nil 
	
	if reg then
	
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		script:RegisterEvent(EVENT_TICK,Load)
		reg = false
		
	end
end


script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,GameClose)
