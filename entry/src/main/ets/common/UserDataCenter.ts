import PreferenceUtil from './PreferenceUtil';
import Logger from './utils/Logger';

const KEY_TOKEN = "KEY_TOKEN";
const KEY_USERNAME = "KEY_USERNAME";

export default new class UserDataCenter {

  private token = '';
  private username = '';


  async prepareData() {
    this.token = await PreferenceUtil.getString(KEY_TOKEN)
    this.username = await PreferenceUtil.getString(KEY_USERNAME)
    Logger.info('prepareData data: ' + this.token);
  }

  putLoginInfo(username: string) {
    this.username = username
    PreferenceUtil.putString(KEY_USERNAME, username)
  }

  isLogin() {
    return this.username.length !== 0
  }

  putCookie(token: string) {
    PreferenceUtil.putString(KEY_TOKEN, token)
    Logger.info('UserDataCenter token: ' + token)
    this.token = token;
  }

  getCookie(): string {
    return this.token;
  }
}