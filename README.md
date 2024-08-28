# Smart Home Project

## Integrantes
- Osmar Israel Villegas Martinez 
- Jose Armando Gutierrez Rodriguez
- Victor Andres Garay Montes

## Visión
El objetivo del proyecto es desarrollar un producto de calidad capaz de monitorear el ambiente. El proyecto está pensado especialmente para aquellas personas que buscan obtener información relevante sobre el entorno a través de una aplicación y desean influir en él. Para cumplir con este propósito, el dispositivo implementa tecnologías para la recolección y análisis de datos, proporcionando así la información al usuario final.

## Objetivo general
Diseñar y desarrollar un sistema de IoT (Internet de las cosas) que permita monitorear y controlar el ambiente de una habitación con el fin de gestionar el entorno del usuario. El sistema debe monitorizar y, en caso necesario, mejorar las condiciones del ambiente para garantizar un entorno de calidad.

### Objetivos específicos
Implementar un sistema de análisis del ambiente que monitoree condiciones como luz, temperatura, Metano en el ambiente, clima, hora y número de pasos. Basado en los resultados, el sistema almacena la información para su posterior análisis y permite la activación de mecanismos como un ventilador o música.

## Arquitectura
![image](./Imagenes/Arquitectura.PNG)

## Librerias Utilizadas
- Pin

- ADC

- Sleep

- dfplayermini

- _thread

- network

- umqtt.simple

- utime

- UART

- Timer

## Tabla de Software utilizado
| Id | Software | Version | Tipo |
|----|----------|---------|------|
| 1 |  Postgresql  | 15.1.0 | SQL |
| 2 | Thonny  | 4.1.4 |  IDE |
| 3 | Node-Red | 3.2.9 | MQTT |
| 4 | supabase | 1.24.07 | NoSQL |
| 5 | Arduino IDE | 1.8.19 | IDE |
| 6 | Flutter | 3.24.1 | Framework |

## Tabla con el hardware utilizado (El costo de cada componente es al dia de 2 de junio del 2024)
| Id | Componente | Descripción | Imagen | Cantidad | Costo total |
|----|------------|-------------|--------|----------|-------------|
|1|Sensor de temperatura DHT22|Sensor para medir la temperatura del ambiente. |![image](/Imagenes/Modulo_DHT22.jpg)|1|$17,04 MXN|
|2|Sensor de gas MQ-9| Sensor para medir concentraciones de Metáno (CH4) y Gas Licuado de Petróleo (GLP).|![image](/Imagenes/Modulo_Gas.jpeg)|$47.00 MXN|   
|3|Fotorresistencia|Sensor capaz de medir la oscuridad del ambiente.|![image](./Imagenes/Fotoresistor.jpeg)|2|$13,97 MXN|
|4|DFPlayer-Mini Módulo|Modulo DFPlayer permite la reproducción de audios grabados en una memoria sd.|![image](./Imagenes/DFPlayer.jpeg)|1|$26,46 MXN|
|5|Bocina|Bocina para reproducir musica utilizando el modulo DFPlayer-mini.|![image](./Imagenes/Bocina.jpeg)|1|$0,00 MXN|
|6|Tarjeta SD|Tarjeta SD para reproducir musica utilizando el modulo DFPlayer-mini.|![image](./Imagenes/SD.jpg)|1|$150,00 MXN|
|7|ESP32|ESP32 es la denominación de una familia de chips SoC de bajo coste y consumo de energía, con tecnología Wi-Fi y Bluetooth de modo dual integrada.|![image](./Imagenes/Esp32.jpg)|2|$250,00 MXN|
|8|Pantalla (Weareble)|Reloj inteligente ESP32, dispositivo programable con WIFI, Bluetooth, papel electrónico, Hardware y Software de código abierto|![image](./Imagenes/Esp32_E-Watch.jpeg)|1|$356,64 MXN|
|9|Relevador 5V KY-019| El Relevador 5V KY-019 es un dispositivo electrónico que permite controlar dispositivos por medio de un puente|![image](./Imagenes/Relevador.jpeg)|1|$19,00 MXN|
|10|Ventilador| Ventilador de bajo consumo. |![image](./Imagenes/Ventilador.jpeg)|1|$16,87|
|11|Placa de pruebas sin soldadura| Placa de pruebas sin soldadura MB-102 400/830 puntos de conexión, placa de desarrollo de prueba PCB blanca/transparente, bricolaje para prototipos de escudo Arduino|![image](./Imagenes/Placa.jpg)|1|$68,86 MXN|
|12|Cautin| Soldador inteligente Original FM01 T65, equipo de soldadura PD, máquina de estación eléctrica, herramientas de reparación de Cautín, puntas FM65|![image](./Imagenes/Cautin.jpg)|1|$68,86 MXN|
|13|Cables | Cable de puente de cobre, Conector de línea Flexible sin soldadura de pruebas para placa Arduino DIY, 10cm, 20cm, 30cm, macho, hembra, 24AWG | ![image](./Imagenes/Cables.jpg)|30|$56,61 MXN|

## Epicas del proyecto (Minimo debe de haber una épica por integrante de equipo)
- Monitorear las condiciones ambientales de una habitación: Esta épica se enfoca en el monitoreo de las condiciones ambientales de la habitación, como temperatura, nivel de metano y oscuridad. El objetivo es medir estos factores, evaluarlos y almacenarlos. Además, la información se recopilará y se visualizará en forma de resumen.

- Control de calidad del ambiente: Esta épica se enfoca en el control del ambiente utilizando un relevador, un ventilador, una bocina y un módulo DFPlayer. El objetivo es influir en el ambiente con los dispositivos implementados; los componentes se pueden activar a través de la aplicación de Flutter.

- Almacenamiento y analsis de datos: Esta épica se enfoca en el almacenamiento y análisis de la información recopilada en tiempo real por medio de los sensores. El objetivo es enviar los datos medidos por los sensores a una base de datos y permitir su análisis para presentarlos en forma de resumen al usuario.

## Tabla de historias de usuario
| Id | Historia de usuario | Prioridad | Estimación | Como probarlo | Responsable |
|----|---------------------|-----------|------------|---------------|-------------|
|  1  | Como usuario quiero que se monitorice en tiempo real la temperatura del ambiente para tener información más fiel a la realidad.| 1 | 3 Dias | Se obtiene información fiel en tiempo real através del sensor.| Osmar Israel Villegas Martínez |            |
|  2  | Como usuario quiero que se monitorice en tiempo real el gas en el ambiente para tener información más fiel a la realidad.| 1 | 3 Dias | Se obtiene información fiel en tiempo real através del sensor.| Osmar Israel Villegas Martínez |
|  3  | Como usuario quiero que se monitorice en tiempo real la luz de mi cuarto para obtener información más fiel a la realidad.| 1 | 3 Dias | Se obtiene información fiel en tiempo real através del sensor.| Osmar Israel Villegas Martínez |
|  4  | Como usuario quiero que se monitorice en tiempo real el clima en mi cuarto para obtener información más fiel a la realidad.| 1 | 3 Dias | Se obtiene información fiel en tiempo real através del sensor.| Victor Andrés Garay Montes |
|  5  | Como usuario quiero que se monitorice los pasos que realizo para obtener información más fiel a la realidad.| 1 | 3 Dias | Se obtiene información fiel en tiempo real através del sensor.| Victor Andrés Garay Montes  |
|  6  | Como usuario quiero una interfaz grafica para poder interactuar con la información obtenida facilmente. | 2 | 1 Semana | Se puede visualizar las graficas sin problemas desde un dispositivo movil, no existen errores graficos. | Jose Armando Gutierrez|
|  7  | Como usuario quiero tener un resumen de la información importante facilmente.| 2 | 2 Semanas | Se da un resumen fiel a la información obtenida, no tiene errores graficos y es accesible desde un télefono movil. | Jose Armando Gutierrez |
|  8  | Como desarrollador quiero que la información se almacene en una base de datos que permita un facil y rapido acceso para facilitar su manejo. | 2 | 5 Dias | Se puede almacenar y acceder a la información para realizar el resumen y generar las graficas sin problemas desde cualquier dispositivo. | Jose Armanado Gutierrez Rodriguez |
|  9  | Como usuario quiero obtener la información atravez de un dispositivo wearable.| 2 | 1 Semana |Se da un resumen fiel a la información obtenida, no tiene errores graficos y es accesible desde un wearable.| Victor Andrés Garay Montes |
|  10  | Como usuario quiero que el dispositivo sea comodo de usar para que no me moleste al llevarlo.| 3 | 1 Semana |El dispositivo que usa el usuario es comodo.| Victor Andrés Garay Montes |
|  11 | Como usuario quiero poder reproducir musica por medio de la aplicación.| 3 | 1 Semana |El dispositivo responde rapidamente y reproduce musica correctamente.| Osmar Israel Villegas Martínez |
|  12 | Como usuario quiero poder activar el ventilador por medio de la aplicación.| 3 | 1 Semana |El dispositivo responde rapidamente y enciende por tiempo prolongado el ventilador correctamente.| Osmar Israel Villegas Martínez |
|  13 | El dispositivo de sobremesa cuenta con una carcasa.| 3 | 1 Semana |El dispositivo cuenta con una carcasa funcional.| Osmar Israel Villegas Martínez/Jose Armanado Gutierrez Rodriguez |

## Tablero Kanban
![image](./Imagenes/Kanban.PNG)


## Prototipo en dibujo
![image](./Imagenes/Prototipo.PNG)

## Codigo
### main.py
```python 
from machine import Pin, ADC
from time import sleep
import dht
from dfplayermini import Player
from _thread import start_new_thread
# Conexión wifi, manejar instancias de un cliente MQTT
import network
from umqtt.simple import MQTTClient
import utime

# Constantes para conexión con el cliente MQTT
MQTT_CLIENT_ID = ""
MQTT_BROKER = "broker.emqx.io"
MQTT_USER = ""
MQTT_PASSWORD = ""
MQTT_TOPIC1 = "project/temperatura/data"
MQTT_TOPIC2 = "project/humedad/data"
MQTT_TOPIC3 = "project/gas/data"
MQTT_TOPIC4 = "project/luz/data"
MQTT_TOPIC5 = "project/music/data"
MQTT_TOPIC6 = "project/ventilador/data"
MQTT_TOPIC7 = "project/system/data"
MQTT_PORT = 1883

# Creando objetos
sensor_dht = dht.DHT22(Pin(14))
sensor_gas = ADC (Pin(32))
photoresistor = ADC(Pin(35, Pin.IN))
music = Player(pin_TX=27, pin_RX=26)

# Ajustamos al resolución y voltaje de trabajo
sensor_gas.width(ADC.WIDTH_10BIT)
sensor_gas.atten(ADC.ATTN_11DB)
photoresistor.atten(photoresistor.ATTN_11DB)
rele = Pin(5, Pin.OUT)
sleep(1)
music.loop()

# Funcion para conectar a una red wifi
def conectar_wifi():
    sta_if = network.WLAN(network.STA_IF)
    sta_if.active(True)
    sta_if.connect("Usuario", "contraseña")
    while not sta_if.isconnected():
        print(".", end="")
        sleep(0.1)
    print("Conectado!")

def mensaje_recibido(MQTT_TOPIC5, mensaje):
    datos = int(mensaje)
    sleep(1)
    music.volume(12)
    print("Bocina: " + str(datos))
    if datos == 1:
        sleep(1)
        music.play(4)
    else:
        sleep(1)
        music.pause()

def subscribir_broker():
    cliente = MQTTClient("", MQTT_BROKER)
    cliente.set_callback(mensaje_recibido)
    cliente.connect()
    cliente.subscribe(MQTT_TOPIC5)
    print("Suscrito Musica")
    return cliente

def mensaje_recibido2(MQTT_TOPIC6, mensaje):
    datos = int(mensaje)
    print("Ventilador: " + str(datos))
    if datos == 1:
        rele.value(1)
        utime.sleep(2)
    else:
        rele.value(0)

def subscribir_broker2():
    cliente = MQTTClient("", MQTT_BROKER)
    cliente.set_callback(mensaje_recibido2)
    cliente.connect()
    cliente.subscribe(MQTT_TOPIC6)
    print("Suscrito Ventilador")
    return cliente

def conectar_Broker():
    print("Conectar al broker: ", MQTT_BROKER)
    cliente = MQTTClient(MQTT_CLIENT_ID,MQTT_BROKER,user=MQTT_USER, password=MQTT_PASSWORD, port = MQTT_PORT, keepalive=3)
    cliente.set_last_will(MQTT_TOPIC7, str(0), retain=True)
    cliente.connect()
    print("Conectar broker")
    return cliente

# Ciclo core 0
def loop():
    try:
        while True:
            # Leer el sensor
            sensor_dht.measure()
            temperatura = sensor_dht.temperature()
            humedad = sensor_dht.humidity()
            lectura_gas = int(sensor_gas.read())
            lectura_luz = photoresistor.read()
        
            utime.sleep(2)
    
            ppm = 400 / 1023
            co = ppm * lectura_gas
        
            # Publicar información
            cliente.publish(MQTT_TOPIC1, str(temperatura))
            cliente.publish(MQTT_TOPIC2, str(humedad))
            cliente.publish(MQTT_TOPIC3, str(lectura_gas))
            cliente.publish(MQTT_TOPIC4, str(lectura_luz))
    except KeyboardInterrupt:
        cliente.sock.close()

def loop2():
    while True:
        music.loop()
        cliente_subs.check_msg()
        sleep(1)
        cliente_subs_2.check_msg()
        sleep(1)

    
# Antes de iniciar el ciclo
conectar_wifi()
cliente = conectar_Broker()
cliente_subs = subscribir_broker()
cliente_subs_2 = subscribir_broker2()
cliente.publish(MQTT_TOPIC7, str(1), retain=True)

# Generar loop en el segundo core
start_new_thread(loop2, ())
loop()
```

### dfplayermini.py
```python
import utime
from machine import UART, Timer

IDLE = 0
PAUSED = 1
PLAYING = 2


class Player:
    def __init__(self, pin_TX, pin_RX):
        self.uart = UART(1, 9600, tx=pin_TX, rx=pin_RX)
        self.cmd(0x3F)  # send initialization parametres
        self._fadeout_timer = Timer(-1)

        self._volume = 15
        self._max_volume = 15
        self._fadeout_speed = 0

    def cmd(self, command, parameter=0x00):
        query = bytes([0x7e, 0xFF, 0x06, command,
                       0x00, 0x00, parameter, 0xEF])
        self.uart.write(query)

    def _fade_out_process(self, timer):
        new_volume = self._volume - self._fadeout_speed
        
        if new_volume <= 0:
            print("fadeout finished")
            new_volume = 0
            self._fadeout_timer.deinit()
            self.stop()
            new_volume = self._max_volume # reset volume to max 
        self.volume(new_volume)

    # playback

    def play(self, track_id=False):
        if not track_id:
            self.resume()
        elif track_id == 'next':
            self.cmd(0x01)
        elif track_id == 'prev':
            self.cmd(0x02)
        elif isinstance(track_id, int):
            self.cmd(0x03, track_id)

    def pause(self):
        self.cmd(0x0E)

    def resume(self):
        self.cmd(0x0D)

    def stop(self):
        self.cmd(0x16)

    def fadeout(self, fadeout_ms=1000):
        # more than 500ms and less than 3000ms
        fadeout_ms = int(sorted([500, fadeout_ms, 3000])[1])
        fade_out_step_ms = 100
        self._fadeout_speed = self._volume * \
            fade_out_step_ms / fadeout_ms  # ten steps per second
        self._fadeout_timer.init(
            period=fade_out_step_ms, callback=self._fade_out_process)

    def loop_track(self, track_id):
        self.cmd(0x08, track_id)

    def loop(self):
        self.cmd(0x19)

    def loop_disable(self):
        self.cmd(0x19, 0x01)

    # volume control

    def volume_up(self):
        self._volume += 1
        self.cmd(0x04)

    def volume_down(self):
        self._volume -= 1
        self.cmd(0x05)

    def volume(self, volume=False):
        if volume:
            self._volume = int(sorted([0, volume, self._max_volume])[1])
            print("volume", self._volume)
            self.cmd(0x06, self._volume)
        
        return self._volume

    # hardware

    def module_sleep(self):
        self.cmd(0x0A)

    def module_wake(self):
        self.cmd(0x0B)

    def module_reset(self):
        self.cmd(0x0C)
```

## Diagrama
![image](./Imagenes/Circuito.PNG)

## Pantallas Flutter

### Main
![image](https://github.com/user-attachments/assets/6c12b443-b5c5-48d2-8f64-cd1bdae8bac9)

### Luz
![image](https://github.com/user-attachments/assets/dfb74d30-dafb-4d71-8e2b-006c4daed80b)

### Temperatura
![image](https://github.com/user-attachments/assets/7a04f1df-b56e-4b47-a36c-3ff62e098863)

### Humedad
![image](https://github.com/user-attachments/assets/b480efcc-9909-41e5-ab59-fd740213fd92)

### Gas
![image](https://github.com/user-attachments/assets/d4dfa266-0da4-448c-acc4-82c9838e394e)

### Wereable
![image](https://github.com/user-attachments/assets/45fa2164-6e20-41b8-bc07-1d09e0c405e3)


## Node-Red Flows

### Produccion
![image](https://github.com/user-attachments/assets/434f2844-97e6-4979-b3f4-2ef63d88b698)
### Test
![image](https://github.com/user-attachments/assets/44db9dc7-54d0-457d-8c47-f4fa80ce26e9)

## Video demostracion
[Link del video](https://drive.google.com/file/d/1IX2vUpmbipwm-nlV36v6pP7F3DbX74k3/view?usp=sharing)

## Carta de agradecimiento
![Carta](./Imagenes/Carta.PNG)

### Video agradecimiento (presentación)
[Link del video](https://drive.google.com/file/d/1JHMdj4cdA24k0qymvwtmJ-ysDoh-p9ci/view?usp=sharing)

## Evidencias fotograficas
![image](./Imagenes/foto_1.jpg)
![image](./Imagenes/foto_2.jpg)