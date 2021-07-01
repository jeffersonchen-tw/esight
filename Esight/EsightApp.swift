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
    var timerMinute: Int = 0
    var timerSecond: Int = 0
    var timer: Timer?
    var leftTime: Int = 0
    @State var restTime: Int = 0
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
        func createMenuBarView() {
            let menuBar = MenuBar()
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
                notificationWindow.contentView = NSHostingView(rootView: NotificationView(window: notificationWindow, restSecond: self.$restTime))
                notificationWindow.isOpaque = true
                notificationWindow.backgroundColor = NSColor(red: 128, green: 128, blue: 128, alpha: 0.6)
            }
            // \\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
            func timerManager() {
                if twenty_twenty {
                    worktime = 20 - timerMinute
                }
                timer?.tolerance = 5
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if self.leftTime >= 0 {
                        self.leftTime = self.worktime - self.timerMinute
                    }
                    self.statusbarItem?.button?.title = "\(self.leftTime)min"
                    if !self.onhold {
                        if !self.twenty_twenty {
                            // normal mode
                            self.timerSecond += 1
                            if self.timerMinute < 60 {
                                if self.timerMinute <= self.worktime {
                                    if self.timerSecond == 60 {
                                        self.timerMinute += 1
                                        self.timerSecond = 0
                                    }
                                } else {
                                    self.restTime = self.timerSecond
                                }
                            } else {
                                self.timerSecond = 0
                                self.timerMinute = 0
                                self.restTime = 0
                            }
                        } else {
                            // 20-20-20 mode
                            self.timerSecond += 1
                            if self.timerMinute < 20 {
                                if self.timerSecond == 60 {
                                    self.timerMinute += 1
                                    self.timerSecond = 0
                                }
                            } else {
                                if self.timerSecond < 20 {
                                    self.timerSecond += 1
                                    self.restTime += 1
                                } else {
                                    self.timerSecond = 0
                                    self.timerMinute = 0
                                    self.restTime = 0
                                }
                            }
                        }
                    } else {
                        self.timerSecond = 0
                        self.timerMinute = 0
                    }
                }
                if timerMinute == worktime, timerSecond == 0 {
                    createNotificationView()
                }
            }
            timerManager()
        }
        pushNotification()
    }
}
