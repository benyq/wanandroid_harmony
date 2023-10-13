import http from '@ohos.net.http'
import WanResponse from './WanResponse'

async function _http<T>(url: string, method: http.RequestMethod, params: object|string, headers: object = null): Promise<WanResponse<T>> {
  let httpRequest = http.createHttp()
  console.info('request method:' + method);
  console.info('request params:' + JSON.stringify(params));
  let startTime = Date.now()
  return httpRequest.request(url, {
    method: method,
    header: headers,
    readTimeout: 20000,
    connectTimeout: 20000,
    extraData: params,
    expectDataType: http.HttpDataType.STRING
  }).then((response) => {
    // data.result为HTTP响应内容，可根据业务需要进行解析
    console.info('cost time:' + (Date.now() - startTime) + 'ms');
    console.info('Result:' + JSON.stringify(response.result));
    console.info('code:' + JSON.stringify(response.responseCode));
    // data.header为HTTP响应头，可根据业务需要进行解析
    console.info('header:' + JSON.stringify(response.header));
    console.info('cookies:' + JSON.stringify(response.cookies)); // 8+
    if (response.responseCode === http.ResponseCode.OK) {
      // @ts-ignore
      return JSON.parse(response.result)
    } else {
      return WanResponse.error(response.responseCode, "")
    }
  }).catch((error) => {
    console.info('error:' + JSON.stringify(error));
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


export async function httpGet<T>(url: string, params: object = {}): Promise<WanResponse<T>> {
  return _http(url, http.RequestMethod.GET, params)
}

export async function httpPost<T>(url: string, params: object = {}): Promise<WanResponse<T>> {
  return _http(url, http.RequestMethod.POST, JSON_to_URLEncoded(params), {
    'Content-Type': 'application/x-www-form-urlencoded'
  })
}

