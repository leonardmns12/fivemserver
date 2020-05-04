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
    
    <style>
      <?php include 'css/index.css'; ?>
    </style>


  </head>
  <body>

    <div style="display:flex; flex-direction:column"> 

      <nav class="navbar navbar-expand-lg navbar-light">
            <div class="logo">
                <a href="Home.php"><img src="image/IFR2.png" alt="IFR"></a>
            </div>
            <span class="text">
                <p>
                    Welcome, 
                </p>
            </span>
        <!-- <a class="navbar-brand" href="#">Navbar</a> -->
        <!-- <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
          <div class="navbar-nav"> -->
            <!-- <a class="nav-item nav-link active" href="#">Home <span class="sr-only">(current)</span></a> -->
            <!-- <a class="nav-item nav-link" href="#">Features</a>
            <button class="btn nav-link navbar-button" data-toggle="modal" data-target="#Loginmodal">Login</button>
            <button class="btn nav-link navbar-button" data-toggle="modal" data-target="#RegisterModal">Register</button> -->
            
          <!-- </div>
        </div> -->
      </nav>
      
      <div class="row">
        <div class="col-xs-2 search-input-position" style="display:flex;">
          <input type="text" class="form-control search-input" placeholder="Coupon">
            <div class="input-group-btn">
              <button class="btn btn-default btn-input" type="submit">
                  <img src="image/coupon.png" alt="coupon" style="height:30px;">
                <!-- <i class="fas fa-search"></i> -->
              </button>
          </div>
      </div>
      
    </div>
      <div class="container-fluid">
        <div class="download_launcher">
            <button class="btn btn-default download">
                Download Launcher
                <img src="image/interface.png" alt="interface" style="height:40px; width:40px; margin-bottom:10px">
            </button>
        </div>
        <div class="wallet">
            <button class="btn btn-default wallets">
                <img src="image/wallet.png" alt="wallet" style="height:30px; width:30px">
                <span class="money">
                    <p>
                        150000
                    </p>
                </span>
            </button>
        </div>
        <div class="power">
            <a href="#"><img src="image/logout.png" alt="Logout" style="height:40px; width:40px"></a>
        </div>
        <div class="connect">
            <span class="hai">
                <p id="a">
                    You are  
                </p>
                <p style="color: #36A86B;" id="a1">
                    connected
                </p>
                <p id="to">
                    to FiveM
                </p>
            </span>
        </div>
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
            <form action="/index.html">
              <div class="modal-body">
                    <div class="input-group mb-3">
                      <div class="input-group-prepend">
                        <span class="input-group-text" id="basic-addon1"><i class="fas fa-user"></i></span>
                      </div>
                      <input type="text" class="form-control" placeholder="Username" aria-label="Username" aria-describedby="basic-addon1" required>
                    </div>
                    <div class="input-group mb-3">
                      <div class="input-group-prepend">
                        <span class="input-group-text" id="basic-addon1"><i class="fas fa-lock"></i></span>
                      </div>
                      <input type="password" class="form-control" placeholder="password" aria-label="Username" aria-describedby="basic-addon1" required>
                    </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="submit" class="btn" style="background-color: #871111; color:#fff;">Login</button>
              </div>
            </form>
          </div>
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
            <form>
              <div class="modal-body">
                  <div class="input-group mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text" id="basic-addon1"><i class="fas fa-user"></i></span>
                    </div>
                    <input type="text" class="form-control" placeholder="Username" aria-label="Username" aria-describedby="basic-addon1" required>
                  </div>
                  <div class="input-group mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text" id="basic-addon1"><i class="fas fa-lock"></i></span>
                    </div>
                    <input type="password" class="form-control" placeholder="Password" aria-label="Password" aria-describedby="basic-addon1" required>
                  </div>
                  <div class="input-group mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text" id="basic-addon1"><i class="fas fa-lock"></i></span>
                    </div>
                    <input type="password" class="form-control" placeholder="Password confirmation" aria-label="Password" aria-describedby="basic-addon1" required>
                  </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="submit" class="btn" style="background-color: #871111; color:#fff;">Register</button>
              </div>
              </div>
            </form>
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