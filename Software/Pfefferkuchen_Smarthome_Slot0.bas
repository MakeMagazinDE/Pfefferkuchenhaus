#picaxe 20m2

symbol I2C_ADDR_RTC = 0xD0
symbol RTC_ADDR_SECONDS = 0

symbol I2C_ADDR_HTU21D = 0x80
; HTU21D commands
symbol HTU21D_REQ_TEMP = 0xF3
symbol HTU21D_REQ_HUM  = 0xF5

symbol I2C_ADDR_OLED = 0x78

symbol I2C_SDA = B.5
symbol I2C_SCL = B.7

; MP3 DFplayer-mini
Symbol MP3_TX_PIN = C.1
Symbol MP3_BAUD = T9600_32

; Bluetooth HM-10
symbol BT_RX_PIN = B.6 ; hserin
symbol BT_TX_PIN = C.5
Symbol BT_BAUD = T9600_32

; Klingeltaster
#define KEY_PRESSED PINC.6 = 0
symbol PU_MASK = %0100000000000000

; LED-Sternenkette
symbol LED_STARS = C.3

; onboard LED
symbol LED_NANOAXE = B.1

; APA102 LED stripe
#define HW_SPI
symbol LED_DATA_PIN = outpinb.3
symbol LED_DATA = B.3 ; B.3 = SDO SSP2
symbol LED_CLK = C.0  ; C.0 = SCK SSP2
symbol SSP2CON1_SFR = 0x9D
symbol SSP2STAT_SFR = 0x9C
symbol SSP2BUF_SFR = 0x99

symbol SSP1STAT_SFR = 0x94

; IR Fernbedienung
symbol IR_PIN = C.2
#macro ENABLE_IR_INT 
   setint %00000000,%00000100 ; C.2 LOW
#endmacro   

; Fernbedienungscodes HAMA 012362 Universal remote control
; Code 0662 (VCR SONY, SIRC 12-bit) => Farbtasten nutzbar, Cursortasten leider nicht
symbol IR_1 = 0 ; IR_1..IR_9 = 0..8
symbol IR_2 = 1
symbol IR_3 = 2
symbol IR_4 = 3
symbol IR_5 = 4
symbol IR_6 = 5
symbol IR_7 = 6
symbol IR_8 = 7
symbol IR_9 = 8
symbol IR_0 = 9
symbol IR_YELLOW = 26
symbol IR_RED = 27
symbol IR_GREEN = 24
symbol IR_BLUE = 28
symbol IR_WHITE = 29 ; Achtung: sendet erst nach 2-maligem Tastendruck einen IR-Code
symbol IR_VOL_OFF = 90
symbol IR_STANDBY = 21
symbol IR_RECORD = IR_WHITE ; Achtung: sendet erst nach 2-maligem Tastendruck einen IR-Code
symbol IR_PLAY = IR_YELLOW
symbol IR_PAUSE = 25
symbol IR_STOP = IR_GREEN
;symbol IR_FASTRWD = nicht vorhanden
symbol IR_RWD = IR_RED
symbol IR_FWD = IR_BLUE
;symbol IR_FASTFWD = nicht vorhanden
;symbol IR_OK = nicht vorhanden
;symbol IR_CURSOR_UP = nicht vorhanden
;symbol IR_CURSOR_DOWN = nicht vorhanden
;symbol IR_CURSOR_LEFT = nicht vorhanden
;symbol IR_CURSOR_RIGHT = nicht vorhanden
symbol IR_MENU = 79
;symbol IR_EXIT = nicht vorhanden
symbol IR_VOL_UP = 18 
symbol IR_VOL_DOWN = 19 
symbol IR_PROG_UP = 16
symbol IR_PROG_DOWN = 17


#MACRO SetMultipleLedsRam(number,r,g,b)
   multipleLeds = number
   if multipleLeds > 0 then
      for multipleLeds = 1 to number
         @bptrinc = b
         @bptrinc = g
         @bptrinc = r
      next multipleLeds
   endif
#ENDMACRO

#macro PAUSE_TIME(x)
   value_word = x * 8
   pause value_word
#endmacro


#macro OLED_CURSOR(x,y)
oled_y = y
oled_x = x
gosub oled_setCursor
#endmacro

#macro OLED_PRINTCHAR(c)
oledChar = c - " "
gosub oledPrintChar
#endmacro

#macro OLED_PRINTTEXT(addr)
textAddr = addr
gosub oledPrintText
#endmacro

; default brightness of RGB
symbol COL_R = 0x40;0x20
symbol COL_G = 0x30;0x10
symbol COL_B = 0x50;0x30


; LED colors for variable LEDs, BGR
EEPROM 0,( 0x00,0x00,COL_R,  0x00,COL_G,COL_R,  0x00,COL_G,0x00,  COL_B,COL_G,0x00,  COL_B,0x00,0x00,  COL_B,0x00,COL_R )


symbol DEGREE_SYMBOL = 0x80

#define TEXT_1 20
EEPROM TEXT_1,("Pfefferkuchen",0) ; 0 als Endezeichen

#define TEXT_2 42
EEPROM TEXT_2,("Smarthome",0) ; 0 als Endezeichen


symbol animationScreenMode = b0 ; gleich wie param_b0
symbol param_b0 = b0
Symbol cmd = b1
Symbol arg = w1 ; b3:b2
Symbol arg.lsb = b2
Symbol arg.msb = b3
symbol volume = b4
symbol irCode = b5
symbol songNumber = b6; w3
symbol oledChar = b7
symbol paused = b8
symbol multipleLeds = b9
symbol counter = b10
symbol led_counter = b11
symbol led_counter2 = b12
symbol led_state = b13
symbol led_color_red = b14
symbol led_color_green = b15
symbol led_color_blue = b16
symbol ledTimer = b17
symbol value_word = w9
symbol value_lsb = b18
symbol value_msb = b19
symbol value_bcd10 = b20
symbol value_bcd1 = b21
symbol textData = b22
symbol currentLed = b23
symbol value2 = b24
symbol measurementTimer = b25
symbol oled_y = b26
symbol oled_x = b27
symbol bptr_save = s_w0
symbol addrWord = s_w1
symbol textAddr = s_w2
symbol dutyCycle = s_w3
symbol dutyCycleDirection = s_w4
symbol animationTimer = s_w5


symbol RAM_LEDS = 30
symbol RAM_TEMPERATURE = 60 ; 8-bit Ganzzahlwert
symbol RAM_TEMPERATURE_NK = 61 ; Nachkommastelle
symbol RAM_HUMIDITY = 62 ; 8-bit
symbol RAM_RTC = 64 ; seconds, minutes, hours, day, month, year
symbol RAM_HOURS = RAM_RTC+2
symbol RAM_DAY = RAM_RTC+3
symbol RAM_FONT = 70
symbol RAM_LEDS_VARIABLE = 80


symbol numberOfLeds = 6
symbol maxLed = numberOfLeds - 1
symbol numberOfLedBytes = numberOfLeds * 3
symbol maxLedByte = numberOfLedBytes - 1


setfreq m32
high MP3_TX_PIN ; set MP3 TX pin high for idle high serial
high BT_TX_PIN  ; set bluetooth TX pin high for idle high serial

if animationScreenMode = 0 then ; ist beim Programmstart 0
   ;gosub oled_init  => wird in Slot1-Programm aufgerufen
   ;OLED_CURSOR(0,0) => wird in Slot1-Programm aufgerufen
   run 1
endif

if animationScreenMode = 1 then
   gosub initSpi
   gosub clearLedStripe

   ;SerTxd("MP3", CR, LF )
   cmd = $09 : arg = $0002 : Gosub Send_MP3 ; select micro SD card
   PAUSE_TIME(2000)
   paused = 1
   volume = 15
   gosub setVolume
   PAUSE_TIME(1000)

   songNumber = 1

   pullup PU_MASK
   ENABLE_IR_INT

   hsersetup B9600_32, %01000

   gosub stopOledAnimation
endif

if animationScreenMode = 2 then
   gosub klingel_continue
endif

main_loop:

   PAUSE_TIME(10) ; Zeitbasis 10ms

   if dutyCycleDirection = 0 or dutyCycleDirection = 0xFF then
      inc measurementTimer
   endif

   if measurementTimer = 30 then ; alle 300ms
      measurementTimer = 0
      gosub i2cGetTemperature
      gosub i2cGetHumidity
      gosub i2cGetDateTime
      gosub showTime
      gosub showTemperature
      gosub showHumidity
   endif   

   if KEY_PRESSED then
      gosub klingel
      PAUSE_TIME(10)
      do while KEY_PRESSED
      loop
   endif
 
   if dutyCycleDirection != 0 then
      inc ledTimer
      inc animationTimer
   endif

   if ledTimer = 5 then ; alle 50ms
      ledTimer = 0
      if dutyCycleDirection = 1 then
         dutyCycle = dutyCycle + 40
         if dutyCycle > 600 then
            dutyCycleDirection = 2
         endif
      elseif dutyCycleDirection = 2 then
         dutyCycle = dutyCycle - 40
         if dutyCycle <= 160 then
            dutyCycleDirection = 1
         endif
      endif
      pwmduty LED_STARS, dutyCycle
   endif 

   if animationTimer = 6000 then
      gosub stopOledAnimation
      animationTimer = 0
      dutyCycleDirection = 0xFF
      dutyCycle = 200
   endif

   gosub checkBluetoothCmd
goto main_loop


klingel:
   gosub allLedsOff
   dutyCycleDirection = 0
   pwmout LED_STARS, off
   low LED_STARS
   songNumber = 1
   gosub playSong
   animationScreenMode = 1
   run 1
klingel_continue:   
   PAUSE_TIME(100)
   ENABLE_IR_INT
   for cmd = 0 to maxLed
      param_b0 = cmd
      gosub ledOn
      PAUSE_TIME(500)
   next cmd
   dutyCycleDirection = 1
   animationTimer = 0
   dutyCycle = 40
   pwmout pwmdiv64, LED_STARS, 255, dutyCycle
return


checkBluetoothCmd:
   param_b0 = 0xFF
   hserin param_b0
   if param_b0 != 0xFF then
      if param_b0 >= "A" and param_b0 <= "F" then
         currentLed = param_b0 - "A"
         param_b0 = currentLed * 3
         bptr = RAM_LEDS_VARIABLE + param_b0
         read param_b0, @bptrinc, @bptrinc, @bptrinc
         gosub updateLedsVariable
         param_b0 = 0xFF
      endif
      if param_b0 >= "a" and param_b0 <= "f" then
         currentLed = param_b0 - "a"
         param_b0 = currentLed * 3
         bptr = RAM_LEDS_VARIABLE + param_b0
         @bptrinc = 0
         @bptrinc = 0
         @bptrinc = 0
         gosub updateLedsVariable
         param_b0 = 0xFF
      endif
      if param_b0 = "O" then gosub allLedsOn
      if param_b0 = "o" then gosub allLedsOff
      if param_b0 = "n" then gosub playNextSong
      if param_b0 = "p" then gosub playPrevSong
      if param_b0 = "P" then gosub playOrPauseSong
      if param_b0 = "s" then gosub stopSong
      if param_b0 = "v" then 
         volume = volume min 1 - 1 : gosub setVolume
      endif         
      if param_b0 = "V" then 
         volume = volume + 1 max 30 : gosub setVolume
      endif
      if param_b0 = "k" then gosub klingel
      if param_b0 = "t" then
         peek RAM_TEMPERATURE, value2
         serout BT_TX_PIN, BT_BAUD, (cr,lf,"T:",#value2,".")
         peek RAM_TEMPERATURE_NK, value2
         serout BT_TX_PIN, BT_BAUD, (#value2,"dC")
         peek RAM_HUMIDITY, value2
         serout BT_TX_PIN, BT_BAUD, (" RH:",#value2,"%",cr,lf)
      endif
      if param_b0 = "r" then
         param_b0 = 2
         gosub adjustLedColor
      endif
      if param_b0 = "g" then
         param_b0 = 1
         gosub adjustLedColor
      endif
      if param_b0 = "h" then
         param_b0 = 0
         gosub adjustLedColor
      endif
      if param_b0 = "!" then
         gosub saveLedColors
      endif
      if param_b0 = "*" then
         gosub toggleStars
      endif
   endif
return


playSong:
   paused = 0
   cmd = $03
   arg = songNumber
   Gosub Send_MP3
return

playNextSong:
   paused = 0
   cmd = $01
   arg = 0
   Gosub Send_MP3
return

playPrevSong:
   paused = 0
   cmd = $02
   arg = 0
   Gosub Send_MP3
return

pauseSong:
   paused = 1
   cmd = $0E
   arg = 0
   Gosub Send_MP3
return

unpauseSong:
   paused = 0
   cmd = $0D
   arg = 0
   Gosub Send_MP3
return

playOrPauseSong:
   if paused = 1 then
      goto unpauseSong 
   else 
      goto pauseSong
   endif
return

stopSong:
   paused = 1
   cmd = $16
   arg = 0
   Gosub Send_MP3
return

setVolume:
   cmd = $06
   arg = volume
   Gosub Send_MP3
return


Send_MP3:
   SerOut MP3_TX_PIN, MP3_BAUD, ( $7E, $FF, $06, cmd, $00, arg.msb, arg.lsb, $EF )
Return


updateLedsVariable:
   bptr = RAM_LEDS_VARIABLE
   goto update_all_leds
updateLeds:
   bptr = RAM_LEDS
update_all_leds:   
   gosub generateStartFrame
   for counter = 1 to numberOfLeds
      param_b0 = 0xFF
      gosub sendSpi
      param_b0 = @bptrinc
      gosub sendSpi
      param_b0 = @bptrinc
      gosub sendSpi
      param_b0 = @bptrinc
      gosub sendSpi
   next counter
   gosub generateEndFrame
   bptr = RAM_LEDS
return


allLedsOn:
   bptr = RAM_LEDS_VARIABLE
   for counter = 0 to maxLedByte
      read counter, @bptrinc
   next counter
   gosub updateLedsVariable
return


allLedsOff:
   bptr = RAM_LEDS_VARIABLE
   for counter = 0 to maxLedByte
      @bptrinc = 0
   next counter
   gosub updateLedsVariable
return


ledOn:
   param_b0 = param_b0 * 3
   bptr = RAM_LEDS_VARIABLE + param_b0
   read param_b0, @bptrinc, @bptrinc, @bptrinc
   gosub updateLedsVariable
return


toogleLed: ; param_b0 = LED number (0..x)
   param_b0 = param_b0 * 3
   bptr = RAM_LEDS_VARIABLE + param_b0
   if @bptrinc = 0 and @bptrinc = 0 and @bptrinc = 0 then
      bptr = RAM_LEDS_VARIABLE + param_b0
      read param_b0, @bptrinc, @bptrinc, @bptrinc
   else
      bptr = RAM_LEDS_VARIABLE + param_b0
      @bptrinc = 0
      @bptrinc = 0
      @bptrinc = 0
   endif
   gosub updateLedsVariable
return


adjustLedColor: ; param_b0 = LED byte number
   bptr = currentLed * 3 + param_b0 + RAM_LEDS_VARIABLE
   @bptr = @bptr + 0x10
   gosub updateLedsVariable
return


saveLedColors:
   gosub clearLedStripe
   PAUSE_TIME(250)
   bptr = RAM_LEDS_VARIABLE
   for counter = 0 to maxLedByte
      write counter, @bptrinc
   next counter
   gosub updateLedsVariable
return


toggleStars:
   if dutyCycleDirection = 0 then
      toggle LED_STARS
   else
      dutyCycleDirection = 0
      pwmout LED_STARS, off
      low LED_STARS
      gosub stopOledAnimation
   endif
return


initSpi:
   #ifdef HW_SPI
      bptr = RAM_LEDS
      low LED_CLK ; SCK as output low
      low LED_DATA ; SDO as output low
      pokesfr SSP2CON1_SFR, 0x22 ; SSPEN=1, CKP=0, SSPM=0010 (500kHz)
      pokesfr SSP2STAT_SFR, 0x40 ; SMP=0, CKE=1
   #else
      bptr = RAM_LEDS
      low LED_CLK ; SCK as output low
      low LED_DATA ; SDO as output low
   #endif
return


sendSpi:
   #ifdef HW_SPI
      pokesfr SSP2BUF_SFR, param_b0
   #else
      LED_DATA_PIN = bit7
      pulsout LED_CLK,10
      LED_DATA_PIN = bit6
      pulsout LED_CLK,10
      LED_DATA_PIN = bit5
      pulsout LED_CLK,10
      LED_DATA_PIN = bit4
      pulsout LED_CLK,10
      LED_DATA_PIN = bit3
      pulsout LED_CLK,10
      LED_DATA_PIN = bit2
      pulsout LED_CLK,10
      LED_DATA_PIN = bit1
      pulsout LED_CLK,10
      LED_DATA_PIN = bit0
      pulsout LED_CLK,10
   #endif
return


generateStartFrame:
   #ifdef HW_SPI
      pokesfr SSP2BUF_SFR,0
      pokesfr SSP2BUF_SFR,0
      pokesfr SSP2BUF_SFR,0
      pokesfr SSP2BUF_SFR,0
   #else
      param_b0 = 0
      gosub sendSpi
      gosub sendSpi
      gosub sendSpi
      gosub sendSpi
   #endif
return


generateEndFrame:
   #rem
   the only function of the End frame is to supply more clock pulses to the string until the data has permeated to the last LED. The number of clock pulses required is exactly half the total number of LEDs in the string. The recommended end frame length of 32 is only sufficient for strings up to 64 LEDs.
   #endrem
   
   #ifdef HW_SPI
      pokesfr SSP2BUF_SFR,0xFF
      pokesfr SSP2BUF_SFR,0xFF
      pokesfr SSP2BUF_SFR,0xFF
      pokesfr SSP2BUF_SFR,0xFF
   #else
      param_b0 = 0xFF
      gosub sendSpi
      gosub sendSpi
      gosub sendSpi
      gosub sendSpi
   #endif
return


clearLedStripe:
   bptr = RAM_LEDS
   SetMultipleLedsRam(numberOfLeds, 0, 0, 0)
   gosub updateLeds
return


i2cGetTemperature:
   hi2csetup i2cmaster, I2C_ADDR_HTU21D, i2cslow, i2cbyte ; setup I2C
   pokesfr SSP1STAT_SFR, 0x40 ; enable SMBus mode => 2,1V on I2C pins is recognized as HIGH level
   hi2cout (HTU21D_REQ_TEMP)
   PAUSE_TIME(60) ; wait until measurement complete
   hi2cin (value_msb, value_lsb, value2)
   value_word = value_word & 0xFFFC ; discard bit0 and bit1
   ; Temp = -46.85 + 175.72 * S_TEMP / 2^16
   ;temperature = 17572 ** value_word - 4685
   value_word = 17572 ** value_word - 4685 / 10
   value2 = value_word % 10
   value_word = value_word / 10 max 99
   poke RAM_TEMPERATURE_NK, value2
   poke RAM_TEMPERATURE, value_word
return


i2cGetHumidity:
   hi2csetup i2cmaster, I2C_ADDR_HTU21D, i2cslow, i2cbyte ; setup I2C
   pokesfr SSP1STAT_SFR, 0x40 ; enable SMBus mode => 2,1V on I2C pins is recognized as HIGH level
   hi2cout (HTU21D_REQ_HUM)
   PAUSE_TIME(60) ; wait until measurement complete
   hi2cin (value_msb, value_lsb, value2)
   value_word = value_word & 0xFFFC ; discard bit0 and bit1
   ; RH = -6 + 125 * S_RH / 2^16
   value_word = 125 ** value_word - 6
   if value_word >= 0x8000 then
      value_word = 0 ; negative result => limit to 0%
   elseif value_word > 99 then
      value_word = 99 ; limit to 99%
   endif
   poke RAM_HUMIDITY, value_word
return


i2cGetDateTime:
   hi2csetup i2cmaster, I2C_ADDR_RTC, i2cslow, i2cbyte ; setup I2C
   pokesfr SSP1STAT_SFR, 0x40 ; enable SMBus mode => 2,1V on I2C pins is recognized as HIGH level
   hi2cout (RTC_ADDR_SECONDS)
   bptr = RAM_RTC
   hi2cin (@bptrinc, @bptrinc, @bptrinc, @bptr, @bptrinc, @bptrinc, @bptrinc)
return


convertBcdValue:
   value_bcd10 = value_word / 16 + "0" ; ASCII digit 10
   value_bcd1 = value_word % 16 + "0"  ; ASCII digit 1
return


interrupt:
   irin [100, ir_timeout], IR_PIN, irCode
   select case irCode
      case IR_VOL_DOWN : volume = volume min 1 - 1 : gosub setVolume
      case IR_VOL_UP : volume = volume + 1 max 30 : gosub setVolume
      case IR_PROG_UP : songNumber = songNumber + 1 max 255 : gosub playNextSong
      case IR_PROG_DOWN : songNumber = songNumber - 1 min 1: gosub playPrevSong
      case IR_MENU : arg = 1 : cmd = $11 : Gosub Send_MP3 ; AV/TV 
                ; 0x11 with arg 1 ==> loop all songs, starts with first FAT file
      case IR_PLAY : gosub unpauseSong 
      case IR_PAUSE 
         if paused = 0 then 
            gosub pauseSong 
         else 
            gosub unpauseSong  ; Mute
         endif
      case IR_1, IR_2, IR_3, IR_4, IR_5, IR_6
         currentLed = irCode - IR_1
         param_b0 = irCode - IR_1
         gosub toogleLed
      case IR_7
         gosub toggleStars
      case IR_0
         gosub allLedsOff
      case IR_9
         gosub allLedsOn
      case IR_RED
         param_b0 = 2
         gosub adjustLedColor
      case IR_GREEN
         param_b0 = 1
         gosub adjustLedColor
      case IR_BLUE
         param_b0 = 0
         gosub adjustLedColor
      case IR_RECORD: gosub saveLedColors ; Achtung: Taste IR_RECORD sendet erst nach 2-maligem Tastendruck einen IR-Code
      case IR_STANDBY: gosub klingel
      else
         goto ir_unused_code
   endselect
   PAUSE_TIME(250) ; mehrfache IR-Codes pro Tastendruck ausblenden
ir_unused_code:
ir_timeout:
   ENABLE_IR_INT
return


;----------------------------------------------------------------------------------

SYMBOL OLED_WIDTH	= 128
SYMBOL OLED_MAX_X	= OLED_WIDTH - 1 ; 127
SYMBOL OLED_HEIGHT = 64
SYMBOL OLED_HEIGHT_LINES	= OLED_HEIGHT / 8 ; 8
SYMBOL OLED_MAX_Y	= OLED_HEIGHT_LINES - 1 ; 7
SYMBOL SSD1306_SETCONTRAST = 0x81
SYMBOL SSD1306_DISPLAYALLON_RESUME = 0xA4
SYMBOL SSD1306_DISPLAYALLON  = 0xA5
SYMBOL SSD1306_NORMALDISPLAY = 0xA6
SYMBOL SSD1306_INVERTDISPLAY = 0xA7
SYMBOL SSD1306_DISPLAYOFF = 0xAE
SYMBOL SSD1306_DISPLAYON = 0xAF	
SYMBOL SSD1306_SETDISPLAYOFFSET = 0xD3
SYMBOL SSD1306_SETCOMPINS = 0xDA	
SYMBOL SSD1306_SETVCOMDETECT = 0xDB	
SYMBOL SSD1306_SETDISPLAYCLOCKDIV = 0xD5
SYMBOL SSD1306_SETPRECHARGE = 0xD9
SYMBOL SSD1306_SETMULTIPLEX = 0xA8	
SYMBOL SSD1306_SETLOWCOLUMN = 0x00
SYMBOL SSD1306_SETHIGHCOLUMN = 0x10
SYMBOL SSD1306_SETSTARTLINE = 0x40
SYMBOL SSD1306_MEMORYMODE = 0x20
SYMBOL SSD1306_COLUMNADDR = 0x21
SYMBOL SSD1306_PAGEADDR = 0x22		; Page 0-7 represents line 0 - 7
SYMBOL SSD1306_COMSCANINC = 0xC0
SYMBOL SSD1306_COMSCANDEC = 0xC8
SYMBOL SSD1306_SEGREMAP_0 = 0xA0
SYMBOL SSD1306_SEGREMAP_1 = 0xA0 | 1
SYMBOL SSD1306_CHARGEPUMP = 0x8D
SYMBOL SSD1306_EXTERNALVCC = 0x1
SYMBOL SSD1306_SWITCHCAPVCC = 0x2

#rem
oled_init:
   gosub i2c_activate_oled
   hi2cout (0, SSD1306_DISPLAYOFF)            ; 0xAE
   hi2cout (0, SSD1306_SETDISPLAYCLOCKDIV)    ; 0xD5
   hi2cout (0, 0x80)                          ; the suggested ratio 0x80
   hi2cout (0, SSD1306_SETMULTIPLEX)          ; 0xA8
   hi2cout (0, 0x3F)
   hi2cout (0, SSD1306_SETDISPLAYOFFSET)      ; 0xD3
   hi2cout (0, 0x0)                           ; no offset
   hi2cout (0, SSD1306_SETSTARTLINE)          ; line #0
   hi2cout (0, SSD1306_CHARGEPUMP)            ; 0x8D
   hi2cout (0, 0x14)     						    ; INTERNAL VCC
   hi2cout (0, SSD1306_MEMORYMODE)            ; 0x20
   hi2cout (0, 0x00)                          ; Horiz mode. 0x0 act like ks0108
   ;hi2cout (0, SSD1306_SEGREMAP_1)
   ;hi2cout (0, SSD1306_COMSCANDEC)
   hi2cout (0, SSD1306_SEGREMAP_0)           ; Bild auf OLED horizontal spiegeln
   hi2cout (0, SSD1306_COMSCANINC)           ; Bild auf OLED vertikal spiegeln
   hi2cout (0, SSD1306_SETCOMPINS)            ; 0xDA
   hi2cout (0, 0x12)
   hi2cout (0, SSD1306_SETCONTRAST)           ; 0x81
   hi2cout (0, 0xCF)						          ; INTERNAL VCC
   hi2cout (0, SSD1306_SETPRECHARGE)          ; 0xD9
   hi2cout (0, 0xF1)						          ; INTERNAL VCC
   hi2cout (0, SSD1306_SETVCOMDETECT)         ; 0xDB
   hi2cout (0, 0x40)
   hi2cout (0, SSD1306_DISPLAYALLON_RESUME)   ; 0xA4
   hi2cout (0, SSD1306_DISPLAYON)         	 ; 0xAF	
return
#endrem

oled_setCursor:
   hi2cout (0, SSD1306_PAGEADDR)
   hi2cout (0, oled_y) ; set row
   hi2cout (0, OLED_MAX_Y)
   hi2cout (0, SSD1306_COLUMNADDR)
   hi2cout (0, oled_x) ; set column
   hi2cout (0, OLED_MAX_X)
return


oled_clearDisplayPartial:
   OLED_CURSOR(0,3)
   for counter = 1 to 128 ; 1024/8
   	hi2cout (0x40, 0, 0, 0, 0, 0, 0, 0, 0)
   next counter
return


oledPrintText:
   do
      read textAddr, textData
      if textData <> 0 then
         OLED_PRINTCHAR(textData)
         inc textAddr
      endif
   loop while textData <> 0
return


oledPrintChar:
   addrWord = oledChar*5
   ;readtable addrWord,font0,font1,font2,font3,font4
   bptr_save = bptr
   bptr = RAM_FONT
   readtable addrWord,@bptrinc,@bptrinc,@bptrinc,@bptrinc,@bptrinc
   bptr = RAM_FONT
   hi2cout (0x40, @bptrinc,@bptrinc,@bptrinc,@bptrinc,@bptrinc, 0x00)
   bptr = bptr_save
return


i2c_activate_oled:
   hi2csetup i2cmaster,I2C_ADDR_OLED,i2cfast_32,i2cbyte
   pokesfr SSP1STAT_SFR, 0x40 ; enable SMBus mode => 2,1V on I2C pins is recognized as HIGH level
return


showTime:
   gosub i2c_activate_oled
   OLED_CURSOR(8,6)
   bptr = RAM_HOURS
   value_word = @bptrdec
   gosub convertBcdValue
   OLED_PRINTCHAR(value_bcd10)
   OLED_PRINTCHAR(value_bcd1)
   OLED_PRINTCHAR(":")

   value_word = @bptrdec
   gosub convertBcdValue
   OLED_PRINTCHAR(value_bcd10)
   OLED_PRINTCHAR(value_bcd1)
   OLED_PRINTCHAR(":")

   value_word = @bptrdec
   gosub convertBcdValue
   OLED_PRINTCHAR(value_bcd10)
   OLED_PRINTCHAR(value_bcd1)

   OLED_CURSOR(74,6)

   bptr = RAM_DAY
   value_word = @bptrinc
   gosub convertBcdValue
   OLED_PRINTCHAR(value_bcd10)
   OLED_PRINTCHAR(value_bcd1)
   OLED_PRINTCHAR(".")

   value_word = @bptrinc
   gosub convertBcdValue
   OLED_PRINTCHAR(value_bcd10)
   OLED_PRINTCHAR(value_bcd1)
   OLED_PRINTCHAR(".")

   value_word = @bptrinc
   gosub convertBcdValue
   OLED_PRINTCHAR(value_bcd10)
   OLED_PRINTCHAR(value_bcd1)
   
return


showTemperature:
   gosub i2c_activate_oled
   OLED_CURSOR(8,4)
   OLED_PRINTCHAR("T")
   OLED_PRINTCHAR(":")
   peek RAM_TEMPERATURE, value2
   value2 = value2 / 10 + "0"
   OLED_PRINTCHAR(value2)
   peek RAM_TEMPERATURE, value2
   value2 = value2 % 10 + "0"
   OLED_PRINTCHAR(value2)
   OLED_PRINTCHAR(".")
   peek RAM_TEMPERATURE_NK, value2
   value2 = value2 + "0"
   OLED_PRINTCHAR(value2)
   OLED_PRINTCHAR(DEGREE_SYMBOL)
   OLED_PRINTCHAR("C")
return


showHumidity:
   gosub i2c_activate_oled
   OLED_CURSOR(74,4)
   OLED_PRINTCHAR("r")
   OLED_PRINTCHAR("H")
   OLED_PRINTCHAR(":")
   peek RAM_HUMIDITY, word value_word
   value_word = value_word / 10 + "0"
   OLED_PRINTCHAR(value_word)
   peek RAM_HUMIDITY, word value_word
   value_word = value_word % 10 + "0"
   OLED_PRINTCHAR(value_word)
   OLED_PRINTCHAR("%")
return


stopOledAnimation:
   gosub i2c_activate_oled
   hi2cout (0,0x2E) ; deactivate scroll
   gosub oled_clearDisplayPartial
return


; Font
table(0x00, 0x00, 0x00, 0x00, 0x00) ; Space
table(0x00, 0x00, 0x5F, 0x00, 0x00) ; !
table(0x00, 0x07, 0x00, 0x07, 0x00) ; "
table(0x14, 0x7F, 0x14, 0x7F, 0x14) ; #
table(0x24, 0x2A, 0x7F, 0x2A, 0x12) ; $
table(0x23, 0x13, 0x08, 0x64, 0x62) ; %
table(0x36, 0x49, 0x56, 0x20, 0x50) ; &
table(0x00, 0x08, 0x07, 0x03, 0x00) ; '
table(0x00, 0x1C, 0x22, 0x41, 0x00) ; (
table(0x00, 0x41, 0x22, 0x1C, 0x00) ; )
table(0x2A, 0x1C, 0x7F, 0x1C, 0x2A) ; *
table(0x08, 0x08, 0x3E, 0x08, 0x08) ; +
table(0x00, 0x80, 0x70, 0x30, 0x00) ; ,
table(0x08, 0x08, 0x08, 0x08, 0x08) ; -
table(0x00, 0x00, 0x40, 0x00, 0x00) ; .
table(0x20, 0x10, 0x08, 0x04, 0x02) ; /
table(0x3E, 0x51, 0x49, 0x45, 0x3E) ; 0
table(0x00, 0x42, 0x7F, 0x40, 0x00) ; 1
table(0x72, 0x49, 0x49, 0x49, 0x46) ; 2
table(0x21, 0x41, 0x49, 0x4D, 0x33) ; 3
table(0x18, 0x14, 0x12, 0x7F, 0x10) ; 4
table(0x27, 0x45, 0x45, 0x45, 0x39) ; 5
table(0x3C, 0x4A, 0x49, 0x49, 0x31) ; 6
table(0x41, 0x21, 0x11, 0x09, 0x07) ; 7
table(0x36, 0x49, 0x49, 0x49, 0x36) ; 8
table(0x46, 0x49, 0x49, 0x29, 0x1E) ; 9
table(0x00, 0x00, 0x14, 0x00, 0x00) ; :
table(0x00, 0x40, 0x34, 0x00, 0x00) ; ;
table(0x00, 0x08, 0x14, 0x22, 0x41) ; <
table(0x14, 0x14, 0x14, 0x14, 0x14) ; =
table(0x00, 0x41, 0x22, 0x14, 0x08) ; >
table(0x02, 0x01, 0x59, 0x09, 0x06) ; ?
table(0x3E, 0x41, 0x5D, 0x59, 0x4E) ; @
table(0x7C, 0x12, 0x11, 0x12, 0x7C) ; A
table(0x7F, 0x49, 0x49, 0x49, 0x36) ; B
table(0x3E, 0x41, 0x41, 0x41, 0x22) ; C
table(0x7F, 0x41, 0x41, 0x41, 0x3E) ; D
table(0x7F, 0x49, 0x49, 0x49, 0x41) ; E
table(0x7F, 0x09, 0x09, 0x09, 0x01) ; F
table(0x3E, 0x41, 0x41, 0x51, 0x73) ; G
table(0x7F, 0x08, 0x08, 0x08, 0x7F) ; H
table(0x00, 0x41, 0x7F, 0x41, 0x00) ; I
table(0x20, 0x40, 0x41, 0x3F, 0x01) ; J
table(0x7F, 0x08, 0x14, 0x22, 0x41) ; K
table(0x7F, 0x40, 0x40, 0x40, 0x40) ; L
table(0x7F, 0x02, 0x1C, 0x02, 0x7F) ; M
table(0x7F, 0x04, 0x08, 0x10, 0x7F) ; N
table(0x3E, 0x41, 0x41, 0x41, 0x3E) ; O
table(0x7F, 0x09, 0x09, 0x09, 0x06) ; P
table(0x3E, 0x41, 0x51, 0x21, 0x5E) ; Q
table(0x7F, 0x09, 0x19, 0x29, 0x46) ; R
table(0x26, 0x49, 0x49, 0x49, 0x32) ; S
table(0x03, 0x01, 0x7F, 0x01, 0x03) ; T
table(0x3F, 0x40, 0x40, 0x40, 0x3F) ; U
table(0x1F, 0x20, 0x40, 0x20, 0x1F) ; V
table(0x3F, 0x40, 0x38, 0x40, 0x3F) ; W
table(0x63, 0x14, 0x08, 0x14, 0x63) ; X
table(0x03, 0x04, 0x78, 0x04, 0x03) ; Y
table(0x61, 0x59, 0x49, 0x4D, 0x43) ; Z
table(0x00, 0x00, 0x7F, 0x41, 0x00) ; [
table(0x01, 0x06, 0x18, 0x60, 0x00) ; \
table(0x00, 0x41, 0x7F, 0x00, 0x00) ; ]
table(0x18, 0x06, 0x01, 0x06, 0x18) ; ^
table(0x40, 0x40, 0x40, 0x40, 0x40) ; _
table(0x00, 0x01, 0x02, 0x00, 0x00) ; '
table(0x20, 0x54, 0x54, 0x78, 0x40) ; a
table(0x7F, 0x28, 0x44, 0x44, 0x38) ; b
table(0x38, 0x44, 0x44, 0x44, 0x28) ; c
table(0x38, 0x44, 0x44, 0x28, 0x7F) ; d
table(0x38, 0x54, 0x54, 0x54, 0x18) ; e
table(0x00, 0x08, 0x7E, 0x09, 0x02) ; f
table(0x18, 0xA4, 0xA4, 0x9C, 0x78) ; g
table(0x7F, 0x08, 0x04, 0x04, 0x78) ; h
table(0x00, 0x44, 0x7D, 0x40, 0x00) ; i
table(0x20, 0x40, 0x40, 0x3D, 0x00) ; j
table(0x7F, 0x10, 0x28, 0x44, 0x00) ; k
table(0x00, 0x41, 0x7F, 0x40, 0x00) ; l
table(0x7C, 0x04, 0x78, 0x04, 0x78) ; m
table(0x7C, 0x08, 0x04, 0x04, 0x78) ; n
table(0x38, 0x44, 0x44, 0x44, 0x38) ; o
table(0xFC, 0x18, 0x24, 0x24, 0x18) ; p
table(0x18, 0x24, 0x24, 0x18, 0xFC) ; q
table(0x7C, 0x08, 0x04, 0x04, 0x08) ; r
table(0x48, 0x54, 0x54, 0x54, 0x24) ; s
table(0x04, 0x04, 0x3F, 0x44, 0x24) ; t
table(0x3C, 0x40, 0x40, 0x20, 0x7C) ; u
table(0x1C, 0x20, 0x40, 0x20, 0x1C) ; v
table(0x3C, 0x40, 0x30, 0x40, 0x3C) ; w
table(0x44, 0x28, 0x10, 0x28, 0x44) ; x
table(0x4C, 0x90, 0x90, 0x90, 0x7C) ; y
table(0x44, 0x64, 0x54, 0x4C, 0x44) ; z
table(0x00, 0x08, 0x36, 0x41, 0x00) ; {
table(0x00, 0x00, 0x77, 0x00, 0x00) ; |
table(0x00, 0x41, 0x36, 0x08, 0x00) ; }
table(0x02, 0x01, 0x02, 0x04, 0x02) ; ~
table(0x3C, 0x26, 0x23, 0x26, 0x3C) ; 0x7F
table(0x00, 0x06, 0x09, 0x09, 0x06) ; 0x80 degree symbol
