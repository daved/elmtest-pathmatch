function pathNameMatches(ref, val) {
  if (val.length < ref.length) {
    return false;
  }

  var n = -1;
  for (var i = 0; i < ref.length; i++) {
    n++;
    if (n >= val.length - 1) {
      break;
    }

    if (ref[i] == '*') {
      if (val[n] == '/') {
        n--;
        continue;
      }

      i--;
      continue;
    }

    if (ref[i] != val[n]) {
      return false;
    }
  }

  return (n == val.length - 1);
}

function TestPathNameMatches(fn) {
  var ds = [{
      name: "static inequal short",
      ref: "INBOX/test",
      val: "oops/",
      want: false
    },
    {
      name: "static inequal",
      ref: "INBOX/test",
      val: "INBOX/oops",
      want: false
    },
    {
      name: "static inequal long",
      ref: "INBOX/test",
      val: "INBOX/testx",
      want: false
    },
    {
      name: "static equal",
      ref: "INBOX/test",
      val: "INBOX/test",
      want: true
    },
    {
      name: "wildcard nonequiv prefix",
      ref: "INBOX/*",
      val: "INBUZ/oops",
      want: false
    },
    {
      name: "wildcard nonequiv long",
      ref: "INBOX/*",
      val: "INBOX/something/test",
      want: false
    },
    {
      name: "wildcard equiv",
      ref: "INBOX/*",
      val: "INBOX/test",
      want: true
    },
    {
      name: "wildcard equiv long",
      ref: "INBOX/*/test",
      val: "INBOX/something/test",
      want: true
    },
  ]

  ds.forEach(function(d) {
    var got = fn(d.ref, d.val);
    if (got != d.want) {
      document.body.innerHTML += d.name + ": got " + got + ", want " + d.want + "\n";
    }
  });
}

TestPathNameMatches(pathNameMatches);
