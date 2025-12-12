import Foundation
import SwiftUI
import linphonesw

class DialerViewModel: ObservableObject {

    @Published var dialerField = ""
    @Published var isCalling = false
    @ObservedObject private var telecomManager = TelecomManager.shared


    // Append digit
    func addDigit(_ digit: String) {
        dialerField += digit
        print("===========> IF: %s\n", dialerField);
        
        objectWillChange.send()   // FORCE REFRESH
    }

    // Remove last digit
    func removeLastDigit() {
        dialerField = String(dialerField.dropLast())
        objectWillChange.send()   // FORCE REFRESH
    }

    // Make a call
    /*
    func performCall() {
        let numberToCall = currentCall != nil
            ? dialerField
            : startCallViewModel.searchField

        callViewModel.isTransferInsteadCall = false
        callViewModel.callNumber(numberToCall)
        startCallViewModel.interpretAndStartCall()

        isCalling = true
    }
    */
    func performCall() {

        guard !dialerField.isEmpty else {
            Log.warn("Cannot call: number is empty")
            return
        }

        // Convert digits -> SIP address
        let sipAddress = "sip:\(dialerField)@\("billing.mecachat.com")"

        print("Calling SIP Address: \(sipAddress)")

        // Create Linphone Address
        guard let address = try? Factory.Instance.createAddress(addr: sipAddress) else {
            Log.error("Invalid SIP address: \(sipAddress)")
            return
        }

        telecomManager.doCallOrJoinConf(address: address)
        print("===========> performCall: \(dialerField)")

        isCalling = true
    }
}
