
#Use:命令行进入项目根目录直接执行 sh build.sh 即可在桌面 projectName-ipa 文件夹里生成ipa安装包

export LC_ALL=zh_CN.GB2312;
export LANG=zh_CN.GB2312

#一些路径的切换：切换到你的工程文件目录---------
projectPath=$(cd `dirname $0`; pwd)
cd ..
cd $projectPath

###############设置需编译的项目配置名称
#选择编译的方式,有Release,Debug，自定义的AdHoc等
echo "\n********************** 请选择你需要编译的版本 **********************\n"
echo "编译 Release 版本输入 'r', 编译 Debug 版本输入 'd'"

read config
echo "你输入的内容是:${config}"

if [ $config = "r" ]; then
buildConfig="Release"
elif [ $config = "d" ]; then
buildConfig="Debug"
else
echo "输入内容有误！默认编译 Debug 版本"
buildConfig="Debug"
fi

echo "你选择的编译版本是:${buildConfig} \n"

echo " \n********************** 创建安装包存放文件夹 ********************** \n"
##############################  以下部分为自动生成部分，不需要手动修改 ############################
#项目名称
projectName=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`
echo "编译的项目名称:$projectName"
projectDir=`pwd` #项目所在目录的绝对路径
echo $projectDir
wwwIPADir=~/Desktop/$projectName-ipa/$buildConfig  #ipa，icon最后所在的目录绝对路径
isWorkSpace=false  #判断是用的workspace还是直接project，workspace设置为true，否则设置为false

if [ -d "$wwwIPADir" ]; then
echo $wwwIPADir
echo "文件目录已存在"
else
echo "文件目录不存在"
mkdir -pv $wwwIPADir
echo "创建${wwwIPADir}目录成功"
fi

echo " \n********************** 开始编译 ********************** \n"
###############进入项目目录
cd $projectDir
rm -rf ./build
buildAppToDir=$projectDir/build #编译打包完成后.app文件存放的目录

###############获取版本号,bundleID
infoPlist="$projectName/*-Info.plist"
bundleVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $infoPlist`
bundleIdentifier=`/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" $infoPlist`
bundleBuildVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $infoPlist`

###############开始编译app
if $isWorkSpace ; then  #判断编译方式
echo  "开始编译workspace...."
xcodebuild  -workspace $projectName.xcworkspace -scheme $projectName  -configuration $buildConfig clean build SYMROOT=$buildAppToDir
else
echo  "开始编译target...."
xcodebuild  -target  $projectName  -configuration $buildConfig clean build SYMROOT=$buildAppToDir
fi
#判断编译结果
if test $? -eq 0
then
echo " \n********************** 编译成功 ********************** \n"
else
echo " \n********************** 编译失败 ********************** \n"
exit 1
fi

echo " \n********************** 开始打包ipa ********************** \n"
###############开始打包成.ipa
ipaName=`echo $projectName | tr "[:upper:]" "[:lower:]"` #将项目名转小写
findFolderName=`find . -name "$buildConfig-*" -type d |xargs basename` #查找目录
appDir=$buildAppToDir/$findFolderName/  #app所在路径


outPath=$projectPath/temp
#####检测outPath路径是否存在
if [ -d "$outPath" ]; then
echo $outPath
echo "文件目录已存在"
else
echo "文件目录不存在"
mkdir -pv $outPath
echo "创建${outPath}目录成功"
fi

#sudo chmod -R 777 $outPath

echo "开始打包$projectName.app成$projectName.ipa....."

xcrun -sdk iphoneos -v PackageApplication $appDir/$projectName.app  -o $outPath/$projectName.ipa

###############开始拷贝到目标下载目录
#检查文件是否存在
if [ -f "$outPath/$ipaName.ipa" ]
then
echo "打包$ipaName.ipa成功."
else
echo "打包$ipaName.ipa失败."
exit 1
fi

echo " \n********************** 导出ipa到存放文件夹 ********************** \n"

Export_Path=$wwwIPADir/$projectName$"_"$buildConfig$(date +_%m%d_%H%M).ipa
cp -f -p $outPath/$ipaName.ipa $Export_Path   #拷贝ipa文件
echo " 复制$ipaName.ipa到${wwwIPADir}成功 \n"
rm -rf $outPath
rm -rf ./build
rm -rf $buildAppToDir
rm -rf $projectDir/tmp

echo " \n********************** ${projectName}出包结束 ********************** \n"
