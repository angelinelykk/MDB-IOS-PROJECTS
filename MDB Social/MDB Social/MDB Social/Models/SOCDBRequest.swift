//
//  SOCDBRequest.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseFirestore

class FIRDatabaseRequest {
    
    static let shared = FIRDatabaseRequest()
    
    let db = Firestore.firestore()
    
    func setUser(_ user: SOCUser, completion: (()->Void)?) {
        guard let uid = user.uid else { return }
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion?()
        }
        catch { }
    }
    
    
    func setEvent(_ event: SOCEvent, completion: (()->Void)?) {
        guard let id = event.id else { return }
        
        do {
            try db.collection("events").document(id).setData(from: event)
            completion?()
        } catch { }
    }
    
    func getUser(uid: String, completion: @escaping ((SOCUser)->())) {
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            let result = Result {
                  try document?.data(as: SOCUser.self)
            }
            switch result {
                case .success(let user):
                    if let user = user {
                        // A `City` value was successfully initialized from the DocumentSnapshot.
                        completion(user)
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot,
                        // or the DocumentSnapshot was nil.
                        print("Document does not exist")
                    }
                case .failure(let error):
                    // A `City` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding user: \(error)")
                }
        }
    }
    
    /* TODO: Events getter */
    
    func getEvents(completion: @escaping (([SOCEvent])->())) {
        var events: [SOCEvent] = []
        let snapshot = db.collection("events").getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("error getting documents")
            } else {
                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: SOCEvent.self)
                    }
                    switch result {
                    case .success(let event):
                        if let event = event {
                            events.append(event)
                            print("Event: \(event)")
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding event: \(error)")
                    }
                }
                completion(self.sortEvents(events: events))
            }
        }
    }
    
    private func sortEvents(events: [SOCEvent]) -> [SOCEvent] {
        var sortedDate = events.sorted { $0.startDate >= $1.startDate}
        return sortedDate
    }
}
