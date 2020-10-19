//
//  DSFLabelledTextFieldGroup.swift
//
//  Created by Darren Ford on 20/10/20.
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

/// A labelled text field grouping construct, allowing the labels to synchronise their widths to match the max content
public class DSFLabelledTextFieldGroup: NSObject {
	// We want to use a weak array, so that if one of the fields vanishes it is automatically removed from the grouping
	private var grouping = NSHashTable<DSFLabelledTextField>.weakObjects()
	
	/// Set the padding for the label
	public var padding: CGFloat {
		didSet {
			self.syncWidths()
		}
	}
	
	/// Create a grouping object with an optional padding value
	public init(padding: CGFloat = 0) {
		self.padding = padding
		super.init()
	}
	
	/// Add a new field to the group
	/// - Parameter field: the field to add. If the field is already a member of a group, does nothing
	///
	/// Group members are held weakly, so if one of the fields disappears the group will automatically update
	@discardableResult public func add(_ field: DSFLabelledTextField) -> Bool {
		guard field.group == nil else {
			// field is already a member of a group.
			return false
		}
		self.grouping.add(field)
		field.group = self
		return true
	}
	
	/// Add a new field to the group
	/// - Parameter fields: the fields to add
	/// - Returns true if the fields were added, false if one or more fields are already a member of a group
	///
	/// Group members are held weakly, so if one of the fields disappears the group will automatically update.
	///
	/// If any of the fields is already a group member, this call does nothing
	@discardableResult public func add(_ fields: [DSFLabelledTextField]) -> Bool {
		// Check ALL of the fields before adding, if any are already a member of a group then the entire fails.
		guard fields.filter({ $0.group != nil }).count == 0 else {
			// One of more of the fields already are a member of a group
			return false
		}
		fields.forEach { self.add($0) }
		self.syncWidths()
		return true
	}
	
	/// Add a new field to the group
	/// - Parameter fields: the fields to add.
	/// - Returns true if the fields were added, false if one or more fields are already a member of a group
	///
	/// Group members are held weakly, so if one of the fields disappears the group will automatically update
	///
	/// If any of the fields is already a group member, this call does nothing
	@discardableResult public func add(fields: DSFLabelledTextField...) -> Bool {
		return self.add(fields as [DSFLabelledTextField])
	}
	
	/// Remove a field from the group
	/// - Parameter field: the field to remove
	/// - Returns true if the field was removed, false if the field is not a member of this group
	@discardableResult public func remove(_ field: DSFLabelledTextField) -> Bool {
		if field.group === self {
			field.group = nil
			self.grouping.remove(field)
			return true
		}
		return false
	}
	
	/// Update the label widths of all the fields in the group to be the maximum width of all the field labels
	@discardableResult public func syncWidths() -> CGFloat {
		var combinedWidth: CGFloat = 0
		self.grouping.objectEnumerator().forEach { f in
			guard let field = f as? DSFLabelledTextField else { return }
			combinedWidth = max(combinedWidth, field.labelTextSize.width)
		}
		
		self.grouping.objectEnumerator().forEach { f in
			guard let field = f as? DSFLabelledTextField else { return }
			field.labelWidth = combinedWidth + self.padding
		}
		
		return combinedWidth
	}
}

#endif
