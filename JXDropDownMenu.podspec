Pod::Spec.new do |s|

s.name         = "JXDropDownMenu"
s.version      = "1.0.7"
s.summary      = "下拉菜单，封装简单"

s.homepage     = "https://github.com/HJXIcon/JXDropDownMenu"

s.license      = "MIT"

s.author       = { "HJXIcon" => "x1248399884@163.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"


s.source       = { :git => "https://github.com/HJXIcon/JXDropDownMenu.git", :tag => s.version}

s.source_files  = "JXDropDownMenu/JXDropDownMenu/**/*.{h,m}"

s.resource     = "JXDropDownMenu/JXDropDownMenu/picture.bundle"

s.requires_arc = true

end



