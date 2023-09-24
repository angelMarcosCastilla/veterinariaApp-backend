<?php
require_once '../models/Mascota.php';
$mascota = new Mascota();

if(isset($_GET["operacion"])){

  if($_GET["operacion"] == "obtenerdetallemascota"){
    $dni = $_GET["dni"];
    $data = $mascota->detalleMascotas($dni);
    echo json_encode( $data);
  }

  if($_GET["operacion"] == "listarAnimales"){
    $data = $mascota->listarAnimales();
    echo json_encode( $data);
  }

  if($_GET["operacion"] == "listarRazas"){
    $data = $mascota->listarRazas($_GET["idanimal"]);
    echo json_encode($data);
  }

  if($_GET["operacion"] == "detalleMascota"){
    $data = $mascota->obtenerMascota($_GET["idmascota"]);
    echo json_encode($data);
  }

}

if(isset($_POST["operacion"])){

  if($_POST["operacion"] = "registrarmascota"){
    $uploadDirectory = "";
    $fileName = "";
    $uploadFilePath = "";

    if ($_POST['fotografia'] != "") {
      $uploadDirectory = "../img/";
      $fileName = sha1(date('c')) . '.jpg';
      $uploadFilePath = $uploadDirectory . $fileName;

      file_put_contents($uploadFilePath, base64_decode($_POST['fotografia']));
    }
    $data = [
      "idcliente" => $_POST["idcliente"],
      "idraza" => $_POST["idraza"],
      "nombre" => $_POST["nombre"],
      "fotografia" => $fileName,
      "genero" => $_POST["genero"],
      "color" => $_POST["color"]
    ];
    $mascota->registrarMascotas($data);
    
  }

  if($_POST["operacion"] == "eliminarmascota"){
    $idmascota = $_POST["idmascota"];
    $mascota->eliminarMascota($idmascota);
  }
}