import Logger from '../../common/utils/Logger';
import HomePage from './HomePage';
import { MainChildState } from './MainChildState';
import MePage from './MePage';


@Entry
@Component
struct MainPage {
  private controller: TabsController = new TabsController();
  @State currentIndex: number = 0
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State title: string = '';
  @Provide childState: MainChildState = new MainChildState(0, true);
  private readonly headTitles = ['首页', '项目', '我']

  changeChildState(index, show) {
    this.childState.index = index
    this.childState.show = show
  }

  aboutToAppear() {
    this.title = this.headTitles[0]
  }

  onPageShow() {
    Logger.info('MainPage onPageShow: ')
    this.currentIndex = this.currentIndex;
    this.childState = new MainChildState(this.currentIndex, true);
  }

  onPageHide() {
    Logger.info('MainPage onPageHide: ')
    // this.childState.show = false
    this.childState = new MainChildState(this.currentIndex, false);
  }

  @Builder TabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.currentIndex === index ? 1 : 0)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EDEDED')
  }

  build() {
    Column() {
      Text(this.title)
        .textAlign(TextAlign.Center)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#EDEDED')
        .width('100%')
        .height(48)
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          Column() {
            HomePage({ currentIndex: this.currentIndex })
          }
          .width('100%')
          .height('100%')
        }.tabBar(this.TabBuilder(0, this.headTitles[0]))

        TabContent() {
          Column() {
            Text('test2')
          }
          .width('100%')
          .height('100%')
        }.tabBar(this.TabBuilder(1, this.headTitles[1]))

        TabContent() {
          Column() {
            MePage()
          }
          .width('100%')
          .height('100%')
        }.tabBar(this.TabBuilder(2, this.headTitles[2]))
      }
      .vertical(false)
      .barHeight(50)
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        this.title = this.headTitles[index]
        this.currentIndex = index
        this.changeChildState(this.currentIndex, true)
      })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}
