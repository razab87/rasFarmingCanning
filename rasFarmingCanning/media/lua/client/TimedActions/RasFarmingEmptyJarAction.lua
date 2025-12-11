-- timed action for pouring jar on ground
--
--
-- by razab








local emptyJarAction = ISBaseTimedAction:derive("emptyJarAction")


function emptyJarAction:isValid()
	return self.character:getInventory():contains(self.item);
end

function emptyJarAction:start()
    if self.item ~= nil then
	    self.item:setJobType(getText("IGUI_JobType_PourOut"));
	    self.item:setJobDelta(0.0);
	    self:setActionAnim(CharacterActionAnims.Pour);
	    self.sound = self.character:playSound("PourLiquidOnGround")
    end
end

function emptyJarAction:update()
    if self.item ~= nil then
        self.item:setJobDelta(self:getJobDelta());
    end
end

function emptyJarAction:stop()
	self:stopSound()
    ISBaseTimedAction.stop(self);
end

function emptyJarAction:perform()
	self:stopSound()
    if self.item ~= nil then
        local player = self.character
        player:getInventory():AddItem("Base.EmptyJar")
        player:getInventory():Remove(self.item)
    end
    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function emptyJarAction:stopSound()
	if self.sound and self.character:getEmitter():isPlaying(self.sound) then
		self.character:stopOrTriggerSound(self.sound);
	end
end

function emptyJarAction:new (character, item)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.item = item;
	o.stopOnWalk = false;
	o.stopOnRun = false;
	o.maxTime = 70
	if o.character:isTimedActionInstant() then o.maxTime = 1; end
	return o
end



return emptyJarAction




