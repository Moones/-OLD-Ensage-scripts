require("libs.ScriptConfig")
require("libs.Utils")

--THANKS TO ZYNOX WE CAN NOW EXECUTE SOME CHEATCOMMANDS, Add commands from here https://privatepaste.com/2b70115c59

local config = ScriptConfig.new()
config:SetParameter("Hotkey", "F", config.TYPE_HOTKEY)
config:SetParameter("Commands","fog_enable 0,cl_predict 1,fog_override 1,fog_end 30000,", config.TYPE_STRING_ARRAY) -- see this post for more commands: http://zynox.net/forum/threads/1566-CheatCommands?p=14128
config:SetParameter("AutoExecute", false)
config:Load()

local key = config.Hotkey
local commandsTable = config.Commands
local autoExec = config.AutoExecute

function KeyExecute(msg,code)	
	if msg ~= KEY_UP or client.chat or not IsIngame() then return end
	if code == key then
		if ExecuteCommands("Starting to execute cheat commands") then
			script:Disable()
			return true
		end
	end
end

function AutoExecution()
	if IsIngame() and autoExec then
		if ExecuteCommands("Starting to AutoExecute cheat commands") then
			script:Disable()
		end
	end
end
		
function ExecuteCommands(msg)
	print(msg)
	for i, v in ipairs(commandsTable) do
		local command = split(v, " ")
		client:RemoveCheatFlag(""..command[1]) client:ExecuteCmd(v)
		print("CheatCommand:", command[1].." has been set to value "..command[2])
	end
	print("Successfully executed "..#commandsTable.." cheat commands")
	return true
end

if autoExec then
	script:RegisterEvent(EVENT_TICK,AutoExecution)
end

script:RegisterEvent(EVENT_KEY,KeyExecute)
