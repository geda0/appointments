$(document).ready(function () {
  $("form").each(function(){
        $(this).validate();
    });
  getAppointments();
});

$(document).on('click', '#search-btn', function (e) {
    e.preventDefault();
    getAppointments($("#search-field").val())
});


//serializing the form and calling "click" on the search button on document ready would have been a better option.
//following the requirements, creating getAppointments.
function getAppointments(search) {
  $.ajax( {
    type: "POST",
    url: "/cgi-bin/index.pl",
    data: {"search": search, "ajax": true},
    success: templateAppointments
  });
}

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
