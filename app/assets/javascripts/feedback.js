// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {

  var state = {};
  var questionNames = ["feedback", "veteran_pii", "email"];
  var requiredQuestions = ["feedback", "email"];
  var errorMessages = {
    "feedback": "Make sure you’ve filled out the comment box below.",
    "email":  "Make sure you’ve entered a valid email address below."
  };
  var emailPattern = /^[A-Z0-9._%+-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i;

  init();

  function init() {
    initState();

    $("#feedback-form input, #feedback-form textarea").on("change keyup paste mouseup", function() {
      return reevalulate();
    });

    $("#feedback-form").on("submit", function() {
      return onSubmit();
    });
  }

  function reevalulate() {
    fetchState();
    processState();
    render();
  }

  function $question(questionName) {
    return $("#question" + questionName);
  }

  function questionValue(questionName) {
    return $question(questionName).find("input[type='text'], textarea, input[type='radio']:checked").val();
  }

  function fetchState() {
    questionNames.forEach(function(questionName) {
      state[questionName].value = questionValue(questionName);
    });
  }

  function processState() {
    requiredQuestions.forEach(function(questionName) {
      validateQuestion(questionName, false);
    });
  }

  function render() {
    requiredQuestions.forEach(function(questionName) {
      var error = state[questionName].error;
      var $q = $question(questionName);
      $q.find(".usa-input-error-message").html(error);
      $q.toggleClass("usa-input-error", !!error);
    });
  }

  function toggleQuestion(questionName) {
      var $q = $question(questionName);
      var hideQuestion = !state[questionName].show;

      $q.toggleClass('hidden-field', hideQuestion);
  }

  function onSubmit() {
    var invalidQuestionNames;

    fetchState();
    invalidQuestionNames = getInvalidQuestionNames();
    render();

    if (invalidQuestionNames.length > 0) {
      // remove loading style
      $(".cf-form").removeClass("cf-is-loading");
    }
    return invalidQuestionNames.length === 0;
  }

  function getInvalidQuestionNames() {
    return requiredQuestions.filter(function(questionName){
      return !validateQuestion(questionName, true);
    });
  }

  function validateQuestion(questionName, showError) {
    var questionState = state[questionName];
    var isValid = !!questionState.value || !questionState.show;

    if (isValid && questionName === "email") {
      isValid = emailPattern.test(questionState.value);
    }

    if(isValid) {
      questionState.error = null;
    }
    else if(showError) {
      questionState.error = errorMessages[questionName];
    }

    return isValid;
  }

  function initState() {
    questionNames.forEach(function(questionName) {
      state[questionName] = { show: true };
    });
    requiredQuestions.forEach(function(questionName) {
      $question(questionName).find(".question-label").append(
        $("<span class='cf-required italic'> Required</span>")
      );
    });
  }
});
