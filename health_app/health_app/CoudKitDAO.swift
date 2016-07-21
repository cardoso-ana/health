//
//  CoudKitDAO.swift
//  health_app
//
//  Created by Pedro de Sá on 19/07/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import Foundation
import CloudKit

public class CloudKitDAO {
    
    var ctUsers = [CKRecord]()
    
    
    // Mandando o idoso pra nuvem:
    
    func send2CloudElder(usuario: Elder) {
        print("got hereeeeeeee")
        
        
        let user = CKRecord(recordType: "Elder")
        
        user["name"] = usuario.getElderName()
        user["age"] = usuario.getElderAge()
        user["phone"] = usuario.getElderPhone()
        user["street"] = usuario.getElderStreet()
        user["houseNumber"] = usuario.getElderHouseNumber()
        user["city"] = usuario.getElderCity()
        user["state"] = usuario.getElderState()
        user["careTakerId"] = usuario.getEldercareTakerId()
        
        let publicData = CKContainer.default().publicCloudDatabase
        
        publicData.save(user, completionHandler: { (record: CKRecord?, error: NSError?) in
            if error == nil {
                
                DispatchQueue.main.asynchronously(execute: { () -> Void in
                    print("IDOSO salvo com sucesso\n")
                })
            }
            else {
                print("\nHUEHUEHUEHUE\n")
                print(error?.localizedDescription)
            }
        })
    }
    
    
    
    // Mandando o cuidador pra nuvem:
    
    func send2CloudCaretaker(usuario: Caretaker) {
        print("got hereeeeeeee")
        
        let user = CKRecord(recordType: "Caretaker")
        
        user["id"] = usuario.getId()
        user["elderName"] = usuario.elderName
        user["elderAge"] = usuario.getElderAge()
        user["elderPhone"] = usuario.getElderPhone()
        
        let publicData = CKContainer.default().publicCloudDatabase
        
        publicData.save(user, completionHandler: { (record: CKRecord?, error: NSError?) in
            if error == nil {
                
                DispatchQueue.main.asynchronously(execute: { () -> Void in
                    print("CUIDADOR salvo com sucesso\n")
                })
            }
            else {
                print("\nHUEHUEHUEHUE\n")
                print(error?.localizedDescription)
            }
        })
    }
    
    // Pega o idoso da nuvem:
    
    typealias CompletionHandler = (success:Bool) -> Void
    func loadElderUser(phone: String, completionHandler: CompletionHandler) {
        
        ctUsers = [CKRecord]()
        print("\nO TELEFONE É:\(phone)")
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@", phone)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        //var sucess = true
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                self.ctUsers = users
                print("\nHow many users in cloud: \(self.ctUsers.count)\n")
                if self.ctUsers.count != 0 {
                    //self.aux = false
                    completionHandler(success: false)
                }
                else {
                    //self.aux = true
                    completionHandler(success: true)
                }
            }
        }
    }
    
    
    // Pega o cuidador(AAAAI QUE DELÍCIA) da nuvem:
    
    typealias CompletionHandler2 = (success:Bool) -> Void
    func loadCaretakerUser(phone: String, completionHandler: CompletionHandler2) {
        
        ctUsers = [CKRecord]()
        print("\nO TELEFONE É:\(phone)")
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@", phone)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        //var sucess = true
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                self.ctUsers = users
                print("\nHow many users in cloud: \(self.ctUsers.count)\n")
                if self.ctUsers.count != 0 {
                    //self.aux = false
                    completionHandler(success: false)
                }
                else {
                    //self.aux = true
                    completionHandler(success: true)
                }
            }
        }
    }
    
    func pareamento(phone: String, ctid: String) {
        ctUsers = [CKRecord]()
        print("O TELEFONE É: \(phone)\n")
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "phone == %@", phone)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                self.ctUsers = users
                print("\nHow many users in cloud: \(self.ctUsers.count)\n")
                
                if self.ctUsers.count != 0 {
                    
                    let user =  users.first //CKRecord(recordType: "Elder")
                    user?["careTakerId"] = ctid
                    
                    let publicData = CKContainer.default().publicCloudDatabase
                    publicData.save(user!, completionHandler: { (record: CKRecord?, error: NSError?) in
                        if error == nil {
                            
                            DispatchQueue.main.asynchronously(execute: { () -> Void in
                                print("IDOSO atualizado com sucesso\n")
                            })
                        }
                        else {
                            print("\nHUEHUEHUEHUE\n")
                            print(error?.localizedDescription)
                        }
                    })
                }
                else {
                    print("\nIDOSO NÃO ENCONTRADO NA CLOUD\n")
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    func pegaIdoso(id: String) {
        
        ctUsers = [CKRecord]()
        print("O ID DO CUIDADOR É: \(id)\n")
        
        var nome = ""
        var idade = ""
        var tel = ""
        var rua = ""
        var cidade = ""
        var estado = ""
        var idCuidador = ""
        
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "careTakerId == %@", id)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                
                nome = (users[0].value(forKey: "name") as? String)!
                idade = (users[0].value(forKey: "age") as? String)!
                tel = (users[0].value(forKey: "phone") as? String)!
                rua = (users[0].value(forKey: "street") as? String)!
                cidade = (users[0].value(forKey: "city") as? String)!
                estado = (users[0].value(forKey: "state") as? String)!
                idCuidador = (users[0].value(forKey: "careTakerId") as? String)!
                
                let myDict = [ "name": nome, "age":idade, "phone" : tel, "street" : rua, "city" : cidade, "state" : estado, "careTakerId" : idCuidador]
                
                
                print("\n PRINTAANDO O NOME DO pegaIdoso: \(nome)\n")
                
                NotificationCenter.default.post(name: "véioChegando" as NSNotification.Name, object: myDict)
                
            }
        }
    }
    
    func verificaPareamento() {
        
        ctUsers = [CKRecord]()
        
        let publicData = CKContainer.default().publicCloudDatabase
        let predicate = Predicate(format: "careTakerId != nil")
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        publicData.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: NSError?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let users = results {
                
            }
        }
    }
    
    
}
