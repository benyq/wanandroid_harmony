import webview from '@ohos.web.webview';
import router from '@ohos.router';

@Entry
@Component
struct ArticlePage {
  webController: webview.WebviewController = new webview.WebviewController();
  articleUrl: string

  aboutToAppear() {
    const params = router.getParams()
    this.articleUrl = params['link']
  }

  build(){
    Column(){
      Web({src: this.articleUrl, controller: this.webController})
        .domStorageAccess(true)
        .mixedMode(MixedMode.All)
    }
  }
}