# The ager bar

# ager = {}
#
# ager.element = {}
# ager.element.parent = $ '#ager'
# ager.element.age = $ '#ager-age'
# ager.element.day = $ '#ager-day'
#
# ager.birthdate = new Date 'November 16, 1995 14:00:00'
# ager.today = new Date Date.now()
# ager.age = Math.floor (ager.today - ager.birthdate) / 31536000000
#
# ager.nextBirthday = new Date ager.birthdate.getTime()
#
# if (ager.today.getFullYear() - ager.birthdate.getFullYear()) == ager.age
#   ager.nextBirthday.setFullYear ager.today.getFullYear() + 1
# else
#   ager.nextBirthday.setFullYear ager.today.getFullYear()
#
# ager.lastBirthday = new Date ager.nextBirthday.getTime()
# ager.lastBirthday.setFullYear ager.lastBirthday.getFullYear() - 1
#
# ager.dayDiff = Math.floor (ager.today - ager.lastBirthday) / 86400000
#
# ager.element.age.addClass('loading').css('width', ((50/100) * ager.age) + '%')
# ager.element.day.addClass('loading').css('width', ((50/365) * ager.dayDiff) + '%')
#
# ager.element.age
#   .attr('data-number', ager.age)
#   .removeClass('loading')
#   .addClass('loaded')
# ager.element.day
#   .attr('data-number', ager.dayDiff)
#   .removeClass('loading')
#   .addClass('loaded')

# Routing
timingMaterial = [.4, 0, .2, 1];

Finch.route '/', ->


Finch.route '/portfolio', ->
  # TODO: After having a full list of portfolios, implement this properly
  $('#portfolio').velocity "scroll", {
    duration: 1000
  }, timingMaterial

Finch.route '/about', ->
  # TODO: After having a full story of your life, implement this properly
  $('#about').velocity "scroll", {
    duration: 1000
  }, timingMaterial

Finch.route '/cv', ->
  # There's no local copy for now, redirect to LinkedIn
  # TODO: After making a local browser design, of course replace this
  window.location.replace 'http://cv.diagramatics.me'

Finch.route '/intro', ->
  Finch.navigate '/'
  $('#intro').velocity "scroll", {
    duration: 1000
  }, timingMaterial

Finch.route '/contact', ->
  $('#contact').velocity "scroll", {
    duration: 1000
  }

Finch.listen()



# Site addon
# A.K.A that rotating personal information text.

class Addon
  constructor: ->
    this.list = [
      'an abacus power-user'
      'a devotee of the PC master race'
      'an ambitious perfectionist'
      'an Android enthusiast'
      'a realistic person, or sometimes optimistical naive'
      'an Owl City fan'
    ]
    this.el = $('span[data-addon="active"]')
    this.delay = 3000

    this.activate()

  randomPick: ->
    tempNo = Math.floor(Math.random() * (this.list.length - 1))
    result = this.list[tempNo]
    this.list.push this.list.splice(tempNo, 1)
    return result

  changeText: ->
    t = this
    if this.running is true
      this.el.parent()
        .velocity({ opacity: 1 }, { duration: 400 })
        .velocity({ opacity: 0 }, { duration: 400, delay: this.delay, complete: ->
          t.el.html t.randomPick()
          t.changeText()
        })
    else this.el.parent().velocity({ opacity: 0 }, { duration: 400 })

  rotate: ->
    t = this
    this.timer = window.setInterval ->
      t.changeText()
    , 3000

  activate: ->
    this.running = true
    this.el.html this.randomPick()
    this.changeText()
    #this.rotate()

  deactivate: ->
    this.running = false
    this.changeText()

addon = new Addon

# Portfolio load
# Load every single portfolio item from the portfolio.json
class Portfolio
  constructor: ->
    this.el = $('#portfolioList')
    this.wipEl = $('#portfolioWip')

    xhr = this.loadData()
    t = this
    xhr.done( (data) ->
      t.insertData()
    )

  loadData: ->
    t = this
    xhr = $.getJSON 'scripts/portfolio.json', (data) ->
      t.data = data.items
      t.options = data.options

    return xhr

  formatListItem: (data) ->
    formattedType = 'data-' + data.status + ' data-' + data.type.join(' data-')
    if data.type[0] is "featured" then formattedFeatured = '
      <svg class="portfolio-list__icon-featured" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
        <use xlink:href="#svg-star" />
      </svg>
    ' else formattedFeatured = ''
    imageUrl = if data.imageUrl then data.imageUrl else ''
    imageLink = if data.url is '#' then '' else '<a class="portfolio-list__item-link" href="'+data.url+'" target="_blank" aria-label="'+data.name+'"></a>'
    return '
      <div class="portfolio-list__item" '+formattedType+'>
        '+formattedFeatured+
        imageLink+
        '<div class="portfolio-list__item-image-container">
          <img class="portfolio-list__item-image" src="'+imageUrl+'" alt="'+(if data.imageUrl then data.name)+'" />
        </div>
        <h2 class="portfolio-list__item-title">'+data.name+'</h2>
        <div class="portfolio-list__item-desc">'+data.desc+'</div>
      </div>
    '

  insertData: ->
    t = this

    this.wipEl.append this.options.projects.wip
    formattedHtml = []
    $.each this.data, (key, val) ->
      formattedHtml.push t.formatListItem(val)
    this.el.append formattedHtml.join("")

portfolio = new Portfolio

# Scroll watchers

navOuterHeight = $('#nav').outerHeight()

watchers = {}

watchers.intro = scrollMonitor.create $('#intro'), { bottom: -100 }
watchers.intro.enterViewport ->
  $('#nav').removeClass('is-opaque')
  addon.activate()

watchers.intro.exitViewport ->
  $('#nav').addClass('is-opaque')
  addon.deactivate()


# For "Portfolio" title animation purposes only
watchers.intro2 = scrollMonitor.create $('#intro'), { bottom: -300 }
watchers.intro2.enterViewport ->
  $('#portfolio').removeClass('is-in-view')

watchers.intro2.exitViewport ->
  $('#portfolio').addClass('is-in-view')


watchers.portfolio = scrollMonitor.create $('#portfolio'), { top: navOuterHeight * 4/3, bottom: -(navOuterHeight) }
watchers.portfolio.enterViewport ->
  # When the portfolio list is above the screen. Scrolling up and hiding nav.
  $('#nav').addClass('is-in-portfolio') if watchers.portfolio.isAboveViewport

watchers.portfolio.fullyEnterViewport ->
  # When the list is all in the screen, obviously it will cover up the nav.
  $('#nav').addClass('is-in-portfolio')

watchers.portfolio.partiallyExitViewport ->
  # Show the navbar
  # First one: scrolling down (isAboveViewport), no part of the list is still on the top (!isInViewport)
  # Second one: scrolling up (isBelowViewport), no part of the list is covering the whole screen (!isFullyInViewport)
  if (watchers.portfolio.isAboveViewport and !watchers.portfolio.isInViewport) or (watchers.portfolio.isBelowViewport and  !watchers.portfolio.isFullyInViewport)
    $('#nav').removeClass('is-in-portfolio')

watchers.portfolio.exitViewport ->
  # When it is fully gone, obviously show it.
  $('#nav').removeClass('is-in-portfolio')



watchers.about = scrollMonitor.create $('#about'), { top: navOuterHeight, bottom: -(navOuterHeight) }
watchers.about.enterViewport ->
  # When the about list is above the screen. Scrolling up and hiding nav.
  $('#nav').addClass('is-in-about') if watchers.about.isAboveViewport

watchers.about.fullyEnterViewport ->
  # When the list is all in the screen, obviously it will cover up the nav.
  $('#nav').addClass('is-in-about')

watchers.about.partiallyExitViewport ->
  # Show the navbar
  # First one: scrolling down (isAboveViewport), no part of the list is still on the top (!isInViewport)
  # Second one: scrolling up (isBelowViewport), no part of the list is covering the whole screen (!isFullyInViewport)
  if (watchers.about.isAboveViewport and !watchers.about.isInViewport) or (watchers.about.isBelowViewport and  !watchers.about.isFullyInViewport)
    $('#nav').removeClass('is-in-about')

watchers.about.exitViewport ->
  # When it is fully gone, obviously show it.
  $('#nav').removeClass('is-in-about')



watchers.headerLogo = scrollMonitor.create $('#headerLogo')
watchers.headerLogo.exitViewport ->
  $('#nav').addClass('is-after-header-logo')
watchers.headerLogo.enterViewport ->
  $('#nav').removeClass('is-after-header-logo')

# watchers.{ITEM} = scrollMonitor.create $('#{ITEM}'), { top: 50 }
# watchers.{ITEM}.enterViewport ->
#   # When the item is above the screen. Scrolling up and hiding nav.
#   $('#nav').addClass('is-hidden') if watchers.{ITEM}.isAboveViewport
# watchers.{ITEM}.fullyEnterViewport ->
#   # When the item is all in the screen, obviously it will cover up the nav.
#   $('#nav').addClass('is-hidden')
# watchers.{ITEM}.partiallyExitViewport ->
#   # Show the navbar
#   # First one: scrolling down (isAboveViewport), no part of the item is still on the top (!isInViewport)
#   # Second one: scrolling up (isBelowViewport), no part of the item is covering the whole screen (!isFullyInViewport)
#   if (watchers.{ITEM}.isAboveViewport and !watchers.{ITEM}.isInViewport) or (watchers.{ITEM}.isBelowViewport and  !watchers.{ITEM}.isFullyInViewport)
#     $('#nav').removeClass('is-hidden')
# watchers.{ITEM}.exitViewport ->
#   # When it is fully gone, obviously show it.
#   $('#nav').removeClass('is-hidden')



# Touch :hover adaptations
# $('.nav-item--blog a').click ->
#   $(this).addClass 'touch'
#   t = this
#   window.setTimeout ->
#     $(t).removeClass 'touch'
#   , 3000
