import UIKit
import Flutter
import Photos


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let CHANNEL = "image_extractor"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      let controller = window?.rootViewController as! FlutterViewController
      let imageChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)

      imageChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
          print("call.method")
          print(call.method)
          if call.method == "getImages" {
                  self.fetchImagePaths(result: result)
              }
              else if call.method == "saveImages" {
                  guard let args = call.arguments as? [String: Any],
                        let bytes = args["bytes"] as? FlutterStandardTypedData,
                        let fileName = args["fileName"] as? String,
                        let folderName = args["folderName"] as? String else {
                      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
                      return
                  }
                  self.saveToAlbum(data: bytes.data, fileName: fileName, albumName: folderName, result: result)
              } else {
                  result(FlutterMethodNotImplemented)
              }
              }
      
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    private func fetchImagePaths(result: @escaping FlutterResult) {
            var imagePaths: [String] = []

            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    let fetchOptions = PHFetchOptions()
                    let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)

                    assets.enumerateObjects { asset, _, _ in
                        let options = PHContentEditingInputRequestOptions()
                        asset.requestContentEditingInput(with: options) { input, _ in
                            if let url = input?.fullSizeImageURL {
                                imagePaths.append(url.path)
                                if imagePaths.count == assets.count {
                                    result(imagePaths)
                                }
                            }
                        }
                    }
                } else {
                    result(FlutterError(code: "PERMISSION_DENIED", message: "Photos permission denied", details: nil))
                }
            }
        }
    private func saveToAlbum(data: Data, fileName: String, albumName: String, result: @escaping FlutterResult) {
        PHPhotoLibrary.requestAuthorization { status in
            if #available(iOS 14, *) {
                guard status == .authorized || status == .limited else {
                    result(FlutterError(code: "PERMISSION_DENIED", message: "Photo access not granted", details: nil))
                    return
                }
            } else {
                guard status == .authorized else {
                    result(FlutterError(code: "PERMISSION_DENIED", message: "Photo access not granted", details: nil))
                    return
                }
            }

            var placeholder: PHObjectPlaceholder?

            PHPhotoLibrary.shared().performChanges({
                let options = PHAssetResourceCreationOptions()
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: data, options: options)
                placeholder = creationRequest.placeholderForCreatedAsset
            }) { success, error in
                if success, let assetID = placeholder?.localIdentifier {
                    self.addAssetToAlbum(assetID: assetID, albumName: albumName, result: result)
                } else {
                    result(FlutterError(code: "SAVE_FAILED", message: error?.localizedDescription, details: nil))
                }
            }
        }
    }

    private func addAssetToAlbum(assetID: String, albumName: String, result: @escaping FlutterResult) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let album = collection.firstObject {
            addAsset(assetID, to: album, result: result)
        } else {
            createAlbum(named: albumName) { newAlbum in
                guard let newAlbum = newAlbum else {
                    result(FlutterError(code: "ALBUM_CREATE_FAILED", message: "Failed to create album", details: nil))
                    return
                }
                self.addAsset(assetID, to: newAlbum, result: result)
            }
        }
    }

    private func createAlbum(named: String, completion: @escaping (PHAssetCollection?) -> Void) {
        var albumPlaceholder: PHObjectPlaceholder?

        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: named)
            albumPlaceholder = creationRequest.placeholderForCreatedAssetCollection
        }) { success, error in
            if success, let placeholder = albumPlaceholder {
                let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                completion(fetchResult.firstObject)
            } else {
                completion(nil)
            }
        }
    }

    private func addAsset(_ assetID: String, to album: PHAssetCollection, result: @escaping FlutterResult) {
        let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
        guard let asset = assetResult.firstObject else {
            result(FlutterError(code: "ASSET_NOT_FOUND", message: "Asset not found", details: nil))
            return
        }

        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCollectionChangeRequest(for: album)
            request?.addAssets([asset] as NSArray)
        }) { success, error in
            if success {
                result("saved")
            } else {
                result(FlutterError(code: "SAVE_FAILED", message: error?.localizedDescription, details: nil))
            }
        }
    }

}
