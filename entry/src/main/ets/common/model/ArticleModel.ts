export default class ArticleModel {
  constructor(readonly title: string, readonly id: string, readonly author: string, readonly shareUser: string,
              readonly link: string, readonly niceDate: string, readonly chapterName: string, readonly superChapterName: string) {
    this.title = title;
    this.id = id;
    this.author = author;
    this.shareUser = shareUser;
    this.link = link;
    this.niceDate = niceDate;
    this.chapterName = chapterName;
    this.superChapterName = superChapterName;
  }
}