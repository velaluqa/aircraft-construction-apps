@expectRounded = (val, precision = 4) ->
  factor = Math.pow(10, precision)
  v = if val > 0
    Math.round(val * factor) / factor
  else
    - Math.round(- val * factor) / factor
  v = 0 if v is -0
  v = null if v isnt v
  expect(v)

@roundArray = (array, precision = 4, predicate) ->
  for val, i in array
    if _.isArray(val)
      @roundArray(val, precision, predicate)
    else
      round = true
      if _.isNumber(predicate)
        v = round = ((i+1) % predicate is 0)
      else if _.isFunction(predicate)
        v = round = predicate(val, i)
      if round
        factor = Math.pow(10, precision)
        _int = val * factor
        if val > 0
          v = Math.round(_int) / factor
        else
          v = - Math.round(-_int) / factor
      else
        v = val
      if v is -0
        0
      else
        v

@expectRoundedArray = ->
  expect(roundArray.apply(this, arguments))
