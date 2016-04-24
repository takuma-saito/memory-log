# filename: longest.awk
#   author: Eric Pement - pemente[at]northpark.edu
#     date: 2005-08-29
# requires: GNU awk, due to ARGIND variable and nextfile command.
#
# awk script to compute the longest line in a file.
#
# Revision history:
# -----------------
# 2003-03-12: Added an EOL marker (Ctrl-Q, which looks like "<" on Windows).
# 2003-06-03: Added new variable to suppress display of the longest line.
# 2005-08-29: Added new variable to display TAB as a graphics character. The
#   filename is now displayed on the summary line, and a carriage return (if
#   any) is displayed a paragraph symbol. Tries to skip nontext files.
#
# Usage:
# gawk -f longest.awk file1 [file2 file3 ...]
# gawk -f longest.awk -v suppress=Y file1 [file2 file3 ...]
# gawk -f longest.awk -v showtabs=Y file1 [file2 file3 ...]
#

# Routine to skip matching binary files. This will still miss some cases.
{
  myfile = tolower(FILENAME)
  if (myfile ~ /\.(com|exe|dll|zip|msi|sfx|7z|gz|wav|mp3|swf|pdf|hlp|chm|gif|jpg|bmp|ico|psd|png)$/) {
    print "Skipping " myfile " because it is not a text file ..."
    nextfile
  }
}

length($0) > m2 {
  m1 = $0
  m2 = length($0)
  m3 = FILENAME
  m4 = NR
}

END {
  sub(/^-$/, "stdin", m3)   # Make standard input symbol readable

  if (ARGIND > 1)
    print "Total of " ARGIND " files examined."

  print "Tot