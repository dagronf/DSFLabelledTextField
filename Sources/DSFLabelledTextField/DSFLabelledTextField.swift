//
//  DSFLabelledTextField.swift
//
//  Created by Darren Ford on 23/6/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//
//	MIT License
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.

#if os(macOS)

import AppKit

// The alpha value used for drawing when the control is disabled.
private let alphaValueForDisabled: CGFloat = 0.4

/// A text field containing an embedded label field
@IBDesignable public class DSFLabelledTextField: NSTextField {
	/// Use round rects when drawing the border
	@IBInspectable public var drawsRoundedEdges: Bool = true {
		didSet {
			self.customCell.roundedEdges = self.drawsRoundedEdges
			self.needsDisplay = true
		}
	}

	/// Draw a background behind the label
	@IBInspectable public var drawsLabelBackground: Bool = true {
		didSet {
			self.customCell.drawsLabelBackground = self.drawsLabelBackground
			self.needsDisplay = true
		}
	}

	/// The text to display within the label section
	@IBInspectable public var label: String = "" {
		didSet {
			self.textLabel.stringValue = self.label
			self.groupSync()

			self.needsLayout = true
		}
	}

	/// The color of the text for the label
	@IBInspectable public var labelForegroundColor = NSColor.secondaryLabelColor {
		didSet {
			self.textLabel.textColor = self.labelForegroundColor
			self.needsDisplay = true
		}
	}

	/// The background color for the label
	@IBInspectable public var labelBackgroundColor = NSColor.windowBackgroundColor {
		didSet {
			self.customCell.labelBackgroundColor = self.labelBackgroundColor
			self.needsDisplay = true
		}
	}

	/// The width of the label section.  If -1, fits to the size of the text within the label
	@IBInspectable public var labelWidth: CGFloat = -1 {
		didSet {
			self.widthConstraint.isActive = (self.labelWidth != -1)
			if self.labelWidth != -1 {
				self.widthConstraint.constant = self.labelWidth
				self.customCell.labelWidth = self.labelWidth
			}
			self.needsLayout = true
		}
	}

	/// The label alignment.  Defaults to center
	@IBInspectable public var labelAlignment: Int = 2 {
		didSet {
			if let align = NSTextAlignment(rawValue: self.labelAlignment) {
				self.labelAlignmentRaw = align
			}
		}
	}

	public var labelAlignmentRaw: NSTextAlignment = .left {
		didSet {
			self.textLabel.alignment = labelAlignmentRaw
			self.needsDisplay = true
		}
	}

	// MARK: Initializers

	override public init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.setup()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

	// MARK: Private Properties

	// The group IF this text field is a member of a group, otherwise nil.
	// Held weakly so that if the group goes away label can still operate
	internal weak var group: DSFLabelledTextFieldGroup?

	// Sync the label widths within the group IF this label is a group member
	internal func groupSync() {
		self.group?.syncWidths()
	}

	// Width constraint for the embedded label
	private var widthConstraint: NSLayoutConstraint!

	// The embedded label for the text field
	private lazy var textLabel: NSTextField = {
		let x = NSTextField()
		x.translatesAutoresizingMaskIntoConstraints = false
		x.stringValue = self.label
		x.isSelectable = false
		x.isEditable = false
		x.cell?.isEditable = false
		x.cell?.isSelectable = false
		x.cell?.wraps = false
		x.drawsBackground = false
		x.isBordered = false

		if let labelFont = self.font {
			var c = NSFontManager.shared.convert(labelFont, toSize: labelFont.pointSize - 1)
			c = NSFontManager.shared.convertWeight(true, of: c)
			c = NSFontManager.shared.convertWeight(true, of: c)
			x.font = c
		}

		x.textColor = NSColor.secondaryLabelColor
		x.alignment = .center
		x.translatesAutoresizingMaskIntoConstraints = false
		return x
	}()
}

private extension DSFLabelledTextField {
	/// Build up the label
	private func setup() {
		let oldCell = self.cell as! NSTextFieldCell
		let newCell = DSFPlainTextFieldCell()

		newCell.isEnabled = oldCell.isEnabled
		newCell.isEditable = oldCell.isEditable
		newCell.isSelectable = oldCell.isSelectable
		newCell.placeholderString = oldCell.placeholderString
		newCell.isScrollable = oldCell.isScrollable
		newCell.isContinuous = oldCell.isContinuous
		newCell.font = oldCell.font
		newCell.isBordered = oldCell.isBordered
		newCell.isBezeled = oldCell.isBezeled
		newCell.backgroundStyle = oldCell.backgroundStyle
		newCell.bezelStyle = oldCell.bezelStyle
		newCell.drawsBackground = oldCell.drawsBackground
		newCell.alignment = oldCell.alignment
		newCell.formatter = oldCell.formatter
		newCell.alignment = oldCell.alignment
		newCell.stringValue = oldCell.stringValue

		self.cell = newCell

		let tl = self.textLabel
		self.addSubview(tl)

		if #available(OSX 10.11, *) {
			tl.allowsDefaultTighteningForTruncation = true
			tl.maximumNumberOfLines = 1
		}
		tl.setContentHuggingPriority(.defaultHigh, for: .horizontal)

		self.addConstraints(
			NSLayoutConstraint.constraints(
				withVisualFormat: "V:|-(>=0)-[item]-(>=0)-|",
				options: .alignAllCenterY, metrics: nil,
				views: ["item": tl]
			)
		)
		self.addConstraint(
			NSLayoutConstraint(
				item: tl, attribute: .centerY,
				relatedBy: .equal,
				toItem: self, attribute: .centerY,
				multiplier: 1, constant: 0
			)
		)

		let rtl = self.userInterfaceLayoutDirection == .rightToLeft

		self.addConstraint(
			NSLayoutConstraint(
				item: tl, attribute: rtl ? .right : .left,
				relatedBy: .equal,
				toItem: self, attribute: rtl ? .right : .left,
				multiplier: 1, constant: rtl ? -1 : 1
			)
		)

		self.addConstraint(
			NSLayoutConstraint(
				item: tl, attribute: rtl ? .left : .right,
				relatedBy: rtl ? .greaterThanOrEqual : .lessThanOrEqual,
				toItem: self, attribute: rtl ? .left : .right,
				multiplier: 1, constant: 0
			)
		)

		self.widthConstraint = NSLayoutConstraint(
			item: tl, attribute: .width,
			relatedBy: .equal,
			toItem: nil, attribute: .notAnAttribute,
			multiplier: 1, constant: self.labelWidth == -1 ? 20 : self.labelWidth
		)

		self.addConstraint(self.widthConstraint)
		self.widthConstraint.isActive = self.labelWidth != -1

		self.syncLabelVisibility()
	}
}

public extension DSFLabelledTextField {
	private func syncLabelVisibility() {
		self.textLabel.alphaValue = self.isEnabled ? 1.0 : alphaValueForDisabled
		self.needsDisplay = true
	}

	override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		self.addObserver(self, forKeyPath: "enabled", options: .new, context: nil)

		self.syncLabelVisibility()
	}

	override func viewWillMove(toWindow newWindow: NSWindow?) {
		super.viewWillMove(toWindow: newWindow)
		guard let _ = newWindow else {
			self.removeObserver(self, forKeyPath: "enabled")
			return
		}
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "enabled" {
			self.syncLabelVisibility()
		}
		else {
			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
		}
	}

	/// Returns the size of the text within the label regardless of any width constraints set.
	var labelTextSize: CGSize {
		return self.textLabel.fittingSize
	}

	override func drawFocusRingMask() {
		let pth = NSBezierPath(roundedRect: self.bounds.insetBy(dx: 0.5, dy: 0.5), xRadius: 2, yRadius: 2)
		pth.fill()
	}

	override func layout() {
		super.layout()

		if self.labelWidth == -1 {
			self.customCell.labelWidth = self.textLabel.fittingSize.width
		}
		else {
			self.customCell.labelWidth = self.labelWidth + ((self.textLabel.alignment != .center) ? 3.0 : 0.0)
		}
	}

	// Convenience for the embedded text cell
	private var customCell: DSFPlainTextFieldCell {
		return self.cell as! DSFPlainTextFieldCell
	}
}

public extension DSFLabelledTextField {
	override func accessibilityValueDescription() -> String? {
		let labelled = "Text field is labelled '\(self.label)'"
		return labelled
	}

	override func accessibilityRoleDescription() -> String? {
		let labelled = "Text field is labelled '\(self.label)'"
		return labelled
	}
}

private class DSFPlainTextFieldCell: NSTextFieldCell {
	@inlinable var isRTL: Bool {
		return self.userInterfaceLayoutDirection == .rightToLeft
	}

	fileprivate var labelWidth: CGFloat = 20
	fileprivate var drawsLabelBackground: Bool = true
	fileprivate var roundedEdges: Bool = true
	fileprivate var labelBackgroundColor = NSColor.windowBackgroundColor

	/// The label background color, taking into account label state
	@inlinable var currentLabelBackgroundColor: NSColor {
		return isEnabled ?
			self.labelBackgroundColor :
			self.labelBackgroundColor.withAlphaComponent(alphaValueForDisabled)
	}

	private func tweak(_ rect: CGRect) -> NSRect {
		let offset: CGFloat = self.labelWidth
		var newRect = rect

		newRect.size.width -= offset

		if self.isRTL {
			newRect.origin.x = newRect.minX
		}
		else {
			newRect.origin.x = offset

			if self.bezelStyle == .roundedBezel {
				newRect.origin.x -= 8
				newRect.size.width += 14
			}
			else {
				newRect.size.width -= 2
			}
		}

		return newRect
	}

	override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
		super.select(withFrame: self.tweak(rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
	}

	override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
		super.edit(withFrame: self.tweak(rect), in: controlView, editor: textObj, delegate: delegate, event: event)
	}

	override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
		NSColor.gridColor.setStroke()
		var bg = self.backgroundColor ?? NSColor.placeholderTextColor
		if !isEnabled {
			bg = bg.withAlphaComponent(alphaValueForDisabled)
		}
		bg.setFill()

		let pth: NSBezierPath
		if self.roundedEdges {
			pth = NSBezierPath(roundedRect: cellFrame.insetBy(dx: 1, dy: 1), xRadius: 2, yRadius: 2)
			pth.lineWidth = 1.5
		}
		else {
			pth = NSBezierPath(rect: cellFrame.insetBy(dx: 1, dy: 1))
			pth.lineWidth = 1
		}
		pth.stroke()
		pth.fill()

		pth.setClip()

		if self.drawsLabelBackground {
			self.currentLabelBackgroundColor.setFill()

			let bit = cellFrame.divided(
				atDistance: self.labelWidth,
				from: self.isRTL ? .maxXEdge : .minXEdge
			).slice
			bit.fill()

			let line = NSBezierPath()
			line.move(to: NSPoint(x: bit.maxX.roundedToHalf, y: cellFrame.minY))
			line.line(to: NSPoint(x: bit.maxX.roundedToHalf, y: cellFrame.maxY))
			line.lineWidth = 0.5
			line.stroke()
		}

		self.drawInterior(withFrame: self.tweak(cellFrame), in: controlView)
	}
}

private extension CGFloat {
	var roundedToHalf: CGFloat {
		let s = self.rounded(.awayFromZero)
		return s < 0 ? s + 0.5 : s - 0.5
	}
}

#endif
