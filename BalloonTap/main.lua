-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local tapCount = 0
local physics = require( "physics" )

local background = display.newImageRect( "db.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY


local paint = { 1, 0, 0.5 }
local paint2 = { 0, 0, 0.5 }
local wallcount = 10
local walls = {}
for i = 1,wallcount do
	--walls[i] = display.newRect(math.random(50, 300),  math.random(50, 500), 20, 20)
	--walls[i].fill = paint
	walls[i] = display.newImageRect("fire.png", 20, 20)
	walls[i].x = math.random(50, 300)
	walls[i].y = math.random(50, 500)
	walls[i].myName = "wall:" .. i
end



local tapText = display.newText( tapCount, display.contentCenterX, 20, native.systemFont, 40 )
tapText:setFillColor( .7, .8, 0 )

local platform = display.newImageRect( "platform.png", 300, 20 )
platform.x = display.contentCenterX
platform.y = display.contentHeight-10
platform.myName = "platform"

local balloon = display.newImageRect( "bomb.png", 112, 112 )
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
	balloon:applyLinearImpulse( 0, -1, balloon.x, balloon.y )
	--balloon.x = balloon.x + 20
	--balloon.y = balloon.y - 10
	
end

local emitterParams = {
    startColorAlpha = 1,
    startParticleSizeVariance = 53.47,
    startColorGreen = 0.3031555,
    yCoordFlipped = -1,
    blendFuncSource = 770,
    rotatePerSecondVariance = 153.95,
    particleLifespan = 0.7237,
    tangentialAcceleration = -144.74,
    finishColorBlue = 0.3699196,
    finishColorGreen = 0.5443883,
    blendFuncDestination = 1,
    startParticleSize = 50.95,
    startColorRed = 0.8373094,
    textureFileName = "fire.png",
    startColorVarianceAlpha = 1,
    maxParticles = 50,
    finishParticleSize = 64,
    duration = 1,
    finishColorRed = 1,
    maxRadiusVariance = 5,
    finishParticleSizeVariance = 5,
    gravityy = -671.05,
    speedVariance = 90.79,
    tangentialAccelVariance = -92.11,
    angleVariance = -142.62,
    angle = -244.11
}



balloon:addEventListener( "tap", pushBalloon )

local function makedynamic( event )
	--physics.addBody( event.other, "dynamic", { radius=50} )
	local obj = event.source.params.myParam1
	obj.alpha = 0.5
	--obj.fill = paint2
	physics.removeBody(obj)
	physics.addBody( obj, "dynamic", { bounce=0.2} )
	obj:applyLinearImpulse( 0, .03, obj.x, obj.y )
	--event.source.params.myParam1.x = event.source.params.myParam1.x + 100

	local emitter = display.newEmitter( emitterParams )

	-- Center the emitter within the content area
	emitter.x = obj.x
	emitter.y = obj.y
	
	tapCount = tapCount + 1
	tapText.text = tapCount
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
