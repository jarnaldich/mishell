! Copyright (C) 2016 .
! See http://factorcode.org/license.txt for BSD license.
USING: help.markup help.syntax kernel strings ;
IN: mishell

ARTICLE: "cheatsheet" "CheatSheet"

"To recurse subdirectories:"
$nl
{ $code "USE: io.directories.search" "\"M:/i\" [ \".txt\" tail? ] find-all-files" }
$nl
"Simple serialization:"
$nl
{ $code

  "\"saved.factor\" utf8 [ ... ] with-file-writer"
  "\"saved.factor\" parse-file call" }
;

HELP: <mishell-cfg>
{ $values
    { "x" null }
}
{ $description "" } ;

HELP: default-process-reader
{ $values
    { "cmd" null }
    { "stream" null }
}
{ $description "" } ;

HELP: dump-words
{ $values
    { "vocab" "a vocabulary specifier" } { "path" "a pathname string" }
}
{ $description "" } ;

HELP: ls
{ $values
    { "dir" null }
    { "files" null }
}
{ $description "" } ;

HELP: mishell-cfg
{ $var-description "" } ;

HELP: mishell-current-cfg
{ $var-description "" } ;

HELP: parsing-raw
{ $values
    { "accum" null } { "end" null }
}
{ $description "" } ;

HELP: r|
{ $description "" } ;

HELP: set-default-cfg
{ $values
    { "enc" null } { "env" null }
}
{ $description "" } ;

HELP: take-until
{ $values
    { "end" null } { "lexer" null }
    { "string" string }
}
{ $description "" } ;

ARTICLE: "mishell" "mishell"
{ $vocab-link "mishell" }
;

ABOUT: "mishell"
