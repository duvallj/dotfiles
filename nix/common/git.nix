{ lib, pkgs, ... }:
let
  isNonEmptyString = part: builtins.isString part && part != "";
  splitNonEmpty = split: string: builtins.filter isNonEmptyString (builtins.split split string);
  # Takes in an a section header and returns the path as a list of strings
  # TODO: error message
  parseSectionHeader = splitNonEmpty "]|[ \"[]";
  # Takes in a line in the gitconfig and returns a two-element list of the
  # [ key value ] pair
  # TODO: error message
  parseLine = splitNonEmpty "\t| = ";
  # Takes in a string, and attempts to convert it to a basic datatype
  # like int/bool if possible
  toValue = string:
    if (builtins.match "^[[:digit:]]+$" string) != null then
      lib.strings.toInt string
    else if string == "true" then true
    else if string == "false" then false
    else if (builtins.match "^\".*\"$" string) != null then
      lib.strings.removePrefix "\"" (lib.strings.removeSuffix "\"" string)
    else string;
  # Takes in a list at least length 1, and then creates an attrset with
  # $0.$1.(...) = $n
  # TODO: error message
  pathToAttrset = path:
    if builtins.length path < 2 then toValue (builtins.head path)
    else { ${builtins.head path} = pathToAttrset (builtins.tail path); };
  # Takes in an attrset, and a path, and sets the path in the attrset,
  # overriding any value that may exist there currently
  setAtPath = attrset: path:
    lib.attrsets.recursiveUpdate attrset (pathToAttrset path);

  raw-gitconfig = builtins.readFile ../../.gitconfig;
  gitconfig-lines = splitNonEmpty "\n" raw-gitconfig;

  # type Context = {
  #   path: string[], // Current section header
  #   gitconfig: attrset, // Accumulated configuration
  # };

  # Parse .gitconfig directly
  # TODO: comments, error messages
  gitconfig = (builtins.foldl' (context@{ path, gitconfig }: line:
    if lib.strings.hasPrefix "[" line then
      # Section has ended, start a new section
      {
        path = parseSectionHeader line;
        inherit gitconfig;
      }
    else
      # Add current line in section to gitconfig
      {
        inherit path;
        gitconfig = setAtPath gitconfig (path ++ (parseLine line));
      }
    )
    { path = []; gitconfig = {}; }
    gitconfig-lines
  ).gitconfig;

  extraConfig = {
    difftool.difftastic.cmd = "${pkgs.difftastic}/bin/difft \"$LOCAL\" \"$REMOTE\"";
  };
in
{
  home.packages = [ pkgs.difftastic ];
  programs.git = {
    enable = true;
    extraConfig = lib.attrsets.recursiveUpdate gitconfig extraConfig;
  };
}
