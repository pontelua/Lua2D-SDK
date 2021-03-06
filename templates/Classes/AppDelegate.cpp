#include "cocos2d.h"
#include "AppDelegate.h"
#include "SimpleAudioEngine.h"
#include "script_support/CCScriptSupport.h"

USING_NS_CC;
using namespace CocosDenshion;

AppDelegate::AppDelegate()
{
    // fixed me
    //_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF|_CRTDBG_LEAK_CHECK_DF);
}

AppDelegate::~AppDelegate()
{
    // end simple audio engine here, or it may crashed on win32
    SimpleAudioEngine::sharedEngine()->end();
    //CCScriptEngineManager::purgeSharedManager();
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());
    
//    CCEGLView::sharedOpenGLView()->setDesignResolutionSize(480, 320, kResolutionShowAll);
	const float screenWidth = 800;
    const CCSize& frameSize = CCEGLView::sharedOpenGLView()->getFrameSize();
	CCEGLView::sharedOpenGLView()->setDesignResolutionSize(screenWidth, screenWidth * frameSize.height / frameSize.width, kResolutionShowAll);

    // enable High Resource Mode(2x, such as iphone4) and maintains low resource on other devices.
    // pDirector->enableRetinaDisplay(true);

    // turn on display FPS
    pDirector->setDisplayStats(true);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);

    // register lua engine
    CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);

    std::vector<std::string>::const_iterator iter;
    for (iter = m_aLuaCmd.begin(); iter != m_aLuaCmd.end(); iter++)
		pEngine->executeString(iter->c_str());

    if (m_aLuaScript.size() > 0)
    {
        for (iter = m_aLuaScript.begin(); iter != m_aLuaScript.end(); iter++)
            execScript(pEngine, *iter);
    }
    else
    {
        execScript(pEngine, "main.lua");
    }

    return true;
}

void AppDelegate::execScript(CCLuaEngine* pEngine, const std::string& script)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    CCString* pstrFileContent = CCString::createWithContentsOfFile(script.c_str());
    if (pstrFileContent)
        pEngine->executeString(pstrFileContent->getCString());
#else
    std::string path = CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(script.c_str());
    pEngine->addSearchPath(path.substr(0, path.find_last_of("/")).c_str());
    pEngine->executeScriptFile(path.c_str());
#endif
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();
    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();
    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}
