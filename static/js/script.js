<script>
  function mostrarConfirmacion() {
    // Obtener el número de elementos a modificar
    var cantidadElementos = {{ vw_mora|length }};

    // Mostrar el mensaje emergente
    var mensaje = `Estás por modificar ${cantidadElementos} elementos. ¿Deseas continuar?`;
    if (confirm(mensaje)) {
      ejecutarFxCambioEstado();
    }
  }

  function ejecutarFxCambioEstado() {