//
//  EsightApp.swift
//  Esight
//
//  Created by 陳奕利 on 2021/6/27.
//

import SwiftUI
import UserNotifications

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
    // status (menu) bar item
    var statusbarItem: NSStatusItem?
    var popOver = NSPopover()
    // notification
    @AppStorage(Settings.WorkTimeKey) var worktime = 40
    @AppStorage(Settings.FullScreenKey) var fullscreen = true
    @AppStorage(Settings.Twenty_TewntyKey) var twenty_twenty = false
    //
    var leftTime: Int?
    // timer
    var timer: DispatchSourceTimer?
    var timerData: AppTimer!
    var notificationWindow: NSWindow!
    // menubar popover
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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        //
        timerData = AppTimer()
        func createMenuBarView() {
            let menuBar = MenuBar(Timer: timer, timerData: timerData)
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
            func timerManager() {
                // Notification
                func createNotification() {
                    let notification = UNMutableNotificationContent()
                    let body = ["have a cup of coffee ☕️", "have a cup of tea 🫖",
                                "go jogging 🏃‍♂️🏃‍♀️", "stretch yourself"]
                    notification.title = "Take a break!"
                    notification.body = body.randomElement()!
                    notification.sound = UNNotificationSound.default
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: nil)
                    UNUserNotificationCenter.current().add(request)
                }
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
                    notificationWindow.backgroundColor = NSColor(red: 48, green: 48, blue: 48, alpha: 0.7)
                }
                
                timer = DispatchSource.makeTimerSource()
                // repeat every minutes
                timer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(60), leeway: DispatchTimeInterval.seconds(5))
                // timer start up
                timer?.setRegistrationHandler(handler: {
                    DispatchQueue.main.async {
                        self.timerData.TimerSecond = 0
                        self.timerData.TimerMinute = 0
                        self.timerData.NMleftTime = 0
                    }
                })
                // timer
                timer?.setEventHandler {
                    self.timerData.TimerMinute += 1
                    self.leftTime = self.worktime - self.timerData.TimerMinute
                    if self.leftTime ?? 0 > 0 {
                        self.statusbarItem?.button?.image = nil
                        self.statusbarItem?.button?.title = "\(String(describing: self.leftTime))min"
                    } else {
                        self.statusbarItem?.button?.image = NSImage(systemSymbolName: "eye.slash.fill", accessibilityDescription: nil)
                    }
                    if self.timerData.TimerMinute == self.worktime {
                        if self.fullscreen {
                            createNotificationView()
                        } else {
                            createNotification()
                        }
                    }
                }
                timer?.activate()
            }
            timerManager()
        }
        pushNotification()
    }
}
