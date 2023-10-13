@Component
export default struct MePage {
  @Builder infoPanel(key: string, value: string, callback?: () => void) {
    Column() {
      Text(key)
        .fontSize(16)
      Text(value)
        .fontSize(16)
        .margin({ top: 5 })
    }.onClick(() => {
      if (callback) {
        callback();
      }
    })
  }

  build() {
    Column() {
      Column(){
        Row() {
          Image('https://i0.hdslb.com/bfs/archive/4d0295bbdc7c9923a695e9e576a619e6d474b8c3.jpg@672w_378h_1c_!web-home-common-cover.webp')
            .width(60)
            .height(60)
            .clip(new Circle({ width: 60, height: 60 }))
          Text('苏打先生')
            .fontSize(20)
            .margin({ left: 20 })
        }
        .width('95%')
        .padding(15)

        Row() {
          this.infoPanel('积分', '224')
          this.infoPanel('积分', '444')
          this.infoPanel('积分', '22')
          this.infoPanel('积分', '7645')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('95%')
        .padding(15)
      }
      .width('95%')
      .backgroundColor(Color.White)
      .borderRadius(20)

      List(){
        ListItem(){
          settingCell()
        }.height(48)
        ListItem(){
          settingCell()
        }.height(48)
        ListItem(){
          settingCell()
        }.height(48)
      }
      .backgroundColor(Color.White)
      .width('95%')
      .margin({top: 20})
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
  isOn:boolean = false;
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
    MePage()
  }
}
