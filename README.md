# App-Build-Shell
App Build Shell



1.	将 build.sh 放到工程根目录下。 (即 projectName.xcodeproj 所在目录)

2.	安装PackageApplication。\n
    	安装方法如下：\n
	  1> 下载 PackageApplication \n
    	  2> 复制 PackageApplication 到该目录:/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ \n
	  3> 打开终端 执行以下步骤：\n
      		a、先用 xcode-select -print-path 查看路径，若xcode已经在该目录下，直接执行 c 步骤，否则先执行 b 步骤 \n
      		b、直接拷贝命令 sudo xcode-select –switch /Applications/Xcode.app/Contents/Developer/ 到终端执行，之后执行步骤 c \n
      		c、直接拷贝命令 chmod +x /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/PackageApplication到终端执行 \n

3.	终端 cd 到工程目录(即 projectName.xcodeproj 所在目录)，使用 sh build.sh 运行脚本
