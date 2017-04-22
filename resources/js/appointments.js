$(document).ready(function () {
  $("form").each(function(){
        $(this).validate();
    });
  getAppointments();

  $("#time-field").datetimepicker({
    datepicker:false,
    format:'H:i',
    step:5
  });

    $("#date-field").datetimepicker({
      timepicker:false,
      format:'Y-m-d',
      minDate:0
    });

});

$(document).on('click', '#search-btn', function (e) {
    e.preventDefault();
    getAppointments($("#search-field").val())
});

$(document).on('click', '.add-form-toggler', function (e) {
  e.preventDefault();
  $(this).hide();
  $(".add-form-item").show("slow");
});

$(document).on('click', '#add-form-cancel', function (e) {
  e.preventDefault();
  $(".add-form-item").hide("fast");
  $(".add-form-toggler").show();
});

//serializing the form and calling "click" on the search button on document ready would have been a better option.
//following the requirements, creating getAppointments.
function getAppointments(search) {
  $.ajax( {
    type: "POST",
    url: window.location.pathname,
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
