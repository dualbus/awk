#!/usr/bin/awk -f

# Awk implementation of (almost) RFC4180 <http://www.ietf.org/rfc/rfc4180.txt>.

function die(s, c, msg) {
    error_fmt = "E [R=%d,C=%d,s=%d,\"i=%s\"]: %s.\n";
    gsub(/"/, "\"\"", c);
    printf error_fmt, NR, _NC, s, c, msg > "/dev/stderr";
    exit 1;
}



# Escape a string according to CSV escaping rules, which basically
# are:
#
# 1. If the string contains double quotes, duplicate the double
#    quotes, so that string = «foo"bar» becomes «foo""bar».
# 2. Put the string inside double quotes, i.e. string -> "string"
#
function csv_escape_field(field) {
    gsub(/"/, "\"\"", field);
    return field;
}



# _buffer manipulation functions. Use these to access the _buffer
# global variable.
function _buffer_clear() {
  _buffer = ""
}

function _buffer_push(c) {
  _buffer = _buffer c
}

function _buffer_get() {
  return _buffer
}


function _dispatch_event(type) {
  if("record" == type) {
    event_record(_buffer_get());
  } else {
    event_field(_buffer_get());
  }

  _buffer_clear();
}


function _state_dquote(input) {
  if("\"" == input) {
      return "escape";
  }

  _buffer_push(input);

  return "dquote";
}

function _state_initial(input) {
  if("\"" == input) {
      return "dquote";
  } else
  if("," == input) {
      _dispatch_event("field");
      return "initial";
  } else
  if("\n" == input) {
      _dispatch_event("record");
      return "initial";
  } else
  if("\r" == input) {
      _dispatch_event("record");
      return "cr";
  }

  _buffer_push(input);

  return "field";
}

function _state_field(input) {
  if("," == input) {
      _dispatch_event("field");
      return "initial";
  } else
  if("\n" == input) {
      _dispatch_event("record");
      return "initial";
  }
  if("\r" == input) {
      _dispatch_event("record");
      return "cr";
  }

  _buffer_push(input);

  return "field";
}

function _state_escape(input) {
  if("\"" == input) {
    _buffer_push(input);

    return "dquote";
  } else
  if("," == input) {
      _dispatch_event("field");
      return "initial";
  } else
  if("\n" == input) {
      _dispatch_event("record");
      return "initial";
  } else
  if("\r" == input) {
      _dispatch_event("record");
      return "cr";
  } else {
      die("escape", input, "Expecting DQUOTE, COMMA, CR, or LF");
  }
}

function _state_cr(input) {
  if("\n" == input) {
    return "initial";
  }

  die("cr", input, "Expecting LF");
}

function _fsm_tick(state, input) {
  if("field"    == state) {
    return _state_field(input);
  } else
  if("dquote"   == state) {
    return _state_dquote(input);
  } else
  if("initial"  == state) {
    return _state_initial(input);
  } else
  if("escape"   == state) {
    return _state_escape(input);
  } else
  if("cr"       == state) {
    return _state_cr(input);
  }
}

function _handle_line(line, state,    len,i,input) {
  len = length(line);
  for(i = 1; i <= len + 1; i++) {
      _NC = 1;

      if(i == len + 1) {
        input = "\n";
      } else {
        input = substr($0, i, 1);
      }

      state = _fsm_tick(state, input);
  }

  return state;
}

BEGIN { state = "initial" }
      { state = _handle_line($0, state) }
