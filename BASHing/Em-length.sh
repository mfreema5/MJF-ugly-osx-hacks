#!/bin/bash
#
#  Usage:
#        ./Em-length [string]
#
#  Calculates the “em-length” of a string.
#  The em-length is how long a line of text will be
#  based on the characters in it.
#
#  This is how newspaper headlines were composed/sized
#  in the days before computerators.
#
#  Notes on math weirdness:
#    A. BASH only does integer math.
#    B. Paper-space ems are width measures.
#    C. Display-space ems are height measures.
#  Thus: ems are doubled to make them all integers (A).
#  But they are divided by three to account for the
#  height-vs-width discrepancy (B & C).
#
#  Double-quotes in the string to passed to the script
#  currently break things.  Other special characters might,
#  too.
#
#  30-Oct-14
#  MJF

String="${@}"
String_length=${#String}

if (( ${#}==0 )) ; then
  printf "You've given me nothing to work with!\n\n"
  exit
fi

totalem=0                                                             # Total ems
totaldem=0                                                            # Total doubled-ems

for (( i=1 ; $i<=$String_length ; i++ )) ; do
  character=$(echo $String | cut -c $i )
  if [[ $character =~ [abcdeghkmnopqrsuvwxyzFIJLT0123456789\?\ ] ]] ; then
    totaldem=$(($totaldem+2))
  elif [[ $character =~ [ABCDEGHKNOPQRSUVXYZ\—] ]]; then
    totaldem=$(($totaldem+3))
  elif [[ $character =~ [MW] ]]; then
    totaldem=$(($totaldem+4))
  else
    totaldem=$(($totaldem+1))
  fi
done

   # NOTE:  There is no conditional for
   # $character =~ [fijlt\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\@\[\\\]\^\_\`\{\|\}\~]
   # because the fall-back for a character that doesn't match any of the sets
   # is to assign 1 em, which is what that set would get anyway (0.5 * 2).

totalem=$(($totaldem/3))               # Reduce to usable base.

if (( $(($totaldem%3))>1 )) ; then     # If remainer was more than 1...
  totalem=$(($totalem+1))              # ...round up the ems
fi

printf "%b = %b display ems.\n\n" "$String" "$totalem"







