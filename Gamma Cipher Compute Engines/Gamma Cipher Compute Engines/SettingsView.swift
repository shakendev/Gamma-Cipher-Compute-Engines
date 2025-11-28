//
//  SettingsView.swift
//  Gamma Cipher Compute Engines
//
//  Created by Dimka Novikov on 28.11.2025.
//  Copyright © 2025 For Communuty. All rights reserved.
//


// MARK: Import section

import ConfidentialKit
import SwiftUI



// MARK: - SettingsView

struct SettingsView: View {
    let computeMode: CFLStreamEncryptionComputeMode
    let imageSizeInMBytes: Int
    let executionTime: String

    @Binding var copiesCount: Float

    let action: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 20) {
                Text("GC \(computeMode.name) Compute Engine")
                    .bold()

                VStack(alignment: .leading) {
                    Text("Image Size: \(imageSizeInMBytes) MB")

                    HStack {
                        Text("Copies Count: \(Int(copiesCount))")

                        Slider(value: $copiesCount, in: 1 ... 1_000, step: 1)
                    }

                    Text("Execution Time: \(executionTime)")
                }
            }

            Button("Generate Gamma & Crypt", action: action)
                .buttonStyle(.borderedProminent)
        }
        .frame(width: 300)
    }
}
