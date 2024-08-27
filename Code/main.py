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
    sta_if.connect("RED", "Contraseña")
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
