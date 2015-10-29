import $ from 'jquery'

import './showHide'

import './fancybox/lib/jquery.mousewheel-3.0.6.pack'
import './fancybox/source/jquery.fancybox.pack'
import './fancybox/source/helpers/jquery.fancybox-buttons'
import './fancybox/source/helpers/jquery.fancybox-media.js'
import './fancybox/source/helpers/jquery.fancybox-thumbs.js'

import './fancybox/source/jquery.fancybox.css!'
import './fancybox/source/helpers/jquery.fancybox-buttons.css!'
import './fancybox/source/helpers/jquery.fancybox-thumbs.css!'

import './tipsy/jquery.tipsy'
import './tipsy/tipsy.css!'

$(() => {
  console.log('jQuery version is: ' + $().jquery)

  $('html').removeClass('no-js')

  $('.divslide').showHide({
    speed: 500,  // speed you want the toggle to happen
    easing: '',  // the animation effect you want. Remove this line if you dont want an effect and if you haven't included jQuery UI
    changeText: 0 // if you dont want the button text to change, set this to 0
  })

   $('.divslide2').showHide({
    speed: 500,  // speed you want the toggle to happen
    easing: '',  // the animation effect you want. Remove this line if you dont want an effect and if you haven't included jQuery UI
    changeText: 0 // if you dont want the button text to change, set this to 0
  })

   $('.divslide3').showHide({
    speed: 500,  // speed you want the toggle to happen
    easing: '',  // the animation effect you want. Remove this line if you dont want an effect and if you haven't included jQuery UI
    changeText: 0 // if you dont want the button text to change, set this to 0
  })

  $('.shrink_work').tipsy({
    gravity: 's',
    live: true
  })

  $(".fancybox").fancybox()
})