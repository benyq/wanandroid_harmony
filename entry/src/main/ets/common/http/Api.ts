import ArticleModel from '../model/ArticleModel';
import BannerModel from '../model/BannerModel';
import LoginModel from '../model/LoginModel';
import PageModel from '../model/PageModel';
import UserInfoModel from '../model/UserInfoModel';
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

  async login(username: string, password: string): Promise<WanResponse<LoginModel>> {
    let data = await httpPost<LoginModel>('https://www.wanandroid.com/user/login', {
      username: username,
      password: password,
    })
    return data;
  }

  async userInfo(): Promise<WanResponse<UserInfoModel>> {
    let data = await httpGet<UserInfoModel>('https://www.wanandroid.com/user/lg/userinfo/json')
    return data;
  }
}