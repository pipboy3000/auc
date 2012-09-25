# auc object
auc =
  cookie_opt:
    path: '/'
  root_uri: location.protocol + "//" + location.host
  color: false
  html_template: false
  text_template: false
  shohin_title: false
  shohin_detail: false

# cookie clear
$(document).on("click", "#cookie-clear", (e)->
  $.each(["color", "html_template", "text_template"], (index, namespace)->
    if $.cookie(namespace)
      auc[namespace] = false
      $.removeCookie(namespace, auc.cookie_opt)
  )
  $("#info").triggerHandler("auc_update")
)

$ ->
  # color picker
  $(".color-picker").miniColors()

  ###
  helper
  ###

  # namespace -> color, html_template, text_template
  get_json_data = (namespace)->
    if $.cookie(namespace)
      $.getJSON(auc.root_uri + "/" + namespace + "/" + $.cookie(namespace) + "/json", (data)->
        auc[namespace] = data[namespace]
        $("#info").triggerHandler("auc_update", [namespace])
      )

  update_preview = ->
    auc.shohin_title = $("#input input").attr("value")
    auc.shohin_detail = $("#input textarea").attr("value")
    if auc.html_template
      $("#htmlsource textarea").attr("value", $.mustache(auc.html_template.contents, auc))
      $("#preview").html $.mustache(auc.html_template.contents, auc)

  ###
  index
  ###
  $.each(["#color", "#html_template", "#text_template"], (index, selector)->
    # namespace -> color, html_template, text_template
    namespace = selector.replace("#", "")

    # initialize check cookie, get data
    get_json_data(namespace)

    # select action
    $(selector).on("click", "a", (e)->
      id = $(@).attr "data-" + namespace
      $.cookie(namespace, id, auc.cookie_opt)
      get_json_data(namespace)
      e.preventDefault()
    )
  )

  $("#info").on("auc_update", (e, namespace)->
    $this = $(@)
    $this.empty()

    template = """
      {{#color}}
        <span class='label'>color</span> {{name}}
      {{/color}}
      {{#html_template}}
        <span class='label'>html_template</span> {{name}}
      {{/html_template}}
      {{#text_template}}
        <span class='label'>text_template</span> {{name}}
      {{/text_template}}
    """

    $this.html $.mustache(template, auc)
    update_preview()
  )

  $('a[data-toggle="tab"]').on('shown', (e)->
    update_preview()
  )




