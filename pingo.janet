(import _pingo)

(defn rgba
  "Makes a tuple representing an rgba colour without transparency"
  [r g b a]
  [(min (max (math/floor r) 0) 255)
   (min (max (math/floor g) 0) 255)
   (min (max (math/floor b) 0) 255)
   (min (max (math/floor a) 0) 255)])

(defn rgb
  "Makes a tuple representing an rgb colour with no transparency"
  [r g b]
  (rgba r g b 255))

(defn make-image-struct
  "Creates an image struct. By the way the pixel data is always assumed to be
  32 bit."
  [data width height]
  {:data data
   :width width
   :height height})

(defn make-blank-image
  "Creates a blank image filled with some colour"
  [width height &opt colour]
  (default colour (rgba 0 0 0 0))
  (def buff (buffer/new-filled (* width height 4) (colour 0)))
  (for i 0 (* width height)
    (do
      (set (buff (+ (* i 4) 1)) (colour 1))
      (set (buff (+ (* i 4) 2)) (colour 2))
      (set (buff (+ (* i 4) 3)) (colour 3))))
  (make-image-struct buff width height))

(defn read-file
  "Reads a png file from a path and returns it as an image struct"
  [file]
  (def buff @"")
  (def result (_pingo/read-file file buff))
  (make-image-struct buff ;result))

(defn read-bytes
  "Reads a png file's bytes and returns it as an image struct"
  [bytes]
  (def buff @"")
  (def result (_pingo/read-bytes bytes buff))
  (make-image-struct buff ;result))

(defn write-file
  "Writes an image struct to a file path"
  [image file]
  (_pingo/write-file file (image :data) (image :width) (image :height)))

(defn write-bytes
  "Writes an image struct to the bytes of a png file"
  [image]
  (_pingo/write-bytes (image :data) (image :width) (image :height)))

(defn flat
  "Takes a 2d pixel coordinate and makes it 1d"
  [image x y]
  (+ (math/floor x) (* (math/floor y) (image :width))))

(defn get-pixel
  "Gets a pixel value from an image struct, returning blank if you go out of
  bounds"
  [image x y]
  (def index (flat image x y))
  (if (or (< x 0) (< y 0) (>= x (image :width)) (>= y (image :height)))
    [0 0 0 0]
    [((image :data) (* index 4))
     ((image :data) (+ (* index 4) 1))
     ((image :data) (+ (* index 4) 2))
     ((image :data) (+ (* index 4) 3))]))

(defn set-pixel
  "Sets a pixel to a value and does nothing if out of bounds"
  [image x y colour]
  (if (or (< x 0) (< y 0) (>= x (image :width)) (>= y (image :height)))
    ()
    (do
      (def index (flat image x y))
      (set ((image :data) (* index 4)) (colour 0))
      (set ((image :data) (+ (* index 4) 1)) (colour 1))
      (set ((image :data) (+ (* index 4) 2)) (colour 2))
      (set ((image :data) (+ (* index 4) 3)) (colour 3)))))

(defn draw-circle
  "Draws a circle on a given image ignoring out of bounds"
  [image x y radius colour]
  (def sqr-radius (* radius radius))
  (for ix (max (- x radius) 0) (min (+ x radius) (- (image :width) 1))
    (for iy (max (- y radius) 0) (min (+ y radius) (- (image :height) 1))
      (do
        (def dx (- x ix))
        (def dy (- y iy))
        (def sqr-dn (+ (* dx dx) (* dy dy)))
        (if (<= sqr-dn sqr-radius) (set-pixel image ix iy colour))))))
