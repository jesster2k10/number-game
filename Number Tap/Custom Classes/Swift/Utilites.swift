
import SpriteKit
import UIKit
import SystemConfiguration

enum ShortcutIdentifier: String {
    case OpenFavorites
    case OpenFeatured
    case OpenTopRated
    
}

extension NSTimer {
    
    // MARK: Schedule timers
    
    /// Create and schedule a timer that will call `block` once after the specified time.
    
    public class func after(interval: NSTimeInterval, _ block: () -> Void) -> NSTimer {
        let timer = NSTimer.new(after: interval, block)
        timer.start()
        return timer
    }
    
    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
    
    public class func every(interval: NSTimeInterval, _ block: () -> Void) -> NSTimer {
        let timer = NSTimer.new(every: interval, block)
        timer.start()
        return timer
    }
    
    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)
    
    @nonobjc public class func every(interval: NSTimeInterval, _ block: NSTimer -> Void) -> NSTimer {
        let timer = NSTimer.new(every: interval, block)
        timer.start()
        return timer
    }
    
    // MARK: Create timers without scheduling
    
    /// Create a timer that will call `block` once after the specified time.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.after` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)
    
    public class func new(after interval: NSTimeInterval, _ block: () -> Void) -> NSTimer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0) { _ in
            block()
        }
    }
    
    /// Create a timer that will call `block` repeatedly in specified time intervals.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)
    
    public class func new(every interval: NSTimeInterval, _ block: () -> Void) -> NSTimer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block()
        }
    }
    
    /// Create a timer that will call `block` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)
    
    @nonobjc public class func new(every interval: NSTimeInterval, _ block: NSTimer -> Void) -> NSTimer {
        var timer: NSTimer!
        timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block(timer)
        }
        return timer
    }
    
    // MARK: Manual scheduling
    
    /// Schedule this timer on the run loop
    ///
    /// By default, the timer is scheduled on the current run loop for the default mode.
    /// Specify `runLoop` or `modes` to override these defaults.
    
    public func start(runLoop runLoop: NSRunLoop = NSRunLoop.currentRunLoop(), modes: String...) {
        let modes = modes.isEmpty ? [NSDefaultRunLoopMode] : modes
        
        for mode in modes {
            runLoop.addTimer(self, forMode: mode)
        }
    }
}

// MARK: - Time extensions

extension Double {
    public var millisecond: NSTimeInterval  { return self / 1000 }
    public var milliseconds: NSTimeInterval { return self / 1000 }
    public var ms: NSTimeInterval           { return self / 1000 }
    
    public var second: NSTimeInterval       { return self }
    public var seconds: NSTimeInterval      { return self }
    
    public var minute: NSTimeInterval       { return self * 60 }
    public var minutes: NSTimeInterval      { return self * 60 }
    
    public var hour: NSTimeInterval         { return self * 3600 }
    public var hours: NSTimeInterval        { return self * 3600 }
    
    public var day: NSTimeInterval          { return self * 3600 * 24 }
    public var days: NSTimeInterval         { return self * 3600 * 24 }
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

struct SocialNetworkUrl {
    let scheme: String
    let page: String
    
    func openPage() {
        let schemeUrl = NSURL(string: scheme)!
        if UIApplication.sharedApplication().canOpenURL(schemeUrl) {
            UIApplication.sharedApplication().openURL(schemeUrl)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: page)!)
        }
    }
}

enum SocialNetwork {
    case Facebook, GooglePlus, Twitter, Instagram
    func url() -> SocialNetworkUrl {
        switch self {
        case .Facebook: return SocialNetworkUrl(scheme: "fb://profile/831944953601016", page: "https://www.facebook.com/831944953601016")
        case .Twitter: return SocialNetworkUrl(scheme: "twitter:///user?screen_name=USERNAME", page: "https://twitter.com/USERNAME")
        case .GooglePlus: return SocialNetworkUrl(scheme: "gplus://plus.google.com/u/0/PageId", page: "https://plus.google.com/PageId")
        case .Instagram: return SocialNetworkUrl(scheme: "instagram://user?username=USERNAME", page:"https://www.instagram.com/USERNAME")
        }
    }
    func openPage() {
        self.url().openPage()
    }
}

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.sharedApplication()
        for url in urls {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
}

public enum Model : String {
    case simulator = "simulator/sandbox",
    iPod1          = "iPod 1",
    iPod2          = "iPod 2",
    iPod3          = "iPod 3",
    iPod4          = "iPod 4",
    iPod5          = "iPod 5",
    iPad2          = "iPad 2",
    iPad3          = "iPad 3",
    iPad4          = "iPad 4",
    iPhone4        = "iPhone 4",
    iPhone4S       = "iPhone 4S",
    iPhone5        = "iPhone 5",
    iPhone5S       = "iPhone 5S",
    iPhone5C       = "iPhone 5C",
    iPadMini1      = "iPad Mini 1",
    iPadMini2      = "iPad Mini 2",
    iPadMini3      = "iPad Mini 3",
    iPadAir1       = "iPad Air 1",
    iPadAir2       = "iPad Air 2",
    iPhone6        = "iPhone 6",
    iPhone6plus    = "iPhone 6 Plus",
    iPhone6S       = "iPhone 6S",
    iPhone6Splus   = "iPhone 6S Plus",
    unrecognized   = "?unrecognized?"
}


public extension UIDevice {
    
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafeMutablePointer(&systemInfo.machine) {
            ptr in String.fromCString(UnsafePointer<CChar>(ptr))
        }
        var modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad2,5"   : .iPadMini1,
            "iPad2,6"   : .iPadMini1,
            "iPad2,7"   : .iPadMini1,
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPad4,1"   : .iPadAir1,
            "iPad4,2"   : .iPadAir2,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus
        ]
        
        if let model = modelMap[String.fromCString(modelCode!)!] {
            return model
        }
        return Model.unrecognized
    }
}


extension NSUserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = NSUserDefaults.standardUserDefaults().stringForKey(firstLaunchFlag) == nil
        if (isFirstLaunch) {
            NSUserDefaults.standardUserDefaults().setObject("false", forKey: firstLaunchFlag)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        return isFirstLaunch
    }
    
    var highScore: Int {
        get {
            print("High Score = " + integerForKey("highScore").description)
            return integerForKey("highScore")
        }
        set {
            guard newValue > highScore else { print("\(newValue) ≤ \(highScore) Try again")
                return
            }
            setInteger(newValue, forKey: "highScore")
            print("New High Score = \(highScore)")
        }
    }
    func resetHighScore() {
        removeObjectForKey("highScore")
        print("removed object for key highScore")
    }
    var highScoreDouble: Double {
        get {
            return doubleForKey("highScoreDouble")
        }
        set {
            guard newValue > highScoreDouble else { print("Try again")
                return
            }
            setDouble(newValue, forKey: "highScoreDouble")
            print("New High Score = \(highScoreDouble)")
        }
    }
    func resetHighScoreDouble() {
        removeObjectForKey("highScoreDouble")
        print("removed object for key highScoreDouble")
    }
}

/**
 MissingHashMarkAsPrefix:   "Invalid RGB string, missing '#' as prefix"
 UnableToScanHexValue:      "Scan hex error"
 MismatchedHexStringLength: "Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8"
 */
public enum UIColorInputError : ErrorType {
    case MissingHashMarkAsPrefix,
    UnableToScanHexValue,
    MismatchedHexStringLength
}

extension UIColor {
    
    /**
     The shorthand three-digit hexadecimal representation of color.
     #RGB defines to the color #RRGGBB.
     
     - parameter hex3: Three-digit hexadecimal value.
     - parameter alpha: 0.0 - 1.0. The default is 1.0.
     */
    public convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The shorthand four-digit hexadecimal representation of color with alpha.
     #RGBA defines to the color #RRGGBBAA.
     
     - parameter hex4: Four-digit hexadecimal value.
     */
    public convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The six-digit hexadecimal representation of color of the form #RRGGBB.
     
     - parameter hex6: Six-digit hexadecimal value.
     */
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.
     
     - parameter hex8: Eight-digit hexadecimal value.
     */
    public convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, throws error.
     
     - parameter rgba: String value.
     */
    public convenience init(rgba_throws rgba: String) throws {
        guard rgba.hasPrefix("#") else {
            throw UIColorInputError.MissingHashMarkAsPrefix
        }
        
        guard let hexString: String = rgba.substringFromIndex(rgba.startIndex.advancedBy(1)),
            var   hexValue:  UInt32 = 0
            where NSScanner(string: hexString).scanHexInt(&hexValue) else {
                throw UIColorInputError.UnableToScanHexValue
        }
        
        guard hexString.characters.count  == 3
            || hexString.characters.count == 4
            || hexString.characters.count == 6
            || hexString.characters.count == 8 else {
                throw UIColorInputError.MismatchedHexStringLength
        }
        
        switch (hexString.characters.count) {
        case 3:
            self.init(hex3: UInt16(hexValue))
        case 4:
            self.init(hex4: UInt16(hexValue))
        case 6:
            self.init(hex6: hexValue)
        default:
            self.init(hex8: hexValue)
        }
    }
    
    /**
     The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, fails to default color.
     
     - parameter rgba: String value.
     */
    public convenience init(rgba: String, defaultColor: UIColor = UIColor.clearColor()) {
        guard let color = try? UIColor(rgba_throws: rgba) else {
            self.init(CGColor: defaultColor.CGColor)
            return
        }
        self.init(CGColor: color.CGColor)
    }
    
    /**
     Hex string of a UIColor instance.
     
     - parameter rgba: Whether the alpha should be included.
     */
    public func hexString(includeAlpha: Bool) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha) {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
    
    public override var description: String {
        return self.hexString(true)
    }
    
    public override var debugDescription: String {
        return self.hexString(true)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Factory Methods -


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Move

extension SKAction {
    
    public class func moveByX(deltaX: CGFloat, y deltaY: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let moveByX = animateKeyPath("x", byValue: deltaX, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let moveByY = animateKeyPath("y", byValue: deltaY, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([moveByX, moveByY])
    }
    
    public class func moveBy(delta: CGVector, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let moveByX = animateKeyPath("x", byValue: delta.dx, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let moveByY = animateKeyPath("y", byValue: delta.dy, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([moveByX, moveByY])
    }
    
    public class func moveTo(location: CGPoint, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let moveToX = animateKeyPath("x", toValue: location.x, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let moveToY = animateKeyPath("y", toValue: location.y, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([moveToX, moveToY])
    }
    
    public class func moveToX(x: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("x", toValue: x, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func moveToY(y: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("y", toValue: y, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Rotate

extension SKAction {
    
    public class func rotateByAngle(radians: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("zRotation", byValue: radians, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func rotateToAngle(radians: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("zRotation", toValue: radians, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Speed

extension SKAction {
    
    public class func speedBy(speed: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("speed", byValue: speed, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func speedTo(speed: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("speed", toValue: speed, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Scale

extension SKAction {
    
    public class func scaleBy(scale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return scaleXBy(scale, y: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func scaleTo(scale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return scaleXTo(scale, y: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func scaleXBy(xScale: CGFloat, y yScale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let scaleXBy = animateKeyPath("xScale", byValue: xScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let scaleYBy = animateKeyPath("yScale", byValue: yScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([scaleXBy, scaleYBy])
    }
    
    public class func scaleXTo(scale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("xScale", toValue: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func scaleYTo(scale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("yScale", toValue: scale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func scaleXTo(xScale: CGFloat, y yScale: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let scaleXTo = self.scaleXTo(xScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let scaleYTo = self.scaleYTo(yScale, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([scaleXTo, scaleYTo])
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Fade

extension SKAction {
    
    public class func fadeInWithDuration(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("alpha", toValue: 1, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func fadeOutWithDuration(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("alpha", toValue: 0, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func fadeAlphaBy(factor: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("alpha", byValue: factor, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func fadeAlphaTo(factor: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("alpha", toValue: factor, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Resize

extension SKAction {
    
    public class func resizeByWidth(width: CGFloat, height: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let resizeByWidth = animateKeyPath("width", byValue: width, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let resizeByHeight = animateKeyPath("height", byValue: height, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([resizeByWidth, resizeByHeight])
    }
    
    public class func resizeToWidth(width: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("width", toValue: width, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func resizeToHeight(height: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("height", toValue: height, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func resizeToWidth(width: CGFloat, height: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        let resizeToWidth = self.resizeToWidth(width, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        let resizeToHeight = self.resizeToHeight(height, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
        
        return SKAction.group([resizeToWidth, resizeToHeight])
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Colorize

extension SKAction {
    
    public class func colorizeWithColorBlendFactor(colorBlendFactor: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath("colorBlendFactor", toValue: colorBlendFactor, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Damping Logic

extension SKAction {
    
    public class func animateKeyPath(keyPath: String, byValue initialDistance: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath(keyPath, byValue: initialDistance, toValue: nil, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    public class func animateKeyPath(keyPath: String, toValue finalValue: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        return animateKeyPath(keyPath, byValue: nil, toValue: finalValue, duration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity)
    }
    
    private class func animateKeyPath(keyPath: String, var byValue initialDistance: CGFloat!, var toValue finalValue: CGFloat!, duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat) -> SKAction {
        
        var initialValue: CGFloat!
        var naturalFrequency, dampedFrequency, t1, t2: CGFloat!
        var A, B: CGFloat!
        
        let animation = SKAction.customActionWithDuration(duration) {
            node, elapsedTime in
            
            if initialValue == nil {
                
                initialValue = node.valueForKeyPath(keyPath) as! CGFloat
                initialDistance = initialDistance ?? finalValue - initialValue
                finalValue = finalValue ?? initialValue + initialDistance
                
                var magicNumber: CGFloat! // picked manually to visually match the behavior of UIKit
                if dampingRatio < 1 { magicNumber = 8 / dampingRatio }
                else if dampingRatio == 1 { magicNumber = 10 }
                else { magicNumber = 12 * dampingRatio }
                
                naturalFrequency = magicNumber / CGFloat(duration)
                dampedFrequency = naturalFrequency * sqrt(1 - pow(dampingRatio, 2))
                t1 = 1 / (naturalFrequency * (dampingRatio - sqrt(pow(dampingRatio, 2) - 1)))
                t2 = 1 / (naturalFrequency * (dampingRatio + sqrt(pow(dampingRatio, 2) - 1)))
            }
            
            var currentValue: CGFloat!
            
            if elapsedTime < CGFloat(duration) {
                
                if dampingRatio < 1 {
                    
                    A = A ?? initialDistance
                    B = B ?? (dampingRatio * naturalFrequency - velocity) * initialDistance / dampedFrequency
                    
                    currentValue = finalValue - exp(-dampingRatio * naturalFrequency * elapsedTime) * (A * cos(dampedFrequency * elapsedTime) + B * sin(dampedFrequency * elapsedTime))
                }
                else if dampingRatio == 1 {
                    
                    A = A ?? initialDistance
                    B = B ?? (naturalFrequency - velocity) * initialDistance
                    
                    currentValue = finalValue - exp(-dampingRatio * naturalFrequency * elapsedTime) * (A + B * elapsedTime)
                }
                else {
                    
                    A = A ?? (t1 * t2 / (t1 - t2)) * initialDistance * (1/t2 - velocity)
                    B = B ?? (t1 * t2 / (t2 - t1)) * initialDistance * (1/t1 - velocity)
                    
                    currentValue = finalValue - A * exp(-elapsedTime/t1) - B * exp(-elapsedTime/t2)
                }
            }
            else {
                
                currentValue = finalValue
            }
            
            node.setValue(currentValue, forKeyPath: keyPath)
        }
        
        if delay > 0 {
            
            return SKAction.sequence([SKAction.waitForDuration(delay), animation])
        }
        else {
            
            return animation
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - KVC Extensions -


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: SKNode

extension SKNode {
    
    var x: CGFloat {
        get {
            
            return position.x
        }
        set {
            
            position.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            
            return position.y
        }
        set {
            
            position.y = newValue
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: SKSpriteNode

extension SKSpriteNode {
    
    var width: CGFloat {
        get {
            
            return size.width
        }
        set {
            
            size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            
            return size.height
        }
        set {
            
            size.height = newValue
        }
    }
}

