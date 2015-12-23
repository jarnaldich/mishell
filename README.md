# mishell

`mishell` is a factor module with goodies for using the factor listener as a
shell. At the moment all code lies in the mishell vocabulary, planning to split
it as it grows.

It is probably not useful for anyone else but me yet...

Some features (will) include:

* A raw string syntax to be able to paste windows paths without escaping `\`.
* The function `>sh` to execute shell commands, print the result and return an
  errorlevel, as one would expect if the command was typed in a shell console.
* A default configuration, including default locale for console io, default
  environment for running programs, etc. All these will be managed through
  dynamic variables.
* Utilites for saving the functions defined in the listener to disk.

# Why?

* Factor code is very concise, which is a good thing in a command shell. 
* It is portable in all major platforms.
* The language is much more powerful than any shell I know of.
