# filename: setcsv.awk
#   author: Peter Stroemberg, based on setcsv by Adrian Davis
#     date: 28 March 2000
#  revised: 22 July 2004 by Eric Pement
#
# purpose: split CSV (comma-separated values) into bar-delimited fields
#          by the setcsv() function, where the CSV format matches the
#          CSV format output by Microsoft Excel. The field separators
#          used for input (default: ",") and output (default: "|") can
#          be changed.
#
# -----------------------------------------------------------------------
# setcsv(str, sep) - parse CSV input
# str: the string to be parsed (usually $0).
# sep: the separator between the values
#
# delim: input field separator (default is a comma). 
# OFS:   output field separator (default is a vertical bar).
#
# Usage:
#   awk -f /path/to/setcsv.awk --source="your-script" file.csv
#   awk -f /path/to/setcsv.awk -f yourscript.awk file.csv
#
# Change the field delimiter for MS Excel tab-separated values:
#   awk -v delim="\t" -f /path/to/setcsv.awk -f yourscript.awk file.txt
#
# After a call to setcsv, double-quotes around fields are removed, the
# field separator is changed to the value of OFS (below), the value of
# str (or $0) is changed, and the parsed fields are found in $1 to $NF.
# setcsv returns 1 on success and 0 on failure, so check the value of
# "result" when using this function.
#
# Don't be confused by the fact that we use "delim" instead of FS as
# the input field separator. The change is intentional because CSV
# files often use commas as field data as well as field separators.
#
# Written by Peter Str”mberg, aka PEZ.
# Based on setcsv by Adrian Davis. Modified to handle field separators
# other than the comma, and embedded newlines within fields. The basic
# approach used in this script is to remove the burden of parsing CSV
# data by replacing ambiguous characters (such as "" for a single double
# quote, or commas embedded within fields), with characters unlikely to
# be found in the input data. We use \035 or 0x1D to represent embedded
# double quote marks.
#
# Note 1. Before calling setcsv, we must set FS to a string which will
#         never be found in the input. We have used SUBSEP, a built-in
#         awk variable with a default value of \034 or 0x1C (Ctrl-\).
#
# Note 2. If setcsv can't find the closing double quote for the string in
#         str, it will consume the next line of input by calling getline
#         and call itself until it finds the closing double quote or
#         until no more input is available (considered a failure).
#
# Note 3. Only the "" representation of a literal double quote is
#         supported. Using \" to represent a double quote will fail.
#
# Note 4. setcsv will probably misbehave if sep, which is used as a
#         regular expression, can match anything other than what an
#         identical call to index() would match. In other words, sep
#         should not contain regular expression metacharacters, since
#         it is used as a regex and also as a non-regex fixed string.
#
# Embedded remarks above revised by Eric Pement on 2004-07-22    from
# original version at http://groups.google.com/groups?selm=an_603309980
# -----------------------------------------------------------------------
BEGIN { 
   FS = SUBSEP     # Leave alone unless 0x1C is in the input.
   OFS = "|"       # Set the output field separator (default: "|").
   if (!delim)     # If the input field delimiter is not defined on
     delim = ","   # the command line, set it to a comma.
}        

{
  result = setcsv($0, delim)
  # print                           # Uncomment this line if you need to
}

# -----------------------------------------------------------------------
function setcsv(str, sep,    i) {
  gsub(/""/, "\035", str)
  gsub(sep, FS, str)

  while (match(str, /"[^"]*"/)) {
    middle = substr(str, RSTART+1, RLENGTH-2)
    gsub(FS, sep, middle)
    str = sprintf("%.*s%s%s", RSTART-1, str, middle, substr(str, RSTART+RLENGTH))
  }

  if (index(str, "\"")) {
    return ((getline) > 0) ? setcsv(str (RT != "" ? RT : RS) $0, sep) : !setcsv(str "\"", sep)
  } else {
    gsub(/\035/, "\"", str)
    $0 = str

    for (i = 1; i <= NF; i++)
      if (match($i, /^"+$/))
        $i = substr($i, 2)

    $1 = $1 ""
    return 1
  }
}
# ---[end-of-script]---
