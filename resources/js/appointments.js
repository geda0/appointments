$(document).ready(function () {
  $("form").each(function(){
        $(this).validate();
    });
});

$(document).on('submit', 'form', function (e) {
    $this = $(this);
    e.preventDefault();
    $.ajax( {
      type: "POST",
      url: $this.attr( 'action' ),
      data: $this.serialize(),
      success: templateAppointments
    } );

});

/**
* using jQuery template plugin to populate the Appointments
**/
function templateAppointments(data) {
  $("#app-table").html("");
  for (var a in data){
    dateArray = data[a]['datetime'].split(" ");
    data[a]['date'] = dateArray[0];
    data[a]['time'] = dateArray[1];
    $.tmpl("appointmentTemplate", data[a]).appendTo("#app-table");
  };
}
