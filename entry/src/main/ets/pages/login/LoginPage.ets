import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import Api from '../../common/http/Api';
import WanResponse from '../../common/http/WanResponse';
import Logger from '../../common/utils/Logger';
import UserDataCenter from '../../common/UserDataCenter';


@Extend(TextInput) function inputStyle() {
  .placeholderColor('#99182431')
  .height(45)
  .fontSize(18)
  .backgroundColor('#F1F3F5')
  .width('100%')
  .padding({ left: 0 })
  .margin({ top: 12 })
}

@Extend(Line) function lineStyle() {
  .width('100%')
  .height(1)
  .backgroundColor('#33182431')
}

@Extend(Text) function blueTextStyle() {
  .fontColor('#007DFF')
  .fontSize(14)
  .fontWeight(FontWeight.Medium)
}

@Entry
@Component
struct LoginPage {
  @State account: string = 'yzjbenyq';
  @State password: string = 'yezijian520';
  @State isShowProgress: boolean = false;

  @Builder imageButton(src: Resource) {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      Image(src)
    }
    .backgroundColor('#F1F3F5')
    .width('48')
    .height('48')
  }

  build() {
    Column() {
      Image($r('app.media.icon'))
        .width(78)
        .height(78)
        .clip(new Circle({ width: 78, height: 78 }))
        .margin({ top: 80, bottom: 8 })

      Text('登录帐号以使用更多服务')
        .fontSize(16)
        .fontColor(Color.Black)
        .margin({ top: 18, bottom: 30 })

      TextInput({ placeholder: '账号' })
        .inputStyle()
        .type(InputType.Normal)
        .onChange((value) => {
          this.account = value;
        })
      Line().lineStyle()
      TextInput({ placeholder: '密码' })
        .inputStyle()
        .type(InputType.Password)
        .onChange((value) => {
          this.password = value;
        })
      Line().lineStyle()
      Row() {
        Text('短信验证码登录').blueTextStyle()
        Text('忘记密码').blueTextStyle()
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 8 })

      Button('登录', { type: ButtonType.Capsule, stateEffect: true })
        .width('90%')
        .height(40)
        .fontSize(16)
        .backgroundColor('#007DFF')
        .fontWeight(FontWeight.Medium)
        .margin({ top: 87, bottom: 12 })
        .onClick(() => {
          if (this.account.length == 0) {
            promptAction.showToast({
              message: '账号不能为空'
            })
            return
          }
          if (this.password.length == 0) {
            promptAction.showToast({
              message: '密码不能为空'
            })
            return
          }
          this.isShowProgress = true
          login(this.account, this.password, (success, msg)=>{
            this.isShowProgress = false
            if (success) {
              router.back()
            }else {
              promptAction.showToast({
                message: msg
              })
            }
          })
        })

      Text('注册账号')
        .fontColor('#007DFF')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)

      if (this.isShowProgress) {
        LoadingProgress()
          .color('#182431')
          .width(30)
          .height(30)
          .margin({ top: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: 12, right: 12, bottom: 24 })
  }
}

async function login(username: string, password: string, callback: (boolean, string)=>void){
  Api.login(username, password).then((response) => {
    const isSuccess = response.isSuccess();
    if (isSuccess) {
      //处理数据
      let data = response.data
      UserDataCenter.putLoginInfo(data.username)
      callback(true, '')
    } else {
      callback(false, '登陆失败: ' + JSON.stringify(response))
    }
  }).catch((error)=>{
    callback(false, '登陆失败: ' + error)
  })
}