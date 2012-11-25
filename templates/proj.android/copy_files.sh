#!/bin/bash
# check the args
# $1: root of cocos2dx $2: app name $3: ndk root $4:pakcage path

APP_NAME=$2
PWD=$1
APP_DIR=$PWD/$APP_NAME
TEMPLATE_ROOT=$PWD/templates/proj.android
NDK_ROOT=$3
PACKAGE_PATH=$4
NEED_BOX2D=$5
NEED_CHIPMUNK=$6
NEED_LUA=$7

# xxx.yyy.zzz -> xxx/yyy/zzz
convert_package_path_to_dir(){
    PACKAGE_PATH_DIR=`echo $1 | sed -e "s/\./\//g"`
}

# copy "Classes" directory to target directory.
copy_classes(){
    if [ ! -d "$APP_DIR/Classes" ]; then
        mkdir $APP_DIR/Classes
        for file in $TEMPLATE_ROOT/../Classes/*
        do
            cp $file $APP_DIR/Classes
        done
    fi
}

# copy "Resources" directory to target directory.
copy_resouces(){
    if [ ! -d "$APP_DIR/Resources" ]; then
        mkdir $APP_DIR/Resources
        
        for file in $TEMPLATE_ROOT/../Resources/*
        do
            cp -rf $file $APP_DIR/Resources
        done
    fi
}

copy_assets() {
    mkdir $APP_DIR/proj.android/assets
    for file in $TEMPLATE_ROOT/../Resources/*
    do
        cp -rf $file $APP_DIR/proj.android/assets
    done
}

# copy android specific template to target directory
copy_android_template(){
    cp -rf $TEMPLATE_ROOT/jni $APP_DIR/proj.android
    cp -rf $TEMPLATE_ROOT/src $APP_DIR/proj.android
    cp -rf $TEMPLATE_ROOT/libs $APP_DIR/proj.android
}

# copy .project and .classpath and replace project name
copy_project_settings(){
    sed "s/Hello/$APP_NAME/" $TEMPLATE_ROOT/.project > $APP_DIR/proj.android/.project
    cp -f $TEMPLATE_ROOT/.classpath $APP_DIR/proj.android
}

# replace AndroidManifext.xml and change the activity name
# use sed to replace the specified line
modify_androidmanifest(){
    sed "s/HelloCpp/$APP_NAME/;s/org\.cocos2dx\.hellocpp/$PACKAGE_PATH/" $TEMPLATE_ROOT/AndroidManifest.xml > $APP_DIR/proj.android/AndroidManifest.xml
}

# *.java file.
modify_applicationdemo(){
    convert_package_path_to_dir $PACKAGE_PATH

    sed "s/Lua2D/$APP_NAME/;s/org\.cocos2dx\.lua2d/$PACKAGE_PATH/" $TEMPLATE_ROOT/src/org/cocos2dx/lua2d/Lua2D.java > $APP_DIR/proj.android/src/$PACKAGE_PATH_DIR/$APP_NAME.java
    rm -fr $APP_DIR/proj.android/src/org
}

# lua2d doesn't need layout xml file.
modify_layout(){
    rm -f $APP_DIR/proj.android/res/layout/main.xml
}

# android.bat of android 4.0 don't create res/drawable-hdpi res/drawable-ldpi and res/drawable-mdpi.
# remove it and fill with template resources.
copy_icon(){
    rm -rf $APP_DIR/proj.android/res
    cp -rf $TEMPLATE_ROOT/res $APP_DIR/proj.android
}

copy_classes
copy_resouces
copy_assets
copy_android_template
copy_project_settings
modify_androidmanifest
modify_applicationdemo
modify_layout
copy_icon
