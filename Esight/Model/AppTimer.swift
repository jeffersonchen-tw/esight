//
//  AppTimer.swift
//  Esight
//
//  Created by 陳奕利 on 2021/7/2.
//

import SwiftUI

class AppTimer: ObservableObject {
    @Published var TimerSecond: Int = 0
    @Published var TimerMinute: Int = 0
    @Published var NMleftTime: Int = 0
}
