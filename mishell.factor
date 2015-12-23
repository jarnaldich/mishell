! Copyright (C) 2015 Joan Arnaldich 
! See http://factorcode.org/license.txt for BSD license.
USING: accessors io io.backend io.directories io.encodings.utf8 io.files
io.launcher io.pathnames kernel lexer math namespaces see sequences sorting
vocabs ;
IN: mishell

! ------------------------------------------------------------------------------
!                               Raw String Syntax
! ------------------------------------------------------------------------------
: take-until ( end lexer -- string )
    dup [ drop 1 + ] change-lexer-column
    [ [ index-from ] 2keep [ swapd subseq ] [ 2drop 1 + ] 3bi ]
    change-lexer-column ;

: parsing-raw ( accum end -- accum )
    lexer get take-until suffix! ;

SYNTAX: r| 124 parsing-raw ;

! ------------------------------------------------------------------------------
!                                Session Saving
! ------------------------------------------------------------------------------
: dump-words ( vocab path -- )
    utf8 [
        words [ name>> ] sort-with
        [ "IN: scratchpad" print [ "DEFER: " write name>> print ] each nl ]
        [ [ see nl ] each ] bi
    ] with-file-writer ;

! Reload a new file with, eg:
! "~/dump.factor" parse-file

! ------------------------------------------------------------------------------
! Commands 
! ------------------------------------------------------------------------------
<PRIVATE
: with-process-reader/noerr ( desc enc q -- n )
    [ <process-reader*> ] dip swap [ with-input-stream ] dip wait-for-process ; inline
PRIVATE>

SYMBOL: mishell-current-cfg
TUPLE: mishell-cfg default-enc default-env ;

: <mishell-cfg> ( -- x )
    mishell-cfg new ;

: set-default-cfg ( enc env --  )
    mishell-cfg boa mishell-current-cfg set ;

: ls ( dir -- files )
    [ directory-files ] [ [ prepend-path normalize-path ] curry ] bi map ;

: >sh ( cmd -- ret-code )
    <process>
      swap >>command
      +stdout+ >>stderr
      mishell-current-cfg get default-env>> >>environment
      mishell-current-cfg get default-enc>> [ contents print ] with-process-reader/noerr ;


