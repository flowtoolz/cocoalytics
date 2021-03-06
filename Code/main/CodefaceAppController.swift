import UIToolz
import AppKit
import SwiftyToolz

@main
class CodefaceAppController: AppController
{
    static func main() { instance.startApp() }
    
    private static let instance = CodefaceAppController(appView: CodefaceView(),
                                                        appMenu: CodefaceMenu())
    
    override func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        super.applicationDidFinishLaunching(aNotification)

        do { try Project.loadLastOpenFolder() }
        catch { log(error) }
    }
}
