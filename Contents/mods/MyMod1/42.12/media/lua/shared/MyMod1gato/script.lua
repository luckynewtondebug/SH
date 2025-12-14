
local function OnKeyPressed(key)
    if key == Keyboard.KEY_T then
        local cell = getCell()
        local zombies = cell:getZombieList()
        for i = 0, zombies:size() - 1 do
            local zombie = zombies:get(i)
            zombie:addLineChatElement("Hello World!")
        end
    end
end

Events.OnKeyPressed.Add(OnKeyPressed)