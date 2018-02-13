# Deploy Django Bash

Este proyecto contiene los scripts necesarios para realizar el deploy
automático de una aplicación web desarrollada con Django.

## Configurar acceso por ssh al servidor:

### Acciones en el equipo remoto:

**Instalar servidor ssh:**
```
sudo apt-get update
sudo apt-get install openssh-server
```

**Iniciar, detener, reiniciar servicio ssh:**
```
sudo service ssh start
sudo service ssh stop
sudo service ssh restart
```

**Crear directorio para almacenar llaves ssh:**
```
mkdir ~/.ssh
```

**Verificar configuración del servidor ssh:**
```
sudo vim /etc/ssh/sshd_config

# Estas entradas deben ser 'yes'
RSAAuthentication yes
PubkeyAuthentication yes

# Estas entradas deben ser 'no'
ChallengeResponseAuthentication no
PasswordAuthentication no
UsePAM no
```

**Reiniciar servidor ssh:**
```
sudo service ssh restart
```

### Acciones en el equipo local:

**Generar llaves ssh:**
```
ssh-keygen -t rsa
```

**Copiar llave pública al servidor:**
```
scp ~/.ssh/id_rsa.pub vagrant@192.168.33.10:~/.ssh/uploaded_key.pub
```

**Agregar llave pública a las authorized_keys del servidor:**
```
ssh vagrant@192.168.33.10 "cat ~/.ssh/uploaded_key.pub >> ~/.ssh/authorized_keys"
```

**Copiar scripts al servidor remoto:**
```
scp run_project.sh vagrant@192.168.33.10
scp hook.sh vagrant@192.168.33.10
scp activate_hook.php vagrant@192.168.33.10:/var/www/html/activate_hook.php
```

## Instrucciones para programar crontab

Por medio de crontab se programa la ejecución cada minuto del script ```run_project.sh```, el cual se encarga de verificar que el proyecto siga corriendo, y en su defecto, de volverlo a levantar.

Las acciones de a continuación se deben realizar en el servidor donde corre el proyecto.

**Abrir crontab:**
```
crontab -e
```

**Agregar línea que ejecuta el script cada minuto:**
```
*/1 * * * * run_project.sh
```

**Aplicar cambios realizados en crontab:**
```
sudo service cron reload
```

## Instrucciones para webhook

Se tiene otro script que se encarga de actualizar el código fuente, instalar dependencias y echar a andar el proyecto al momento que ocurre algún evento en el repositorio de git, que en este caso será un push, esto con el objetivo de actualizar automáticamente el proyecto que está corriendo en el servidor al momento de guardar cambios en el repositorio.
