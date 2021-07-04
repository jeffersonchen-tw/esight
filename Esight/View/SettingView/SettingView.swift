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
    @Binding var selected: Int
    // app setting data
    @AppStorage(Settings.Twenty_TewntyKey) var twenty_twenty = false
    @AppStorage(Settings.WorkTimeKey) var worktime = 40
    @AppStorage(Settings.FullScreenKey) var fullscreen = true
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
                Spacer().frame(height: 40)
                Toggle(isOn: $fullscreen) {
                    Text("By default, the app enable pop-up windows. \n Uncheck to use notification mode").font(.custom("Helvetica", size: 22))
                }.toggleStyle(CheckboxToggleStyle())
                if !fullscreen {
                    Button("grant permission") {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
                            _, _ in
                        }
                    }.offset(x: 30)
                }
                Spacer().frame(height: 40)
                Toggle(isOn: $twenty_twenty) {
                    Text("20-20-20 Rule").font(.custom("Helvetica", size: 22))
                }.toggleStyle(CheckboxToggleStyle())
                Spacer().frame(height: 20)
                if !twenty_twenty {
                    HStack {
                        Picker("work", selection: $worktime) {
                            ForEach(worktimeList, id: \.self) { Text("\($0)")
                            }
                        }.frame(width: 130)
                        Text("minute per hour")
                    }.offset(x: 50)
                }
            }
            Spacer()
        }
    }
}
