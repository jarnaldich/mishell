! Copyright (C) 2015 Joan Arnaldich 
! See http://factorcode.org/license.txt for BSD license.
USING: accessors io io.backend io.directories io.encodings.utf8 io.files
io.launcher io.pathnames kernel lexer math namespaces see sequences sorting
vocabs io.encodings.binary strings assocs serialize ;
IN: mishell

SYMBOL: mishell-current-cfg
TUPLE: mishell-cfg default-enc default-env ;


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
        vocab-words [ name>> ] sort-with
        [ "IN: scratchpad" print [ "DEFER: " write name>> print ] each nl ]
        [ [ see nl ] each ] bi
    ] with-file-writer ;

<PRIVATE

: save-var? ( k v -- ? )
    drop 
      [ string? ] 
      [ V{ 
            current-directory 
            mishell-current-cfg
         } member? ]
    bi or ; inline

PRIVATE>

: dump-vars ( fname -- )
    ! filter out the keys that are not strings
    ! to remove system variables that may not be serializable
    [ namespace [ save-var? ] assoc-filter ] dip
    binary [ serialize ] with-file-writer ;

: load-vars ( fname -- )
   binary [ deserialize ] with-file-reader
   [ set ] assoc-each ;

    
! Reload a new file with, eg:
! "~/dump.factor" parse-file

! ------------------------------------------------------------------------------
! Commands 
! ------------------------------------------------------------------------------
<PRIVATE
: with-process-reader/noerr ( desc q -- n )
    [ mishell-current-cfg get default-enc>> <process-reader> ] dip
    swap
    [ with-input-stream ] dip
    wait-for-process ; inline
PRIVATE>


: <mishell-cfg> ( -- x )
    mishell-cfg new ;

: set-default-cfg ( enc env --  )
    mishell-cfg boa mishell-current-cfg set ;

: ls ( dir -- files )
    [ directory-files ] [ [ prepend-path normalize-path ] curry ] bi map ;

: default-process-reader ( cmd -- stream )
    <process>
        swap >>command
        +stdout+ >>stderr
        t >>hidden
        mishell-current-cfg get default-env>> >>environment
        mishell-current-cfg get default-enc>> <process-reader> ;

: proc-lines ( cmd -- arr )
    default-process-reader stream-lines ;
    
! : each-proc-line ( proc quot -- status )
!     '[ readln dup _ when* ]

! : >sh ( cmd -- ret-code )
!       [ [ readln dup [ print ] when* ] loop ] with-process-reader/noerr ;


