<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>distance between user origin and destination</title>
<link href="bootstrap.min.css" />
<link rel="preconnect" href="https://fonts.gstatic.com">
<script src="https://kit.fontawesome.com/ab2155e76b.js"
	crossorigin="anonymous">
	
</script>

<link
	href="https://fonts.googleapis.com/css2?family=Poppins&display=swap">

<!-- using css -->
<style>
/*add font family,*/
html, body {
	height: 100%;
	margin: 0;
	padding: 0;
}

.fa-map-marker-alt, .fa-dot-circle {
	color: #5bc0de;
}

.jumbotron {
	background-color: transparent;
	text-align: center;
}

.jumbotron h1 {
	letter-spacing: 2.5px;
	font-size: 3.5em;
}

.jumbotron h1, .jumbotron p {
	text-align: center;
}

#floating-panel {
	position: absolute;
	top: 10px;
	left: 25%;
	z-index: 5;
	background-color: #fff;
	padding: 5px;
	border: 1px solid #999;
	text-align: center;
	font-family: 'Roboto', 'sans-serif';
	line-height: 30px;
	padding-left: 10px;
	opacity: 0.8;
}

#googleMap {
	width: 100%;
	height: 700px;
	margin: 18px auto;
}
/*output box*/
#output {
	text-align: center;
	font-size: 2em;
	margin: 20px auto;
}

#mode {
	color: blue;
}

.weather {
	text-align: center;
	font-size: 1em;
}

.weather h2 {
	margin-bottom: 0;
	align-items: center;
} /* .weather img{ transform: scale(2); } */
</style>
</head>
<body>
	<div class="jumbotron">
		<div class="container-fluid">

			<div id="floating-panel">
				<p>PROVIDE ORIGIN AND DESTINATION</p>

				<form class="form-horizontal">
					<div class="form-group">

						<div class="col-xs-4">
							<input type="text" id="from" placeholder="Origin"
								class="form-control">
						</div>
					</div>
					<div class="form-group">

						<div class="col-xs-4">
							<input type="text" id="to" placeholder="Destination"
								class="form-control">


						</div>
					</div>
					<b>Mode of Travel</b> <select id="mode">
						<option value="DRIVING">Driving</option>
						<option value="WALKING">Walking</option>
						<option value="BICYCLING">Bicycling</option>
						<option value="TRANSIT">Transit</option>

					</select>

				</form>
				<form id="form">
					<input type="text" id="search" placeholder="Search By Loaction"
						autocomplete="off">
				</form>
				<main id="main"></main>




				<div class="col-xs-offset-2 col-xs-10">
					<button class="btn btn-info btn-lg " onclick="routecalculation();">ENTER

					</button>
				</div>


			</div>
		</div>
	</div>
	<div class="container-fluid">
		<div id="googleMap"></div>
		<div id="output"></div>
	</div>


	<!-- javascript for google API access -->
	<script
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBAh14jX_szt0Dz-eG_aPWZ_T29kYhM6g8&libraries=places"></script>
	<!--download and host jQuery through CDN -->
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

	<!-- to include jquery inside our program -->
	<script src="jquery-3.1.1.min.js"></script>


	<script>
		var myLatLng = {
			lat : 27.1766701,
			lng : 78.0080745
		};
		var mapOptions = {
			center : myLatLng,
			zoom : 14,
			mapTypeId : google.maps.MapTypeId.ROADMAP

		};

		//create map
		var map = new google.maps.Map(document.getElementById('googleMap'),
				mapOptions);

		//DirectionsService object to use the route method and get a result for our request
		var directionsService = new google.maps.DirectionsService();

		//create a DirectionsRenderer object which we will use to display the route
		var directionsDisplay = new google.maps.DirectionsRenderer();

		//bind the DirectionsRenderer to the map
		directionsDisplay.setMap(map);
		
        routecalculation(directionsService, directionsDisplay);
		
		
		document.getElementById("mode").addEventListener("change", () => {
		
			calculateAndDisplayRoute(directionsService, directionsDisplay);
		
		});

		//define routecalculation() function
		function routecalculation() {
			const selectedMode = document.getElementById("mode").value;
			//create request
			var request = {
				origin : document.getElementById("from").value,
				destination : document.getElementById("to").value,
				travelMode : google.maps.TravelMode.WALKING, //WALKING, BYCYCLING, TRANSIT
				unitSystem : google.maps.UnitSystem.IMPERIAL
			}

			//pass the request to the route method
			directionsService
					.route(
							request,
							function(result, status) {
								if (status == google.maps.DirectionsStatus.OK) {

									//Get distance and time
									const output = document
											.querySelector('#output');
									output.innerHTML = "<div class='alert-info'>From: "
											+ document.getElementById("from").value
											+ ".<br />To: "
											+ document.getElementById("to").value
											+ ".<br /> distance <i class='fas fa-road'></i> : "
											+ result.routes[0].legs[0].distance.text
											+ ".<br />Duration <i class='fas fa-hourglass-start'></i> : "
											+ result.routes[0].legs[0].duration.text
											+ ".</div>";

									//display route
									directionsDisplay.setDirections(result);
								} else {
									//delete route from map
									directionsDisplay.setDirections({
										routes : []
									});

									map.setCenter(myLatLng);

									//show error message
									output.innerHTML = "<div class='alert-danger'><i class='fas fa-exclamation-triangle'></i> Could not retrieve driving distance.</div>";
								}
							});

		}

		//create autocomplete objects for all inputs
		var options = {
			types : [ '(cities)' ]
		}

		var input1 = document.getElementById("from");
		var autocomplete1 = new google.maps.places.Autocomplete(input1, options);

		var input2 = document.getElementById("to");
		var autocomplete2 = new google.maps.places.Autocomplete(input2, options);

       const apiKey = "2f82c29f0281b868271a59736da45f89";

       const search = document.getElementById('search');
  
       const url = (city)=> `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}`;


       async function getWeatherByLocation(city){
     
         const resp = await fetch(url(city), {
             origin: "cros" });
         const respData = await resp.json();
     
           addWeatherToPage(respData);
          
     }

      function addWeatherToPage(data){
          const temp = Ktoc(data.main.temp);

          const weather = document.createElement('div')
          weather.classList.add('weather');

          weather.innerHTML = `
          <h2><img src="https://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png" /> ${temp}°C <img src="https://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png" /></h2>
          <small>${data.weather[0].main}</small>
          
          `;


        //   cleanup 
          main.innerHTML= "";
           main.appendChild(weather);
      };


     function Ktoc(K){
         return Math.floor(K - 273.15);
     }



     form.addEventListener('submit',(e) =>{
        e.preventDefault();

        const city = search.value;

        if(city){
            getWeatherByLocation(city)
        }

     });
    </script>
</body>
</html>


