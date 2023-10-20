import router from '@ohos.router';
import data from '@ohos.telephony.data';
import promptAction from '@ohos.promptAction';
import Api from '../../common/http/Api';
import UserInfoModel from '../../common/model/UserInfoModel';
import Logger from '../../common/utils/Logger';
import UserDataCenter from '../../common/UserDataCenter';


@Component
export default struct MePage {
  @Prop @Watch('onPageChanged') currentIndex: number
  private ownIndex = 2
  @State collectCount: string = '-'
  @State coinCount: string = '-'
  @State level: string = '-'
  @State rank: string = '-'
  @State username: string = '-'

  async getUserInfo() {
    let error = null
    try {
      let response = await Api.userInfo()
      let isSuccess = response.isSuccess()
      Logger.error('userInfo success ' + isSuccess + ', ' + JSON.stringify(response.data))
      if (isSuccess) {
        this.updateUserInfo(response.data)
      } else {
        error = response.errorMsg
      }
    } catch (err) {
      error = err
    } finally {
      if (error) {
        promptAction.showToast({
          message: error
        })
      }
    }
  }

  onPageChanged() {
    if (this.ownIndex === this.currentIndex) {
      //页面发生了切换
      Logger.info('MePage onPageShow: ' + this.currentIndex)
    }
  }

  aboutToAppear() {
    if (UserDataCenter.isLogin()) {
      this.getUserInfo()
    }
  }

  updateUserInfo(userInfo: UserInfoModel) {
    Logger.error('updateUserInfo ' + JSON.stringify(userInfo))
    this.collectCount = userInfo.userInfo.collectIds.length.toString()
    this.coinCount = userInfo.coinInfo.coinCount.toString()
    this.level = userInfo.coinInfo.level.toString()
    this.rank = userInfo.coinInfo.rank
    this.username = userInfo.userInfo.username
  }

  @Builder infoPanel($$: {
    p1: string,
    p2: string,
    callback?: () => void
  }) {
    Column() {
      Text($$.p1)
        .fontSize(16)
      Text($$.p2)
        .fontSize(16)
        .margin({ top: 5 })
    }.onClick(() => {
      $$.callback()
    })
  }

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.icon'))
            .width(60)
            .height(60)
            .clip(new Circle({ width: 60, height: 60 }))
            .onClick(() => {
              router.pushUrl({ url: 'pages/login/LoginPage' })
            })
          Text(this.username)
            .fontSize(20)
            .margin({ left: 20 })
        }
        .width('95%')
        .padding(15)

        Row() {
          this.infoPanel({ p1: '收藏', p2: this.collectCount, callback: () => {

          }})
          this.infoPanel({ p1: '硬币', p2: this.coinCount })
          this.infoPanel({ p1: '等级', p2: this.level })
          this.infoPanel({ p1: '排名', p2: this.rank })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('95%')
        .padding(15)
      }
      .width('95%')
      .backgroundColor(Color.White)
      .borderRadius(20)

      List() {
        ListItem() {
          settingCell()
        }.height(48)

        ListItem() {
          settingCell()
        }.height(48)

        ListItem() {
          settingCell()
        }.height(48)
      }
      .backgroundColor(Color.White)
      .width('95%')
      .margin({ top: 20 })
      .divider({
        strokeWidth: 0.25,
        color: Color.Grey,
        startMargin: 42,
        endMargin: 24
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EDEDED')
  }
}

@Component
struct settingCell {
  icon: Resource
  title: string

  build() {
    Row({ space: 12 }) {
      Image(this.icon)
        .width(22)
        .height(22)

      Text(this.title)
        .fontSize(16)
        .layoutWeight(1)

      Image($r('app.media.right_grey'))
        .width(12)
        .height(24)
    }
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 8, right: 22 })
  }
}

@Component
struct settingSwitchCell {
  icon: Resource
  title: string
  isOn: boolean = false;
  switchAction: (isOn: boolean) => void

  build() {
    Row({ space: 12 }) {
      Image(this.icon)
        .width(22)
        .height(22)

      Text(this.title)
        .fontSize(16)
        .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: false })
        .onChange(this.switchAction)
    }
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 8, right: 22 })
  }
}


@Preview
@Component
struct MePagePreview {
  build() {
    MePage({ currentIndex: 2 })
  }
}
