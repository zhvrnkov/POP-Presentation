struct Label {
    let text: String
    let font: UIFont
    ...
    init() {
        ...
        text.refCount = 1
        font.refCount = 1
    }
}

let label = Label(text: "Hi", font: font)
let label2 = label
retain(label2.text._storage) // because it's a String and it stores its Content (Characters) on the **Heap**
retain(label2.font)

// use label
retain(label.text._storage)
retain(label.font)

// use label2
retain(label2.text._storage)
retain(label2.font)
