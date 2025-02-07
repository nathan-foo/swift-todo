//
//  ContentView.swift
//  Tasks
//
//  Created by Nathan Foo on 2/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ToDo.isCompleted) private var toDos: [ToDo]
    
    @State private var isAlertShowing = false
    @State private var toDoTitle = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(toDos) { toDo in
                    HStack {
                        Button {
                            toDo.isCompleted.toggle()
                        } label: {
                            Image(systemName: toDo.isCompleted ? "checkmark.circle.fill" : "circle")
                        }
                        
                        Text(toDo.title)
                    }
                }
                .onDelete(perform: deleteToDos)
            }
            .navigationTitle("To-do App")
            .toolbar {
                Button {
                    isAlertShowing.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .alert("Add To-do", isPresented: $isAlertShowing) {
                TextField("Enter To-do", text: $toDoTitle)
                
                Button {
                    modelContext.insert(ToDo(title: toDoTitle, isCompleted: false))
                    toDoTitle = ""
                } label: {
                    Text("Add")
                }
            }
            .overlay {
                if toDos.isEmpty {
                    ContentUnavailableView("Nothing to do here.", systemImage: "checkmark.circle.fill")
                }
            }
        }
    }
    
    func deleteToDos(_ indexSet: IndexSet) {
        for index in indexSet {
            let toDo = toDos[index]
            modelContext.delete(toDo)
        }
    }
}

#Preview {
    ContentView()
}
