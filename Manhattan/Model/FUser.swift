//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FUser: NSObject {
    
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    var profilePic: String
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, profilePic: String, completion: @escaping (Bool, String) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                //user?.sendEmailVerification(completion: nil)
                let values = ["name": withName, "email": email, "profilePicLink": profilePic]
                Database.database().reference().child("users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                    if errr == nil {
                        //let userInfo = ["email" : email, "password" : password]
                        //UserDefaults.standard.set(userInfo, forKey: "userInformation")
                        completion(true, "")
                    }
                })
            }
            else {
                completion(false, (error?.localizedDescription)!)
            }
        })
    }
    
   class func loginUser(withEmail: String, password: String, completion: @escaping (Bool, String) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                //let userInfo = ["email": withEmail, "password": password]
                //UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true, "")
            } else {
                completion(false, (error?.localizedDescription)!)
            }
        })
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            //UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    class func updateProfile(name: String, email: String, password: String, profilePic: String, completion: @escaping (Bool, String) -> Swift.Void) {
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if error != nil {
                completion(false, (error?.localizedDescription)!)
            } else {
                Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
                    if error != nil {
                        completion(false, (error?.localizedDescription)!)
                    } else {
                        let user = Auth.auth().currentUser
                        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                        
                        user?.reauthenticate(with: credential) { (error) in
                            if error != nil {
                                completion(false, (error?.localizedDescription)!)
                            } else {
                                let values = ["name": name, "email": email, "profilePicLink": profilePic]
                                Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                                    if errr == nil {
                                        //let userInfo = ["email" : email, "password" : password]
                                        //UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                        completion(true, "")
                                    }
                                })
                            }
                        }
                    }
                })
            }
        })
        
    }
    
    class func info(forUserID: String, completion: @escaping (FUser) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let link = data["profilePicLink"]!
                
                let user = FUser.init(name: name, email: email, id: forUserID, profilePic: link)
                completion(user)
                
            }
        })
    }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (FUser) -> Swift.Void) {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != exceptID {
                let name = credentials["name"]!
                let email = credentials["email"]!
                let link = credentials["profilePicLink"]!
                
                let user = FUser.init(name: name, email: email, id: id, profilePic: link)
                completion(user)
            }
        })
    }
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })
    }

    
    //MARK: Inits
    init(name: String, email: String, id: String, profilePic: String) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
    }
}

