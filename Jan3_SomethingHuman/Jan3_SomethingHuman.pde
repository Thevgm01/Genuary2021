/* Hopes
2021 will be better than 2020
I'll be funnier
I'll feel happier
*/

/* Fears
I won't be good enough
I'll die before I can see the world
I'll fail out of college
I'll never find love
I'll never find my purpose
*/

/* Dreams
To see the northern lights
To go to space
To climb a mountain
To swim in the ocean
To find my purpose
*/

/* Ideas
A game where you can control gravity
A movie where the side character is the villain
A play that explores philosophy
A twitter bot that generates terrible art
*/

String name = "";
String hope = "";
String fear = "";
String dream = "";
String idea = "";

String symbols = "1234567890!@#$%^&*()_+-=,./;'[]{}:\"<>?";
String vowels = "aeiou";
HashMap<String, String[]> wordDatabase;
float optionalProbability = 0.5f;

String carat = "|";
int caratBlinkFrames = 30;
int sentenceReveal = 0;

void setup() {
  size(500, 500); 
  
  wordDatabase = new HashMap<String, String[]>();
  wordDatabase.put("HOPE", new String[]{ 
    "2021 will be better than 2020",
    "I'll !BE !POSITIVE_ADJECTIVE ?TIME", 
    "I won't !BE !NEGATIVE_ADJECTIVE ?TIME", 
    "I will !BE !POSITIVE_ADJECTIVE ?TIME", 
    "my !FAMILY will !BE !POSITIVE_ADJECTIVE" });
  wordDatabase.put("FEAR", new String[]{ 
    "I'll never !BE !POSITIVE_ADJECTIVE", 
    "I won't !BE !POSITIVE_ADJECTIVE ?TIME", 
    "I'll always be !NEGATIVE_ADJECTIVE", 
    "I'll still !BE !NEGATIVE_ADJECTIVE ?TIME", 
    "I'll never become a ?POSITIVE_ADJECTIVE !CHARACTER", 
    "I'll never !HAVE !MY ?POSITIVE_ADJECTIVE !FAMILY", 
    "my !FAMILY will !BE !NEGATIVE_ADJECTIVE",
    "I'll be too !NEGATIVE_ADJECTIVE to ask out my !FAMILY_FRIEND" });
  wordDatabase.put("DREAM", new String[]{ 
    "become a ?POSITIVE_ADJECTIVE !PROFESSION/FAMILY_ABOVE/FAMILY_RELATIONSHIP",
    "!HAVE my !FAMILY ?TIME",
    "find a !FAMILY_FRIEND/FAMILY_RELATIONSHIP ?TIME",
    "ask out my !FAMILY_FRIEND ?TIME" });
  wordDatabase.put("IDEA", new String[]{
    "a game where you play as a ?ADJECTIVE !CHARACTER who !GOAL",
    "a !MEDIUM where the main character !GOAL",
    "a !MEDIUM where the main character can !ABILITY and !GOAL",
    "a !MEDIUM where the main character, a ?ADJECTIVE !CHARACTER , !GOAL",
    "a !MEDIUM where the main character, a ?ADJECTIVE !CHARACTER who/that can !ABILITY , !GOAL"});
    
  wordDatabase.put("MEDIUM", new String[]{ "game", "movie", "book", "play", "performance" });    
  wordDatabase.put("GOAL", new String[]{ "!ACTION !PRONOUN ?ADJECTIVE !FAMILY", "!ACTION a ?ADJECTIVE !PROFESSION", "!ACTION !PRONOUN ?ADJECTIVE !FAMILY"});
  wordDatabase.put("ACTION", new String[]{ "is searching for", "is trying to find", "is adventuring with", "goes on an adventure with", "is on a quest with", "is trying to kill", "is trying to save", "is rescuing", "wants to kill", "hates", "loves", "wants to save" });
  wordDatabase.put("ABILITY", new String[]{ "!MODIFICATION !TARGET", "read minds", "fly" });
  wordDatabase.put("MODIFICATION", new String[]{ "manipulate", "control", "alter", "change" });
  wordDatabase.put("TARGET", new String[]{ "time", "fire", "water", "the future", "the past", "gravity", "air", "minds" });
  
  wordDatabase.put("ADJECTIVE", new String[]{ "!POSITIVE_ADJECTIVE", "!NEGATIVE_ADJECTIVE" });
  wordDatabase.put("POSITIVE_ADJECTIVE", new String[]{ "beautiful", "successful", "wealthy", "capable", "fabulous", "talented", "happy", "skilled", "loving", "loved", "beloved", "famous", "cute", "pretty", "kind", "wonderful", "loyal" });
  wordDatabase.put("NEGATIVE_ADJECTIVE", new String[]{ "scared", "fearful", "frail", "sad", "depressed", "lonely", "frightened", "afraid", "sickly", "empty", "hated", "angry" });
  
  wordDatabase.put("CHARACTER", new String[]{ "!PROFESSION", "!FAMILY_NOT_FRIEND" });
  wordDatabase.put("PROFESSION", new String[]{ "man", "woman", "astronaut", "game designer", "performer", "artist", "mountain climber", "florist", "programmer", "software developer", "engineer", "writer", "creator", "YouTuber", "doctor", "police officer", "paramedic", "pilot", "filmmaker", "assistant", "nurse" });
  
  wordDatabase.put("FAMILY", new String[]{ "!FAMILY_ABOVE", "!FAMILY_BELOW", "!FAMILY_RELATIONSHIP", "!FAMILY_FRIEND" });
  wordDatabase.put("FAMILY_FRIEND", new String[]{ "friend", "best friend", "crush" });
  wordDatabase.put("FAMILY_NOT_FRIEND", new String[]{ "!FAMILY_ABOVE", "!FAMILY_BELOW", "!FAMILY_RELATIONSHIP" });
  wordDatabase.put("FAMILY_RELATIONSHIP", new String[]{ "girlfriend", "boyfriend", "wife", "husband", "fiancé", "partner" });
  wordDatabase.put("FAMILY_ABOVE", new String[]{ "mother", "father", "grandmother", "grandfather", "aunt", "uncle" });
  wordDatabase.put("FAMILY_BELOW", new String[]{ "cousin", "son", "daughter", "grandson", "granddaughter", "friend", "best friend" });
  
  wordDatabase.put("TIME", new String[]{ "this year", "this week", "this month", "today", "tomorrow", "all the time" });
  wordDatabase.put("PRONOUN", new String[]{ "his", "her", "their" });
  wordDatabase.put("HAVE", new String[]{ "be with", "find", "see", "meet", "talk to", "kiss" });
  wordDatabase.put("BE", new String[]{ "be", "feel", "think I'm" });
  wordDatabase.put("MY", new String[]{ "a", "my" });
}

void draw() {
  background(0);
  
  if(frameCount % caratBlinkFrames == 0) {
    if(carat.equals(" ")) carat = "|";
    else carat = " ";
  }
  
  int startOffset = 80;
  int lineOffset = 80;
  float noiseVal = frameCount / 50f;
  float noiseScale = 10f;
  
  translate(width/2, 0);
  textAlign(CENTER, TOP);
  textSize(50);
  text(
    splitLines(name) + carat, 
    noiseScale * noise(noiseVal + 200), 
    noiseScale * noise(noiseVal + 300));
  textSize(20);
  text(
    splitLines("I hope " + getHiddenText(hope, sentenceReveal)), 
    noiseScale * noise(noiseVal), 
    noiseScale * noise(noiseVal + 100) + startOffset + lineOffset);
  text(
    splitLines("I'm afraid that " + getHiddenText(fear, sentenceReveal)), 
    noiseScale * noise(noiseVal + 10), 
    noiseScale * noise(noiseVal + 110) + startOffset + lineOffset * 2);
  text(
    splitLines("My dream is to " + getHiddenText(dream, sentenceReveal)), 
    noiseScale * noise(noiseVal + 20), 
    noiseScale * noise(noiseVal + 120) + startOffset + lineOffset * 3);
  text(
    splitLines("I have an idea for " + getHiddenText(idea, sentenceReveal)), 
    noiseScale * noise(noiseVal + 30), 
    noiseScale * noise(noiseVal + 130) + startOffset + lineOffset * 4);
    
  if(frameCount % 2 == 0) 
    ++sentenceReveal;
}

String getHiddenText(String input, int len) {
  if(len >= input.length() - 1) return input; 
  else {
    return input.substring(0, len) + symbols.charAt((input.length() + len) % symbols.length());
  }
}

String splitLines(String input) {
  if(textWidth(input) > width - 10) {
    String[] words = input.split(" ");
    String result = "";
    String newText = "";
    for(int i = 0; i < words.length; ++i) {
      if(textWidth(newText + words[i]) > width - 10) {
         result += newText + "\n";
         newText = "";
      }
      newText += words[i] + " "; 
    }
    if(!newText.equals("")) result += newText;
    return result;
  } else return input;
}

void keyPressed() {
  if(key == '1')      println(generateSentence("HOPE"));
  else if(key == '2') println(generateSentence("FEAR"));
  else if(key == '3') println(generateSentence("DREAM"));
  else if(key == '4') println(generateSentence("IDEA"));
  else if(key == BACKSPACE) {
    if(name.length() > 0) {
      name = name.substring(0, name.length() - 1);
      generateHumanity();
    }
    if(name.length() == 0) deleteHumanity();
  } else if(key != CODED) {
    name += key;
    generateHumanity();
  }
}

void generateHumanity() {
  randomSeed(name.hashCode());

  hope = generateSentence("HOPE"); 
  fear = generateSentence("FEAR"); 
  dream = generateSentence("DREAM"); 
  idea = generateSentence("IDEA"); 
  
  sentenceReveal = 0;
}

void deleteHumanity() {
  hope = ""; 
  fear = ""; 
  dream = ""; 
  idea = ""; 
}

String generateSentence(String base) {
  String result = generateToken(base);
  
  result = result.trim(); // Remove leading/trailing whitespace
  result = result.replace("  ", " "); // Remove double spaces
  result = result.replace(" ,", ","); // Move commas back next to words
  String[] resultWords = result.split(" ");
  for(int i = 1; i < resultWords.length; ++i) // Add "an" for vowels
    for(int j = 0; j < vowels.length(); ++j)
      if(resultWords[i - 1].equals("a") && resultWords[i].charAt(0) == vowels.charAt(j))
        resultWords[i - 1] = "an";
  result = String.join(" ", resultWords);
  //result = result.substring(0, 1).toUpperCase() + result.substring(1); // Capitalize first word
  result += "."; // Add a period
  return result;
}

private String generateToken(String base) {
  if(wordDatabase.containsKey(base)) {
    String[] options = wordDatabase.get(base);
    String choice = options[(int)random(options.length)];
    String[] tokens = choice.split(" "); //<>//
    for(int i = 0; i < tokens.length; ++i) {
      tokens[i] = generateToken(getTokenFromWord(tokens[i]));
    }
    return String.join(" ", tokens);
  }
  return base;
}

private String getTokenFromWord(String word) {
  if(word.startsWith("!")) {
    word = word.substring(1);
  } else if(word.startsWith("?")) {
    if(random(1) < optionalProbability) {
      word = word.substring(1);
    } else {
      return "";
    }
  }
  if(word.contains("/")) {
    String[] words = word.split("/");
    return words[(int)random(words.length)];
  }
  return word;
}
