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
    var timer: Timer?
    var timerData: AppTimer!
    var leftMinute: Int = 0
    //
    var notificationWindow: NSWindow!
    // menu popover
    @objc func togglePopover(_ sender: AnyObject?) {
        // show
        func showPopup(_: AnyObject?) {
            if let button = statusbarItem?.button {
                popOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
        // close
        func closePopover(_ sender: AnyObject?) {
            popOver.performClose(sender)
        }
        if popOver.isShown {
            closePopover(sender)
        } else {
            showPopup(sender)
        }
    }

    func applicationDidFinishLaunching(_: Notification) {
        //
        timerData = AppTimer()
        func createMenuBarView() {
            let menuBar = MenuBar(timerData: timerData)
            popOver.behavior = .transient
            popOver.animates = true
            popOver.contentViewController = NSViewController()
            popOver.contentViewController?.view = NSHostingView(rootView: menuBar)
            // create menu-bar button
            statusbarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusbarItem?.button?.action = #selector(togglePopover)
        }

        createMenuBarView()
        // \\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
        func pushNotification() {
            // Notification View
            func createNotificationView() {
                notificationWindow = NSWindow(
                    contentRect: NSRect(
                        x: 0, y: 0, width: NSScreen.main!.frame.width,
                        height: NSScreen.main!.frame.height
                    ),
                    styleMask: [.closable, .fullSizeContentView],
                    backing: .buffered,
                    defer: false
                )
                notificationWindow.center()
                notificationWindow.level = .floating
                notificationWindow.orderFrontRegardless()
                notificationWindow.contentView = NSHostingView(rootView: NotificationView(window: notificationWindow, timerData: timerData))
                notificationWindow.isOpaque = true
                notificationWindow.backgroundColor = NSColor(red: 128, green: 128, blue: 128, alpha: 0.6)
            }
            // \\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
            func timerManager() {
                timer?.tolerance = 5
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if self.twenty_twenty {
                        self.worktime = 20
                    }
                    if self.leftMinute >= 0 {
                        self.leftMinute = self.worktime - self.timerData.TimerMinute
                    }
                    if self.leftMinute > 0 {
                        self.statusbarItem?.button?.image = nil
                        self.statusbarItem?.button?.title = "\(self.leftMinute)min"
                    } else {
                        self.statusbarItem?.button?.image = NSImage(systemSymbolName: "eye.slash.fill", accessibilityDescription: nil)
                    }
                    if !self.onhold {
                        // not on-hold
                        self.timerData.TimerSecond += 1
                        if self.timerData.TimerSecond == 60 {
                            self.timerData.TimerMinute += 1
                            self.timerData.TimerSecond = 0
                        }
                        if !self.twenty_twenty {
                            // normal mode
                            if self.timerData.TimerMinute == 60 {
                                self.timerData.TimerSecond = 0
                                self.timerData.TimerMinute = 0
                            }
                        } else {
                            // 20-20-20 mode
                            if self.timerData.TimerMinute == 20, self.timerData.TimerSecond == 20 {
                                self.timerData.TimerSecond = 0
                                self.timerData.TimerMinute = 0
                            }
                        }
                    } else {
                        // on-hold
                        self.timerData.TimerSecond = 0
                        self.timerData.TimerMinute = 0
                    }
                    if self.timerData.TimerMinute == self.worktime, self.timerData.TimerSecond == 0 {
                        createNotificationView()
                    }
                }
            }
            timerManager()
        }
        pushNotification()
    }
}
