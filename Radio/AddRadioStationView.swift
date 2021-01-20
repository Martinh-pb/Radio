//
//  AddRadioStationView.swift
//  PhonixRadio
//
//  Created by Martin Haisma on 27/07/2020.
//

import SwiftUI

struct AddRadioStationView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title:String = ""
    @State private var url:String = ""
    @State private var radioUrl:RadioUrl? = nil
    
    var body: some View {
        NavigationView {
            Form{
                Section {
                    TextField("Title", text: $title)
                    TextField("Url", text: $url)
                }
                Button("Add radio station") {
                    if (self.radioUrl == nil) {
                        self.radioUrl = RadioUrl(context: self.managedObjectContext)
                    }
                    self.radioUrl?.title = self.title
                    self.radioUrl?.url = self.url.trimmingCharacters(in: CharacterSet(charactersIn: " "))
                    self.radioUrl?.logo = ""
                    
                    do {
                        try self.managedObjectContext.save()
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print ("failed to save: \(error.localizedDescription)")
                    }
                }
            }
            .navigationTitle("New radio station")
        }
    }
    
}

struct AddRadioStationView_Previews: PreviewProvider {
    static var previews: some View {
        AddRadioStationView()
    }
}
