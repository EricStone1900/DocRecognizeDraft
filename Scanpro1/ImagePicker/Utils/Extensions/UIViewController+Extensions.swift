import UIKit

extension UIViewController {

  func g_addChildController(_ controller: UIViewController) {
//    addChild(controller)
    addChildViewController(controller)
    view.addSubview(controller.view)
//    controller.didMove(toParent: self)
    controller.didMove(toParentViewController: self)

    controller.view.g_pinEdges()
  }

  func g_removeFromParentController() {
//    willMove(toParent: nil)
    willMove(toParentViewController: nil)
    view.removeFromSuperview()
//    removeFromParent()
    removeFromParentViewController()
  }
}
