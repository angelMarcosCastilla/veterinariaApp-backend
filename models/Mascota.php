<?php
require_once 'Conexion.php';

class Mascota extends Conexion {
  private $conexion;

  public function __CONSTRUCT()
  {
    $this->conexion = parent::getConexion();
  }

  public function detalleMascotas($dni){
    try {
      $consulta = $this->conexion->prepare("CALL SPU_DETALLE_MASCOTA_CLIENTE(?)");
      $consulta->execute(array($dni));
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function registrarMascotas($data){
    try{
      $consulta = $this->conexion->prepare("CALL SPU_REGISTRAR_MASCOTA(?,?,?,?,?,?)");
      $consulta->execute(array(
        $data['idcliente'],
        $data['idraza'],
        $data['nombre'],
        $data['fotografia'],
        $data["color"],
        $data['genero']));
    }catch(Exeption $e){
      die($e->getMessage());
    }
  }

  public function listarRazas($idanimal){
    try {
      $consulta = $this->conexion->prepare("CALL SPU_LISTAR_RAZA(?)");
      $consulta->execute(array($idanimal));
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function listarAnimales(){
    try {
      $consulta = $this->conexion->prepare("CALL SPU_LISTAR_ANIMALES()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  
  public function eliminarMascota($idmascota){
    try {
      $consulta = $this->conexion->prepare("CALL SPU_ELIMINAR_MASCOTA(?)");
      $consulta->execute(array($idmascota));
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function obtenerMascota($idmascota){
    try {
      $consulta = $this->conexion->prepare("CALL SPU_DETALLE_MASCOTA(?)");
      $consulta->execute(array($idmascota));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}