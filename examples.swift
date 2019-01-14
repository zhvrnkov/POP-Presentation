import Foundation

func duration(_ closure: () -> ()) {
    let start = CFAbsoluteTimeGetCurrent()
    closure()
    print(CFAbsoluteTimeGetCurrent() - start)
}

protocol Drawable {
    func draw()
}

struct Point: Drawable {
    func draw() {
        arc4random()
    }
}

struct Line: Drawable {
    func draw() {
        arc4random()
    }
}

var arr: [Drawable] = [Point(), Line(), Point(), Line(), Point(), Line(), Point(), Line(), Point(), Line()]

func drawACopy<T: Drawable>(of val: T) {
    val.draw()
}

duration { // 1: "0.001971006393432617"; 2: 0.0008800029754638672"; 3: 0.000995039939880371"
    for item in arr {
        if item is Point {
            drawACopy(of: item as! Point)
        } else {
            drawACopy(of: item as! Line)
        }
    }
}

class Drawables {
    func draw() {}
}

class Points: Drawables {
    override func draw() {
        arc4random()
    }
}

class Lines: Drawables {
    override func draw() {
        arc4random()
    }
}

var arrs: [Drawables] = [Points(), Lines(), Points(), Lines(), Points(), Lines(), Points(), Lines(), Points(), Lines()]

func drawACopies(of val: Drawables) {
    val.draw()
}

duration { //3: 0.007066011428833008"; 4: 0.0014339685440063477; 5: 0.0011680126190185547; 6: 0.0021080970764160156
    for item in arrs {
        drawACopies(of: item)
    }
}

protocol Drawable { ... }
struct Point: Drawable {
    var x, y: Int
    // protocol realization
}

let polymorphicPoint: Drawable = Point()
MemoryLayout.size(of: polymorphicPoint) // 40

let justPoint: Point = Point()
MemoryLayout.size(of: justPoint) // 16
