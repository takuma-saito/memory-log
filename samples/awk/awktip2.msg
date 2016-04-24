In a textfile where paragraphs are separated by a blank line, locate
all instances of one-line paragraphs.

gawk -f script.awk myfile

# filename:  script.awk
BEGIN { RS=""; FS="\n"}
NF==1 { print NR ": " $0 }
#---end of script---

   or, in 4dos:
 gawk `"BEGIN{RS=\"\";FS=\"\\n\"}; NF==1{print NR \": \" $0}"` myfile

