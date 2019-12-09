$(document).ready(function() {
  $("div.reply-form").hide();
  $("a.showhide").click(function() {
    $(this).next().toggle().prevenDefault();
  });
});
