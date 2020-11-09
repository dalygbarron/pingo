(declare-project
  :name "pingo"
  :author "Daly Barron"
  :license "zlib"
  :url "https://github.com/dalygbarron/pingo"
  :repo "git+https://github.com/dalygbarron/pingo.git")

(declare-native
  :name "_pingo"
  :source ["main.c" "lodepng.c"])

(declare-source
  :source ["pingo.janet"])
