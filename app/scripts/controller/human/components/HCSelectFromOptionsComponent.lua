--- @class HCSelectFromOptionsComponent: HumanControllerComponent
--- @field decision SelectFromOptionsDecision
HCSelectFromOptionsComponent = class("HCSelectFromOptionsComponent", HumanControllerComponent)

function HCSelectFromOptionsComponent:onNewDecision()
    option_select_widget:setOptions(self.decision.options)
    option_select_widget.hidden = false
end

function HCSelectFromOptionsComponent:onOptionSelect(type, option)
    if self.decision:selected(option) then
        option_select_widget.hidden = true
    end
end

function HCSelectFromOptionsComponent:onCancel()
    if self.decision:cancelled() then
        option_select_widget.hidden = true
        return true
    end
end
