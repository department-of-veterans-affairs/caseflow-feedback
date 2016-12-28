// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(document).ready(function () {
  $('.new_feedback').submit(function () {
    window.validated = true;
    var testEmail = /^[A-Z0-9._%+-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
    var errors = {
      "1" :   { "message": "Make sure you’ve entered a valid email address below." },
      "2" :   { "message": "Make sure you’ve filled out the comment box below." }
    };
    // Check if textarea or input is empty
    $($(this).find( 'textarea, input[type!="hidden"]' ).get().reverse()).each(function (index) {
        // Add error class, add error message, change border css, add focus and adjust width
        function addError(element) {
          $(element).parent().addClass('usa-input-error');
          $('.usa-input-error-message:eq('+(2-index) +')').text(errors[index]["message"]);
          $(element).addClass('error-border');
          $(element).css("width", 375);
          $(element).focus();
          validated = false;
        };

        function removeError(element) {
          $(element).parent().removeClass();
          $('.usa-input-error-message:eq('+(2-index)+')').empty();
          $(element).removeClass('error-border');
        }
        // If it is empty add error
        if ( ! $(this).val() ) {
          addError($(this));
        } else
        {
          // If there was an error, remove it since field is not empty
          if ($(this).parent().attr('class') == 'usa-input-error') {
            removeError($(this));
          }
          // Although field is not empty check if email is valid
          if ((index == 1) && (!testEmail.test($(this).val()))){
            addError($(this));
          }
        }

    });

    return validated
  });



});
