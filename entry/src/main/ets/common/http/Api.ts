import ArticleModel from '../model/ArticleModel';
import BannerModel from '../model/BannerModel';
import PageModel from '../model/PageModel';
import { httpGet, httpPost } from './HttpUtil';
import WanResponse from './WanResponse';

export default new class Api {
  async getBanner(): Promise<WanResponse<BannerModel[]>> {
    let data = await httpGet<BannerModel[]>('https://www.wanandroid.com/banner/json')
    return data;
  }

  async homeArticles(page: number): Promise<WanResponse<PageModel<ArticleModel>>> {
    let data = await httpGet<PageModel<ArticleModel>>(`https://www.wanandroid.com/article/list/${page}/json`)
    return data;
  }

  async login(username: string, password: string): Promise<WanResponse<string>> {
    let data = await httpPost<string>('https://www.wanandroid.com/user/login', {
      username: username,
      password: password,
    })
    return data;
  }

}