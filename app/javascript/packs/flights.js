(function() {
  $(function() {
    return $(document).on('change', '#departure_select', function(evt) {
      return $.ajax('update_airports', {
        type: 'GET',
        dataType: 'script',
        data: {
          departure_airport_id: $("#departure_select option:selected").val()
        },
        error: function(jqXHR, textStatus, errorThrown) {
          return console.log(`AJAX Error: ${textStatus}`);
        },
        success: function(data, textStatus, jqXHR) {
          return console.log("Dynamic arrival select OK");
        } 
      });
    });
  });

}).call(this);