timingMaterial = [.4, 0, .2, 1];



# Site addon
# A.K.A that rotating personal information text.

class Addon
  constructor: ->
    this.list = [
      'an abacus power-user'
      'an ambitious perfectionist'
      'a realistic person, or sometimes optimistically naive'
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

watchers.headerLogo = scrollMonitor.create $('#headerLogo')
watchers.headerLogo.exitViewport ->
  $('#nav').addClass('is-after-header-logo')
watchers.headerLogo.enterViewport ->
  $('#nav').removeClass('is-after-header-logo')

