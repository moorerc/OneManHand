#define MIC_DATA_SAMPLE_SIZE (30)
#define MIC_DATA_DEFAULT_TIME (20)
#define MIC_DATA_LOWER_BOUND (70)

int micValue;
int micTimeLeft;

int blow = 0;
int index = 1;
int middle = 2;
int ring = 3;
int pinky = 4;
int lowOct = 2;
int highOct = 4;

int MIDDLE_THRESHOLD = 100;
int RING_THRESHOLD = 160;
int INDEX_THRESHOLD = 165;
int PINKY_THRESHOLD = 175;

int CALIBRATE_LED = 8;

void setup(){
   Serial.begin(9600);
   micValue = 0;
   micTimeLeft = -1;
   
   pinMode(CALIBRATE_LED, OUTPUT);
   digitalWrite(CALIBRATE_LED, HIGH);
   INDEX_THRESHOLD = calibrate(index, 100);
   MIDDLE_THRESHOLD = calibrate(middle, 100);
   RING_THRESHOLD = calibrate(ring, 100);
   PINKY_THRESHOLD = calibrate(pinky, 100);
   digitalWrite(CALIBRATE_LED, LOW);
}

void loop(){
  /*
  Serial.print("blow: ");
  Serial.print(getMicValue());
  Serial.print(" index: ");
  Serial.print(analogRead(index));
  Serial.print(" middle: ");
  Serial.print(analogRead(middle));
  Serial.print(" ring: ");
  Serial.print(analogRead(ring));
  Serial.print(" pinky: ");
  Serial.print(analogRead(pinky));
  Serial.print('\n');
  */
  
  updateMic();
  if(Serial.available()){
    int inputByte = Serial.read();
    switch(inputByte){
      case 10: // blow
        //Serial.write((analogRead(blow) < BLOW_THRESHOLD)? 1:0);
        Serial.write(getMicValue());
        break;
      case 11: // index
        Serial.write((analogRead(index) < INDEX_THRESHOLD)? 1:0);
        break;
      case 12: // middle
        Serial.write((analogRead(middle) < MIDDLE_THRESHOLD)? 1:0);
        break;
      case 13: // ring
        Serial.write((analogRead(ring) < RING_THRESHOLD)? 1:0);
        break;
      case 14: // pinky
        Serial.write((analogRead(pinky) < PINKY_THRESHOLD)? 1:0);
        break;  
      case 15: //lowButton
        Serial.write(digitalRead(lowOct));
        break;
      case 16: //highButton
        Serial.write(digitalRead(highOct));
        break;     
    }
  }
}

int calibrate(int input, int numSamples){
  int valArray[numSamples];
  
  for(int i = 0; i < numSamples; i++){
    int val = analogRead(input);
    
    valArray[i] = val;
    for(int j = i; j > 0; j--){
      if(valArray[j - 1] > valArray[j]){
        int temp = valArray[j];
        valArray[j] = valArray[j - 1];
        valArray[j - 1] = temp;
      }else{
        break;
      }
    }
    delay(5);
  }
  
  return valArray[numSamples / 2];;
}

void updateMic(){
  if(micTimeLeft > 0){
    micTimeLeft--;
  }
  
  int count = 0;
  for(int i = 0; i < MIC_DATA_SAMPLE_SIZE; i++){
    int val = analogRead(blow);
    /*
    if((val >= MIC_DATA_LOWER_BOUND) && (micTimeLeft <= 0)){
      if(micValue < val){
        micValue = val;
      }else{
        micTimeLeft = MIC_DATA_DEFAULT_TIME;
        micValue = val;
      }
    }*/
    if(val >= MIC_DATA_LOWER_BOUND){
      if(micValue < val){
        micValue = val;
      }
      micTimeLeft = MIC_DATA_DEFAULT_TIME;
    }
  }
}

int getMicValue(){
  if(micTimeLeft > 0){
    return 1;//micValue;
  }else{
    return 0;
  }
}


