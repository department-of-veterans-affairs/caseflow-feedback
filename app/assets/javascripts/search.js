// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {

  var state = {};
  var TYPEAHEAD_DELAY = 2000;
  var SEARCH_URL = '/search';

  function init() {
    initState();

    $( "#search-field" ).keyup( function() {
      state.term = this.value;
      state.timers.push(setTimeout(function(){
        reevaluate();}, TYPEAHEAD_DELAY));
    });
  }

  function initState() {
      state.feedback = [];
      state.timers = [];
      state.data_valid = false;
      state.data = $('.data').data('feedback');
      state.table = document.getElementById("feedback");
      state.pagination = $('#pagination');
      if (state.data != null && state.data.length !== 0) {
        processState();
        render();
      }
  }

  function reevaluate() {
    
    resetState();
    fetchState();
  }

  function resetState() {
    state.data = {};
    state.table.empty();
    state.pagination.empty();
    state.data_valid = false;
    state.feedback = [];
    state.timers.forEach(function (value) {
      clearTimeout(value);
    });
  }

  function fetchState() {
     $.get( SEARCH_URL, {search: state.term}, function( data ) {
      state.data = data;
        validateData();
        if (state.data_valid) {
          processState();
          render();
        }
    });
  }

  function processState() {

    state.data.forEach(function (value, i) {
      state.feedback[i] = {};
      state.feedback[i].user = typeof value.contact_email === "undefined" ? value.username :  value.contact_email;
      state.feedback[i].date = getFormattedDate(value.created_at);
      state.feedback[i].app = value.subject;
      state.feedback[i].feedback = value.feedback;
      state.feedback[i].github_url = value.github_url;
      state.feedback[i].issue = getIssueNumber(value.github_url);
      state.feedback[i].pii = value.veteran_pii;
    });

  }

  function render() {
    
    state.feedback.forEach(function (value) {
      var tr = state.table.insertRow();
       var userCell = tr.insertCell();
       userCell.innerHTML = '<td class="user-col">'+value.user+'</td>';
       var dateCell = tr.insertCell();
       dateCell.innerHTML = '<td class="date-col">'+value.date+'</td>';
       var appCell = tr.insertCell();
       appCell.innerHTML = '<td class="app-col">'+value.app+'</td>';
       var feedbackCell = tr.insertCell();
       feedbackCell.innerHTML = '<td class="feedback-col">'+value.feedback+'</td>';
       var issueCell = tr.insertCell();
       issueCell.innerHTML = '<td class="issue-col"><a target="_blank" href='+value.github_url+'>'+value.issue+'</a></td>';
       var piiCell = tr.insertCell();
       piiCell.innerHTML = '<td class="pii-col">'+value.pii+'</td>';
    }); 
  }

  function validateData() {
    if (state.data != null && state.data.length !== 0) {
      state.data_valid = true;
    }
  }

  function getFormattedDate(date_string) {
    date_string = new Date(date_string).toISOString();
    var date = date_string.substring(0,10);
    var month = date.substring(5,7);
    var day = date.substring(8,10);
    var year = date.substring(2,4);

    return month + '/' + day + '/' + year;
  }

  function getIssueNumber(url) {
    return /[^/]*$/.exec(url)[0];
  }

  init();
});
