require("libs.ScriptConfig")

--THANKS TO ZYNOX WE CAN NOW EXECUTE SOME CHEATCOMMANDS, Add commands from here https://developer.valvesoftware.com/wiki/List_of_DOTA_2_Cvars

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("Commands","fog_enable 0,cl_predict 1,dota_fake_battle_bonus 1,fog_override 1,fog_end 3000", config.TYPE_STRING_ARRAY)
config:Load()

local key = config.Hotkey
local commandsTable = config.Commands

function Key(msg,code)	
	if msg ~= KEY_UP or client.chat then return end
	if code == key then
		print("Starting to execute cheat commands")
		for i, v in ipairs(commandsTable) do
			local command = split(v, " ")
			client:RemoveCheatFlag(""..command[1]) client:ExecuteCmd(v)
			print("CheatCommand:", command[1].." has been set to value "..command[2])
		end
		print("Successfully executed "..#commandsTable.." cheat commands")
	end
end

script:RegisterEvent(EVENT_KEY,Key)
