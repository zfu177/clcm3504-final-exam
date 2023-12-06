document.addEventListener('DOMContentLoaded', function () {
  var elems = document.querySelectorAll('.parallax');
  var options = {};
  var instances = M.Parallax.init(elems, options);

  var elems = document.querySelectorAll('.collapsible');
  var instances = M.Collapsible.init(elems, options);

  // Initiate sidenav
  var elems = document.querySelectorAll('.sidenav');
  M.Sidenav.init(elems, options);
});
