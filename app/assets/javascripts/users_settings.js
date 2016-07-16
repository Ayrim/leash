
$(document).ready(function(){
    $('#user_is_walker').on('change', function() {
      if (this.checked)
      {
        $("#walkerinformation").show();
      }
      else
      {
        $("#walkerinformation").hide();
      }
    });
});