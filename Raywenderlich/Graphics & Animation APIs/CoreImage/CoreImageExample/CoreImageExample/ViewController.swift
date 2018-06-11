//
//  ViewController.swift
//  CoreImageExample
//
//  Created by Quoc Nguyen on 2018/06/08.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensitySlider: UISlider!

    lazy var beginCIImage: CIImage? = {
        guard let imageUrl = Bundle.main.url(forResource: "image", withExtension: "png") else {
            return nil
        }
        return CIImage(contentsOf: imageUrl)
    }()
    var orientation = UIImageOrientation.up

    func logAllFilters() {
        let properties = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
        print("-- CIFilter names --")
        print(properties)

        for filterName in properties {
            let filter = CIFilter(name: filterName)
            print(filter?.attributes)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.logAllFilters()
        intensityChange(self.intensitySlider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func intensityChange(_ sender: UISlider) {
        guard let cgImage = beginCIImage?.filter(sender.value) else {
            return
        }
        self.imageView.image = UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
    }

    @IBAction func addPhoto(_ sender: Any) {
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.present(pickerC, animated: true, completion: nil)
    }

    @IBAction func savePhoto(sender: AnyObject) {
        guard let savedImage = self.imageView.image else {
            return
        }
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: savedImage)
        }) { (finish, error) in
            if error == nil {
                let alert = UIAlertController(title: "Success", message: "Saved success", preferredStyle: .alert)
                let action = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error!.localizedDescription)
            }
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        guard let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        orientation = newImage.imageOrientation
        beginCIImage = CIImage(image: newImage)
        intensityChange(self.intensitySlider)
    }
}

extension CIImage {
    func oldPhoto(_ intensity: Float) -> CIImage {
        let sepia = CIFilter(name:"CISepiaTone")!
        sepia.setValue(self, forKey:kCIInputImageKey)
        sepia.setValue(intensity, forKey:"inputIntensity")

        let random = CIFilter(name:"CIRandomGenerator")!

        let lighten = CIFilter(name:"CIColorControls")!
        lighten.setValue(random.outputImage, forKey:kCIInputImageKey)
        lighten.setValue(1 - intensity, forKey:"inputBrightness")
        lighten.setValue(0, forKey:"inputSaturation")

        let croppedImage = lighten.outputImage?.cropped(to: self.extent)

        let composite = CIFilter(name:"CIHardLightBlendMode")!
        composite.setValue(sepia.outputImage, forKey:kCIInputImageKey)
        composite.setValue(croppedImage, forKey:kCIInputBackgroundImageKey)

        let vignette = CIFilter(name:"CIVignette")!
        vignette.setValue(composite.outputImage, forKey:kCIInputImageKey)
        vignette.setValue(intensity * 2, forKey:"inputIntensity")
        vignette.setValue(intensity * 30, forKey:"inputRadius")

        return vignette.outputImage!
    }

    func filter(_ intensity: Float) -> CGImage? {
        let newCIImage = self.oldPhoto(intensity)
        let context = CIContext(options: nil)
        return context.createCGImage(newCIImage, from: newCIImage.extent)
    }
}

