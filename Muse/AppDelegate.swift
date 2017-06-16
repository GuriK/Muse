//
//  AppDelegate.swift
//  Muse
//
//  Created by Marco Albera on 21/11/16.
//  Copyright © 2016 Edge Apps. All rights reserved.
//

import Cocoa

@available(OSX 10.12.2, *)
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier!
    }
    
    private var supportFiles = ["application.json", "token.json"]
    
    // MARK: Properties
    
    let menuItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    var windowToggledHandler: () -> () = { }

    // MARK: Outlets
    
    @IBOutlet weak var menuBarMenu: NSMenu!
    
    // MARK: Actions
    
    @IBAction func toggleWindowMenuItemClicked(_ sender: Any) {
        // Show window
        windowToggledHandler()
    }
    
    @IBAction func quitMenuItemClicked(_ sender: Any) {
        // Quit the application
        NSApplication.shared().terminate(self)
    }
    
    // MARK: Data saving
    
    var applicationSupportURL: URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .applicationSupportDirectory,
            .userDomainMask,
            true
        ).first else { return nil }
        
        return NSURL(fileURLWithPath: path).appendingPathComponent(bundleIdentifier)
    }
    
    /**
     Checks if application support folder is present.
     http://www.cocoabuilder.com/archive/cocoa/281310-creating-an-application-support-folder.html
     */
    var hasApplicationSupportFolder: Bool {
        guard let url = applicationSupportURL else { return false }
        
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: url.path,
                                                    isDirectory: &isDirectory)
        
        return exists && isDirectory.boolValue
    }
    
    /**
     Checks if application support files are present.
     */
    var hasApplicationSupportFiles: Bool {
        guard let url = applicationSupportURL else { return false }
        
        let filesExist = supportFiles.map { file in
            return FileManager.default
                .fileExists(atPath: url.appendingPathComponent(file).path)
        }
        
        return !filesExist.contains(false)
    }
    
    func createApplicationSupportFolder() {
        guard let url = applicationSupportURL else { return }
        
        do {
            try FileManager.default.createDirectory(at: url,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
        } catch {
            // Application support folder can't be created
        }
    }
    
    // MARK: Functions
    
    func attachMenuItem() {
        // Set the menu for the item
        menuItem.menu = menuBarMenu
        
        // Set the icon
        menuItem.image = .menuBarIcon
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Enable TouchBar overlay
        NSApplication.shared().isAutomaticCustomizeTouchBarMenuItemEnabled = true
        
        // Create the menu item
        attachMenuItem()
        
        // Create application support folder if necessary
        if !hasApplicationSupportFolder { createApplicationSupportFolder() }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

