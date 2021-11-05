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
    
    /* TODO: Events getter */
    
    func getEvents() -> [SOCEvent] {
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
            }
        }
        return events
    }
}
