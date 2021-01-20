//
//  RadioCard.swift
//  PhonixRadio
//
//  Created by Martin Haisma on 27/07/2020.
//

import SwiftUI
import CoreData

protocol SelectedDelegate {
    func setSelected(for radioUrl:RadioUrl)
}

struct RadioCard: View {
    var radioUrl:RadioUrl
    var selectedDelegate:SelectedDelegate?
    var isSelected:Bool = false
    
    var body: some View {
        HStack{
            Text(radioUrl.title ?? "").frame(minWidth:0, maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            Spacer()
        }
        .contentShape(Rectangle())
        .foregroundColor(self.isSelected ? Color.orange : nil)
        .onTapGesture(count: 1, perform: {
            if (selectedDelegate != nil) {
                selectedDelegate?.setSelected(for: self.radioUrl)
            }
        })
    }
}

struct RadioCard_Previews: PreviewProvider {
    static var previews: some View {
        let radioUrl = RadioUrl(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        
        RadioCard(radioUrl: radioUrl, selectedDelegate: nil, isSelected: false)
    }
}
