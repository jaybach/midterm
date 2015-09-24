$(document).ready(function() {

  var MIN_NO_OF_ANSWERS = 2;
  var MAX_NO_OF_ANSWERS = 5;

  function getNumOfAnswers() {
    return $('.answer:visible').length;
  }

  $('.answers').children().slice(2-5).hide()

  $('.add_answer').on('click', function(e) {
    e.preventDefault();
    if (getNumOfAnswers() < MAX_NO_OF_ANSWERS) {
      $('.answer:hidden').first().show();
    }
  });

  $('.remove_answer').on('click', function(e) {
    e.preventDefault();
    if (getNumOfAnswers() > MIN_NO_OF_ANSWERS) {
      $('.answer:visible').last().hide();
    }
  });

});
