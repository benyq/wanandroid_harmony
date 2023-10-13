export default class PageModel<T> {
  constructor(readonly curPage: number, readonly datas: T[], readonly offset: number, readonly over: boolean,
              readonly pageCount: number, readonly size: number, readonly total: string) {

    this.curPage = curPage;
    this.datas = datas;
    this.offset = offset;
    this.over = over;
    this.pageCount = pageCount;
    this.size = size;
    this.total = total;
  }
}