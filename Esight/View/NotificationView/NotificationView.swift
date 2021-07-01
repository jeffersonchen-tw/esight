//
//  NotificationView.swift
//  Esight
//
//  Created by 陳奕利 on 2021/6/26.
//

import SwiftUI


func progressCal(restTimeSecond: Int, workMinute: Int) -> CGFloat {
    var expectedRestTime: Int
    expectedRestTime = (60 - workMinute) * 60
    return CGFloat(restTimeSecond / expectedRestTime)
}

struct NotificationView: View {
    let window: NSWindow?
    // notification type
    @AppStorage(Settings.Twenty_TewntyKey) var twenty_twenty = false
    // timer
    @State var timer = Timer.publish(every: 1, tolerance: 0.3, on: .main, in: .common).autoconnect()
    @State var count = 20
    @State var progress: CGFloat = 1
    @Binding var restSecond: Int
    @State var expectRestSecond: Int = 20
    @AppStorage(Settings.WorkTimeKey) var worktime = 40
    //
    var body: some View {
        VStack {
            Spacer()
            // \\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
            // 20-20-20 rule
            if twenty_twenty {
                Text("LOOK FAR, \n LOOK AWAY 👁")
                    .font(.custom("Helvetica", size: 80))
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                Spacer().frame(height: 40)
                Text("look away at something that is 20 feet away from you")
                    .font(.custom("Didot Italic", size: 40))
                Spacer()
                ZStack {
                    Circle()
                        .trim(from: 0, to: self.progress)
                        .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                        .frame(width: 350, height: 350, alignment: .center)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(-270))
                    Text("\(self.count)")
                        .font(.system(size: 65))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }.onReceive(self.timer) { _ in
                    if self.count != 0 {
                        self.count -= 1
                        withAnimation(.default) {
                            self.progress = CGFloat(self.count) / 20
                        }
                    } else {
                        timer.upstream.connect().cancel()
                        window?.close()
                    }
                }
            } else {
                // normal mode
                Text("Take a long break, or have an shut-eye")
                    .font(.custom("Helvetica", size: 80))
                    .fontWeight(.heavy)
                Spacer()
                ZStack {
                    Circle()
                        .trim(from: 0, to: self.progress)
                        .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                        .frame(width: 350, height: 350, alignment: .center)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(-270))
                    Text("\(self.count)")
                        .font(.system(size: 65))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
              }
            // \\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
            Spacer()
            Button(action: {
                window?.close()
            }, label: {
                Text("Skip")
                    .font(.custom("Helvetica", size: 40))
            })
                .buttonStyle(BorderlessButtonStyle())
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
