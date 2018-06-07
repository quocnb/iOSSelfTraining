//
//  PhotoOperations.swift
//  ClassicPhotos
//
//  Created by Quoc Nguyen on 2018/06/07.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit

enum PhotoRecordState {
    case new, downloaded, filtered, failed
}

class PhotoRecord {
    let name: String
    let url: URL
    var state = PhotoRecordState.new
    var image = UIImage(named: "Placeholder")

    init(name:String, url: URL) {
        self.name = name
        self.url = url
    }
}

class PendingOperations {
    lazy var downloadsInProgress = [IndexPath: Operation]()
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    lazy var filtrationsInProgress = [IndexPath: Operation]()
    lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloader: Operation {
    let photoRecord: PhotoRecord

    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }

    override func main() {
        if self.isCancelled {
            return
        }
        let imageData = try? Data(contentsOf: self.photoRecord.url)
        if self.isCancelled {
            return
        }
        guard let img = imageData else {
            return
        }
        if img.count > 0 {
            self.photoRecord.image = UIImage(data: img)
            self.photoRecord.state = .downloaded
        } else {
            self.photoRecord.state = .failed
            self.photoRecord.image = UIImage(named: "Failed")
        }
    }
}

class ImageFiltration: Operation {
    let photoRecord: PhotoRecord

    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }

    override func main () {
        if self.isCancelled {
            return
        }
        if self.photoRecord.state != .downloaded {
            return
        }
        guard let filteredImage = photoRecord.image?.sepiaFilterImage() else {
            return
        }
        self.photoRecord.image = filteredImage
        self.photoRecord.state = .filtered
    }
}

extension UIImage {
    func sepiaFilterImage() -> UIImage? {
        guard let data = UIImagePNGRepresentation(self) else {
            return nil
        }
        guard let inputImage = CIImage(data: data) else {
            return nil
        }
        guard let filter = CIFilter(name: "CISepiaTone") else {
            return nil
        }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: "inputIntensity")
        guard let outputImage = filter.outputImage else {
            return nil
        }
        let context = CIContext(options: nil)
        guard let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: outImage)
    }
}
