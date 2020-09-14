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

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

