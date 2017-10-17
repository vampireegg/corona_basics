-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local tapCount = 0
local physics = require( "physics" )

local background = display.newImageRect( "background.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY


local paint = { 1, 0, 0.5 }
local paint2 = { 0, 0, 0.5 }
local wallcount = 10
local walls = {}
for i = 1,wallcount do
	walls[i] = display.newRect(math.random(50, 300),  math.random(50, 500), 20, 20)
	walls[i].fill = paint
	walls[i].myName = "wall:" .. i
end



local tapText = display.newText( tapCount, display.contentCenterX, 20, native.systemFont, 40 )
tapText:setFillColor( 0, 0, 0 )

local platform = display.newImageRect( "platform.png", 300, 50 )
platform.x = display.contentCenterX
platform.y = display.contentHeight-25
platform.myName = "platform"

local balloon = display.newImageRect( "balloon.png", 112, 112 )
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8
balloon.myName = "balloon"


physics.start()

physics.addBody( platform, "static" )
physics.addBody( balloon, "dynamic", { radius=50} )
for i = 1, wallcount do
	physics.addBody( walls[i], "static" )
end

local function pushBalloon()
	balloon:applyLinearImpulse( math.random() * 0.5, math.random() * 2 - 1, balloon.x, balloon.y )
	--balloon.x = balloon.x + 20
	--balloon.y = balloon.y - 10
	tapCount = tapCount + 1
	tapText.text = tapCount
end

balloon:addEventListener( "tap", pushBalloon )

local function makedynamic( event )
  --physics.addBody( event.other, "dynamic", { radius=50} )
  local obj = event.source.params.myParam1
  obj.fill = paint2
  physics.removeBody(obj)
  physics.addBody( obj, "dynamic", { bounce=0.2} )
  obj:applyLinearImpulse( 0, .03, obj.x, obj.y )
  --event.source.params.myParam1.x = event.source.params.myParam1.x + 100
end


local function onLocalCollision( self, event ) 
    if ( event.phase == "began" ) then
        print( self.myName .. ": collision began with " .. event.other.myName .. " x = " .. event.other.x .. " y = " .. event.other.y)
    elseif ( event.phase == "ended" ) then
        print( self.myName .. ": collision ended with " .. event.other.myName  .. " x = " .. event.other.x .. " y = " .. event.other.y)
		local tm = timer.performWithDelay( 50, makedynamic )
		tm.params = { myParam1 = event.other }
    end
end
 
balloon.collision = onLocalCollision
balloon:addEventListener( "collision" )
