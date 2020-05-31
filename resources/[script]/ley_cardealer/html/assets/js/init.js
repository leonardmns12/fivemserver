$(document).ready(function(){
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'open') {
      var type      	= event.data.type;
      var userData  	= event.data.array['user'][0];
      var regPlate  	= event.data.array['regPlate'];
      var regModel  	= event.data.array['regModel'];
      var regDate  		= event.data.array['regDate'];
      var regPayment  	= event.data.array['regPayment'];
	  
      if ( type == null) {    
        $('#first-name').text(userData.firstname);
        $('#last-name').text(userData.lastname);
        $('#dob').text(userData.dateofbirth);
        $('#reg-plate').text(regPlate);
        $('#reg-model').text(regModel);
        $('#reg-date').text(regDate);
        $('#reg-payment').text(regPayment);
      }

      $('#reg-paper').show();
    } else if (event.data.action == 'close') {
      $('#first-name').text('');
      $('#last-name').text('');
      $('#dob').text('');
      $('#reg-plate').text('');
      $('#reg-model').text('');
      $('#reg-date').text('');
      $('#reg-payment').text('');
      $('#reg-paper').hide();
    }
  });
});
