require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Hotkey", "E", config.TYPE_HOTKEY)
config:Load()

local key = config.Hotkey

local casted = false local target = nil local old_selection = nil

function Main(tick)
	if not IsIngame() or client.console or not SleepCheck() then return end

	local me = entityList:GetMyHero()

	if not me or me.classId ~= CDOTA_Unit_Hero_Furion then 
		script:Disable()
		return
	end
	
	local sprout = me:GetAbility(1)
	local call = me:GetAbility(3)
	
	if sprout and sprout.level > 0 and call and call.level > 0 and call.state == LuaEntityAbility.STATE_READY then		
		if IsKeyDown(key) and not client.chat then							
			target = entityList:GetMouseover()
			if target then
				me:SafeCastAbility(call, target.position)
				casted = true
			end
		end
	end
	
	if casted and target then
		if call.state == LuaEntityAbility.STATE_COOLDOWN then
			local treants = entityList:GetEntities({controllable=true, classId=287,alive = true, visible = true})
			for i,v in ipairs(treants) do
				v:Attack(target)
			end
			casted=false
		end
	end
	Sleep(200)
end

script:RegisterEvent(EVENT_TICK, Main)
