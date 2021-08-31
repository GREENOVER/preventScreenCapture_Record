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
  let preventAnnounceView = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
  
  
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
    NotificationCenter.default.addObserver(self, selector: #selector(hideScreen(notification:)), name: UIScreen.capturedDidChangeNotification, object: nil)
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    
  }
  
  // MARK: Prevent Screen Capture & Record
  @objc private func alertPreventScreenCapture(notification:Notification) -> Void {
    let preventCaptureAlert = UIAlertController(title: "주의", message: "📵 화면 캡쳐를 하면 안되요!\n사진을 삭제하시겠습니까?", preferredStyle: .alert)
    preventCaptureAlert.addAction(UIAlertAction(title: "네", style: .default, handler: { [self] _ in
      didTakeScreenshot()
    }))
    preventCaptureAlert.addAction(UIAlertAction(title: "아니오", style: .destructive, handler: { [self] _ in
      alertCautionNotDeleteScreenCapture()
    }))
    self.window?.rootViewController!.present(preventCaptureAlert, animated: true, completion: nil)
  }
  
  private func alertCautionNotDeleteScreenCapture() {
    let cautionAlert = UIAlertController(title: "주의", message: "캡쳐를 악의적으로 사용 시 책임을 물 수 있습니다.", preferredStyle: .alert)
    cautionAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.window?.rootViewController!.present(cautionAlert, animated: true, completion: nil)
  }
  
  @objc private func hideScreen(notification:Notification) -> Void {
    configurePreventView()
    if UIScreen.main.isCaptured {
      window?.addSubview(preventAnnounceView)
    } else {
      preventAnnounceView.removeFromSuperview()
      alertPreventScreenRecord()
    }
  }
  
  private func alertPreventScreenRecord() {
    let preventRecordAlert = UIAlertController(title: "주의", message: "📵 화면 녹화를 하면 안되요", preferredStyle: .alert)
    preventRecordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.window?.rootViewController!.present(preventRecordAlert, animated: true, completion: nil)
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
  
  private func configurePreventView() {
    preventAnnounceView.backgroundColor = .black
    let preventAnnounceLabel = configurePreventAnnounceLabel()
    preventAnnounceView.addSubview(preventAnnounceLabel)
  }
  
  private func configurePreventAnnounceLabel() -> UILabel {
    let preventAnnounceLabel = UILabel()
    preventAnnounceLabel.text = "화면 녹화를 할 수 없습니다"
    preventAnnounceLabel.font = .boldSystemFont(ofSize: 30)
    preventAnnounceLabel.numberOfLines = 0
    preventAnnounceLabel.textColor = .white
    preventAnnounceLabel.textAlignment = .center
    preventAnnounceLabel.sizeToFit()
    preventAnnounceLabel.center.x = self.preventAnnounceView.center.x
    preventAnnounceLabel.center.y = self.preventAnnounceView.center.y
    
    return preventAnnounceLabel
  }
}

