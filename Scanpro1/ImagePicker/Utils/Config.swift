import UIKit
import AVFoundation

public struct Config {

//  public static var tabsToShow: [GalleryTab] = [.imageTab, .cameraTab, .videoTab]
  // Defaults to cameraTab if present, or whatever tab is first if cameraTab isn't present.
  public static var initialTab: GalleryTab?
  
  public enum GalleryTab {
    case imageTab
  }

  public struct PageIndicator {
    public static var backgroundColor: UIColor = UIColor(red: 0, green: 3/255, blue: 10/255, alpha: 1)
    public static var textColor: UIColor = UIColor.white
  }


  public struct Grid {

    public struct CloseButton {
      public static var tintColor: UIColor = UIColor(red: 109/255, green: 107/255, blue: 132/255, alpha: 1)
    }
    
    public struct ArrowButton {
        public static var tintColor: UIColor = UIColor(red: 110/255, green: 117/255, blue: 131/255, alpha: 1)
    }


    public struct FrameView {
      public static var fillColor: UIColor = UIColor(red: 50/255, green: 51/255, blue: 59/255, alpha: 1)
      public static var borderColor: UIColor = UIColor(red: 0, green: 239/255, blue: 155/255, alpha: 1)
    }

    struct Dimension {
      static let columnCount: CGFloat = 4
      static let cellSpacing: CGFloat = 2
    }
    
    public struct StackView {
        public static let imageCount: Int = 4
    }
    
    public static var imageLimit: Int = 0
  }

  public struct EmptyView {
    public static var image: UIImage? = GalleryBundle.image("gallery_empty_view_image")
    public static var textColor: UIColor = UIColor(red: 102/255, green: 118/255, blue: 138/255, alpha: 1)
  }

  public struct Permission {
    public static var image: UIImage? = GalleryBundle.image("gallery_permission_view_camera")
    public static var textColor: UIColor = UIColor(red: 102/255, green: 118/255, blue: 138/255, alpha: 1)

    public struct Button {
      public static var textColor: UIColor = UIColor.white
      public static var highlightedTextColor: UIColor = UIColor.lightGray
      public static var backgroundColor = UIColor(red: 40/255, green: 170/255, blue: 236/255, alpha: 1)
    }
  }

  public struct Font {

    public struct Main {
      public static var light: UIFont = UIFont.systemFont(ofSize: 1)
      public static var regular: UIFont = UIFont.systemFont(ofSize: 1)
      public static var bold: UIFont = UIFont.boldSystemFont(ofSize: 1)
      public static var medium: UIFont = UIFont.boldSystemFont(ofSize: 1)
    }

    public struct Text {
      public static var regular: UIFont = UIFont.systemFont(ofSize: 1)
      public static var bold: UIFont = UIFont.boldSystemFont(ofSize: 1)
      public static var semibold: UIFont = UIFont.boldSystemFont(ofSize: 1)
    }
  }

}
