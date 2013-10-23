$(document).ready(function() {
 $('#tweetbox').on('submit', function(event){
  event.preventDefault();
  console.log('banana')
    $('#tweet').prop('disabled', true);
    $('#submit').prop('disabled', true);
  var data = {jonsdecision : $('#tweet').val(), timer : $('#timer').val()};
  console.log(data)
    $('h1').append("<div id='proccessed'><li>Your Post is being proccessed</li></div>")
  $.post('/tweet', data, function(){
  })
  .fail(function(){
  $('#proccessed').replaceWith("<div id='failed'><li>Tweet failed!</li></div>")
  })
  .done(function(){
  $('#proccessed').replaceWith("<div id='complete'><li>Tweet's been tweeted</li></div>")
  });

    $.get('/status',function(response){
    var sidekiq = response.job_id
    $.get('/status/' + sidekiq, function(response){
      $('.index').append(response)
    })
 })
  });
});
