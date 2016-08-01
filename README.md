# textadept-TLA+
TLA+ and PlusCal syntax highlighting for Textadept

## Installation
* Place the tlaplus.lua and pluscal.lua files in your ~/.textadept/lexers folder
* Associate the ".tla" extension with TLA+ files by placing the following in your init.lua:
```textadept.file_types.extensions["tla"] = "tlaplus"```

## Known issues
The PlusCal lexer will only actiavte if the comment containing the algorithm ONLY containst the algorithm. For example:
```
(*Good *)
(*
--algorithm SomeAlgorithm {
...
};
*)
```
```
(* Bad *)
(* Clutter in the comments
--algorithm SomeAlgorithm {
...
};
More stuff
*)
```
