//
//  GalleryController.swift
//  SuperApp
//
//  Created by song on 2019/6/24.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit
import AVFoundation

public protocol SHBGalleryControllerDelegate: class {
    
    func galleryController(_ controller: SHBGalleryController, didSelectImages images: [Image])
    func galleryController(_ controller: SHBGalleryController, requestLightbox images: [Image])
    func galleryControllerDidCancel(_ controller: SHBGalleryController)
}

public class SHBGalleryController: UIViewController, PermissionControllerDelegate{
    public weak var delegate: SHBGalleryControllerDelegate?
    
    public let cart = Cart()
    // MARK: - Init
    
    public required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        if let imageController = makeImagesController() {
            g_addChildController(imageController)
        } else {
            let permissionController = makePermissionController()
            g_addChildController(permissionController)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    public override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func makeImagesController() -> ImagesController? {
        guard Permission.Photos.status == .authorized else {
            return nil
        }
        let controller = ImagesController(cart: cart)
        controller.title = "Gallery.Images.Title".g_localize(fallback: "PHOTOS")
        
        return controller
    }
    
    func makePermissionController() -> PermissionController {
        let controller = PermissionController()
        controller.delegate = self
        
        return controller
    }
    
    // MARK: - Setup
    
    func setup() {
        EventHub.shared.close = { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.galleryControllerDidCancel(strongSelf)
            }
        }

        EventHub.shared.doneWithImages = { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.galleryController(strongSelf, didSelectImages: strongSelf.cart.images)
            }
        }

//        EventHub.shared.doneWithVideos = { [weak self] in
//            if let strongSelf = self, let video = strongSelf.cart.video {
//                strongSelf.delegate?.galleryController(strongSelf, didSelectVideo: video)
//            }
//        }

        EventHub.shared.stackViewTouched = { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.galleryController(strongSelf, requestLightbox: strongSelf.cart.images)
            }
        }
    }
    
    // MARK: - PermissionControllerDelegate
    
    func permissionControllerDidFinish(_ controller: PermissionController) {
        if let imageController = makeImagesController() {
            g_addChildController(imageController)
            controller.g_removeFromParentController()
        }
    }
}
