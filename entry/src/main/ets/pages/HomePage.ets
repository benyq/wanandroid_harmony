import router from '@ohos.router';
import Api from '../common/http/Api';
import ArticleModel from '../common/model/ArticleModel';
import BannerModel from '../common/model/BannerModel';
import {entitiesDecode} from '../common/utils/StringUtil';

@Component
export default struct HomePage {
  @State isLoading: boolean = true;
  @State bannerData: BannerModel[] = [];
  @State articleData: ArticleModel[] = [];
  private pageIndex: number = 0;
  private swiperController: SwiperController = new SwiperController()
  private isLoadingMore = false;
  private initIndex = 0;

  aboutToAppear() {
    Api.getBanner().then((data) => {
      this.bannerData.push(...data.data);
    }).finally(()=>{
      this.initEnd()
    })
    Api.homeArticles(this.pageIndex)
      .then((data) => {
        this.articleData = this.articleData.concat(data.data.datas)
      })
      .finally(() => {
        this.pageIndex++;
        this.initEnd()
      })
  }

  initEnd() {
    this.initIndex++
    if (this.initIndex === 2) {
      this.isLoading = false;
    }
  }

  @Builder articleItem(index: number, item: ArticleModel) {
    Column() {
      Text(entitiesDecode(item.title))
        .width('100%')
        .fontSize(16)
        .fontColor(Color.Black)
        .maxLines(2)
        .textOverflow({overflow: TextOverflow.Ellipsis})
      Row(){
        Text(item.author ? `作者: ${item.author}` : `分享者: ${item.shareUser}`)
          .fontSize(12)
          .layoutWeight(1)
        Text(`分类: ${item.superChapterName}/${item.chapterName}`)
          .fontSize(12)
          .margin({left: 10})
          .layoutWeight(1)
        Text(item.niceDate)
          .fontSize(12)
          .margin({left: 10, right: 15})
      }
      .width('100%')
      .margin({top: 8})
      Divider()
        .vertical(false)
        .color(Color.Black)
        .strokeWidth(0.5)
        .margin({top: 5})
    }
    .width('100%')
    .margin({top: 5, bottom: 5})
  }

  build() {
    Stack() {
      Column(){
        List() {
          if (this.bannerData.length > 0) {
            ListItem(){
              Swiper(this.swiperController) {
                ForEach(this.bannerData, (item: BannerModel) => {
                  Image(item.imagePath)
                    .width('100%')
                    .height(160)
                    .objectFit(ImageFit.Cover)
                }, item => JSON.stringify(item))
              }
              .width('100%')
              .cachedCount(2)
              .index(1)
              .autoPlay(true)
              .interval(4000)
              .indicator(true)
              .loop(true)
              .duration(1000)
              .itemSpace(20)
              .curve(Curve.Ease)
              .onChange((index: number) => {
              })
            }
          }
          ForEach(this.articleData, (item: ArticleModel, index) => {
            ListItem() {
              this.articleItem(index, item)
            }
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/ArticlePage',
                params:{
                  link: item.link
                }
              })
            })
          }, item => JSON.stringify(item))
        }
        .width('100%')
        .height('100%')
        .onScrollIndex((start,end)=>{
          if (end + 3 === this.articleData.length && !this.isLoadingMore) {
            this.isLoadingMore = true;
            Api.homeArticles(this.pageIndex)
              .then((data) => {
                this.articleData = this.articleData.concat(data.data.datas)
              })
              .finally(() => {
                this.pageIndex++
                this.isLoadingMore = false;
              })
          }
        })
      }
      .width('100%')
      .height('100%')

      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width('25%')
            .height('25%')
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(Color.White)
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}

