//
//  MainScreen.swift
//  Gamma Cipher Compute Engines
//
//  Created by Dimka Novikov on 28.11.2025.
//  Copyright © 2025 For Communuty. All rights reserved.
//


// MARK: Import section

import SwiftUI



// MARK: - ComputeEngine

enum ComputeEngine: String, CaseIterable {
    case cpu = "CPU"
    case gpu = "GPU"
}



// MARK: - MainScreen

struct MainScreen: View {
    private let imageSize: Int

    @State private var selectedComputeEngine: ComputeEngine = .cpu

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

                        Picker("", selection: $selectedComputeEngine) {
                            ForEach(ComputeEngine.allCases, id: \.self) { computeEngine in
                                Text(computeEngine.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(spacing: 40) {
                        HStack(spacing: 50) {
                            let imageSizeInBytes = imageSize * Int(copiesCount)
                            let imageSizeInMBytes = imageSizeInBytes / 1_048_576

                            SettingsView(
                                computeEngine: selectedComputeEngine,
                                imageSizeInMBytes: imageSizeInMBytes,
                                executionTime: selectedComputeEngine == .cpu ? cpuExecutionTime : gpuExecutionTime,
                                copiesCount: $copiesCount
                            ) {
                                switch selectedComputeEngine {
                                case .cpu:
                                    cryptUsingCPU()
                                case .gpu:
                                    cryptUsingGPU()
                                }
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

    private func cryptUsingCPU() {
        cpuExecutionTime = "Computing"

        Task.detached(priority: .high) {
            let cipher = GammaCipher(using: .cpu)

            let imageData = getImageData()

            var plaintext = Data()
            for _ in await 0 ..< Int(copiesCount) {
                plaintext.append(imageData)
            }

            let keystream = cipher?.generateKeystream(length: plaintext.count)!

            let startTime = CACurrentMediaTime()

            let _ = cipher.crypt(consume plaintext, using: consume keystream)

            let endTime = CACurrentMediaTime()
            let executionTime = endTime - startTime

            cpuExecutionTime = unsafe String(format: "%.10f sec", executionTime)
        }
    }

    private func cryptUsingGPU() {
        gpuExecutionTime = "Computing"

        Task.detached(priority: .high) {
            let cipher = GammaCipher(using: .gpu)

            let imageData = getImageData()

            var plaintext = Data()
            for _ in await 0 ..< Int(copiesCount) {
                plaintext.append(imageData)
            }

            let keystream = cipher?.generateKeystream(length: plaintext.count)

            let startTime = CACurrentMediaTime()

            let _ = cipher.crypt(consume plaintext, using: consume keystream)

            let endTime = CACurrentMediaTime()
            let executionTime = endTime - startTime

            gpuExecutionTime = unsafe String(format: "%.10f sec", executionTime)
        }
    }
}
