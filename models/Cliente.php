<?php
require_once 'Conexion.php';

class Cliente extends Conexion {
  private $conexion;

  public function __CONSTRUCT()
  {
    $this->conexion = parent::getConexion();
  }

  public function buscarCliente($dni){
    try {
      $consulta = $this->conexion->prepare("CALL SPU_BUSCAR_CLIENTE(?)");
      $consulta->execute(array($dni));
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function buscarMascotasClientes($dni){
    try {
      $consulta = $this->conexion->prepare("CALL SPU_DETALLE_MASCOTA_CLIENTE(?)");
      $consulta->execute(array($dni));
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function registrarCliente($data){
    try{
      $consulta = $this->conexion->prepare("CALL SPU_REGISTRAR_CLIENTE(?,?,?,?,?,?)");
      $consulta->execute(array(
        $data['nombres'],
        $data['apellidos'],
        $data['dni'],
        $data['genero'],
        $data['claveacceso'],
        $data['tipousuario'],
        )
      );
      
      return $consulta->fetchAll(PDO::FETCH_ASSOC);

    }catch(Exeption $e){
      die($e->getMessage());
    }
  }

  public function listarCliente(){
    try {
      $consulta = $this->conexion->prepare("CALL SPU_LISTAR_CLIENTE()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  // login

  public function login($username){
    try {
      $consulta = $this->conexion->prepare("CALL SPU_LOGIN(?)");
      $consulta->execute(array($username));
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}