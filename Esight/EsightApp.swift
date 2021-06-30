//
//  EsightApp.swift
//  Esight
//
//  Created by 陳奕利 on 2021/6/27.
//

import SwiftUI

@main
struct EsightApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appdelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
 
class AppDelegate: NSObject, NSApplicationDelegate {
    // status(menu) bar item
    var statusbarItem: NSStatusItem?
    var popOver = NSPopover()
    // notification
    @AppStorage(Settings.OnHold) var onhold = false
    @AppStorage(Settings.WorkTimeKey) var worktime = 40
    @AppStorage(Settings.FullScreenKey) var fullscreen = true
    @AppStorage(Settings.Twenty_TewntyKey) var twenty_twenty = false
    //
    @State var timerMinute: Int = 0
    @State var timerSecond: Int = 0
    var timer: Timer? = nil
    //
    var notificationWindow: NSWindow!
    
    // menu popover
    @objc func togglePopover(_ sender: AnyObject?) {
        // show
        func showPopup(_ sender: AnyObject?) {
            if let button = statusbarItem?.button {
                popOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
        //close
        func closePopover(_ sender: AnyObject?) {
            popOver.performClose(sender)
        }
        if popOver.isShown {
            closePopover(sender)
        } else {
           showPopup(sender)
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        //
        func createMenuBarView() {
            let menuBar = MenuBar()
            popOver.behavior = .transient
            popOver.animates = true
            popOver.contentViewController = NSViewController()
            popOver.contentViewController?.view = NSHostingView(rootView: menuBar)
            // create menu-bar button
            statusbarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusbarItem?.button?.title = "40min"
            statusbarItem?.button?.action = #selector(togglePopover)
            }
        
        createMenuBarView()
        //
        func timerManager() {
            timer?.tolerance = 5
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.onhold {
                    self.timerMinute = 0
                    self.timerSecond = 0
                } else if self.twenty_twenty {
                    if self.timerMinute < 60 {
                        if self.timerSecond == 59 {
                            self.timerMinute += 1
                            self.timerSecond = 0
                        } else {
                            self.timerSecond += 1
                        }
                    } else {
                        self.timerMinute = 0
                        self.timerSecond = 0
                    }
                }
            }
        }
        //nNotification View
        func createNotificationView() {
            notificationWindow = NSWindow(
                contentRect: NSRect(
                    x: 0, y: 0, width: NSScreen.main!.frame.width,
                    height: NSScreen.main!.frame.height),
                    styleMask: [.closable, .fullSizeContentView],
                    backing: .buffered,
                    defer: false)
            notificationWindow.center()
            notificationWindow.level = .floating
            notificationWindow.orderFrontRegardless()
            notificationWindow.contentView = NSHostingView(rootView: NotificationView(window: notificationWindow))
            notificationWindow.isOpaque = true
            notificationWindow.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        }
    }
}
