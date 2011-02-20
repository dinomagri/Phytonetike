// ANALOG PINS
int temperaturaPin = 0;
int umidadePin = 3;
int ldrTras =  1;
int ldrFrente = 2;

// DIGITAL PINS
int colisaoTras = 0; //2
int colisaoFrente = 1; //3
int forward = 2; //Movimenta motor pra frente
int backwards = 7; //Movimenta motor pra trás
int soundPin = 8;

// GLOBAL VARS
int direcao = 1; // 1 frente 0 tras

// VERIFICA LUZ
int limiarLuz= 50; // limiarLuzque define a "luz agradável"
int limiarUmidade = 750;
//VALUES
int luzTras;
int luzFrente;
int temperatura;
int umidade;
 
void setup()   {     
  Serial.begin(9600);
  //ANALOG
  pinMode(temperaturaPin, INPUT);  
  pinMode(umidadePin, INPUT); 
  pinMode(ldrTras, INPUT);
  pinMode(ldrFrente, INPUT);
  //DIGITAL
  pinMode(colisaoTras, INPUT);
  pinMode(colisaoFrente, INPUT);
  pinMode(soundPin, OUTPUT);
}

void loop()                    
{
 
  int luzTras = analogRead(ldrTras);
  int luzFrente = analogRead(ldrFrente);
  int temperatura = analogRead(temperaturaPin);
  int umidade = analogRead(umidadePin);
  Serial.println(luzTras);
  Serial.println(luzFrente);
 
  colisaoFrenteHappened();
  colisaoTrasHappened();
 
 
  //Se umidade menor que limiar Umidade, executa movimento doidão
  if (umidade < limiarUmidade) {
     crazyMovement();
     // som de alegria \o/ águaaaaa eeeeeeeeeeeeeeeee :-D
     for (int i=0; i<5; i++) tone(soundPin, map(umidade, 600, 800, 1000, 2000), 100);
  }
 
  //Senão, verifiza luz
  else {
    // se a luz de um dos sensores estiver acima do limiar, planta fica parada
    if ((luzTras >= limiarLuz) || (luzFrente >= limiarLuz)) {
      //stopMove();
        digitalWrite(backwards, 0);
        pinMode(backwards, INPUT);
        digitalWrite(forward, 0);
        pinMode(forward, INPUT);
        Serial.println("entrou!");
     
    // senão, se movimenta em direção do sensor com mais luminosidade 
    }
    else {
     if (luzTras > luzFrente) {
        direcao = 0;
        littleMovement();   
      } else {
        direcao = 1;
        littleMovement();
      }
     
    }
  }
  
  // som do passo
  for (int i=0; i<5; i++) tone(soundPin, map(umidade, 600, 800, 1000, 2000), 10);
 
} 

 
  /*
  // REALIZA MOVIMENTO
  */
 
  //temperatura = analogRead(temperaturaPin);
  //luminosidade_frente = analogRead(luminosidade_frentePin);
  //luminosidade_tras = analogRead(luminosidade_trasPin);
   //umidade = analogRead(umidadePin);
  //contato_frente = digitalRead(contato_frentePin);
  //contato_tras = digitalRead(contato_trasPin);
 
// FUNCOES AUXILIARES 

void tone(int speakerPin, int tone, int duration) {
  for (long i = 0; i < duration * 1000L; i += tone * 2) {
    digitalWrite(speakerPin, HIGH);
    delayMicroseconds(tone);
    digitalWrite(speakerPin, LOW);
    delayMicroseconds(tone);
  }
}
 
void stopMove()   
{
  digitalWrite(backwards, 0);
  pinMode(backwards, INPUT);
  digitalWrite(forward, 0);
  pinMode(forward, INPUT);
}

void moveForward()
{
  stopMove();
  pinMode(forward, OUTPUT);
  digitalWrite(forward, 1);          
  }

void moveBackwards()
{
  stopMove();
  pinMode(backwards, OUTPUT); 
  digitalWrite(backwards, 1);          
} 

void littleMovement()
{
    switch(direcao) {
   
    case 1:
    moveForward();
    delay(600);
    stopMove();
    delay(300);
    break;
 
    case 0:
    moveBackwards();
    delay(100);
    stopMove();
    delay(600);
    break;
  }
} 


void mediumMovement()
{
    switch(direcao) {
   
    case 1:
    moveForward();
    delay(800);
    stopMove();
    delay(300);
    break;
 
    case 0:
    moveBackwards();
    delay(800);
    stopMove();
    delay(300);
    break;
  }
} 

void crazyMovement()
{
  int i;
  for(i=0; i<1000; i++)
    stopMove();
    moveForward();
    delay(100);
    moveBackwards();
    delay(100);
}

 void colisaoFrenteHappened() {
    if (digitalRead(colisaoFrente)) {
      direcao = 0;
      mediumMovement();
      Serial.println("Colisao Frente");
    }
  }

void colisaoTrasHappened() {
    if (digitalRead(colisaoTras)) {
      direcao = 1;
      mediumMovement();
      Serial.println("Colisao TRAS");
    }
  } 
