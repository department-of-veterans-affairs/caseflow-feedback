// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {
  $('.cf-form').submit(function () {
    window.validated = true;
    var testEmail = /^[A-Z0-9._%+-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
    var errors = {
      "1" :   { "message": "Make sure you’ve entered a valid email address below." },
      "2" :   { "message": "Make sure you’ve filled out the comment box below." }
    };
    // Check if textarea or input is empty
    $($(this).find( 'textarea, input[type!="hidden"]' ).get().reverse()).each(function (index) {
        // Add error class, add error message, add focus and adjust width
        function addError(element) {
          $(element).parent().addClass('usa-input-error');
          $('.usa-input-error-message:eq('+(2-index) +')').text(errors[index]["message"]);
          $(element).css("width", '46rem');
          $(element).focus();
          window.validated = false;
        }

        function removeError(element) {
          $(element).parent().removeClass();
          $('.usa-input-error-message:eq('+(2-index)+')').empty();
        }
        // If it is empty add error
        if ( ! $(this).val() ) {
          addError($(this));
        } else
        {
          // If there was an error, remove it since field is not empty
          if ($(this).parent().attr('class') === 'usa-input-error') {
            removeError($(this));
          }
          // Although field is not empty check if email is valid
          if ((index === 1) && (!testEmail.test($(this).val()))){
            addError($(this));
          }
        }

    });

    return window.validated;
  });



});
