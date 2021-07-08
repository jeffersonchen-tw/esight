//
//  SwiftUIView.swift
//  eyes
//
//  Created by 陳奕利 on 2021/6/22.
//

import LaunchAtLogin
import SwiftUI
import UserNotifications

struct SettingView: View {
    // view index
    var setStatusFunc: () -> Void
    @Binding var selected: Int
    // app setting data
    @AppStorage(Settings.Twenty_TewntyKey) var twenty_twenty = false
    @AppStorage(Settings.WorkTimeKey) var worktime = 40
    @AppStorage(Settings.FullScreenKey) var fullscreen = true
    //
    @AppStorage(Settings.NMworktimeKey) var nmworktime = 40
    //
    @AppStorage(Settings.NotificationPermitKey) var notificationpermit = false
    //
    @ObservedObject private var launchAtLogin = LaunchAtLogin.observable

    var worktimeList = [20, 25, 30, 35, 40, 45, 50]

    var body: some View {
        VStack {
            Spacer().frame(maxHeight: 10)
            HStack(alignment: .center) {
                Image(systemName: "gearshape.2.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 35)
                Text("Settings").font(.custom("Helvetica", size: 35)).fontWeight(.heavy)
            }
            Spacer().frame(maxHeight: 90)
            VStack(alignment: .leading) {
                Toggle("Launch at login", isOn: $launchAtLogin.isEnabled).font(.custom("Helvetica", size: 22))
                    .padding(5)
                Spacer().frame(height: 40)
                Toggle(isOn: $fullscreen) {
                    Text("By default, the app enable fullscreen notification. \n Uncheck to use notification of notification center.").font(.custom("Helvetica", size: 22))
                        .lineSpacing(10)
                        .padding(5)
                }.toggleStyle(CheckboxToggleStyle())
                if !self.fullscreen && !self.notificationpermit {
                    Button("grant permission") {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
                            success, _ in
                            if success {
                                self.notificationpermit = true
                            } else {
                                self.notificationpermit = false
                            }
                        }
                    }.offset(x: 30)
                }
                Spacer().frame(height: 40)
                Toggle(isOn: $twenty_twenty) {
                    Text("20-20-20 Rule").font(.custom("Helvetica", size: 22))
                        .padding(5)
                }.onReceive([self.twenty_twenty].publisher.first()) { (value) in
                    if value {
                        self.worktime = 20
                    } else {
                        self.worktime = self.nmworktime
                    }
                }
                .toggleStyle(CheckboxToggleStyle())
                Spacer().frame(height: 20)
                if !twenty_twenty {
                    HStack {
                        Stepper(onIncrement: {
                            if self.nmworktime < 50 {
                                self.nmworktime += 5
                            }
                        }, onDecrement: {
                            if self.nmworktime > 20 {
                                self.nmworktime -= 5
                            }
                        }) {
                            Text("work \(self.$nmworktime.wrappedValue)")
                        }.onReceive([self.nmworktime].publisher.first()) { _ in
                            self.worktime = self.nmworktime
                            setStatusFunc()
                        }
                        Text("minute per hour")
                    }.offset(x: 50)
                }
            }
            Spacer()
        }
    }
}
