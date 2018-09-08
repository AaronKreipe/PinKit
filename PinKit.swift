//    ____    _           _  __  _   _
//   |  _ \  (_)  _ __   | |/ / (_) | |_
//   | |_) | | | | '_ \  | ' /  | | | __|
//   |  __/  | | | | | | | . \  | | | |_
//   |_|     |_| |_| |_| |_|\_\ |_|  \__|
//
/// PinKit is a super lightweight wrapper around vanilla auto layout for iOS that makes laying out constraints just like doing any other normal math.
/// See the Playgrounds for examples of how to use.
/// created by Aaron Kreipe 2018

/*This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
*/
/// PinKit is a super lightweight wrapper around vanilla Auto Layout for iOS that makes laying out constraints just like doing any other normal math.
/// See the Playground for examples of how to use.

import UIKit

extension Array where Element == NSLayoutConstraint{
    /** Activate an array of constraints*/
    public func activate(){
        NSLayoutConstraint.activate(self)
    }/** Deactivate an array of constraints*/
    public func deactivate(){
        NSLayoutConstraint.deactivate(self)
    }
}

// special operators for constraints
/**Just like = except its for creating constraints.*/
infix operator |=|: AssignmentPrecedence
/**Just like `<` except its for creating constraints.*/
infix operator |<|: AssignmentPrecedence
/**Just like `>` except its for creating constraints.*/
infix operator |>|: AssignmentPrecedence
/**Just like `<=` except its for creating constraints.*/
infix operator |<=|: AssignmentPrecedence
/**Just like `>=` except its for creating constraints.*/
infix operator |>=|: AssignmentPrecedence
/**Just like `=` except its for creating constraints.  The little `~` means `SystemSpacing` and is read as "equal to systemSpacing to:"*/
infix operator |=|~: AssignmentPrecedence
/**Just like `<=` except its for creating constraints. The little `~` means `SystemSpacing` and is read as "less than or equal to systemSpacing to:"*/
infix operator |<=|~: AssignmentPrecedence
/**Just like `>=` except its for creating constraints. The little `~` means `SystemSpacing` and is read as "greater than or equal to systemSpacing to:"*/
infix operator |>=|~: AssignmentPrecedence

/**A LayoutAnchor is a wrapper for the components that will be passed into NSLayout*AxisAnchor .constraint() function so we can do math.*/
public struct LayoutAnchor<T: NSObject>{
    /**The NSLayoutAnchor to constain to.*/
    public var anchor: NSLayoutAnchor<T>
    /**The value to add to the NSLayoutAnchor's value.  Default is 0.0*/
    public var constant: CGFloat = 0
}

/** The LayoutAnchorable protocol provides a Swift wrapper for a NSLayoutAnchor<AnchorType> that can access the AnchorType at runtime.*/
public protocol LayoutAnchorable{
    associatedtype AnchorType: NSObject
    var anchor: NSLayoutAnchor<AnchorType>{get}
}

extension NSLayoutYAxisAnchor: LayoutAnchorable{
    public var anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>{return self}
}

extension NSLayoutXAxisAnchor: LayoutAnchorable{
    public var anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>{return self}
}

extension LayoutAnchorable{
    public static func + (lhs: Self, rhs: CGFloat)->LayoutAnchor<AnchorType>{
        return LayoutAnchor(anchor: lhs.anchor, constant: rhs)
    }
    public static func - (lhs: Self, rhs: CGFloat)->LayoutAnchor<AnchorType>{
        return LayoutAnchor(anchor: lhs.anchor, constant: -rhs)
    }
    public static func |=| (_ lhs: Self, _ rhs: Self)->NSLayoutConstraint{
        return lhs.anchor.constraint(equalTo: rhs.anchor)
    }
    public static func |=| (_ lhs: Self, _ rhs: LayoutAnchor<Self.AnchorType>)->NSLayoutConstraint{
        return lhs.anchor.constraint(equalTo: rhs.anchor, constant: rhs.constant)
    }
    public static func |<=| (_ lhs: Self, _ rhs: Self)->NSLayoutConstraint{
        return lhs.anchor.constraint(lessThanOrEqualTo: rhs.anchor)
    }
    public static func |>=| (_ lhs: Self, _ rhs: Self)->NSLayoutConstraint{
        return lhs.anchor.constraint(greaterThanOrEqualTo: rhs.anchor)
    }
}

/**A LayoutDimension is a wrapper for the components that will be passed into the NSLayoutDimension .constraint() function so we can do math.*/
public struct LayoutDimension{
    /**The NSLayoutDimension to modify*/
    public var dimension: NSLayoutDimension
    /**The value to multiply by the dimension.  Default is 1.0*/
    public var multiplier: CGFloat = 1
    /**The value to add to the dimension.  Default is 0.0*/
    public var constant: CGFloat = 0
    public init(dimension: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat = 0){
        self.dimension = dimension
        self.multiplier = multiplier
        self.constant = constant
    }
    public init(dimension: NSLayoutDimension, constant: CGFloat){
        self.dimension = dimension
        self.constant = constant
    }
}

// add/sub a constant, or multiply/divide by a multiplier
extension LayoutDimension{
    public static func + (lhs: LayoutDimension, rhs: CGFloat)->LayoutDimension{
        return LayoutDimension(dimension: lhs.dimension, multiplier: lhs.multiplier, constant: lhs.constant + rhs)
    }
    public static func - (lhs: LayoutDimension, rhs: CGFloat)->LayoutDimension{
        return LayoutDimension(dimension: lhs.dimension, multiplier: lhs.multiplier, constant: lhs.constant - rhs)
    }
    public static func * (lhs: LayoutDimension, rhs: CGFloat)->LayoutDimension{
        return LayoutDimension(dimension: lhs.dimension, multiplier: lhs.multiplier * rhs, constant: lhs.constant)
    }
    public static func / (lhs: LayoutDimension, rhs: CGFloat)->LayoutDimension{
        return LayoutDimension(dimension: lhs.dimension, multiplier: lhs.multiplier / rhs, constant: lhs.constant)
    }
}

extension NSLayoutDimension{
    // add/sub/mult/div NSLayoutDimension
    public static func *(lhs: NSLayoutDimension, rhs: CGFloat)->LayoutDimension{
        return LayoutDimension(dimension: lhs, multiplier: rhs)
    }
    public static func /(lhs: NSLayoutDimension, rhs: CGFloat)->LayoutDimension{
        return LayoutDimension(dimension: lhs, multiplier: 1/rhs)
    }
    public static func +(lhs: NSLayoutDimension, rhs: CGFloat)->LayoutDimension{
        return LayoutDimension(dimension: lhs, constant: rhs)
    }
    public static func -(lhs: NSLayoutDimension, rhs: CGFloat)->LayoutDimension{
        return LayoutDimension(dimension: lhs, constant: -rhs)
    }
    // dimension constraints
    public static func |=| (_ lhs: NSLayoutDimension, _ rhs: CGFloat)->NSLayoutConstraint {
        return lhs.constraint(equalToConstant: rhs)
    }
    public static func |=| ( _ lhs: NSLayoutDimension, rhs: NSLayoutDimension)->NSLayoutConstraint{
        return lhs.constraint(equalTo: rhs)
    }
    public static func |=| ( _ lhs: NSLayoutDimension, rhs: LayoutDimension)->NSLayoutConstraint{
        return lhs.constraint(equalTo: rhs.dimension, multiplier: rhs.multiplier, constant: rhs.constant)
    }
    public static func |<=| (_ lhs: NSLayoutDimension, _ rhs: CGFloat)->NSLayoutConstraint {
        return lhs.constraint(lessThanOrEqualToConstant: rhs)
    }
    public static func |<=| (_ lhs: NSLayoutDimension, _ rhs: LayoutDimension)->NSLayoutConstraint {
        return lhs.constraint(lessThanOrEqualTo: rhs.dimension, multiplier: rhs.multiplier, constant: rhs.constant)
    }
    public static func |>=| (_ lhs: NSLayoutDimension, _ rhs: CGFloat)->NSLayoutConstraint {
        return lhs.constraint(greaterThanOrEqualToConstant: rhs)
    }
    public static func |>=| (_ lhs: NSLayoutDimension, _ rhs: LayoutDimension)->NSLayoutConstraint {
        return lhs.constraint(greaterThanOrEqualTo: rhs.dimension, multiplier: rhs.multiplier, constant: rhs.constant)
    }
}

/**A SystemSpacingXAxisAnchor is a wrapper for the components that will be passed into the NSLayoutXAxisAnchor .constraint*SystemSpacingAfter() function so we can do math.*/
public struct SystemSpacingXAxisAnchor{
    /**The NSLayoutXAxisAnchor to calculate the system spacing after*/
    var anchor: NSLayoutXAxisAnchor
    /**The value to multiply by the  system spacing after the anchor.  Default is 1.0*/
    var multiplier: CGFloat
}

extension NSLayoutXAxisAnchor{
    public static func |=|~ (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(equalToSystemSpacingAfter: rhs, multiplier: 1)
        #else
        return lhs.constraintEqualToSystemSpacingAfter(rhs, multiplier: 1)
        #endif
    }
    public static func |<=|~ (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(lessThanOrEqualToSystemSpacingAfter: rhs, multiplier: 1)
        #else
        return lhs.constraintLessThanOrEqualToSystemSpacingAfter(rhs, multiplier: 1)
        #endif
    }
    public static func |>=|~ (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(greaterThanOrEqualToSystemSpacingAfter: rhs, multiplier: 1)
        #else
        return lhs.constraintGreaterThanOrEqualToSystemSpacingAfter(rhs, multiplier: 1)
        #endif
    }
    public static func * (lhs: NSLayoutXAxisAnchor, rhs: CGFloat)->SystemSpacingXAxisAnchor{
        return SystemSpacingXAxisAnchor(anchor: lhs, multiplier: rhs)
    }
    public static func / (lhs: NSLayoutXAxisAnchor, rhs: CGFloat)->SystemSpacingXAxisAnchor{
        return SystemSpacingXAxisAnchor(anchor: lhs, multiplier: 1/rhs)
    }
    public static func |=|~ (lhs: NSLayoutXAxisAnchor, rhs: SystemSpacingXAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(equalToSystemSpacingAfter: rhs.anchor, multiplier: rhs.multiplier)
        #else
        return lhs.constraintEqualToSystemSpacingAfter(rhs.anchor, multiplier: rhs.multiplier)
        #endif
    }
    public static func |<=|~ (lhs: NSLayoutXAxisAnchor, rhs: SystemSpacingXAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(lessThanOrEqualToSystemSpacingAfter: rhs.anchor, multiplier: rhs.multiplier)
        #else
        return lhs.constraintLessThanOrEqualToSystemSpacingAfter(rhs.anchor, multiplier: rhs.multiplier)
        #endif
    }
    public static func |>=|~ (lhs: NSLayoutXAxisAnchor, rhs: SystemSpacingXAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(greaterThanOrEqualToSystemSpacingAfter: rhs.anchor, multiplier: rhs.multiplier)
        #else
        return lhs.constraintGreaterThanOrEqualToSystemSpacingAfter(rhs.anchor, multiplier: rhs.multiplier)
        #endif
    }
}

/**A SystemSpacingYAxisAnchor is a wrapper for the components that will be passed into the NSLayoutYAxisAnchor .constraint_?_SystemSpacingBelow() function so we can do math.*/
public struct SystemSpacingYAxisAnchor{
    /**The NSLayoutXAxisAnchor to calculate the system spacing below*/
    var anchor: NSLayoutYAxisAnchor
    /**The value to multiply by the system spacing below the anchor.  Default is 1.0*/
    var multiplier: CGFloat
}

extension NSLayoutYAxisAnchor{
    public static func |=|~ (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(equalToSystemSpacingBelow: rhs, multiplier: 1)
        #else
        return lhs.constraintEqualToSystemSpacingBelow(rhs, multiplier: 1)
        #endif
    }
    public static func |<=|~ (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(lessThanOrEqualToSystemSpacingBelow: rhs, multiplier: 1)
        #else
        return lhs.constraintLessThanOrEqualToSystemSpacingBelow(rhs, multiplier: 1)
        #endif
    }
    public static func |>=|~ (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(greaterThanOrEqualToSystemSpacingBelow: rhs, multiplier: 1)
        #else
        return lhs.constraintGreaterThanOrEqualToSystemSpacingBelow(rhs, multiplier: 1)
        #endif
    }
    public static func * (lhs: NSLayoutYAxisAnchor, rhs: CGFloat)->SystemSpacingYAxisAnchor{
        return SystemSpacingYAxisAnchor(anchor: lhs, multiplier: rhs)
    }
    public static func / (lhs: NSLayoutYAxisAnchor, rhs: CGFloat)->SystemSpacingYAxisAnchor{
        return SystemSpacingYAxisAnchor(anchor: lhs, multiplier: 1/rhs)
    }
    public static func |=|~ (lhs: NSLayoutYAxisAnchor, rhs: SystemSpacingYAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(equalToSystemSpacingBelow: rhs.anchor, multiplier: rhs.multiplier)
        #else
        return lhs.constraintEqualToSystemSpacingBelow(rhs.anchor, multiplier: rhs.multiplier)
        #endif
    }
    public static func |<=|~ (lhs: NSLayoutYAxisAnchor, rhs: SystemSpacingYAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(lessThanOrEqualToSystemSpacingBelow: rhs.anchor, multiplier: rhs.multiplier)
        #else
        return lhs.constraintLessThanOrEqualToSystemSpacingBelow(rhs.anchor, multiplier: rhs.multiplier)
        #endif
    }
    public static func |>=|~ (lhs: NSLayoutYAxisAnchor, rhs: SystemSpacingYAxisAnchor)->NSLayoutConstraint{
        #if swift(>=4.2)
        return lhs.constraint(greaterThanOrEqualToSystemSpacingBelow: rhs.anchor, multiplier: rhs.multiplier)
        #else
        return lhs.constraintGreaterThanOrEqualToSystemSpacingBelow(rhs.anchor, multiplier: rhs.multiplier)
        #endif
    }
}

extension UIView{
    /** pin a view to another view's edges*/
    public func pinEdges(to other: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        [topAnchor |=| other.topAnchor,
         leadingAnchor |=| other.leadingAnchor,
         trailingAnchor |=| other.trailingAnchor,
         bottomAnchor |=| other.bottomAnchor].activate()
    }
}

