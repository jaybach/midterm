$(function() {

// Getting answers input when a user submits a question

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

// Filtering by tags

  $(function() {
    $('.no_tag_filter_button').click(function(e) {
      $('.all').show("slow");
      e.preventDefault();
    });
  });

  $(function() {
    $('.tag1_filter_button').click(function(e) {
      $('.all').hide();
      $('.all.tag1').show("slow");
      e.preventDefault();
    });
  });

  $(function() {
    $('.tag2_filter_button').click(function(e) {
      $('.all').hide();
      $('.all.tag2').show("slow");
      e.preventDefault();
    });
  });

  $(function() {
    $('.tag3_filter_button').click(function(e) {
      $('.all').hide();
      $('.all.tag3').show("slow");
      e.preventDefault();
    });
  });

  $(function() {
    $('.tag4_filter_button').click(function(e) {
      $('.all').hide();
      $('.all.tag4').show(500);
      e.preventDefault();
    });
  });

  $(function() {
    $('.tag5_filter_button').click(function(e) {
      $('.all').hide();
      $('.all.tag5').show("slow");
      e.preventDefault();
    });
  });

  $(function() {
    $('.tag6_filter_button').click(function(e) {
      $('.all').hide();
      $('.all.tag6').show("slow");
      e.preventDefault();
    });
  });

// Adding question to a test

  $(function() {
    $('select#user_tests').click(function(e) {
      var question_selection = $('select option:selected').val()
    });
  });

});
