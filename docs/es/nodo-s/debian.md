
# Instalación del NODO-S en Debian 8.6

## SSH

* Se requiere el software de acceso remoto SSH server.
    * `Inicio -> Gestor de Paquetes -> SSH server`, para instalarlo por entorno gráfico.
    * `sudo apt-get install openssh-server`, para instalarlo por comandos.
* El usuario del equipo NODO-T debe conocer usuario/clave de cada equipo remoto con perfil de administrador.
* Modificar el fichero `/etc/ssh/sshd_config` con `PermitRootLogin yes`.
* Para reiniciar el servicio hacemos `systemctl restart sshd` o `service sshd restart`.