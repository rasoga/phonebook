$(document).foundation()

$('#nameSearch').on('input', function() { 
  //$(this).val() // get the current value of the input field.
  var menus = document.getElementsByClassName("persoWrapper");
  if($(this).val() == "")
  {
    for (var i = menus.length - 1; i >= 0; i--)
    {
      menus[i].style.display = "block";
    }
  }
  else
  {
    for (var i = menus.length - 1; i >= 0; i--)
    {
      var curEl = ($(menus[i]).find('.fullname'))[0];
      var curEll = ($(menus[i]).find('.accname'))[0];
      var vnameNode = null;
      var nnameNode = null;
      for (var j = 0; j < curEl.childNodes.length; j++) {
          console.log(curEl.childNodes[j]);
          if (curEl.childNodes[j].className == "vname") {
            vnameNode = curEl.childNodes[j];
            break;
          }
      }
      for (var j = 0; j < curEl.childNodes.length; j++) {
          if (curEl.childNodes[j].className == "nname") {
            nnameNode = curEl.childNodes[j];
            break;
          }
      }
      if(vnameNode.innerText.toLowerCase().indexOf($(this).val().toLowerCase()) != -1 || nnameNode.innerText.toLowerCase().indexOf($(this).val().toLowerCase()) != -1 || curEll.innerText.toLowerCase().indexOf($(this).val().toLowerCase()) != -1)
      {
        menus[i].style.display = "block";
      }
      else
      {
        menus[i].style.display = "none";
      }
    }
  }
});

function showForLetter(sign) {
  var menus = document.getElementsByClassName("persoWrapper");
  for (var i = menus.length - 1; i >= 0; i--)
  {
    menus[i].style.display = "block";
  }
  for (var i = menus.length - 1; i >= 0; i--)
  {
    var curEl = ($(menus[i]).find('.fullname'))[0];
    var vnameNode = null;
    for (var j = 0; j < curEl.childNodes.length; j++) {
        if (curEl.childNodes[j].className == "vname") {
          vnameNode = curEl.childNodes[j];
          break;
        }
    }
    if( vnameNode.innerText.charAt(0).toLowerCase() == sign.toLowerCase() )
    {
      menus[i].style.display = "block";
    }
    else
    {
      menus[i].style.display = "none";
    }
  }
}
