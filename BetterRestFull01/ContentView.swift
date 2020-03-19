//
//  ContentView.swift
//  BetterRestFull01
//
//  Created by Viettasc Doan on 3/19/20.
//  Copyright © 2020 Viettasc Doan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    static var time: Date {
        var components = DateComponents()
        components.hour = 5
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var tyemtee: (wake: Date, sleep: Double, tea: Int, title: String, message: String, alert: Bool) = (time, 8, 1, "", "", false)
    
    var body: some View {
        NavigationView {
            Form {
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 200)
                    Image("11")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(lineWidth: 3).foregroundColor(.pink))
                        .frame(width: 200, height: 200)
                }
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $tyemtee.wake, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                }
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $tyemtee.sleep, in: 4...12, step: 0.25) {
                        Text("\(tyemtee.sleep, specifier: "%g") hours")
                    }
                }
                Section(header: Text("Daily coffee intake")) {
                    Stepper(value: $tyemtee.tea, in: 1...20) {
                        Text("\(tyemtee.tea) cups")
                    }
                }
            }
            .navigationBarTitle("Tyemtee")
            .navigationBarItems(trailing:
                Button(action: calculate) {
                    Text("Calculate")
                }
            )
                .alert(isPresented: $tyemtee.alert) {
                    Alert(title: Text(tyemtee.title), message: Text(tyemtee.message), dismissButton: .default(Text("OK")))
            }
        }
        .foregroundColor(Color.pink.opacity(0.6))
    }
    
    func calculate() {
        let model = RandomForest()
        let components = Calendar.current.dateComponents([.hour, .minute], from: tyemtee.wake)
        let hour = (components.hour ?? 0) * 360
        let minute = (components.minute ?? 0) * 60
        let seconds = Double(hour + minute)
        do {
            let prediction = try model.prediction(wake: seconds, estimatedSleep: Double(tyemtee.sleep), coffee: Double(tyemtee.tea))
            let time = tyemtee.wake - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            tyemtee.title = "Your ideal bedtime is ..."
            tyemtee.message = formatter.string(from: time)
            
        } catch {
            tyemtee.title = "Unexpected."
            tyemtee.message = "Something is not right!"
        }
        tyemtee.alert = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
