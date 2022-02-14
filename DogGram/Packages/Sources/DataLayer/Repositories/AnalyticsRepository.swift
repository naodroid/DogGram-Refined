//
//  AnalyticsRepository.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation
import FirebaseAnalytics

public protocol AnalyticsRepository {
    func likePostDoubleTap() async
    func likePostHeartPressed() async
}

public actor AnalyticsRepositoryImpl: AnalyticsRepository {
    public func likePostDoubleTap() async {
        Analytics.logEvent("like_double_tap", parameters: nil)
    }
    public func likePostHeartPressed() async {
        Analytics.logEvent("like_heart_pressed", parameters: nil)
    }
}
