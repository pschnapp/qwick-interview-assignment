var doThingsAndStuff = x => {
  var working = [];
  var string;
  var charIndex;
  var workIndex;
  while (x.length) {
    string = x.pop();
    if (!string) continue;
    for (charIndex = 0; charIndex < string.length; charIndex++)
      if (string && string.charCodeAt(charIndex) == 32) {
        var start = ++charIndex;
        var doBreak = false;
        var isFound = false;
        for (workIndex = 0; workIndex < working.length; workIndex++) {
          if (doBreak) {
            break;
          }
          charIndex = start;
          isFound = false;
          for (var workCharIndex = 0; workCharIndex < working[workIndex].length; workCharIndex++) {
            if (!isFound && working[workIndex].charCodeAt(workCharIndex) == 32) {
              isFound = true;
              continue;
            } else if (!isFound) {
              continue;
            }
            if (!string.charCodeAt(charIndex) || string.charCodeAt(charIndex) <
              working[workIndex].charCodeAt(workCharIndex)) {
              workIndex--;
              if (workIndex < 0) {
                workIndex = 0;
              }
              working.splice(workIndex, 0, string);
              doBreak = true;
              break;
            } else if (string.charCodeAt(charIndex) == working[workIndex].charCodeAt(workCharIndex)) {
              charIndex++;
              continue;
            } else {
              doBreak = true;
              break;
            }
          }
        }
        addIfUnique(string, working)
        break
      }
  };
  transferBack(working, x)
};

function addIfUnique(str, list) {
  var isFound = false;
  for (var i = 0; i < list.length; i++) {
    if (str === list[i]) {
      isFound = true;
      break;
    }
  }
  if (!isFound) {
    list.push(str);
  }
}

function transferBack(source, dest) {
  while (source.length) {
    dest.push(source.pop());
  }
}

var x = [" hello", " world,", null, " how", " ", "are you?"]
doThingsAndStuff(x);
console.log(x);
