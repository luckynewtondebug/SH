local BaseHandler = require("BaseHandler_V42")
local BaseHealthActions = require("BaseHealthActions_V42")
local CustomHealthActions = require("CustomHealthActions_V42")

if MiniHealthTreatment then
    function MiniHealthTreatment:doBodyPartContextMenu(bodyPart, context)
        local handlers = {}
        -- Base Handlers
        table.insert(handlers, BaseHealthActions.HRemoveBandage:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HApplyPlantain:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HApplyComfrey:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HApplyGarlic:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HApplyBandage:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HDisinfect:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HStitch:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HRemoveStitch:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HRemoveGlass:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HSplint:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HRemoveSplint:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HRemoveBullet:new(self, bodyPart))
        table.insert(handlers, BaseHealthActions.HCleanBurn:new(self, bodyPart))

        -- Custom Handlers
        table.insert(handlers, CustomHealthActions.HReplaceBandage:new(self, bodyPart))
        table.insert(handlers, CustomHealthActions.HReplaceAndDisinfectBandage:new(self, bodyPart))

        MiniHealthTreatment:checkItems(handlers)

        local optionsCount = 0

        for _,handler in ipairs(handlers) do
            handler:addToMenu(context, optionsCount)
            optionsCount = optionsCount + 1
        end

        if optionsCount <= 0 then
            context:addOption("No action available")
        end

    end

    -- BaseHandlerOverride
    function BaseHandler:getDoctor()
        return mhpHandle.player
    end

    function BaseHandler:getPatient()
        return mhpHandle.player
    end
end