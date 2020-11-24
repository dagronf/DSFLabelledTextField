//
//  DSFLabelledTextField+utils.swift
//  
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
//

#if os(macOS)

import AppKit

// MARK: - Dark Mode

internal extension NSAppearance {
	/// Is the appearance dark aqua?
	@inlinable var isDarkMode: Bool {
		if #available(macOS 10.14, *), self.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
			return true
		}
		return false
	}
}

internal extension NSView {
	/// Is this view displaying in dark mode?
	///
	/// Note that just because the application is in dark mode doesn't mean that each view is displaying in dark mode.
	/// The 'effective appearance' of the view depends on many elements, such as the parent and any effect view(s) that
	/// contain it.
	@inlinable var isDarkMode: Bool {
		return self.effectiveAppearance.isDarkMode
	}
}

/// A global method to determine if the system is running in dark mode.
@inlinable func IsDarkMode() -> Bool {
	if #available(OSX 10.14, *) {
		if let style = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") {
			return style.lowercased().contains("dark")
		}
	}
	return false
}

// MARK: - Simple accessibility wrapper

internal enum Accessibility {
	@inlinable static var reduceTransparency: Bool {
		return NSWorkspace.shared.accessibilityDisplayShouldReduceTransparency
	}

	@inlinable static var reduceMotion: Bool {
		if #available(macOS 10.12, *) {
			return NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
		}
		return false
	}

	@inlinable static var increaseContrast: Bool {
		return NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast
	}
}

// MARK: - Graphics Context

extension NSGraphicsContext {
	func withoutAntialias(stateBlock: () throws -> Void) rethrows -> Void {
		let existing = self.shouldAntialias
		self.shouldAntialias = false
		defer {
			self.shouldAntialias = existing
		}
		try stateBlock()
	}
}

extension NSGraphicsContext {

	/// Execute the supplied block within a `saveGraphicsState() / restoreGraphicsState()` pair
	///
	/// Example usage:
	/// ```
	///     NSGraphicsContext.usingGraphicsState {
	///        backgroundColor.setFill()
	///        rectanglePath.fill()
	///     }
	/// ```
	///
	/// - Parameter stateBlock: The block to execute within the new graphics state
	static func usingGraphicsState(stateBlock: () throws -> Void) rethrows -> Void {
		NSGraphicsContext.saveGraphicsState()
		defer {
			NSGraphicsContext.restoreGraphicsState()
		}
		try stateBlock()
	}
}


#endif
