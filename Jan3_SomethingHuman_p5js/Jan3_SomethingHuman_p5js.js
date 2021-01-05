Object.defineProperty(String.prototype, 'hashCode', {
  value: function() {
    var hash = 0, i, chr;
    for (i = 0; i < this.length; i++) {
      chr   = this.charCodeAt(i);
      hash  = ((hash << 5) - hash) + chr;
      hash |= 0; // Convert to 32bit integer
    }
    return hash;
  }
});

var name = "";
var hope = "";
var fear = "";
var dream = "";
var idea = "";

var symbols = "1234567890!@#$%^&*()_+-=,./;'[]{}:\"<>?";
var vowels = "aeiou";
var wordDatabase = new Map();
var optionalProbability = 0.5;

var carat = "|";
var caratBlinkFrames = 30;
var sentenceReveal = 0;

function setup() {
  createCanvas(500, 500); 
  frameRate(60);
  noStroke();
  fill(255);
  
  wordDatabase.set("HOPE", [ 
    "2021 will be better than 2020",
    "I'll !BE !POSITIVE_ADJECTIVE ?TIME", 
    "I won't !BE !NEGATIVE_ADJECTIVE ?TIME", 
    "I will !BE !POSITIVE_ADJECTIVE ?TIME", 
    "my !FAMILY will !BE !POSITIVE_ADJECTIVE" ]);
  wordDatabase.set("FEAR", [ 
    "I'll never !BE !POSITIVE_ADJECTIVE", 
    "I won't !BE !POSITIVE_ADJECTIVE ?TIME", 
    "I'll always be !NEGATIVE_ADJECTIVE", 
    "I'll still !BE !NEGATIVE_ADJECTIVE ?TIME", 
    "I'll never become a ?POSITIVE_ADJECTIVE !CHARACTER", 
    "I'll never !HAVE !MY ?POSITIVE_ADJECTIVE !FAMILY", 
    "my !FAMILY will !BE !NEGATIVE_ADJECTIVE",
    "I'll be too !NEGATIVE_ADJECTIVE to ask out my !FAMILY_FRIEND" ]);
  wordDatabase.set("DREAM", [ 
    "become a ?POSITIVE_ADJECTIVE !PROFESSION/FAMILY_ABOVE/FAMILY_RELATIONSHIP",
    "!HAVE my !FAMILY ?TIME",
    "find a !FAMILY_FRIEND/FAMILY_RELATIONSHIP ?TIME",
    "ask out my !FAMILY_FRIEND ?TIME" ]);
  wordDatabase.set("IDEA", [
    "a game where you play as a ?ADJECTIVE !CHARACTER who !GOAL",
    "a !MEDIUM where the main character !GOAL",
    "a !MEDIUM where the main character can !ABILITY and !GOAL",
    "a !MEDIUM where the main character, a ?ADJECTIVE !CHARACTER , !GOAL",
    "a !MEDIUM where the main character, a ?ADJECTIVE !CHARACTER who/that can !ABILITY , !GOAL"]);
    
  wordDatabase.set("MEDIUM", [ "game", "movie", "book", "play", "performance" ]);    
  wordDatabase.set("GOAL", [ "!ACTION !PRONOUN ?ADJECTIVE !FAMILY", "!ACTION a ?ADJECTIVE !PROFESSION", "!ACTION !PRONOUN ?ADJECTIVE !FAMILY"]);
  wordDatabase.set("ACTION", [ "is searching for", "is trying to find", "is adventuring with", "goes on an adventure with", "is on a quest with", "is trying to kill", "is trying to save", "is rescuing", "wants to kill", "hates", "loves", "wants to save" ]);
  wordDatabase.set("ABILITY", [ "!MODIFICATION !TARGET", "read minds", "fly" ]);
  wordDatabase.set("MODIFICATION", [ "manipulate", "control", "alter" ]);
  wordDatabase.set("TARGET", [ "time", "fire", "water", "the future", "the past", "gravity", "air", "minds" ]);
  
  wordDatabase.set("ADJECTIVE", [ "!POSITIVE_ADJECTIVE", "!NEGATIVE_ADJECTIVE" ]);
  wordDatabase.set("POSITIVE_ADJECTIVE", [ "beautiful", "successful", "wealthy", "capable", "fabulous", "talented", "happy", "skilled", "loving", "loved", "beloved", "famous", "cute", "pretty", "kind", "wonderful", "loyal" ]);
  wordDatabase.set("NEGATIVE_ADJECTIVE", [ "scared", "fearful", "frail", "sad", "depressed", "lonely", "frightened", "afraid", "sickly", "empty", "hated", "angry" ]);
  
  wordDatabase.set("CHARACTER", [ "!PROFESSION", "!FAMILY_NOT_FRIEND" ]);
  wordDatabase.set("PROFESSION", [ "man", "woman", "astronaut", "game designer", "performer", "artist", "mountain climber", "florist", "programmer", "software developer", "engineer", "writer", "creator", "YouTuber", "doctor", "police officer", "paramedic", "pilot", "filmmaker", "assistant", "nurse" ]);
  
  wordDatabase.set("FAMILY", [ "!FAMILY_ABOVE", "!FAMILY_BELOW", "!FAMILY_RELATIONSHIP", "!FAMILY_FRIEND" ]);
  wordDatabase.set("FAMILY_FRIEND", [ "friend", "best friend", "crush" ]);
  wordDatabase.set("FAMILY_NOT_FRIEND", [ "!FAMILY_ABOVE", "!FAMILY_BELOW", "!FAMILY_RELATIONSHIP" ]);
  wordDatabase.set("FAMILY_RELATIONSHIP", [ "girlfriend", "boyfriend", "wife", "husband", "fiancé", "partner" ]);
  wordDatabase.set("FAMILY_ABOVE", [ "mother", "father", "grandmother", "grandfather", "aunt", "uncle" ]);
  wordDatabase.set("FAMILY_BELOW", [ "cousin", "son", "daughter", "grandson", "granddaughter", "friend", "best friend" ]);
  
  wordDatabase.set("TIME", [ "this year", "this week", "this month", "today", "tomorrow", "all the time" ]);
  wordDatabase.set("PRONOUN", [ "his", "her", "their" ]);
  wordDatabase.set("HAVE", [ "be with", "find", "see", "meet", "talk to", "kiss" ]);
  wordDatabase.set("BE", [ "be", "feel", "think I'm" ]);
  wordDatabase.set("MY", [ "a", "my" ]);
}

function draw() {
  background(0);
  
  if(frameCount % caratBlinkFrames == 0) {
    if(carat === " ") {
      carat = "|";
    } else {
      carat = " ";
    }
  }
  
  let startOffset = 80;
  let lineOffset = 80;
  let noiseVal = frameCount / 50.0;
  let noiseScale = 10.0;
  
  //translate(width/2, 0);
  //textAlign(CENTER, TOP);
  translate(10, 0);
  textAlign(LEFT, TOP);
  textSize(50);
  text(
    splitLines(name) + carat, 
    noiseScale * noise(noiseVal + 200), 
    noiseScale * noise(noiseVal + 300));
  textSize(20);
  text(
    splitLines("I hope " + getHiddenText(hope)), 
    noiseScale * noise(noiseVal), 
    noiseScale * noise(noiseVal + 100) + startOffset + lineOffset);
  text(
    splitLines("I'm afraid that " + getHiddenText(fear)), 
    noiseScale * noise(noiseVal + 10), 
    noiseScale * noise(noiseVal + 110) + startOffset + lineOffset * 2);
  text(
    splitLines("My dream is to " + getHiddenText(dream)), 
    noiseScale * noise(noiseVal + 20), 
    noiseScale * noise(noiseVal + 120) + startOffset + lineOffset * 3);
  text(
    splitLines("I have an idea for " + getHiddenText(idea)), 
    noiseScale * noise(noiseVal + 30), 
    noiseScale * noise(noiseVal + 130) + startOffset + lineOffset * 4);
    
  if(frameCount % 2 == 0) {
    ++sentenceReveal;
  }
}

function getHiddenText(input) {
  if(sentenceReveal >= input.length - 1) {
    return input; 
  } else {
    return input.substring(0, sentenceReveal) + symbols.charAt((input.length + sentenceReveal) % symbols.length);
  }
}

function splitLines(input) {
  if(textWidth(input) > width - 20) {
    let words = input.split(" ");
    let result = "";
    let newText = "";
    for(let i = 0; i < words.length; ++i) {
      if(textWidth(newText + words[i]) > width - 20) {
         result += newText + "\n";
         newText = "";
      }
      newText += words[i] + " "; 
    }
    if(newText !== "") {
      result += newText;
    }
    return result;
  } else {
    return input;
  }
}

function keyTyped() {
  name += key;
  generateHumanity();
  return false;
}

function keyPressed() {
  if(keyCode == BACKSPACE) {
    if(name.length > 0) {
      name = name.substring(0, name.length - 1);
      generateHumanity();
    }
    if(name.length == 0) {
      deleteHumanity();
    }
    return false;
  }
}

function generateHumanity() {
  randomSeed(name.hashCode());

  hope = generateSentence("HOPE"); 
  fear = generateSentence("FEAR"); 
  dream = generateSentence("DREAM"); 
  idea = generateSentence("IDEA"); 
  
  sentenceReveal = 0;
}

function deleteHumanity() {
  hope = ""; 
  fear = ""; 
  dream = ""; 
  idea = ""; 
}

function generateSentence(base) {
  let result = generateToken(base);
  
  result = result.trim(); // Remove leading/trailing whitespace
  result = result.replace("  ", " "); // Remove double spaces
  result = result.replace(" ,", ","); // Move commas back next to words
  let resultWords = result.split(" ");
  for(let i = 1; i < resultWords.length; ++i) { // Add "an" for vowels
    for(let j = 0; j < vowels.length; ++j) {
      if(resultWords[i - 1] === "a" && resultWords[i].charAt(0) == vowels.charAt(j)) {
        resultWords[i - 1] = "an";
      }
    }
  }
  result = resultWords.join(" ");
  //result = result.substring(0, 1).toUpperCase() + result.substring(1); // Capitalize first word
  result += "."; // Add a period
  return result;
}

function generateToken(base) {
  let options = wordDatabase.get(base);
  if(options != null) {
    let choice = options[Math.floor(random(options.length))];
    let tokens = choice.split(" ");
    for(let i = 0; i < tokens.length; ++i) {
      tokens[i] = generateToken(getTokenFromWord(tokens[i]));
    }
    return tokens.join(" ");
  }
  return base;
}

function getTokenFromWord(word) {
  if(word.startsWith("!")) {
    word = word.substring(1);
  } else if(word.startsWith("?")) {
    if(random(1) < optionalProbability) {
      word = word.substring(1);
    } else {
      return "";
    }
  }
  if(word.includes("/")) {
    let words = word.split("/");
    return words[Math.floor(random(words.length))];
  }
  return word;
}
