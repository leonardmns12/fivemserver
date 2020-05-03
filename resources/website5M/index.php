<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://kit.fontawesome.com/4696d6047b.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="css/index.css">

    <style>
    body{
    background-image: url('bg.png');
    background-repeat: no-repeat;
    background-size: cover;
    background-color: #212121;

  }

  .navbar{
    background-color: #871111!important;
  }

  .navbar-button{
    justify-content: center;
    align-items : center;
    margin-top: 8px;
    background-color : #5E1717;
    color: #FFFFFF!important;
    font-family:'Kristen ITC';
    width : 100px;
    height : 40px;
    margin-bottom : 10px;
    font-size : 14px;
    border-radius : 40px;
    text-transform : uppercase;
  } 
  .search-input{
    border-radius: 40px;
    width : 120px;
    height : 30px;
    padding-left: 27px;
    border : 1px solid #707070;
    position : absolute;
    top: 12px;
    right: 10px;
    font-size: 12px;
    text-transform : uppercase;
  }

  .containers{
    background-image: url('bg.png');
    width: 1920px;

  }

  @media (min-width: 1200px) { 
    .navbar-button{
      margin-left : 36px;
    }

    .search-input{
      top: 18px;
      width : 275px;
      height : 40px;
      font-size: 18px;
      padding-left: 37px;
    }

    .navbar{
    background-color: #212121!important;
    }
  }
    </style>


  </head>
  <body>

    <div style="display:flex; flex-direction:column"> 

      <nav class="navbar navbar-expand-lg navbar-light" style="background-color: #212121">
      <!-- <a class="navbar-brand" href="#">Navbar</a> -->
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
        <div class="navbar-nav">
          <!-- <a class="nav-item nav-link active" href="#">Home <span class="sr-only">(current)</span></a> -->
          <!-- <a class="nav-item nav-link" href="#">Features</a> -->
          <button class="btn nav-link navbar-button" data-toggle="modal" data-target="#exampleModalCenter">Login</button>
          <button class="btn nav-link navbar-button">Register</button>
        </div>
      </div>
    </nav>
    <input placeholder="search" class="search-input" />
      <div class="containers">
      </div>
      <!-- Button trigger modal -->

    <!-- Modal -->
    <!-- Modal -->
<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header" style="background-color: rgba(33, 33, 33, 0.1)">
        <h5 class="modal-title" id="exampleModalCenterTitle" style="color:white;">Login</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" style="background-color: rgba(33, 33, 33, 0.1)">
          <form>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <span class="input-group-text" id="basic-addon1"><i class="fas fa-user"></i></span>
            </div>
            <input type="text" class="form-control" placeholder="Username" aria-label="Username" aria-describedby="basic-addon1">
          </div>
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <span class="input-group-text" id="basic-addon1"><i class="fas fa-lock"></i></span>
            </div>
            <input type="password" class="form-control" placeholder="password" aria-label="Username" aria-describedby="basic-addon1">
          </div>
          </form>
      </div>
      <div class="modal-footer" style="background-color: rgba(33, 33, 33, 0.1)">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Login</button>
      </div>
    </div>
  </div>
</div>




    </div>
    


    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
  </body>
</html>