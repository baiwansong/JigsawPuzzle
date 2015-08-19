# JigsawPuzzle
Simple 9x9 jigsaw puzzle game written in Swift, also Slidding puzzle concept included.

In my learning journey I decided to make completely working Jigsaw puzzle game concept.

So here it is.

It uses 81 ```UIBezierPaths``` to cut out puzzle pieces from main image.

And it looks like this:

video: https://www.dropbox.com/s/8las1gfayfgbf32/puzzlePreview.m4v?dl=0

image:
![alt tag](https://github.com/nealCeffrey/JigsawPuzzle/blob/master/screenshots/jigsaw.jpg)

There's known issue:

When I cut these irregular shapes memory can peak up to 650mb on iPad air 2 and after 1-2 seconds it goes back to ~50mb.
I tried many ways to reduce it, but without losing quality there's none.
So, maybe you can help me understand how can the same thing be done in lighter way. Or is it just normal?


Also I have included Slidding puzzle.
It can be with numbers or image.
Numbers can be 4x4, 8x8 and so on.
Image can be 4x4, 6x6, 8x8.
```
enum NumberLevels : Int {
    case easy   = 4
    case medium = 8
    case hard   = 12
    case insane = 16
    case areyoukiddingme = 20
}
enum ImageLevels : Int {
    case easy   = 4
    case normal = 6
    case hard   = 8
}

```
Here's how it looks like.
![alt tag](https://github.com/nealCeffrey/JigsawPuzzle/blob/master/screenshots/sliding.jpg)
