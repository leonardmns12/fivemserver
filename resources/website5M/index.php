<?php
session_start();
  require 'connection.php';

  if(isset($_POST["register"])){
    
    if( registrasi($_POST) > 0 ){
			echo "<script> 
					alert('registrasi berhasil!');
			</script>";
		} else{
			echo mysqli_error($conn);
    }
    
  }

  if(isset($_POST["login"])){
    $username1 = $_POST["username1"];
    $password1 = $_POST["password1"];
     
    $result1 = mysqli_query($conn, "SELECT * FROM loginlauncher_users WHERE username = '$username1' AND password = '$password1'");

    if( mysqli_num_rows($result1) == 1 ){

      $_SESSION["login"] = true;
      $_SESSION["username"] = $username1;
      header("Location: Home.php");
 
    }else{
      echo "<script>alert('Username atau password salah!');</script>";
    }
    $error = true;
  }

?>


<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- <link rel="stylesheet" href="/css/index.css"> -->
    <!-- Bootstrap CSS -->
  
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <script src="https://kit.fontawesome.com/4696d6047b.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" type="text/css" href="css/index.css"/>
    <style>
    body{
    background-repeat: no-repeat;
    background-size: 96%;
    background-color: rgba(33, 33, 33, 1);
    background-image: url('image/IFR.png');
    background-position-x: center;
    background-position-y: -5%;
    }
    </style>


  </head>
  <body>

    <div style="display:flex; flex-direction:column"> 

      <nav class="navbar navbar-expand-lg navbar-light">
        <!-- <a class="navbar-brand" href="#">Navbar</a> -->
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
          <div class="navbar-nav">
            <!-- <a class="nav-item nav-link active" href="#">Home <span class="sr-only">(current)</span></a> -->
            <!-- <a class="nav-item nav-link" href="#">Features</a> -->
            <button class="btn nav-link navbar-button" data-toggle="modal" data-target="#Loginmodal">Login</button>
            <button class="btn nav-link navbar-button" data-toggle="modal" data-target="#RegisterModal">Register</button>
          </div>
        </div>
      </nav>


      
      <div class="row">
        <div class="col-xs-2 search-input-position" style="display:flex;">
          <input type="text" class="form-control search-input" placeholder="Search">
            <div class="input-group-btn">
              <button class="btn btn-default btn-input" type="submit">
                <i class="fas fa-search"></i>
              </button>
          </div>
      </div>
      
    </div>
      <div class="container-fluid">
        <!-- <img src="image/IFR.png" alt="IFR" style="width:97%;"> -->
      </div>
      <!-- Button trigger modal -->

    
    <!-- Modal Login -->
      <div class="modal fade" id="Loginmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
          <div class="modal-content" style="background-color: rgba(33, 33, 33, 0.65)">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalCenterTitle" style="color:white;">Login</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true" style="color: #FFF;">&times;</span>
              </button>
            </div>
             <form action="" method="post">
              <div class="modal-body">
                    <div class="input-group mb-3">
                      <div class="input-group-prepend">
                        <span class="input-group-text" id="basic-addon1"><i class="fas fa-user"></i></span>
                      </div>
                      <input type="text" name="username1" class="form-control" placeholder="Username" aria-label="Username" aria-describedby="basic-addon1" required>
                    </div>
                    <div class="input-group mb-3">
                      <div class="input-group-prepend">
                        <span class="input-group-text" id="basic-addon1"><i class="fas fa-lock"></i></span>
                      </div>
                      <input type="password" name="password1" class="form-control" placeholder="password" aria-label="Username" aria-describedby="basic-addon1" required>
                    </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="submit" name="login" class="btn" style="background-color: #871111; color:#fff;">Login</button>
              </div>
          </div>
          </form>
        </div>
      </div>


      <!-- Modal Register -->
      <div class="modal fade" id="RegisterModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
          <div class="modal-content" style="background-color: rgba(33, 33, 33, 0.65)">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalCenterTitle" style="color:white;">Register</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true" style="color: #FFF;">&times;</span>
              </button>
            </div>
              <div class="modal-body">
              <form accept="" method="POST">
                  <div class="input-group mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text" id="basic-addon1"><i class="fas fa-user"></i></span>
                    </div>
                    <input type="text" class="form-control" name="username" placeholder="Username" aria-label="Username" aria-describedby="basic-addon1" required>
                  </div>
                  <div class="input-group mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text" id="basic-addon1"><i class="fas fa-lock"></i></span>
                    </div>
                    <input type="password" name="password" class="form-control" placeholder="Password" aria-label="Password" aria-describedby="basic-addon1" required>
                  </div>
                  <div class="input-group mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text" id="basic-addon1"><i class="fas fa-lock"></i></span>
                    </div>
                    <input type="password" class="form-control" name="password2" placeholder="Password confirmation" aria-label="Password" aria-describedby="basic-addon1" required>
                  </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <input type="submit"name="register" class="btn" style="background-color: #871111; color:#fff;" value="Register" />     
              </div>
              </form>
              </div>
          </div>
        </div>
      </div>




    </div>
    


    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
  </body>
</html>