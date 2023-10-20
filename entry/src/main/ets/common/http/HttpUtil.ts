import http from '@ohos.net.http'
import WanResponse from './WanResponse'
import Logger from '../utils/Logger';
import UserDataCenter from '../UserDataCenter';

async function _http<T>(url: string, method: http.RequestMethod, params: object|string, headers: object = {}): Promise<WanResponse<T>> {
  let httpRequest = http.createHttp()
  let token = UserDataCenter.getCookie()
  headers['Cookie'] = token;
  Logger.info('request token:' + token);
  Logger.info('request method:' + method);
  Logger.info('request params:' + JSON.stringify(params));
  let startTime = Date.now()
  return httpRequest.request(url, {
    method: method,
    header: headers,
    readTimeout: 20000,
    connectTimeout: 20000,
    extraData: params,
    expectDataType: http.HttpDataType.STRING,
  }).then((response) => {
    // data.result为HTTP响应内容，可根据业务需要进行解析
    Logger.info('cost time:' + (Date.now() - startTime) + 'ms')
    Logger.info('Result:' + JSON.stringify(response.result));
    Logger.info('code:' + JSON.stringify(response.responseCode));
    // data.header为HTTP响应头，可根据业务需要进行解析
    Logger.info('header:' + JSON.stringify(response.header));
    Logger.info('cookies:' + JSON.stringify(response.cookies)); // 8+
    if (response.responseCode === http.ResponseCode.OK) {
      // 不能直接 JSON.parse(response.result)， 不然不能调用 WanResponse 中的方法， 会报 TypeError: is not callable
      // @ts-ignore
      let res: WanResponse<any> = JSON.parse(response.result)
      if (res.errorCode === 0) {
        if (url.includes('/user/login')) {
          saveLoginCookie(response, params)
        }
        return WanResponse.success(res.data)
      }else {
        return WanResponse.error(res.errorCode, res.errorMsg)
      }
    } else {
      return WanResponse.error(response.responseCode, "")
    }
  }).catch((error) => {
    Logger.error('error:' + JSON.stringify(error));
    return WanResponse.error(-1, JSON.stringify(error))
  })
}

//这是转义函数
function JSON_to_URLEncoded(params: object){
  var list = [];
  for (var idx in params) {
    list.push(idx+'='+encodeURIComponent(params[idx]));
  }
  return list.join('&');
}

function saveLoginCookie(response: http.HttpResponse, params: string|object) {
  Logger.debug('saveLoginCookie params: ' + JSON.stringify(params))
  let token = ''

  const str = params as string;
  const regex = /username=([^&]*)/;
  const match = str.match(regex);
  if (match) {
    const username = match[1];
    token += `loginUserName_wanandroid_com=${username};`
  } else {
    Logger.error('未找到匹配');
  }

  let cookie = response.header['set-cookie'] as string
  let array = cookie.split(';')
  for (const element of array) {
    if (element.includes('token_pass_wanandroid_com')) {
      token += element
    }
  }
  UserDataCenter.putCookie(token)
}

export async function httpGet<T>(url: string, params: object = {}): Promise<WanResponse<T>> {
  return _http(url, http.RequestMethod.GET, params)
}

export async function httpPost<T>(url: string, params: object = {}): Promise<WanResponse<T>> {
  return _http(url, http.RequestMethod.POST, JSON_to_URLEncoded(params), {
    'Content-Type': 'application/x-www-form-urlencoded'
  })
}

