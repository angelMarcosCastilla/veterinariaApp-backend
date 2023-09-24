<?php
require_once '../models/Cliente.php';

$cliente = new Cliente();

if(isset($_GET['operacion'])){

  if($_GET["operacion"] == "buscarCliente"){
    $dni = $_GET["dni"];
    $datos = $cliente->buscarCliente($dni);
    echo json_encode($datos);
  }

  if($_GET["operacion"] == "buscarClienteMascotas"){
    $dni = $_GET["dni"];
    $datos = $cliente->buscarMascotasClientes($dni);
    echo json_encode($datos);
  }

  if($_GET["operacion"] == "listarCliente"){
    $datos = $cliente->listarCliente();
    echo json_encode($datos);
  }
}

if(isset($_POST['operacion'])){
  if($_POST["operacion"] == "registrarCliente"){
    $data = [
      "nombres" => $_POST["nombres"],
      "apellidos" => $_POST["apellidos"],
      "dni" => $_POST["dni"],
      "telefono" => $_POST["telefono"],
      "direccion" => $_POST["direccion"],
      "genero" => $_POST["genero"],
    ];
    
    $cliente->registrarCliente($data);

  }

  // login
  if($_POST["operacion"] == "login"){
    $username = $_POST["nombreusuario"];
    $password = $_POST["claveacceso"];

    $datos = $cliente->login($username);

    if(count($datos) == 0){
      echo json_encode(
        [
          "success" => false,
          "message" => "Usuario o contraseña incorrectos"
        ]
      );
    }

    if($datos[0]["claveacceso"] !=  $password){
        echo json_encode(
        [
          "success" => false,
          "message" => "Usuario o contraseña incorrectos"
        ]
      );
    }

    echo json_encode(
      [
        "success" => true,
        "message" => "Bienvenido Al sistema"
      ]
    );
  }
}