export default class BannerModel {

  constructor(readonly desc: string, readonly id: number, readonly imagePath: string,
              readonly title: string, readonly url: string) {
    this.desc = desc;
    this.id = id;
    this.imagePath = imagePath;
    this.title = title;
    this.url = url
  }
}