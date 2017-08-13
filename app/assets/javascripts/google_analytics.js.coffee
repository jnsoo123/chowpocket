class @GoogleAnalytics
  @load: ->
    window._gaq = []
    window._gaq.push ['_setAccount', GoogleAnalytics.analyticsId()]

    ga = document.createElement('script')
    ga.type = 'text/javasript'
    ga.async = true
    ga.src = ((if 'https:' is document.location.protocol then 'https://ssl' else 'http://www')) + '.google-analytics.com/ga.js'
    firstScript = document.getElementsByTagName('script')[0]
    firstScript.parentNode.insertBefore ga, firstScript

    if typeof Turbolinks isnt 'undefined' and Turbolinks.supported
      document.addEventListener 'page:change', (->
        GoogleAnalytics.trackPageview()
      ), true
    else
      GoogleAnalytics.trackPageview()

  @trackPageview: (url) ->
    unless GoogleAnalytics.isLocalRequest()
      if url
        window._gaq.push ['_trackPageview', url]
      else
        window._gaq.push ['_trackPageview']
      window._gaq.push ['_trackPageLoadTime']

  @isLocalRequest: ->
    GoogleAnalytics.documentDomainIncludes 'local'

  @documentDomainIncludes: (str) ->
    document.domain.indexOf(str) isnt -1

  @analyticsId: ->
    'UA-104385266-1'

GoogleAnalytics.load()
    
