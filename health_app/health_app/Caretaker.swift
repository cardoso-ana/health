//
//  Caretaker.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import Foundation

public class Caretaker {
    
    static let singleton = Caretaker()
    
    var id = ""
    var elderName = ""
    var elderAge = 0
    var elderPhone = ""
    
    
    private init() {
        
    }
    
    func getElderName() -> String {
        return elderName
    }
    
    func setElderName(name: String) {
        self.elderName = name
    }
    
    
    func getId() -> String {
        return id
    }
    
    func setId(id: String) {
        self.id = id
    }
    
    
    func getElderAge() -> Int {
        return elderAge
    }
    
    func setElderAge(age: Int) {
        self.elderAge = age
    }
    
    
    func getElderPhone() -> String {
        return elderPhone
    }
    
    func setElderPhone(phone: String) {
        self.elderPhone = phone
    }
    
    
}
