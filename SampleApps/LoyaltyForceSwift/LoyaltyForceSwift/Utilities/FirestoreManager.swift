//
//  FirestoreManager.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/18/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager {
    
    static func addMemberData(member: MemberModel) throws {
        
        let db = Firestore.firestore()

        do {
            try db.collection("members").document(member.email).setData(from: member)
        } catch let error {
            print("Error writing member info to Firestore: \(error)")
            throw error
        }

    }

    static func getMemberData(by email: String) async throws -> MemberModel {

        let db = Firestore.firestore()

        do {
            return try await db.collection("members").document(email).getDocument(as: MemberModel.self)
        } catch {
            throw error
        }

    }
}
