//
//  NotificationView.swift
//  Esight
//
//  Created by 陳奕利 on 2021/6/26.
//

import SwiftUI

struct NotificationView: View {
    //
    var setStatusFunc: () -> Void
    let window: NSWindow?
    @AppStorage(Settings.WorkTimeKey) var worktime = 40
    @AppStorage(Settings.Twenty_TewntyKey) var twenty_twenty = false
    @StateObject var timerData: AppTimer
    //
    var body: some View {
        VStack {
            Spacer()
            if !twenty_twenty {
                // normal mode
                Text("Take a long break,\n or have an eye-shut")
                    .font(.custom("Helvetica", size: 80))
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                // 20-20-20 mode
                Text("LOOK FAR, \n LOOK AWAY 👁")
                    .font(.custom("Helvetica", size: 80))
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                Spacer().frame(height: 40)
                Text("look away at something that is 20 feet away from you")
                    .font(.custom("Didot Italic", size: 40))
                Spacer()
            }
            ZStack {
                if !twenty_twenty {
                    // normal mode
                    ZStack {
                        Circle()
                            .trim(from: 0, to: self.timerData.NMprogress
                            )
                            .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                            .frame(width: 350, height: 350, alignment: .center)
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(-270))
                        VStack {
                            //
                            if self.timerData.NMleftTime != 1 {
                                // show minute
                                Text("\(self.timerData.NMleftTime)")
                                    .font(.system(size: 60))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("min").font(.system(size: 30))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            } else {
                                Text("One Minute left \n Get ready to work")
                                    .font(.system(size: 45))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                } else {
                    // 20-20-20 mode
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 1 - CGFloat(self.timerData.TimerSecond) / 20)
                            .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                            .frame(width: 350, height: 350, alignment: .center)
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(-270))
                        Text("\(20 - self.timerData.TimerSecond)")
                            .font(.system(size: 65))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            // \\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
            Spacer()
            Button(action: {
                self.timerData.Reset()
                setStatusFunc()
                window?.close()
            }, label: {
                Text("Skip")
                    .foregroundColor(.orange)
                    .font(.custom("Helvetica", size: 40))
                    .fontWeight(.bold)
            })
                .buttonStyle(BorderlessButtonStyle())
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
