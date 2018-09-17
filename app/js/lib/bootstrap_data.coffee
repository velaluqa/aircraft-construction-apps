isDocumentReady = false

ajaxFiles =
  'labels.default.yml':
    loaded: false
  'labels.overwrite.yml':
    loaded: false
    optional: true
  'settings.default.yml':
    loaded: false
  'settings.overwrite.yml':
    loaded: false
    optional: true

processAjaxData = ->
  try
    defaultLabels = jsyaml.load(ajaxFiles['labels.default.yml'].content)
  catch
    errorText = "Error: labels.default.yml does not contain valid YAML."
    alert(errorText)
    throw errorText
  ILR.strings = flattenObject(defaultLabels)

  overwriteLabelsDoc = ajaxFiles['labels.overwrite.yml'].content
  if overwriteLabelsDoc
    try
      overwriteLabels = jsyaml.load(overwriteLabelsDoc)
      flattenObject(overwriteLabels, ILR.strings)
    catch
      alert("Warning: labels.overwrite.yml does not contain valid YAML.")

  try
    ILR.settings = jsyaml.load(ajaxFiles['settings.default.yml'].content)
  catch
    errorText = "Error: settings.default.yml does not contain valid YAML."
    alert(errorText)
    throw errorText

  overwriteSettingsDoc = ajaxFiles['settings.overwrite.yml'].content
  if overwriteSettingsDoc
    try
      overwriteSettings = jsyaml.load(overwriteSettingsDoc)
      $.extend(true, ILR.settings, overwriteSettings)
    catch
      alert("Warning: settings.overwrite.yml does not contain valid YAML.")

maybeLoadedAjaxData = ->
  if isDocumentReady
    unless _.findWhere(_.values(ajaxFiles), { loaded: false })
      processAjaxData()
      startApp()

$(document).ready ->
  isDocumentReady = true
  maybeLoadedAjaxData()

for ajaxFile, state of ajaxFiles
  do (ajaxFile, state) ->
    $.ajax "#{ajaxFile}.txt",
      success: (data) ->
        state.loaded = true
        state.content = data
      error: ->
        if state.optional
          state.loaded = true
        else
          alert("Error: Failed to load #{ajaxFile}.")
      complete: ->
        maybeLoadedAjaxData()
