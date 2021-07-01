//
//  menubar.swift
//  eyes
//
//  Created by 陳奕利 on 2021/6/19.
//

import SwiftUI
import UserNotifications

struct MenuBar: View {
    // app setting data
    @AppStorage(Settings.Twenty_TewntyKey) var twenty_twenty = false
    @AppStorage(Settings.WorkTimeKey) var worktime = 40
    @AppStorage(Settings.FullScreenKey) var fullscreen = true
    @AppStorage(Settings.OnHold) var onhold = false
    //
    var body: some View {
        VStack {
            Spacer().frame(minHeight: 8)
            Text("Esight").fontWeight(.heavy).font(.custom("PT Serif", size: 22)).kerning(1.0)
            Divider()
            VStack(alignment: .leading) {
            Picker("Mode", selection: $fullscreen) {
                Text("fullscreen pop-up").font(.custom("Helvetica",size: 14)).tag(true)
                Text("notification").font(.custom("Helvetica",size: 14)).tag(false)
            }.frame(width: 180)
                if !fullscreen {
                    Button("grant permission") {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) {
                            success, error in
                            if success {
                                print("success")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }.offset(x: 50)
                Spacer().frame(minHeight: 20)
                }
                Spacer().frame(minHeight: 20)
                Toggle(isOn: $twenty_twenty) {
                    Text("20-20-20 Rule").font(.custom("Helvetica",size: 14))
                       }.toggleStyle(CheckboxToggleStyle())
            Spacer().frame(height: 15)
            if !twenty_twenty {
                HStack {
                    Stepper(onIncrement: {
                        if worktime < 50 {
                            worktime+=5
                        }
                    }, onDecrement: {
                        if worktime > 20 {
                            worktime-=5
                        }
                    }) {
                        Text("work \($worktime.wrappedValue)")
                    }
                    Text("minutes per hour")
                }.offset(x: 20)
            }
            Divider()
                Button(action: {onhold.toggle()}) {
                    HStack {
                        Image(systemName: $onhold.wrappedValue ? "play.fill": "pause.fill")
                        Text($onhold.wrappedValue ? "enable Esight": "On Hold")
                    }
                }
            }.padding(8)
            if onhold {
                Text("Esight won't work untill you dismiss on-hold")
                    .font(.custom("Helvetica",size: 12))
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                }
            Button(action: {
                NSApp.terminate(self)
            }) {
                Text("quit the app")
            }.padding(.bottom, 5)
        }.frame(width: 300, height: 300, alignment: .top)
    }
}

