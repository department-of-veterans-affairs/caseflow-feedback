// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {

  var state = {};
  var questionNames = ["feedback", "veteran_pii", "email"];
  var requiredQuestions = ["feedback", "email"];
  var incompleteErrorMessages = {
    "feedback": "Make sure you’ve filled out the comment box below.",
    "email":  "Make sure you’ve entered a valid email address below."
  };
  var patternErrorMessages = {
    "feedback": "Your feedback contains text that looks like personally identifiable information. Please remove the text \"{match}\" in order to submit.",
    "email": "Make sure you’ve entered a valid email address below."
  };
   var errorMessages = {
    "incompleteError": incompleteErrorMessages,
    "patternError": patternErrorMessages
  };
  var emailPattern = /^[A-Z0-9._%+-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
  var feedbackPattern = /(^|[^0-9])([0-9]{3}[- ]?[0-9]{2}[- ]?[0-9]{4}(?![0-9])S?|[0-9]{7,8}(?![0-9])C?)/i;

  function init() {
    initState();

    new window.CharacterCounter($question(questionNames[0]));

    $("#feedback-form input, #feedback-form textarea").on("change keyup paste mouseup", function() {
      return reevalulate();
    });

    $("#feedback-form").on("submit", function() {
      return onSubmit();
    });
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

  function reevalulate() {
    fetchState();
    processState();
    render();
  }

  function $question(questionName) {
    return $("#question" + questionName);
  }

  function questionValue(questionName) {
    return $question(questionName).find("input[type='text'], textarea, input[type='radio']:checked").val().trim();
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

  function validatePattern(questionName, questionValue) {
    switch (questionName) {
      case "feedback":
        return !feedbackPattern.test(questionValue);
      case "email":
        return emailPattern.test(questionValue);
    }
  }

  function findOffendingString(questionValue) {
    var pii = questionValue.match(feedbackPattern);
    return pii && pii[pii.length-1];
  }

  function findErrorType(questionName, questionValue) {
    if(!questionValue) {
      return "incompleteError";
    }
    if(!validatePattern(questionName, questionValue)) {
      return "patternError";
    }
  }

  function errorMessage(errorType, questionName) {
    if(errorType === "patternError" && questionName === "feedback") {
      var value = questionValue(questionName);
      var offendingString = findOffendingString(value);
      return errorMessages[errorType][questionName].replace("{match}", offendingString);
    }
    else {
      return errorMessages[errorType][questionName];
    }
  }

  function validateQuestion(questionName, showError) {
    var questionState = state[questionName];
    var errorType = findErrorType(questionName, questionState.value);
    var isValid = !errorType || !questionState.show;

    if(isValid) {
      questionState.error = null;
    }
    else if(showError) {
      questionState.error = errorMessage(errorType, questionName);
    }

    return isValid;
  }

  init();
});
