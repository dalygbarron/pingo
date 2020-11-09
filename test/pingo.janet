(import ../pingo)

(defn save-and-load
  "Loads a picture, saves a copy of it, then loads that copy and compares it to
  the origina;"
  []
  (def pic (pingo/read-file "test/testPicture.png"))
  (assert (deep= (pingo/get-pixel pic 1 0)
                 (pingo/rgb 255 219 0))
          "top left + 1 to right pixel is yellow")
  (assert (deep= (pingo/get-pixel pic 13 8)
                 (pingo/rgb 255 0 0))
          "middle pixel is red")
  (pingo/write-file pic "test/output.png")
  (def reloaded (pingo/read-file "test/output.png"))
  (assert (deep= pic reloaded) "saved file is same as old file")
  (pingo/draw-circle pic
                     (/ (pic :width) 2)
                     (/ (pic :height) 2)
                     5
                     (pingo/rgb 123 187 98))
  (assert (not (deep= pic reloaded)) "One pic has changed but not the other"))

(defn save-and-load-bytes
  "Loads a png file with janet file io, then writes it to bytes, then saves it
  with janet file iom then does the old reload and compare"
  []
  (def file-buffer @"")
  (with [f (file/open "test/testPicture.png" :r)]
    (file/read f :all file-buffer))
  (def pic (pingo/read-bytes file-buffer))
  (def written-bytes (pingo/write-bytes pic))
  (with [f (file/open "test/output.png" :w)]
    (file/write f written-bytes))
  (def reloaded-pic (pingo/read-file "test/output.png"))
  (assert (deep= pic reloaded-pic)))

(defn test-circle
  "Draws a circle on a pic created in script, then makes sure the circle
  drawing did the right stuff."
  []
  (def japanese-flag (pingo/make-blank-image 512 256 (pingo/rgb 255 255 255)))
  (pingo/draw-circle japanese-flag 256 128 48 (pingo/rgb 255 0 0))
  (pingo/write-file japanese-flag "test/japaneseFlag.png")
  (def loaded-flag (pingo/read-file "test/japaneseFlag.png"))
  (assert (deep= (pingo/get-pixel loaded-flag 0 0)
                 (pingo/rgb 255 255 255)))
  (assert (deep= (pingo/get-pixel loaded-flag 213 102)
                 (pingo/rgb 255 255 255)))
  (assert (deep= (pingo/get-pixel loaded-flag 288 95)
                 (pingo/rgb 255 0 0)))
  (assert (deep= (pingo/get-pixel loaded-flag 256 128)
                 (pingo/rgb 255 0 0))))

(defn nice-drawing
  "Just makes a nice picture with random circles of random colour"
  []
  (def pic (pingo/make-blank-image 512 512))
  (for i 0 128
    (do
      (def x (* (math/random) 512))
      (def y (* (math/random) 512))
      (def radius (* (math/random) 64))
      (def colour (pingo/rgba
                    (* (math/random) 255)
                    (* (math/random) 255)
                    (* (math/random) 255)
                    (* (math/random) 255)))
      (pingo/draw-circle pic x y radius colour)))
  (pingo/write-file pic "test/nice-drawing.png"))

(save-and-load)
(test-circle)
(nice-drawing)
