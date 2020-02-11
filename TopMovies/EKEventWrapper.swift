//
//  EKEventWrapper.swift
//  TopMovies
//
//  Created by Никита on 10.02.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import Foundation
import SwiftUI
import EventKitUI

let eventStore = EKEventStore()

struct EKEventWrapper: UIViewControllerRepresentable {

    typealias UIViewControllerType = EKEventEditViewController

    @Binding var isShowing: Bool

    var theEvent = EKEvent.init(eventStore: eventStore)

    func makeUIViewController(context: UIViewControllerRepresentableContext<EKEventWrapper>) -> EKEventEditViewController {
        
        let calendar = EKCalendar.init(for: .event, eventStore: eventStore)

        theEvent.startDate = Date()
        theEvent.endDate = Date()
        theEvent.title = "Movie"
        theEvent.calendar = calendar

        let controller = EKEventEditViewController()
//        let controller = UIViewControllerType()
        controller.event = theEvent
        controller.eventStore = eventStore
        controller.editViewDelegate = context.coordinator

        return controller
    }

    func updateUIViewController(_ uiViewController: EKEventWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<EKEventWrapper>) {
        //
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing)
    }

    class Coordinator : NSObject, UINavigationControllerDelegate, EKEventEditViewDelegate {

        @Binding var isShowing: Bool

        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            switch action {
            case .canceled:
                print("Canceled")
                isShowing = false
            case .saved:
                print("Saved")
                do {
                    try controller.eventStore.save(controller.event!, span: .thisEvent, commit: true)
                }
                catch {
                    print("Problem saving event")
                }
                isShowing = false
            case .deleted:
                print("Deleted")
                isShowing = false
            @unknown default:
                print("I shouldn't be here")
                isShowing = false
            }
        }
    }
}

struct EKEventWrapper_Previews: PreviewProvider {
    static var previews: some View {
        EKEventWrapper(isShowing: .constant(true))
    }
}

