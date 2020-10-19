# DSFLabelledTextField

![](https://img.shields.io/github/v/tag/dagronf/DSFLabelledTextField) ![](https://img.shields.io/badge/macOS-10.11+-red) ![](https://img.shields.io/badge/Swift-5.0-orange.svg)
![](https://img.shields.io/badge/License-MIT-lightgrey) [![](https://img.shields.io/badge/pod-compatible-informational)](https://cocoapods.org) [![](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

A simple macOS labelled text field using Swift.

![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFLabelledTextField/s1.png)
![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFLabelledTextField/s2.png)

## Installation

### Swift Package Manager

Add `https://github.com/dagronf/DSFLabelledTextField` to your project.

### CocoaPods

Add the following to your `Podfiles` file

```ruby
pod 'DSFLabelledTextField', :git => 'https://github.com/dagronf/DSFLabelledTextField'
```

### Direct

Add the swift files from the `Sources/DSFLabelledTextField` subfolder to your project

## Usage

1. Add a new NSTextField using Interface Builder, then change the class type to `DSFLabelledTextField`, or
2. Programatically create one

## Properties

* `drawsRoundedEdges ` : Draw the control border using round rects
* `drawsLabelBackground` : Draw a solid color behind the label
* `label` : The text to display in the label
* `labelForegroundColor` : The color of the label text
* `labelBackgroundColor` : The color behind the label
* `labelWidth` : The width of the label.  If set to -1, fits the label size to the label text.
* `labelAlignment` : The alignment of the label. Useful if you have multiple label fields that you want to synchronise the width for.  Defaults to `NSTextAlignment.center`

## Grouping fields

There are times where you might need to synchronise the width of the labels of a number of fields.  To do this, you can add the fields to a `DSFLabelledTextFieldGroup` instance and the field labels will size to fit the maximum width of all the labels in the group.

### Example

```swift

@IBOutlet weak var redField: DSFLabelledTextField!
@IBOutlet weak var greenField: DSFLabelledTextField!
@IBOutlet weak var blueField: DSFLabelledTextField!
let colorGroup = DSFLabelledTextFieldGroup()

override func viewDidLoad() {
   super.viewDidLoad()

   /// Sync the widths of the red, green and blue labels
   self.colorGroup.add(fields: redField, greenField, blueField)
}

```

## More screenshots

![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFLabelledTextField/s3.png)
![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFLabelledTextField/s4.png)

## History

* `1.1.0`: Added support for label grouping
* `1.0.2`: Added label alignment (left, right, center etc)
* `1.0.1`: Demonstrate dynamically create
* `1.0.0`: Initial release


## License

```
MIT License

Copyright (c) 2020 Darren Ford

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
