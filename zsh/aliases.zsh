alias cls='clear' # Good 'ol Clear Screen command
grel() { git commit -a -m "$2" -n && git tag -a "$1" -m "$2"; }
