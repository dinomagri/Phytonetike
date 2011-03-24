//frente esq = 1
// frente dir = 5

// tras esq 3
// tras dir 2

// isso precisa ir pro arquivo.h>

void mediumMovement();
void colisaoFrenteHappened();
void colisaoTrasHappened(); 
void crazyMovement();
void littleMovement();
void stopMove();

// ANALOG PINS
//int temperaturaPin = 0;

int umidadePin = 0;

int ldrTrasEsq =  3;
int ldrTrasDir =  1;
int ldrFrenteEsq = 2;
int ldrFrenteDir = 5;

// int umidadePin = 0;
// int ldrTrasEsq =  3;
// int ldrTrasDir =  2;
// int ldrFrenteEsq = 1;
// int ldrFrenteDir = 5;

// DIGITAL PINS
int colisaoTras = 12; //2
int colisaoFrente = 11; //3
int forward = 2; //Movimenta motor pra frente
int backwards = 7; //Movimenta motor pra trás
int left = 10; //Movimenta motor pra esquerda
int right = 13; //Movimenta motor pra direita


int soundPin = 8;

// GLOBAL VARS
int direcao = 1; // 1 frente 0 tras

// VERIFICA LUZ
int limiarLuz= 650; // limiarLuzque define a "luz agradável"
int limiarUmidade = 450;
//VALUES
int luzTras;
int luzFrente;
int temperatura;
int umidade;
 
void setup()   {     
  Serial.begin(9600);
  //ANALOG
  //pinMode(temperaturaPin, INPUT);  
  pinMode(umidadePin, INPUT); 
  pinMode(ldrTrasEsq, INPUT);
  pinMode(ldrFrenteEsq, INPUT);
  pinMode(ldrTrasDir, INPUT);
  pinMode(ldrFrenteDir, INPUT);
  
  //DIGITAL
  pinMode(colisaoTras, INPUT);
  pinMode(colisaoFrente, INPUT);
  pinMode(soundPin, OUTPUT);
  pinMode(left, OUTPUT);
  pinMode(right, OUTPUT);
  
}

void loop()                    
{
 
  int luzTrasEsq = analogRead(ldrTrasEsq);
  int luzTrasDir = analogRead(ldrTrasDir);
  int luzFrenteEsq = analogRead(ldrFrenteEsq);
  int luzFrenteDir = analogRead(ldrFrenteDir);

  //int temperatura = analogRead(temperaturaPin);
  int umidade = analogRead(umidadePin);
  
  // DEBUGS
  Serial.print("\nluzTrasEsq:");
  Serial.print(luzTrasEsq);
  Serial.print("\nluzTrasDir:");
  Serial.print(luzTrasDir);
  
  Serial.print("\nluzFrenteEsq:");
  Serial.print(luzFrenteEsq);
  Serial.print("\nluzFrenteDir:");
  Serial.print(luzFrenteDir);
  
  Serial.print("\n\n\n");
  Serial.print("\nUmidade:");
  Serial.print(umidade);
 
  colisaoFrenteHappened(); 
  colisaoTrasHappened();

  int luzFrente = (luzFrenteEsq+luzFrenteDir)/2;
  int luzTras = (luzTrasEsq+luzTrasDir)/2; 

  //Se umidade menor que limiar Umidade, executa movimento doidão
  if (umidade > limiarUmidade) {
     crazyMovement();
     // som de alegria \o/ águaaaaa eeeeeeeeeeeeeeeee :-D
     Serial.println("recebeu agua!");
     for (int i=0; i<5; i++) tone(soundPin, map(umidade, 600, 800, 1000, 2000), 100);
  }
 
  //Senão, verifiza luz
  else {
    Serial.print("\n\n #### Verificando luz!");
    // se a luz de um dos sensores estiver acima do limiar, planta fica parada
    if ((luzTras >= limiarLuz) || (luzFrente >= limiarLuz)) {
        Serial.print("\n\nfica parada!");
        stopMove();
        digitalWrite(backwards, 0);
        pinMode(backwards, INPUT);
        digitalWrite(forward, 0);
        pinMode(forward, INPUT);
     
    // senão, se movimenta em direção do sensor com mais luminosidade 
    }
    else {
      if (((luzTrasEsq > luzFrenteEsq*1.1) and (luzTrasEsq > luzFrenteDir*1.1)) or ((luzTrasDir > luzFrenteDir*1.1) and (luzTrasDir > luzFrenteEsq*1.1))) {
        Serial.print("\n\nandando pra trás!!");
          
        direcao = 0;
        mediumMovement();
                
        if (luzTrasEsq > luzTrasDir) { digitalWrite(left, 1); Serial.print("\n\nandando pra esquerda!!"); }
        else { Serial.print("\n\nandando pra direita!!"); digitalWrite(right, 1); }         
        colisaoTrasHappened();
        littleMovement();
        digitalWrite(left, 0);
        digitalWrite(right, 0);
      } else {
        Serial.print("\n\nandando pra frente!!");
        direcao = 1;
        littleMovement();
        
        if (luzFrenteEsq > luzFrenteDir) { digitalWrite(left, 1); Serial.print("\n\nandando pra esquerda!!"); }
        else { Serial.print("\n\nandando pra direita!!"); digitalWrite(right, 1); }           
        colisaoFrenteHappened();
        littleMovement(); 
      }
     
    }
  }
  
  // som do passo
  for (int i=0; i<5; i++) tone(soundPin, map(umidade, 600, 800, 1000, 2000), 10);
 
} 
 
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
  // digitalWrite(left, 0);
  // pinMode(left, INPUT);
  // digitalWrite(right, 0);
  // pinMode(right, INPUT);
}

void moveForward()
{
  stopMove();
  pinMode(forward, OUTPUT);
  digitalWrite(forward, 1);          
  }

void moveLeft()
{
  pinMode(left, OUTPUT);
  digitalWrite(left, 1);          
  }


void moveRight()
{
  pinMode(right, OUTPUT);
  digitalWrite(right, 1);          
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
    delay(1800);
    stopMove();
    delay(400);
    break;
 
    case 0:
    moveBackwards();
    delay(1800);
    stopMove();
    delay(400);
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
      //pinMode(left, OUTPUT);
      digitalWrite(left, 1);          
      littleMovement();
      mediumMovement();
      digitalWrite(left, 0);          
      Serial.println("\n\n !!!!! Colisao Frente");
    }
  }

void colisaoTrasHappened() {
    if (digitalRead(colisaoTras)) {
      direcao = 1;
      //pinMode(right, OUTPUT);
      digitalWrite(right, 1);          
      mediumMovement();
      mediumMovement();
      digitalWrite(right, 0);          
      Serial.println("\n\n !!!! Colisao TRAS");
    }
  } 

