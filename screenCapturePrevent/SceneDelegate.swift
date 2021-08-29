//
//  SceneDelegate.swift
//  screenCapturePrevent
//
//  Created by Chanwoo Cho on 2021/08/28.
//

import UIKit
import SwiftUI
import Photos


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // Create the SwiftUI view that provides the window contents.
    let contentView = ContentView()
    
    // Use a UIHostingController as window root view controller.
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      self.window = window
      window.makeKeyAndVisible()
    }
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    NotificationCenter.default.addObserver(self, selector: #selector(alertPreventScreenCapture(notification:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(alertPreventScreenRecord(notification:)), name: UIScreen.capturedDidChangeNotification, object: nil)
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    
  }
  
  // MARK: Prevent Screen Capture & Record
  @objc private func alertPreventScreenCapture(notification:Notification) -> Void {
    let alert = UIAlertController(title: "주의", message: "화면 캡쳐를 하면 안되요!\n사진을 삭제하시겠습니까?", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "네", style: .default, handler: { [self] _ in
      didTakeScreenshot()
    }))
    alert.addAction(UIAlertAction(title: "아니오", style: .destructive, handler: nil))
    self.window?.rootViewController!.present(alert, animated: true, completion: nil)
  }
  
  @objc private func alertPreventScreenRecord(notification:Notification) -> Void {
    let alert = UIAlertController(title: "주의", message: "화면 녹화를 하면 안되요!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    hideScreen()
    self.window?.rootViewController!.present(alert, animated: true, completion: nil)
  }
  
  private func hideScreen() {
    if UIScreen.main.isCaptured {
      window?.isHidden = true
    } else {
      window?.isHidden = false
    }
  }
  
  private func didTakeScreenshot() {
    let fetchScreenshotOptions = PHFetchOptions()
    fetchScreenshotOptions.sortDescriptors?[0] = Foundation.NSSortDescriptor(key: "creationDate", ascending: true)
    let fetchScreenshotResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchScreenshotOptions)
    
    guard let lastestScreenshot = fetchScreenshotResult.lastObject else { return }
    PHPhotoLibrary.shared().performChanges {
      PHAssetChangeRequest.deleteAssets([lastestScreenshot] as NSFastEnumeration)
    } completionHandler: { (success, errorMessage) in
      if !success, let errorMessage = errorMessage {
        print(errorMessage.localizedDescription)
      }
    }
  }
}

