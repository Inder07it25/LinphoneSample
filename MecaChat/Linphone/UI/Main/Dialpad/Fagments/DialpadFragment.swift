//
//  DialpadFragment.swift
//

import SwiftUI
import linphonesw

struct DialpadFragment: View {
    @ObservedObject var vm: DialerViewModel
    @State private var orientation = UIDevice.current.orientation

    var body: some View {
        VStack(spacing: 0) {

            // Dialed number ALWAYS at top
            displayNumber
                .padding(.bottom, 20)

            Spacer()

            // Number keypad
            keypad

            // Call button (only for new call)
            callButton

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(vm.dialerField != nil ? Color.gray600 : Color.gray100)
        .onRotate { orientation = $0 }
    }

    // MARK: - UI Elements

    private var topHandle: some View {
        Capsule()
            .fill(vm.dialerField != nil ? .white : Color.grayMain2c300)
            .frame(width: 75, height: 5)
            .padding(15)
    }

    private var displayNumber: some View {
        HStack {
            Text(vm.dialerField)
                .foregroundStyle(vm.dialerField != nil ? .white : Color.grayMain2c600)
                .default_text_style(styleSize: 25)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 10)
                .lineLimit(1)
                .truncationMode(.head)

            Button {
                vm.removeLastDigit()
            } label: {
                Image("backspace-fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(vm.dialerField != nil ? .white : Color.grayMain2c500)
            }
            .frame(width: 60, height: 60)
        }
        .padding(.horizontal, 20)
        .padding(.top, 5)
    }

    private var keypad: some View {
        VStack(spacing: 12) {
            numberRow(["1", "2", "3"])
            numberRow(["4", "5", "6"])
            numberRow(["7", "8", "9"])
            numberRow(["*", "0", "#"])
        }
        .padding(.horizontal, 60)
    }

    private func numberRow(_ digits: [String]) -> some View {
        HStack {
            ForEach(digits, id: \.self) { digit in
                Spacer()
                dialButton(digit)
                Spacer()
            }
        }
    }

    private func dialButton(_ digit: String) -> some View {
        Button {
            vm.addDigit(digit)
        } label: {
            Text(digit)
                .foregroundStyle(vm.dialerField != nil ? .white : Color.grayMain2c600)
                .default_text_style(styleSize: 32)
                .frame(width: 60, height: 60)
                .background(vm.dialerField != nil ? Color.gray500 : .white)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }

    private var callButton: some View {
        Button {
            vm.performCall()
        } label: {
            Image("phone")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .frame(width: 90, height: 60)
                .background(Color.greenSuccess500)
                .cornerRadius(40)
                .shadow(radius: 4)
        }
        .padding(.top, 20)
    }
}

#Preview {
    DialpadFragment(
        vm: .init()
    )
}
