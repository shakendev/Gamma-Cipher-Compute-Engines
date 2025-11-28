//
//  MainScreen.swift
//  Gamma Cipher Compute Engines
//
//  Created by Dimka Novikov on 28.11.2025.
//  Copyright © 2025 For Communuty. All rights reserved.
//


// MARK: Import section

import ConfidentialKit
import SwiftUI



// MARK: - CFLStreamEncryptionComputeMode

extension CFLStreamEncryptionComputeMode: @retroactive CaseIterable {
    public static var allCases: [CFLStreamEncryptionComputeMode] = [.cpu, .gpu]

    var name: String {
        switch self {
        case .cpu: "CPU"
        case .gpu: "GPU"
        }
    }
}



// MARK: - MainScreen

struct MainScreen: View {
    private let imageSize: Int

    @State private var selectedComputeMode: CFLStreamEncryptionComputeMode = .cpu

    @State private var cpuExecutionTime: String = "- - -"
    @State private var gpuExecutionTime: String = "- - -"

    @State private var copiesCount: Float = 1

    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay {
                Image(.background)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .overlay {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
            }
            .overlay {
                VStack(spacing: 50) {
                    HStack {
                        Text("Compute Engine:")

                        Picker("", selection: $selectedComputeMode) {
                            ForEach(CFLStreamEncryptionComputeMode.allCases, id: \.self) { computeMode in
                                Text(computeMode.name)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(spacing: 40) {
                        HStack(spacing: 50) {
                            let imageSizeInBytes = imageSize * Int(copiesCount)
                            let imageSizeInMBytes = imageSizeInBytes / 1_048_576

                            SettingsView(
                                computeMode: selectedComputeMode,
                                imageSizeInMBytes: imageSizeInMBytes,
                                executionTime: selectedComputeMode == .cpu ? cpuExecutionTime : gpuExecutionTime,
                                copiesCount: $copiesCount
                            ) {
                                runTest()
                            }
                        }
                    }
                }
                .padding(20)
                .background(Color.black.opacity(0.5))
                .clipShape(.rect(cornerRadius: 20))
                .fixedSize()
            }
    }

    init() {
        let image = UIImage(named: "Background")!
        let imageData = image.pngData()!
        let imageSize = imageData.count

        self.imageSize = imageSize
    }

    private nonisolated func getImageData() -> Data {
        let image = UIImage(named: "Background")!

        return image.pngData()!
    }

    private func runTest() {
        switch selectedComputeMode {
        case .cpu:
            cpuExecutionTime = "Computing"
        case .gpu:
            gpuExecutionTime = "Computing"
        }

        Task.detached(priority: .high) { [selectedComputeMode] in
            guard let cipher = CFLStreamEncryption(cipher: .gamma(using: selectedComputeMode)) else {
                await MainActor.run {
                    switch selectedComputeMode {
                    case .cpu:
                        cpuExecutionTime = "- - -"
                    case .gpu:
                        gpuExecutionTime = "- - -"
                    }
                }

                return
            }

            let imageData = getImageData()

            var plaintext = Data()
            for _ in await 0 ..< Int(copiesCount) {
                plaintext.append(imageData)
            }

            guard let keystream = cipher.generateKeystream(length: plaintext.count) else {
                await MainActor.run {
                    switch selectedComputeMode {
                    case .cpu:
                        cpuExecutionTime = "- - -"
                    case .gpu:
                        gpuExecutionTime = "- - -"
                    }
                }

                return
            }

            let startTime = CACurrentMediaTime()

            let _ = cipher.crypt(consume plaintext, using: consume keystream)

            let endTime = CACurrentMediaTime()
            let executionTime = endTime - startTime

            await MainActor.run {
                switch selectedComputeMode {
                case .cpu:
                    cpuExecutionTime = unsafe String(format: "%.10f sec", executionTime)
                case .gpu:
                    gpuExecutionTime = unsafe String(format: "%.10f sec", executionTime)
                }
            }
        }
    }
}
