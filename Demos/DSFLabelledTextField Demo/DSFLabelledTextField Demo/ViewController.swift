//
//  ViewController.swift
//  DSFLabelledTextField Demo
//
//  Created by Darren Ford on 14/9/20.
//

import Cocoa

class ViewController: NSViewController {

	@objc dynamic var frameX: CGFloat = 100.0
	@objc dynamic var frameY: CGFloat = 34.0
	@objc dynamic var frameW: CGFloat = 1366
	@objc dynamic var frameH: CGFloat = 990

	@objc dynamic var boundsX: CGFloat = 0.0
	@objc dynamic var boundsY: CGFloat = 0.0
	@objc dynamic var boundsW: CGFloat = 1366
	@objc dynamic var boundsH: CGFloat = 990

	@objc dynamic var ta: CGFloat = 0.5
	@objc dynamic var tb: CGFloat = 0.5
	@objc dynamic var tc: CGFloat = 1.0
	@objc dynamic var td: CGFloat = 1.0
	@objc dynamic var tx: CGFloat = 0.0
	@objc dynamic var ty: CGFloat = 0.0

	@IBOutlet weak var dynamicStackView: NSStackView!
	override func viewDidLoad() {
		super.viewDidLoad()


		// Add some fields dynamically

		let a = DSFLabelledTextField()
		a.translatesAutoresizingMaskIntoConstraints = false
		a.label = "最初"
		a.labelWidth = 45
		a.placeholderString = "これが最初です"
		dynamicStackView.addArrangedSubview(a)

		let b = DSFLabelledTextField()
		b.translatesAutoresizingMaskIntoConstraints = false
		b.label = "二番目"
		b.labelWidth = 45
		b.placeholderString = "これは2番目です"
		dynamicStackView.addArrangedSubview(b)

	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

