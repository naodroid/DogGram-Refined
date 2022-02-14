//
//  FeedbackRepository.swift
//  DogGram
//
//  Created by nao on 2022/02/13.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol FeedbackRepository {
    // Profile
    func postFeedback(email: String?, message: String) async throws
}

public actor FeedbackRepositoryImpl: FeedbackRepository {
    private static let firestore = Firestore.firestore()
    private let feedbacksRef = FeedbackRepositoryImpl.firestore.collection("feedbacks")
    
    public nonisolated init() {
    }
    
    public func postFeedback(email: String?, message: String) async throws {
        let feedback = Feedback(id: nil, email: email, message: message, dateCreated: nil)
        _ = try feedbacksRef.addDocument(from: feedback)
    }
}
