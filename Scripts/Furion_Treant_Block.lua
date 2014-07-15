require("libs.ScriptConfig")
require("libs.TargetFind")
require("libs.Utils")

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "E", config.TYPE_HOTKEY)
config:Load()

local keycode = config.Hotkey

local casted = false 
local target = nil 

function Main(tick)
	if not IsIngame() or client.console or not SleepCheck() then 
		return 
	end
	-- only furion can use this script
	local me = entityList:GetMyHero()
	if not me or me.classId ~= CDOTA_Unit_Hero_Furion then 
		script:Disable()
		return
	end
	-- check if combo has been casted
	if casted and target then
		local call = me:GetAbility(3)
		if call and call.state == LuaEntityAbility.STATE_COOLDOWN then
			local treants = entityList:GetEntities({controllable=true, classId=CDOTA_BaseNPC_Creep,alive = true, visible = true})
			for i,v in ipairs(treants) do
				v:Attack(target)
			end
			casted=false
			target=nil
		end
	end
	Sleep(200)
end

function Key(msg,code)
	if msg ~= KEY_UP or code ~= keycode or not IsIngame() or client.chat then
		return
	end
	-- only furion can use this script
	local me = entityList:GetMyHero()
	if not me or me.classId ~= CDOTA_Unit_Hero_Furion then 
		script:Disable()
		return
	end
	-- get and check the needed abilities
	local sprout = me:GetAbility(1)
	local call = me:GetAbility(3)
	if not sprout or not call or sprout.level == 0 or call.level == 0 or call.state ~= LuaEntityAbility.STATE_READY or sprout.state ~= LuaEntityAbility.STATE_COOLDOWN then
		return
	end
	-- get a valid target
	target = targetFind:GetClosestToMouse(500,true)
	if not target then
		return
	end
	-- cast treants
	me:SafeCastAbility(call, target.position)
	casted = true
	-- block key input from game
	return true
end

script:RegisterEvent(EVENT_KEY, Key)
script:RegisterEvent(EVENT_TICK, Main)
