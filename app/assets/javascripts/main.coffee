# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready =  ->
  log_id = $('.main-table').data('id')
  $("li").find("[data-id= '"+log_id+"']").parent().addClass('active')

#  $("#search").on "click", (event) ->
#    event.preventDefault()
#    $('tr').each (index)->
#      element = $(this).find('td')
#      alert element.val()
#      if element.val == '8768'
#        element.fadeOut()



$(document).ready(ready)
$(document).on('page:load', ready)