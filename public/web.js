(function() {
  var auc;

  auc = {
    cookie_opt: {
      path: '/'
    },
    root_uri: location.protocol + "//" + location.host,
    color: false,
    html_template: false,
    text_template: false,
    shohin_title: false,
    shohin_detail: false
  };

  $(document).on("click", "#cookie-clear", function(e) {
    $.each(["color", "html_template", "text_template"], function(index, namespace) {
      if ($.cookie(namespace)) {
        auc[namespace] = false;
        return $.removeCookie(namespace, auc.cookie_opt);
      }
    });
    return $("#info").triggerHandler("auc_update");
  });

  $(function() {
    var get_json_data, update_preview;
    $(".color-picker").miniColors();
    /*
      helper
    */

    get_json_data = function(namespace) {
      if ($.cookie(namespace)) {
        return $.getJSON(auc.root_uri + "/" + namespace + "/" + $.cookie(namespace) + "/json", function(data) {
          auc[namespace] = data[namespace];
          return $("#info").triggerHandler("auc_update", [namespace]);
        });
      }
    };
    update_preview = function() {
      auc.shohin_title = $("#input input").attr("value");
      auc.shohin_detail = $("#input textarea").attr("value");
      if (auc.html_template) {
        $("#htmlsource textarea").attr("value", $.mustache(auc.html_template.contents, auc));
        return $("#preview").html($.mustache(auc.html_template.contents, auc));
      }
    };
    /*
      index
    */

    $.each(["#color", "#html_template", "#text_template"], function(index, selector) {
      var namespace;
      namespace = selector.replace("#", "");
      get_json_data(namespace);
      return $(selector).on("click", "a", function(e) {
        var id;
        id = $(this).attr("data-" + namespace);
        $.cookie(namespace, id, auc.cookie_opt);
        get_json_data(namespace);
        return e.preventDefault();
      });
    });
    $("#info").on("auc_update", function(e, namespace) {
      var $this, template;
      $this = $(this);
      $this.empty();
      template = "{{#color}}\n  <span class='label'>color</span> {{name}}\n{{/color}}\n{{#html_template}}\n  <span class='label'>html_template</span> {{name}}\n{{/html_template}}\n{{#text_template}}\n  <span class='label'>text_template</span> {{name}}\n{{/text_template}}";
      $this.html($.mustache(template, auc));
      return update_preview();
    });
    return $('a[data-toggle="tab"]').on('shown', function(e) {
      return update_preview();
    });
  });

}).call(this);
