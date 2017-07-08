local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
function buttonPress(event)
    timer.performWithDelay(100, function() composer.gotoScene("scenes.scene_game") end)
end

function scene:create(event)

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local g = display.newGroup()
    local bg = display.newRect(g, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    bg:setFillColor(0,0,0.5)

    local title = display.newText( g, "Nuffins", display.contentCenterX, 100, "media/Bungee-Regular.ttf" , 48)
    local start = widget.newButton({
        id = "start",
        label = "Start",
        x = display.contentCenterX,
        y = 200,

        shape = "roundedRect",
        width = 100,
        height = 50,
        radius = 3,
        fillColor = {default={1,1,1}, over={0,0,0}},

        font = "media/Bungee-Regular.ttf",
        labelColor = {default={0,0,0}, over={0,0,0}}
        })
    start:addEventListener("tap", buttonPress)
    g:insert(start)
    sceneGroup:insert(g)
end
 

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end
 

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        composer.removeScene("scenes.scene_menu")
    end
end
 

function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    print("menu must die")
    bg:removeSelf()
    start:removeSelf()

    bg = nil
    start = nil
end
 
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene