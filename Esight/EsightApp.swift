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
            ContentView(setStatus: appdelegate.setStatusTitle)
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
    var leftTime: Int = 0
    // timer
    var timer: DispatchSourceTimer!
    var viewTimer: DispatchSourceTimer!
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
    
    // status bar icon & title
    func setStatusTitle() {
        leftTime = worktime - timerData.TimerMinute
        if (leftTime == 0) || (self.timerData.onHold) {
            statusbarItem?.button?.image = NSImage(systemSymbolName: "eye.slash.fill", accessibilityDescription: nil)
        } else {
            statusbarItem?.button?.image = nil
            statusbarItem?.button?.title = "\(leftTime)min"
        }
    }

    @objc func sleepListener(_: Notification) {
        self.timerData.Reset()
        self.setStatusTitle()
        if self.notificationWindow.isVisible {
            self.notificationWindow.close()
        }
    }

    func applicationDidFinishLaunching(_: Notification) {
        //
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        //
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(sleepListener(_:)), name: NSWorkspace.didWakeNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(sleepListener(_:)), name: NSWorkspace.screensDidWakeNotification, object: nil)
        //
        timerData = AppTimer()
        func createMenuBarView() {
            let menuBar = MenuBar(setStatusFunc: self.setStatusTitle, Timer: timer, timerData: timerData)
            popOver.behavior = .transient
            popOver.animates = true
            popOver.contentViewController = NSViewController()
            popOver.contentViewController?.view = NSHostingView(rootView: menuBar)
            // create menu-bar button
            statusbarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusbarItem?.button?.action = #selector(togglePopover)
        }
        createMenuBarView()
        //
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
                // close Notification View
                func closeNotificationView() {
                    notificationWindow.close()
                    timerData.Reset()
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
                    notificationWindow.contentView = NSHostingView(rootView: NotificationView(setStatusFunc: {
                        self.leftTime = self.worktime - self.timerData.TimerMinute
                        if self.leftTime != 0 {
                            self.statusbarItem?.button?.image = nil
                            self.statusbarItem?.button?.title = "\(self.leftTime)min"
                        } else {
                            self.statusbarItem?.button?.image = NSImage(systemSymbolName: "eye.slash.fill", accessibilityDescription: nil)
                        }
                    }, window: notificationWindow, timerData: self.timerData))
                    notificationWindow.isOpaque = true
                    notificationWindow.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                    NSSound.beep()
                }

                timer = DispatchSource.makeTimerSource()
                viewTimer = DispatchSource.makeTimerSource()
                // repeat every minutes
                timer?.schedule(deadline: DispatchTime.now() + 60, repeating: DispatchTimeInterval.seconds(60), leeway: DispatchTimeInterval.seconds(5))
                // timer start up
                timer?.setRegistrationHandler(handler: {
                    DispatchQueue.main.async {
                        if self.twenty_twenty {
                            self.worktime = 20
                        }
//                        self.timerData.TimerMinute = 19
                        self.setStatusTitle()
                    }
                })
                // timer event
                timer?.setEventHandler {
                    DispatchQueue.main.async { [self] in

                        if self.twenty_twenty {
                            self.worktime = 20
                        }

                        self.timerData.TimerMinute += 1

                        self.setStatusTitle()

                        if (self.timerData.TimerMinute >= self.worktime) && !self.twenty_twenty {
                            self.timerData.NMleftTime = 60 - self.timerData.TimerMinute
                            self.timerData.NMprogress = 1 - CGFloat((self.timerData.TimerMinute - self.worktime) / (60 - self.worktime))
                        }

                        // show notification
                        if self.timerData.TimerMinute == self.worktime {
                            if self.fullscreen {
                                createNotificationView()
                            } else {
                                createNotification()
                                self.setStatusTitle()
                            }
                        }
                        // close notification window
                        if self.notificationWindow != nil && self.timerData.TimerMinute == 60 {
                            NSSound.beep()
                            closeNotificationView()
                            self.setStatusTitle()
                        }

                        if self.twenty_twenty && (self.timerData.TimerMinute == 20) {
                            viewTimer.schedule(deadline: DispatchTime.now() + 1, repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.seconds(1))
                            viewTimer.setRegistrationHandler(handler: {
                                DispatchQueue.main.async {
                                    self.timer.suspend()
                                }
                            })
                            viewTimer.setEventHandler(handler: {
                                DispatchQueue.main.async {
                                    self.timerData.TimerSecond += 1
                                    if self.timerData.TimerSecond > 20 {
                                        if self.notificationWindow != nil {
                                            NSSound.beep()
                                            closeNotificationView()
                                        }
                                        self.timerData.Reset()
                                        self.setStatusTitle()
                                        self.timer.resume()
                                        self.viewTimer.cancel()
                                    }
                                }
                            })
                            viewTimer.activate()
                        }
                    }
                }
                // timer event end
                timer?.activate()
            }
            timerManager()
        }
        pushNotification()
    }
}
