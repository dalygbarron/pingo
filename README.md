```
Portable
In
Network
Graphics
Out
```
Pingo is an i/o library for PNG files for use in janet. In the back it uses the
lodepng C library https://github.com/lvandeve/lodepng which is where the hard
work is actually happening. I was going to call this a lodepng wrapper but then
I realised it had a bunch of functionality to do with the internals of the png
format blah blah blah so I changed my mind.

You can build, test, and run with jpm, but you need to do `sudo jpm install`
before the tests will pass because it has to install the native part of the
module first. The tests draw some nice pictures into your test folder so
I highly recommend running them for your personal pleasure.

## Image Struct
The library creates and works with structs of the following form:
```
{:pixels @""
 :width 100
 :height 100}
```
Pixels are 32 bits so the order of bytes in the buffer is red, green, blue,
alpha starting from the top left pixel, then going in reading order.

## Input
There are two functions for reading png files into janet.
```
(read-bytes bytes)
(read-file path)
```
Both of these create an image struct, but read-file creates one by loading an
image file, and read works on the bytes of an already read file.

## Output
There are also two functions for writing png files.
```
(write-bytes image)
(write-file path image)
```
Write evaluates to a buffer containing the bytes of a png file representing the
raw pixel data in image, whereas write-file actually writes it to the file.
image in this case is one of the image structs I mentioned above which is
important because it stores the width and height which is needed.

## Bonus
There are some extra functions defined in pingo.janet which do things like
creating empty images, basic drawing and blitting, and destroying western
civilisation. They're not exactly comprehensive but they aren't really meant to
be so whatever. They are documented in the code so read it.
