ILR.DirectOperatingCosts ?= {}
ILR.DirectOperatingCosts.Views ?= {}
class ILR.DirectOperatingCosts.Views.Legend extends ILR.Views.Legend
  airplanesTemplate: _.template '
<div class="airplanes col">
  <div class="range">At <%= range %> km</div>
</div>
'

  airplaneTemplate: _.template '
<div>
  <span class="line-type<%= lineTypeClass %>"></span>
  <span><%= name %></span>
</div>
'

  renderValueHeaderColumn: ->
    $airplanes = $ @airplanesTemplate range: @range.toFixed(2)
    for calc, i in @calcs
      $airplanes.append @airplaneTemplate
        lineTypeClass: if i <= 0 then ' solid' else ' dashed'
        name: calc.airplane.get('name')
    @$wrapper.append($airplanes)

  calculatorFunction: (curve) -> curve.get('function')
