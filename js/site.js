function takeover(){
  var $content = $('.screen .content'),
      audio = $('audio')[0];

  $content.addClass('nyan');
  audio.play();

  setTimeout(function(){
    $content.removeClass('nyan');
    audio.pause();
    audio.currentTime = 0;
  }, 10000)
}

function alert(){
  var $alerts = $('.alert');

  $alerts.show();

  setTimeout(function(){
    $alerts.hide();
  }, 10000)
}

function change(num, value){
  $('#gscreen-' + num)
      .children('.content')
      .removeClass()
      .addClass('content ' + value)
}

$(document).ready(function(){

  $('select.channel').change(function(e){
    var value = e.target.value;
    change($('select.greenscreen').val(), value);
  })

});

new WOW().init();
