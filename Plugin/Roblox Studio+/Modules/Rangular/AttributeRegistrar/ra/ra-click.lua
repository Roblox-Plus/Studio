-- CodeSync: ModuleScript (2/18/2019 3:40:28 AM)
local attributeTypes = require(script.Parent.Parent.AttributeTypes)
local attributeValueParser = require(script.Parent.Parent.AttributeValueParser)
local eventContextProvider = require(script.Parent.Parent.EventContextProvider)

return {
	["type"] = attributeTypes.instance,

	trigger = function(attribute, instance, activeComponent, value, instanceComponent)
		assert(instance:IsA("GuiObject") or instance:IsA("ClickDetector"), "Expected ra-click to be used with GuiObject or ClickDetector (got " .. instance.ClassName .. ")")

		value = attributeValueParser:parseAttributeValue(activeComponent.controller, value)
		assert(typeof(value) == "function", "Expected ra-click value to be function (got " .. typeof(value) .. ")")

		local function mouseClick(...)
			value(eventContextProvider:buildEventContext(instanceComponent, instance), ...)
		end

		if (instance:IsA("GuiObject")) then
			instance.InputEnded:connect(function(input, ...)
				if (input.UserInputType == Enum.UserInputType.MouseButton1) then
					mouseClick(input, ...)
				end
			end)
		elseif (instance:IsA("ClickDetector")) then
			instance.MouseClick:connect(mouseClick)
		end

		return {}
	end
}

-- WebGL3D
