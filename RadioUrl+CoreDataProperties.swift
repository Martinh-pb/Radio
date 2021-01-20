//
//  RadioUrl+CoreDataProperties.swift
//  PhonixRadio
//
//  Created by Martin Haisma on 27/07/2020.
//
//

import Foundation
import CoreData


extension RadioUrl {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RadioUrl> {
        return NSFetchRequest<RadioUrl>(entityName: "RadioUrl")
    }

    @NSManaged public var logo: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}

extension RadioUrl : Identifiable {

}
