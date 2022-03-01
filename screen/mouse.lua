mouseCircle = nil
mouseCircleTimer = nil
hs.hotkey.bind({"alt"}, "F", function ()
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.absolutePosition()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()
    mouseCircleTimer = hs.timer.doAfter(1, function()
      mouseCircle:delete()
      mouseCircle = nil
    end)
end)