-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local tapCount = 0

local background = display.newImageRect( "background.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY


local paint = { 1, 0, 0.5 }
local wallcount = 10
local walls = {}
for i = 1,wallcount do
	walls[i] = display.newRect(math.random(50, 300),  math.random(50, 500), 20, 20)
	walls[i].fill = paint
end



local tapText = display.newText( tapCount, display.contentCenterX, 20, native.systemFont, 40 )
tapText:setFillColor( 0, 0, 0 )

local platform = display.newImageRect( "platform.png", 300, 50 )
platform.x = display.contentCenterX
platform.y = display.contentHeight-25

local balloon = display.newImageRect( "balloon.png", 112, 112 )
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

local physics = require( "physics" )
physics.start()

physics.addBody( platform, "static" )
physics.addBody( balloon, "dynamic", { radius=50} )
for i = 1, wallcount do
	physics.addBody( walls[i], "static" )
end

local function pushBalloon()
	--balloon:applyLinearImpulse( math.random() * 0.5, math.random() * 2 - 1, balloon.x, balloon.y )
	balloon.x = balloon.x + 20
	balloon.y = balloon.y - 10
	tapCount = tapCount + 1
	tapText.text = tapCount
end

balloon:addEventListener( "tap", pushBalloon )
