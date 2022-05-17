//
//  Watch.swift
//  Film Sepeti
//
//  Created by mert can çifter on 10.05.2022.
//

import Foundation
import CoreData

@objc(Watch)

public class Watch: NSManagedObject {
    
}

extension Watch {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Watch> {
        return NSFetchRequest<Watch>(entityName: "Watch")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var link: String?
    @NSManaged public var date: Date?
    
}
