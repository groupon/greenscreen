function takeover(){
  var $content = $('.screen .content');

  $content.addClass('nyan');

  setTimeout(function(){
    $content.removeClass('nyan');
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
  new WOW().init();

  $('select.channel').change(function(e){
    var value = e.target.value;
    change($('select.greenscreen').val(), value);
  })

});
