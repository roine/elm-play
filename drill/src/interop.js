window.onload = function() {
  // var data = JSON.parse("{\"v1_report\":{\"v1_reporter_details\":{\"reporter_details_fieldset\":{\"zip_country_grid\":{\"postcode\":\"WC1V 6DX\",\"country\":\"UK\"},\"telephone_number\":\"01234 567890\",\"email\":\"reporter@mymedsandme.com\",\"address_line_2\":\"55-57 High Holborn\",\"address_line_1\":\"4th Floor Caroline House\",\"address_grid\":{\"town\":\"London\",\"county\":\"London\"}},\"personal_information_fieldset\":{\"names_grid\":{\"surname\":\"Reporter\",\"first_name\":\"Bob\"}},\"consent_to_contact\":false},\"v1_products_involved\":{\"names\":[\"ibuprofen\",\"paracetamol\"]},\"v1_patient_details\":{\"personal_data_grid\":{\"initials\":\"MMR\",\"gender\":\"female\"},\"other_product\":{\"names\":[\"other drug 1\",\"other drug 2\"]},\"birth_date_grid\":{\"birth_date_known\":true,\"birth_date\":\"2015-11-04\"},\"age_grid\":{\"age_unit\":\"years\",\"age\":15}},\"v1_medical_history\":{\"names\":[\"diabetes\",\"nerves\"]},\"v1_adverse_event_details\":{\"names\":[\"cough\",\"sneeze\",\"back pain\"],\"event_details_fieldset\":{\"start_date\":\"2015-10-05\",\"company_aware_date\":\"2015-10-05\",\"adverse_event_description\":\"Patient feels really bad\"}}}}")
  var data = [
    { path: ["v1_report", "adverse_event_description"], value: "Patient feels really bad" },
    { path: ["v1_report", "company_aware_date"], value: "2015-10-15" },
    { path: ["v1_report", "age"], value: 5}
  ]
  console.log(data);

  var app = Elm.fullscreen(Elm.Main, {
    initialData: data
  });

  app.ports.initialData.send(data)
};
