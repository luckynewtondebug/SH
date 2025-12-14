---------------------------------
---     Coded by Sioyth       ---
--- https://github.com/Sioyth ---
---------------------------------

local BaseHandler = require("BaseHandler_V42")

local HReplaceBandage = BaseHandler:derive("HReplaceBandage")

function HReplaceBandage:new(panel, bodyPart)
    local o = BaseHandler.new(self, panel, bodyPart)
    o.items.ITEMS = {}
    return o
end

function HReplaceBandage:checkItem(item)
    if item:getBandagePower() > 0 then
        self:addItem(self.items.ITEMS, item)
    end
end

function HReplaceBandage:addToMenu(context)
    local types = self:getAllItemTypes(self.items.ITEMS)
    if #types > 0 and self.bodyPart:bandaged() then
        local option = context:addOption(getText("IGUI_Replace_Bandage"), nil)
        local subMenu = context:getNew(context)
        context:addSubMenu(option, subMenu)
        for i=1,#types do
            local item = self:getItemOfType(self.items.ITEMS, types[i])
            subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, types[i])
        end
    end
end

function HReplaceBandage:dropItems(items)
    local types = self:getAllItemTypes(items)
    if #self.items.ITEMS > 0 and #types == 1 and self.bodyPart:damaged() then
        self:onMenuOptionSelected(types[1])
        return true
    end
    return false
end

function HReplaceBandage:isValid(itemType)
    self:checkItems()
    return self:getItemOfType(self.items.ITEMS, itemType) and self.bodyPart:bandaged()
end

function HReplaceBandage:perform(previousAction, itemType)
    local removeBandage = ISApplyBandage:new(self:getDoctor(), self:getPatient(), nil, self.bodyPart, false)
    ISTimedActionQueue.addAfter(previousAction, removeBandage)

    local item = self:getItemOfType(self.items.ITEMS, itemType)
    previousAction = self:toPlayerInventory(item, previousAction)
    local addBandage = ISApplyBandage:new(self:getDoctor(), self:getPatient(), item, self.bodyPart, true)
    ISTimedActionQueue.addAfter(removeBandage, addBandage)
end

---------------------------------
--- Replace & Disinfect Bandage
---------------------------------

local HReplaceAndDisinfectBandage = BaseHandler:derive("HReplaceAndDisinfectBandage")

function HReplaceAndDisinfectBandage:new(panel, bodyPart)
    local o = BaseHandler.new(self, panel, bodyPart)
    o.items.ITEMS = {}
    o.items.ALCOHOL = {}
    return o
end

function HReplaceAndDisinfectBandage:checkItem(item)
    if item:getBandagePower() > 0 then
        self:addItem(self.items.ITEMS, item)
    elseif (item:hasComponent(ComponentType.FluidContainer) and item:getFluidContainer():getProperties():getAlcohol() >= 0.4 and (item:getFluidContainer():getAmount() > 0.15)) or (instanceof(item, "DrainableComboItem") and item:getAlcoholPower() == 4.0) then
        self:addItem(self.items.ITEMS, item)
    end

end

function HReplaceAndDisinfectBandage:addToMenu(context)
    local types = self:getAllItemTypes(self.items.ITEMS)
    if #types > 0 and self.bodyPart:bandaged() and #self.items.ALCOHOL > 0 then
        local option = context:addOption(getText("IGUI_Replace_&_Disinfect"), nil)
        local subMenu = context:getNew(context)
        context:addSubMenu(option, subMenu)
        for i=1,#types do
            local item = self:getItemOfType(self.items.ITEMS, types[i])
            subMenu:addOption(item:getName(), self, self.onMenuOptionSelected, types[i])
        end
    end
end

function HReplaceAndDisinfectBandage:dropItems(items)
    local types = self:getAllItemTypes(items)
    if #self.items.ITEMS > 0 and #types == 1 and self.bodyPart:damaged() then
        self:onMenuOptionSelected(types[1])
        return true
    end
    return false
end

function HReplaceAndDisinfectBandage:isValid(itemType)
    self:checkItems()
    return self:getItemOfType(self.items.ITEMS, itemType) and self.bodyPart:bandaged() and #self.items.ALCOHOL > 0
end

function HReplaceAndDisinfectBandage:perform(previousAction, itemType)
    local removeBandage = ISApplyBandage:new(self:getDoctor(), self:getPatient(), nil, self.bodyPart, false)
    ISTimedActionQueue.addAfter(previousAction, removeBandage)

    local alcohol = ReplaceBandage:GetBestDisinfectant(self.items.ALCOHOL)
    local getItem = self:toPlayerInventory(alcohol, removeBandage)

    local disinfect = ISDisinfect:new(self:getDoctor(), self:getPatient(), alcohol, self.bodyPart)
    ISTimedActionQueue.addAfter(getItem, disinfect)

    local item = self:getItemOfType(self.items.ITEMS, itemType)
    previousAction = self:toPlayerInventory(item, previousAction)
    local addBandage = ISApplyBandage:new(self:getDoctor(), self:getPatient(), item, self.bodyPart, true)
    ISTimedActionQueue.addAfter(disinfect, addBandage)
end

return
{
    HReplaceBandage = HReplaceBandage,
    HReplaceAndDisinfectBandage = HReplaceAndDisinfectBandage,
}