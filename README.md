# Lua2D-SDK

last update : 11/29/12 15:17:09

```
 _______________ 
< Hello Lua2D!! >
 --------------- 
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

## 안드로이드 플랫폼 프로젝트 생성

* 이 프로젝트를 `clone`.
* `tools/lua2d-android-gen.sh` 파일에 android SDK의 path 업데이트

	```
	ANDROID_SDK_ROOT_LOCAL="<YOUR-SDK-PATH>"
	```

* `tools/lua2d-android-gen.sh` 스크립트를 실행.
	* 스크립트가 실행되면 `패키지 이름`, `타겟 안드로이드 버전`, `앱 이름` 을 차례로 입력.
* 생성된 디렉토리는 아래와 같은 구조를 가지고 있다.

	```
	.
	├── Classes
	│   ├── AppDelegate.cpp
	│   └── AppDelegate.h
	├── Resources
	│   ├── debugger.lua
	│   ├── debugintrospection.lua
	│   └── main.lua
	└── proj.android
	    ├── AndroidManifest.xml
	    ├── ant.properties
	    ├── assets
	    ├── bin
	    ├── build.xml
	    ├── jni
	    ├── libs
	    ├── local.properties
	    ├── proguard-project.txt
	    ├── project.properties
	    ├── res
	    └── src
	```

* 주요 디렉토리 설명

	|디렉토리|설명|
	| ------------ | ------------- |
	|proj.android  |Lua2D 안드로이드 프로젝트|
	|assets        |게임에 필요한 이미지, 효과음, lua 스크립트가 저장됨|
	|libs          |Lua2D 바이너리 파일인 liblua2d.so와 자바 라이브러리인 lua2d.jar 가 저장됨|

	`Classes`, `Resources` 디렉토리는 안드로이드 프로젝트에서는 **사용되지 않음**

### 빌드 & 확인

* [Eclipse](http://www.eclipse.org/downloads/) 를 통해 `proj.android` 디렉토리를 `import`.
* 해당 프로젝트를 실행 후 아래의 `Logcat` 메시지 확인.

```
11-29 15:15:23.242: D/cocos2d-x debug info(31315): Hello Lua Bind!!!
```