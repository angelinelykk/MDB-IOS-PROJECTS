//
//  AuthManager.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SOCAuthManager {
    
    static let shared = SOCAuthManager()
    
    let auth = Auth.auth()
    
    enum SignInErrors: Error {
        case wrongPassword
        case userNotFound
        case invalidEmail
        case internalError
        case errorFetchingUserDoc
        case errorDecodingUserDoc
        case unspecified
        case emailInUse
        case weakPassword
        case passwordsMismatch
        case missingInput
    }
    
    let db = Firestore.firestore()
    
    var currentUser: SOCUser?
    
    private var userListener: ListenerRegistration?
    
    init() {
        guard let user = auth.currentUser else { return }
        
        linkUser(withuid: user.uid, completion: nil)
    }
    
    func signIn(withEmail email: String, password: String,
                completion: ((Result<SOCUser, SignInErrors>)->Void)?) {
        
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let nsError = error as NSError
                let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
                
                switch errorCode {
                case .wrongPassword:
                    completion?(.failure(.wrongPassword))
                case .userNotFound:
                    completion?(.failure(.userNotFound))
                case .invalidEmail:
                    completion?(.failure(.invalidEmail))
                default:
                    completion?(.failure(.unspecified))
                }
                return
            }
            guard let authResult = authResult else {
                completion?(.failure(.internalError))
                return
            }
            
            self?.linkUser(withuid: authResult.user.uid, completion: completion)
        }
    }
    
    
    func signup(givenName: String, givenEmail: String, givenUsername: String, givenPassword: String, secondPassword: String, completion: ((Result<SOCUser, SignInErrors>)->Void)?) {
        if (givenPassword != secondPassword) {
            // display error banner that it does not match
            completion?(.failure(.passwordsMismatch))
            return
        }
        if (givenName == "" || givenEmail == "" || givenUsername == "" || givenPassword == "" || secondPassword == "") {
            completion?(.failure(.missingInput))
            return
        } else {
            // signup user - register user with Firebase Auth and then use the uid returned from Firebase Auth to write user information to Cloud Firestore
            auth.createUser(withEmail: givenEmail, password: givenPassword) {
                [weak self] authResult, error in
                
                guard let user = authResult?.user, error == nil else {
                    // display errors
                    if let error = error {
                        // support errors - email in use, weak password, passwords don't match and missing input fields
                        let nsError = error as NSError
                        let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
                        
                        switch errorCode {
                        case .emailAlreadyInUse:
                            completion?(.failure(.emailInUse))
                        case .weakPassword:
                            completion?(.failure(.weakPassword))
                        default:
                            completion?(.failure(.unspecified))
                        }
                        return
                    }
                    return
                }
                
                guard let authResult = authResult else {
                    completion?(.failure(.internalError))
                    return
                }
                
                // add user to firestore
                let newUser = SOCUser(uid: user.uid, username: givenUsername, email: givenEmail, fullname: givenName, savedEvents: [])
                
                self!.auth.signIn(withEmail: givenEmail, password: givenPassword) { [weak self] authResult, error in
                    if let error = error {
                        let nsError = error as NSError
                        let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
                        
                        switch errorCode {
                        case .wrongPassword:
                            completion?(.failure(.wrongPassword))
                        case .userNotFound:
                            completion?(.failure(.userNotFound))
                        case .invalidEmail:
                            completion?(.failure(.invalidEmail))
                        default:
                            completion?(.failure(.unspecified))
                        }
                        return
                    }
                    guard let authResult = authResult else {
                        completion?(.failure(.internalError))
                        return
                    }
                    
                    self?.linkUser(withuid: authResult.user.uid, completion: completion)
                    FIRDatabaseRequest.shared.setUser(newUser, completion: nil)
                }
                
                completion?(.success(newUser))
//
            }
            // redirect to feednavigation VC - to be done in SignupVC
            
        }
    }
    
    func isSignedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    func signOut(completion: (()->Void)? = nil) {
        do {
            try auth.signOut()
            unlinkCurrentUser()
            completion?()
        } catch { }
    }
    
    private func linkUser(withuid uid: String,
                          completion: ((Result<SOCUser, SignInErrors>)->Void)?) {
        
        userListener = db.collection("users").document(uid).addSnapshotListener { [weak self] docSnapshot, error in
            guard let document = docSnapshot else {
                completion?(.failure(.errorFetchingUserDoc))
                return
            }
            guard let user = try? document.data(as: SOCUser.self) else {
                completion?(.failure(.errorDecodingUserDoc))
                return
            }
            
            self?.currentUser = user
            completion?(.success(user))
        }
    }
    
    private func unlinkCurrentUser() {
        userListener?.remove()
        currentUser = nil
    }
}
