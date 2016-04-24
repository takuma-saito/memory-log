# This is a GNU awk script.
# Filename:  pad_num.awk
#   Author:  Eric Pement - pemente@northpark.edu
#     Date:  August 22, 2001
#
#  Purpose:  To pad the current line (with spaces) to a specified length.
#            It uses a test to see if any lines are too long.
#
# Requires:  'PAD' is a variable which must be passed to awk externally,
#            like this:
#                        awk -v PAD=50 -f pad_num.awk

{ if (length($0) > PAD) {
     print "Error! Line #" NR, "is already", length, "chars.";
     print $0;
  }
  else {
#  Note how I've used * in the printf statement. * in the "format"
#  controls width, and is replaced by the value of arg1 (i.e, PAD).
     printf("%-*s\n",PAD,$0)
  }
}
#---end of script---
