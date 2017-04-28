function cycleValue(e) {
  var target = e.target;
  switch (target.className){
    case "guesses one":
      target.className = "guesses two";
      break;
    case "guesses two":
      target.className = "guesses three";
      break;
    case "guesses three":
      target.className = "guesses four";
      break;
    case "guesses four":
      target.className = "guesses zero";
      break;
    case "guesses zero":
      target.className = "guesses one"
      break;
    }
  }
