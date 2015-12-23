$(document).ready ->
  if $.support.localStorage
    parseUrl = (url) ->
      regexp = /^((http[s]?|ftp):\/)?\/?([^:\/\s]+(\.\w{2,4}))(\/|)(...){0,20}$/i
      result = url.match(regexp)
      result[3].replace(/www\./g, "").toLowerCase()

    sendPending = ->
      if window.navigator.onLine
        pendingLinks = $.parseJSON(localStorage.pendingLinks)
        if pendingLinks.length > 0
          item = pendingLinks[0]
          $.post "/links", item.data, (data) ->
            pendingLinks = $.parseJSON(localStorage.pendingLinks)
            pendingLinks.shift()
            localStorage.pendingLinks = JSON.stringify(pendingLinks)
            setTimeout sendPending, 100

    clearAll = ->
      if window.navigator.onLine && localStorage.key('toDelete')
        localStorage.removeItem('toDelete')
        $.post "/links/clear_all", {"_method":"delete"}, dataType: "json", (data) ->
          data.preventDefault()


    $(window.applicationCache).bind "error", ->
      console.log "There was an error when loading the cache manifest."

    localStorage.pendingLinks = JSON.stringify([])  unless localStorage.pendingLinks
    $.retrieveJSON "/links.json", (data) ->
      pendingLinks = $.parseJSON(localStorage.pendingLinks)
      $("#content").html $("#link_template").tmpl(pendingLinks.reverse().concat(data))


    $("#clear_all").click (event) ->
      event.preventDefault()
      localStorage.clear()
      $("#content").empty()
      localStorage.setItem('toDelete', true) unless window.navigator.onLine
      $.post "/links/clear_all", {"_method":"delete"}, dataType: "json", (data) ->
        alert "All links deleted!"

    $("#new_link").submit (event) ->
      event.preventDefault()
      pendingLinks = $.parseJSON(localStorage.pendingLinks)
      urlPath = parseUrl($("#url-box").val())
      item =
        data: $(this).serialize()
        link:
          url: urlPath

      $("dt:contains(#{item.link.url})").remove()
      $("#link_template").tmpl(item).prependTo "#content"
      pendingLinks.push item
      localStorage.pendingLinks = JSON.stringify(pendingLinks)
      sendPending()
      $("#url-box").val ""


    errorHandler = ->
      console.log "Connection was lost. Now you in Offline version. Try to connect."

    setInterval (->
      request()
    ), 15000

    request = ->
      $.ajax
        url: "/status.json",
        type: "GET",
        dataType:"json",

        success: (data, textStatus, xhr) ->
          if @xhr().status is 0
            errorHandler
          if xhr.status is 200
            console.log "200 ok"
            sendPending()

        error: errorHandler


    sendPending()
    $(window).bind "online", sendPending
  else
    alert "Try a different browser."
