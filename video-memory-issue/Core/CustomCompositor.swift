//
//  CustomCompositor.swift
//  video-memory-issue
//
//  Created by Slava Semeniuk on 03.08.2021.
//

import AVFoundation

final class CustomCompositor: NSObject, AVVideoCompositing {

    // MARK: - Dependencies
    private let renderingQueue = DispatchQueue(label: "com.templify.renderingqueue", qos: .userInteractive, autoreleaseFrequency: .workItem)

    // MARK: - State

    /// Set if all pending requests have been cancelled.
    private var shouldCancelAllRequests = false

    let requiredPixelBufferAttributesForRenderContext: [String: Any] =
        [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    let sourcePixelBufferAttributes: [String: Any]? =
        [kCVPixelBufferPixelFormatTypeKey as String: [kCVPixelFormatType_32BGRA,
                                                      kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                                                      kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]]


    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {}

    // MARK: - Render
    func startRequest(_ asyncVideoCompositionRequest: AVAsynchronousVideoCompositionRequest) {
        renderingQueue.async {
            self.handle(request: asyncVideoCompositionRequest)
        }
    }

    private func handle(request: AVAsynchronousVideoCompositionRequest) {
        if shouldCancelAllRequests {
            request.finishCancelledRequest()
            return
        }
        guard let compositionInstruction = request.videoCompositionInstruction as? SceneInstruction else {
            request.finish(with: Error.cantFindInstruction)
            return
        }

        guard let pixelBuffer = request.renderContext.newPixelBuffer() else {
            request.finish(with: Error.cannotGenerateOutputPixelBuffer)
            return
        }

        request.finish(withComposedVideoFrame: pixelBuffer)
    }

    // MARK: - Cancel
    func cancelAllPendingVideoCompositionRequests() {

        /*
         Pending requests will call finishCancelledRequest, those already rendering will call
         finishWithComposedVideoFrame.
         */
        renderingQueue.sync { shouldCancelAllRequests = true }
        renderingQueue.async {
            // Start accepting requests again.
            self.shouldCancelAllRequests = false
        }
    }

    @objc
    private func handleMemoryWarning() {
        cancelAllPendingVideoCompositionRequests()
    }
}

extension CustomCompositor {
    enum Error: Swift.Error {
        case cannotGenerateOutputPixelBuffer
        case newRenderedPixelBufferForRequestFailure
        case cantFindInstruction
        case missingMTIContext
    }
}
