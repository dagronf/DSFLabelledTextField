//
//  NSGraphicsContext+extensions.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#if os(macOS)

import AppKit

// MARK: - Graphics Context

extension NSGraphicsContext {
	/// Perform the block without antialiasing
	func disablingAntialiasing(_ stateBlock: () throws -> Void) rethrows -> Void {
		let existing = self.shouldAntialias
		defer { self.shouldAntialias = existing }

		self.shouldAntialias = false
		try stateBlock()
	}

	/// Execute the supplied block within a `saveGraphicsState() / restoreGraphicsState()` pair
	///
	/// Example usage:
	/// ```
	/// NSGraphicsContext.usingGraphicsState {
	///    backgroundColor.setFill()
	///    rectanglePath.fill()
	/// }
	/// ```
	///
	/// - Parameter stateBlock: The block to execute within the new graphics state
	static func usingGraphicsState(stateBlock: (NSGraphicsContext) throws -> Void) rethrows -> Void {
		NSGraphicsContext.saveGraphicsState()
		defer {
			NSGraphicsContext.restoreGraphicsState()
		}

		if let ctx = NSGraphicsContext.current {
			try stateBlock(ctx)
		}
	}
}


#endif
