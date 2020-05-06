<?php

$servername = "server.indofolks.com";
$username = "root";
$password = "indofolksrp12";
$database = "zap467568-2";
$conn = mysqli_connect($servername, $username, $password, $database);

function registrasi($data) {
    global $conn;
    $username = strtolower(stripslashes($data["username"]));
    $password = mysqli_real_escape_string($conn , $data["password"]);
    $password2 = mysqli_real_escape_string($conn, $data["password2"]);

    $result = mysqli_query($conn , "SELECT username FROM loginlauncher_users WHERE username = '$username'");
    if( mysqli_fetch_assoc($result) ){
        echo "<script> alert('Username tidak dapat digunakan!')</script>";
        return false;
    }

    if ( $password != $password2 ){
        echo "<script> alert('Password tidak sesuai!');</script>";
        return false;
    }

    mysqli_query($conn, "INSERT INTO loginlauncher_users VALUES ('$username', '$password', '' , '','', 0 , '')");

    return mysqli_affected_rows($conn);

}

?>