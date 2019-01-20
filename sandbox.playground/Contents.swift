import UIKit
import Foundation

protocol Drawable {
    func draw() -> Double
}

struct Point: Drawable {
    var x,y: Double
    func draw() -> Double {
        let xLength = pow(x, 2)
        let yLength = pow(y, 2)
        return sqrt(xLength + yLength)
    }
}

struct Line: Drawable {
    var x1, x2, y1, y2: Double
    func draw() -> Double {
        let xLength = pow(x2 - x1, 2)
        let yLength = pow(y2 - y1, 2)
        return sqrt(xLength + yLength)
    }
}

/* Код #1 */

//let polymorphicPoint: Drawable = Point(x: 10, y: 10)
//MemoryLayout.size(ofValue: polymorphicPoint)
//
//let justPoint: Point = Point(x: 10, y: 10)
//MemoryLayout.size(ofValue: justPoint)

/* Код #2 */

//func drawACopy(local: Drawable) { // (1)
//    local.draw() // (2)
//} // (3)
//
//let point: Drawable = Point(x: 2, y: 2)
//drawACopy(local: point)
//
/* PSEUDO CODE */
//
//struct ExistentialContainerDrawable {
//    var valueBuffer: (Int, Int, Int)
//    var vwt: ValueWitnessTable
//    var pwt: ProtocolWitnessTable
//}
//
//func drawACopy(val: ExistentialContainerDrawable) {
//    let local = ExistentialContainerDrawable() // (1)
//    let vwt = val.vwt
//    let pwt = val.pwt
//    local.vwt = vwt
//    local.pwt = pwt
//    vwt.allocateBufferAndCopyValue(&local, val)
//    pwt.draw(vwt.projectBuffer(&local)) // (2)
//    vwt.destructAndDeallocateFugger(temp) // (3)
//}

/* Код #3 */

//struct Pair {
//    init(_ f: Drawable, _ s: Drawable) {
//        first = f; second = s
//    }
//    var first, second: Drawable
//}
//
//let line: Line = Line(x1: 0, x2: 10, y1: 0, y2: 10)
//let point: Point = Point(x: 10, y: 10)
//
//var pair = Pair(line, point)

/*
 | Pair            |
 | :-------------  |
 | E.C. for first  | -> HEAP allocation (Line )
 | E.C. for second | -> Value in Value Buffer
 */

//MemoryLayout.size(ofValue: pair)
//MemoryLayout.size(ofValue: pair.first)
//MemoryLayout.size(ofValue: pair.second)
//
//pair.second = Line(x1: 0, x2: 3, y1: 0, y2: 3)

/*
 | Pair            |
 | :-------------  |
 | E.C. for first  | -> HEAP allocation (Line)
 | E.C. for second | -> HEAP allocation (Line)
*/

//let copy = pair

/*
 | Pair            |
 | :-------------  |
 | E.C. for first  | -> HEAP allocation (Line)
 | E.C. for second | -> HEAP allocation (Line)
 
 | Copy            |
 | :-------------  |
 | E.C. for first  | -> HEAP allocation (Line)
 | E.C. for second | -> HEAP allocation (Line)
 */

//class LineStorage {
//    var x1, y1, x2, y2: Double
//    init(_ origin: (x: Double, y: Double), _ endpoint: (x: Double, y: Double)) {
//        x1 = origin.x
//        y1 = origin.y
//        x2 = endpoint.x
//        y2 = endpoint.y
//    }
//    convenience init(_ storage: LineStorage) {
//        self.init((storage.x1, storage.x2), (storage.y1, storage.y2))
//    }
//}
//
//struct BetterLine: Drawable {
//    private var storage: LineStorage
//    init() {
//        storage = LineStorage((0, 0), (10, 10))
//    }
//    func draw() -> Double {
//        let xLength = pow(storage.x2 - storage.x1, 2)
//        let yLength = pow(storage.y2 - storage.y1, 2)
//        return sqrt(xLength + yLength)
//    }
//    mutating func move() {
//        if !isKnownUniquelyReferenced(&storage) {
//            storage = LineStorage(self.storage)
//        }
//        // changes for storage
//    }
//}

/*
 | Pair            |
 | :-------------  |
 | E.C. for first  | -> Reference to the `LineStorage`
 | E.C. for second | -> Reference to the `LineStorage`
 
 | Copy            |
 | :-------------  |
 | E.C. for first  | -> Reference to the `LineStorage`
 | E.C. for second | -> Reference to the `LineStorage`
 */

/* Код #4 */

//func genericDrawACopy<T: Drawable>(local: T) {
//    print(MemoryLayout.size(ofValue: local))
//    local.draw()
//    print(MemoryLayout.size(ofValue: local))
//}
//
//genericDrawACopy(local: line)
//genericDrawACopy(local: point)

/* PSEUDO CODE */

//func genericDrawACopy(val: Drawable.conformedTypes, vwt: ValueWitnessTable, pwt: ProtocolWitenssTable) {
//    let local = val // (1)
//    vwt.allocateBufferAndCopyValue(&local, val)
//    pwt.draw(vwt.projectBuffer(&local)) // (2)
//    vwt.destructAndDeallocateFugger(local) // (3)
//}

/* Код #5 */

func drawACopy<T: Drawable>(local: T) {
    local.draw()
}
drawACopy(local: Point(x: 10, y: 10))
drawACopy(local: Line(x1: 0, x2: 10, y1: 0, y2: 10))

/* PSEUDO CODE */
// MARK: Create type-specific version of method

func drawACopyOfAPoint(local: Point) {
    local.draw()
}

func drawACopyOfALine(local: Line) {
    local.draw()
}
drawACopyOfAPoint(local: Point(x: 10, y: 10))
drawACopyOfALine(local: Line(x1: 0, x2: 10, y1: 0, y2: 10))

// MARK: aggressive compiler optimization

do {
    let local = Point(x: 10, y: 10)
    local.draw()
}

do {
    let local = Line(x1: 0, x2: 10, y1: 0, y2: 10)
    local.draw()
}

// MARK: or even

Point(x: 10, y: 10).draw()
Line(x1: 0, x2: 10, y1: 0, y2: 10).draw()

/* END OF PSEUDO CODE */

/* Код #6 */

struct GenericPair<T: Drawable> {
    init(_ f: T, _ s: T) {
        first = f; second = s
    }
    var first, second: T
}

// NOTE:  Now swift compiler know explicitly, that this is a pair of instance with the same type, because `T` can't be different.

var pair = GenericPair(Line(x1: 0, x2: 10, y1: 0, y2: 10), Line(x1: 10, x2: 0, y1: 10, y2: 0))

// NOTE: type doesn't change at runtime

//pair.second = Point(x: 10, y: 10)

// MARK: STACK ALLOCATION!

MemoryLayout.size(ofValue: pair)
MemoryLayout.size(ofValue: pair.first)
MemoryLayout.size(ofValue: pair.second)
