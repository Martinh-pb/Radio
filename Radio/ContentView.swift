//
//  ContentView.swift
//  PhonixRadio
//
//  Created by Martin Haisma on 17/07/2020.
//

import SwiftUI

struct ContentView: View, SelectedDelegate {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: RadioUrl.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \RadioUrl.title, ascending: true)]) var radioUrls: FetchedResults<RadioUrl>
    
    @State private var showingAddRadioStation = false
    @State private var selectedRadioStation:RadioUrl? = nil
    
    @ObservedObject private var player:AudioStream = AudioStream()
    
    func setSelected(for radioUrl: RadioUrl) {
        self.selectedRadioStation = radioUrl
    }
    
    var body: some View {
        NavigationView{
            VStack {
                GeometryReader { geometry in
                    List() {
                        ForEach(radioUrls, id:\.self) { radioUrl in
                            RadioCard(radioUrl: radioUrl, selectedDelegate: self, isSelected: radioUrl.title == selectedRadioStation?.title ?? "" )
                                .frame(width: geometry.size.width,
                                       alignment: .leading)
                                .listRowInsets(.init())
                                
                        }
                        .onDelete(perform: deleteRadioStation)
                    }
                }
                Text(self.player.metadata).italic().padding(.bottom)
                /*
                Button(action: {
                    if (self.player.isPlaying) {
                        self.player.pause()
                    }
                    else {
                        if (self.selectedRadioStation != nil) {
                            let u:String = self.selectedRadioStation?.url ?? ""
    
                            if (u.count > 0) {
                                //let radioUrl:URL = URL(string: u)!
    
                                self.player.play(radioUrl: self.selectedRadioStation!)
                            }
                        }
                    }
                })
                {
                    Image(systemName: "play").renderingMode(.original)
                    //Image(self.player.isPlaying ? "pause" : "play").renderingMode(.original)
                }
                */
            }
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    Button(action: {self.showingAddRadioStation.toggle()}) {
                        Image(systemName: "plus")
                    }
            )
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        if (self.player.isPlaying) {
                            self.player.pause()
                        }
                        else {
                            if (self.selectedRadioStation != nil) {
                                let u:String = self.selectedRadioStation?.url ?? ""
        
                                if (u.count > 0) {
                                    //let radioUrl:URL = URL(string: u)!
        
                                    self.player.play(radioUrl: self.selectedRadioStation!)
                                }
                            }
                        }
                    }) {
                        Image(systemName: self.player.isPlaying ? "pause.fill" : "play.fill").imageScale(.large)
                    }.padding()
                }
            }
            
        }
        .sheet(isPresented: $showingAddRadioStation) {
                    AddRadioStationView().environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
    
    func deleteRadioStation(at offsets:IndexSet) {
        for index in offsets {
            let radioUrl = radioUrls[index]
            
            if self.selectedRadioStation != nil && self.selectedRadioStation == radioUrl {
                self.player.pause()
                self.selectedRadioStation = nil;
            }
            
            managedObjectContext.delete(radioUrl)
        }
        do {
            try managedObjectContext.save()
        } catch {
            print ("Unable to delete: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
