--<<Show Aegis expiration timer, made by Moones>>

--[[ AegisTimer ]]--

require("libs.Utils")
require("libs.SideMessage")

local bg = drawMgr:CreateRect(client.screenSize.x*0.869,client.screenSize.y*0.049,client.screenSize.x*0.0235,client.screenSize.y*0.032,0x000000ff) bg.visible = false showsidemsg = false
local start = nil local reg = false local timer local icon = drawMgr:CreateRect(client.screenSize.x*0.87,client.screenSize.y*0.05,client.screenSize.x*0.03,client.screenSize.y*0.03,0x000000ff,drawMgr:GetTextureId("NyanUI/items/aegis")) icon.visible = false
local font = drawMgr:CreateFont("font","Tahoma",client.screenSize.x*0.015,500) local text = drawMgr:CreateText(client.screenSize.x*0.895,client.screenSize.y*0.05,0x66FF33FF,"",font) text.visible = false local sidemsg = nil local fog = false local roshdead = false

function Main(tick)
	if client.paused then return end
	local mathfloor,tostring = math.floor,tostring
	local aegis = entityList:GetEntities(function (ent) return ent.item and ent.name == "item_aegis" and ent.owner.hero end)[1]
	if not start then
		if aegis or fog then
			start = client.gameTime
			return
		end
	elseif not aegis and not fog then
		icon.visible = false
		text.visible = false
		bg.visible = false
		start = nil
		return
	else
		if aegis and aegis.owner and aegis.owner.visible then fog = false roshdead = false end
		local time = 300 - mathfloor(client.gameTime - start)
		local minutes = mathfloor(time / 60)
		local seconds = time - minutes*60
		if minutes > 0 then
			text.text = tostring(minutes).."mins "..tostring(seconds).."secs"
		else
			text.text = tostring(seconds).."secs"
		end
		if seconds == 0 or time < 10 then
			if not showsidemsg then
				GenerateSideMessage(tostring(minutes).."mins")
				showsidemsg = true
			end
		else
			showsidemsg = false
		end
		if sidemsg then
			local txt = sidemsg.elements[2]
			if txt.obj and txt.obj.text then
				if minutes > 0 then
					txt.obj.text = tostring(minutes).."mins "..tostring(seconds).."secs"
				else
					txt.obj.text = tostring(seconds).."secs"
				end
			end
		end
		icon.visible = true
		text.visible = true
		bg.visible = true
	end	
end

function GenerateSideMessage(msg)
	sidemsg = sideMessage:CreateMessage(client.screenSize.x*0.13,client.screenSize.y*0.05,0x111111C0,0x444444FF,150,5000)
	sidemsg:AddElement(drawMgr:CreateRect(client.screenSize.x*0.002,client.screenSize.x*0.002,client.screenSize.x*0.04,client.screenSize.y*0.04,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/items/aegis")))
	sidemsg:AddElement(drawMgr:CreateText(client.screenSize.x*0.035,client.screenSize.y*0.01,-1,"" .. msg,font))
end

function int(event)
	local names = event.name
	if names == "dota_roshan_kill" then
		roshdead = true
	end
	if roshdead and names == "spec_item_pickup" then
		fog = true
		roshdead = false
	end
end

function Load()
	if IsIngame() then
		start = nil
		reg = true
		roshdead = false
		sidemsg = nil
		fog = false
		showsidemsg = false
		icon.visible = false
		text.visible = false
		bg.visible = false
		script:RegisterEvent(EVENT_TICK,Main)
		script:RegisterEvent(EVENT_DOTA,int)
		script:UnregisterEvent(Load)
	end
end

function Close()
	start = nil
	showsidemsg = false
	icon.visible = false
	text.visible = false
	bg.visible = false
	if reg then
		script:UnregisterEvent(Main)
		script:UnregisterEvent(int)
		script:RegisterEvent(EVENT_TICK, Load)	
		reg = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
