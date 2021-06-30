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
            Spacer().frame(maxHeight: 25)
            Text("Esight").fontWeight(.heavy).font(.custom("PT Serif", size: 22)).kerning(1.0)
            Divider()
            Spacer().frame(height: 30)
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
                Spacer().frame(height: 25)
                }
                Spacer().frame(height: 25)
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
            Toggle(isOn: $onhold) {
                HStack{
                    Image(systemName: "pause.fill")
                    Text("On Hold")
                }
            }.toggleStyle(CheckboxToggleStyle())
            if onhold {
                Text("Esight won't work untill you dismiss on-hold")
                    .font(.custom("Helvetica",size: 14))
                    .foregroundColor(.red)
                }
            }.padding()
            Spacer()
            Button(action: {
                NSApp.terminate(self)
            }) {
                Text("quit the app")
            }.padding()
        }.frame(width: 300, height: 300, alignment: .top)
    }
}

