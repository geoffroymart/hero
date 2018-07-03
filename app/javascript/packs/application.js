import "bootstrap";

document.addEventListener('DOMContentLoaded', () => {
  window.setTimeout(function() {
    $(".alert").fadeTo(500, 0).slideUp(500, function(){
      $(this).remove();
    });
  }, 2000);
});

document.addEventListener('DOMContentLoaded', () => {
  window.setTimeout(function() {
    $(".alert-info").fadeTo(500, 0).slideUp(500, function(){
      $(this).remove();
    });
  }, 1000);
});

document.addEventListener('DOMContentLoaded', () => {
  window.setTimeout(function() {
    $(".alert-warning").fadeTo(500, 0).slideUp(500, function(){
      $(this).remove();
    });
  }, 2000);
});
