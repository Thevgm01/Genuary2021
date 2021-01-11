final float trigTableSize = 5000f;
float[] sinTable, cosTable;

void initializeTrigTable() {
  int numEntries = (int)(TWO_PI * trigTableSize);
  sinTable = new float[numEntries + 1];
  cosTable = new float[numEntries + 1];
  for(int i = 0; i <= numEntries; ++i) {
    sinTable[i] = sin(i / trigTableSize);
    cosTable[i] = cos(i / trigTableSize);
  }
}

float trigTable(float[] table, float angle) {
  while(angle < 0) angle += TWO_PI;
  while(angle >= TWO_PI) angle -= TWO_PI;
  return table[(int)(angle * trigTableSize)];
}
float sinTable(float angle) {
  return trigTable(sinTable, angle); 
}

float cosTable(float angle) {
  return trigTable(cosTable, angle); 
}
