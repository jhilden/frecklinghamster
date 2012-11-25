#= require jquery
#= require jquery_ujs
#= require_tree .

$ ->
  $('#js-facts-table').on 'change', '[data-role=fact-export-checkbox]', ->
    $input = $(@)
    $form = $("form#batch-export-facts-#{$input.closest('tr').data('day')}")
    ids = $form.find("input#fact_ids").val()
    minutes = parseInt($form.find("input#minutes").val())

    if $input.is(':checked')
      $form.find("input:disabled").removeAttr('disabled') # enable export form on first checkbox

      $input.closest('tr').addClass('info') # highlight row
      $form.find("input#minutes").val( minutes + $input.data('minutes') ) # add minutes
      $form.prepend $("<input type='hidden' id='fact_id_#{$input.val()}' name='fact_ids[]' value='#{$input.val()}' />") # add to fact_ids

    else
      $input.closest('tr').removeClass('info') # unhighlight row
      $form.find("input#minutes").val( minutes - $input.data('minutes') ) # remove minutes
      $form.find("input#fact_id_#{$input.val()}").remove() # remove from fact_ids

    $form.find("[name='fact_ids[]']").each -> console.log $(@).val()