$(document).ready ->
  if $.support.localStorage

    $(window.applicationCache).bind "error", ->
      console.log "There was an error when loading the cache manifest."

    # urls
    links_url       = "/links"
    links_json_url  = "/links.json"
    status_json_url = "/status.json"
    clear_all_url   = "/clear_all"
    # dom elements
    content         = $("#content")
    urlBox          = $("#url-box")
    linkTmpl        = $("#link_template")

    #
    # Methods
    #

    parseUrl = (url) ->
      regexp = /^((http[s]?|ftp):\/)?\/?([^:\/\s]+(\.\w{2,4}))(\/|)(...){0,20}$/i
      result = url.match(regexp)
      result[3].replace(/www\./g, "").toLowerCase()

    sendPending = ->
      if localStorage.getItem('isOnline')
        pendingLinks = $.parseJSON(localStorage.pendingLinks)
        if pendingLinks.length > 0
          item = pendingLinks[0]
          $.post links_url, item.data, (data) ->
            pendingLinks = $.parseJSON(localStorage.pendingLinks)
            pendingLinks.shift()
            localStorage.pendingLinks = JSON.stringify(pendingLinks)
            setTimeout sendPending, 100

    clearAll = ->
      if localStorage.getItem('isOnline')
        window.localStorage.setItem('toDelete', false)
        $.ajax
          type: "DELETE",
          dataType: "json",
          url: clear_all_url,
          data: {"_method":"delete"},
          success: (data) ->
            alert "All links deleted!"

    errorHandler = ->
      window.localStorage.setItem('isOnline', false)
      console.log "Connection was lost. Now you in Offline version. Try reconnect."

    request = ->
      $.ajax
        url: status_json_url,
        type: "GET",
        dataType:"json",
        success: (data, textStatus, xhr) ->
          if @xhr().status is 0
            errorHandler
          if xhr.status is 200
            window.localStorage.setItem('isOnline', true)
            getItems()
            sendPending() if localStorage.pendingLinks.length > 0
            clearAll() if localStorage.getItem('toDelete') is true
        error: errorHandler

    # Get all links and append to #content
    getItems = ->
      localStorage.pendingLinks = JSON.stringify([])  unless localStorage.pendingLinks
      $.retrieveJSON links_json_url, ((json, status, data) ->
        pendingLinks = $.parseJSON(localStorage.pendingLinks)
        content.html $("#link_template").tmpl(pendingLinks.reverse().concat(json))
      ), contentType: "application/json;charset=utf-8", mimeType: "application/json", dataType: "json"
    #
    # Events
    #

    $("#clear_all").click (e) ->
      $.each localStorage, (key, val) ->
        window.localStorage.removeItem key
      content.empty()
      window.localStorage.setItem('toDelete', true) if localStorage.getItem('isOnline') is false
      localStorage.pendingLinks = JSON.stringify([])  unless localStorage.pendingLinks
      $.ajax
        type: "DELETE",
        dataType: "json",
        url: clear_all_url,
        data: {"_method":"delete"},
        success: (data) ->
          alert "All links deleted!"

    $("form").submit (e) ->
      e.preventDefault()
      pendingLinks = $.parseJSON(localStorage.pendingLinks)
      item =
        data: $(this).serialize()
        link:
          url: parseUrl(urlBox.val())
      $("dt:contains(#{item.link.url})").remove()
      linkTmpl.tmpl(item).prependTo "#content"
      pendingLinks.push item
      localStorage.pendingLinks = JSON.stringify(pendingLinks)
      sendPending()
      urlBox.val ""
      false

    getItems()

    #
    # Ajax Long-polling
    #

    setInterval (->
      request()
    ), 15000

    sendPending()

    $(window).bind "online", sendPending

  else
    alert "Try a different browser."
