! Copyright (C) 2015 Joan Arnaldich 
! See http://factorcode.org/license.txt for BSD license.
USING: accessors io io.backend io.directories io.files
io.launcher io.pathnames kernel lexer math namespaces see sequences sorting
vocabs io.encodings.binary io.encodings.utf8 strings assocs parser serialize 
io.files.private ui.tools.listener prettyprint ;
IN: mishell

SYMBOL: mishell-current-cfg
TUPLE: mishell-cfg default-enc default-env session-dir ;


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
        vocab-words [ name>> ] sort-by
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

: save-session ( -- )    
    mishell-current-cfg get session-dir>> 
    [ "scratchpad.factor" append-path "scratchpad" swap dump-words ]
    [ "vars.bin" append-path dump-vars ] bi ;

: load-session ( -- )
    mishell-current-cfg get session-dir>> 
    [ "scratchpad.factor" append-path run-file ]
    [ "vars.bin" append-path dump-vars ] bi ;

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

: set-cfg ( session-path enc env --  )
    mishell-cfg boa mishell-current-cfg set ;

: set-default-cfg ( -- )
    utf8 
    H{ } 
    home ".mishell/" append-path dup make-directories
    set-cfg ;

! The old version is like qualified-directory-files
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
!     '[ readln dup _ when* ] ;
! 
! : >sh ( cmd -- ret-code )
! default-process-reader
! [ [ readln dup [ print ] when* ] loop ] with-process-reader/noerr ;

: cls ( -- )
    get-listener clear-output ;

STARTUP-HOOK: set-default-cfg 

! ------------------------------------------------------------------------------
!                              "Shell" commands
! ------------------------------------------------------------------------------
: ls ( -- )
    cwd directory-files . ;
!    [ directory-files ] [ [ prepend-path normalize-path ] curry ] bi map ;

: cat ( fname -- )
    mishell-current-cfg get default-enc>> file-contents . ;
