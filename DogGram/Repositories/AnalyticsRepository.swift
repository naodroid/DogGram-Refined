//
//  AnalyticsRepository.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation
import FirebaseAnalytics

protocol AnalyticsRepository {
    func likePostDoubleTap() async
    func likePostHeartPressed() async
}

actor AnalyticsRepositoryImpl: AnalyticsRepository {
    func likePostDoubleTap() async {
        Analytics.logEvent("like_double_tap", parameters: nil)
    }
    func likePostHeartPressed() async {
        Analytics.logEvent("like_heart_pressed", parameters: nil)
    }
}
