function classToValue(element){
  switch(element.className){
    case "guesses one":
      return "1";
      break;
    case "guesses two":
      return "2";
      break;
    case "guesses three":
      return "3";
      break;
    case "guesses four":
      return "4";
      break;
  }
}

function updateInput(element) {
  var value = classToValue(element);
  switch(element.id){
    case "guess1":
      document.getElementById("input1").value = value;
      break;
    case "guess2":
      document.getElementById("input2").value = value;
      break;
    case "guess3":
      document.getElementById("input3").value = value;
      break;
    case "guess4":
      document.getElementById("input4").value = value;
      break;
  }
}

function cycleValue(e) {
  var target = e.target;
  switch (target.className){
    case "guesses one":
      target.className = "guesses two";
      updateInput(target);
      break;
    case "guesses two":
      target.className = "guesses three";
      updateInput(target);
      break;
    case "guesses three":
      target.className = "guesses four";
      updateInput(target);
      break;
    case "guesses four":
      target.className = "guesses one";
      updateInput(target);
      break;
    case "guesses zero":
      target.className = "guesses one";
      updateInput(target);
      break;
    }
  }
