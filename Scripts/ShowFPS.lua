require("libs.Animations")
require("libs.Utils")
require("libs.ScriptConfig")

local config = ScriptConfig.new()
config:SetParameter("PositionX", 20)
config:SetParameter("PositionY", 50)
config:SetParameter("Size", 15)
config:Load()

x = config.PositionX
y = config.PositionY
size = config.Size

local FPS = nil
local color = 0x00FF00FF
local Font = drawMgr:CreateFont("Font","Tahoma",size,550)

function ShowFPS(tick)
	if client.paused or Animations.maxCount < 1 then return end
	local FPSv = Animations.maxCount

	if FPSv > 80 then color = 0x00FF00FF elseif FPSv > 70 then color = 0x66FF33FF
	elseif FPSv > 60 then color = 0x99FF33FF elseif FPSv > 50 then color = 0xCCFF33FF
	elseif FPSv > 40 then color = 0xFFFF00FF elseif FPSv > 30 then color = 0xFFCC00FF
	elseif FPSv > 20 then color = 0xFF6600FF else color = 0xFF0000FF end
	
	if not FPS or not FPS.visible then
		FPS = drawMgr:CreateText(x,y,color,"FPS: "..FPSv,Font) FPS.visible = true
	else
		FPS.text = "FPS: "..FPSv
		FPS.color = color
	end
	
end

function Load()
	if FPS then
		FPS.visible = false
	end
end

function Close()
	if FPS then
		FPS.visible = false
	end
end

script:RegisterEvent(EVENT_CLOSE, Close)
script:RegisterEvent(EVENT_LOAD, Load)
script:RegisterEvent(EVENT_FRAME, ShowFPS)
