
export default class WanResponse<T>{
  data: T
  errorCode: number
  errorMsg: string

  constructor(data: T, errorCode: number, errorMsg: string) {
    this.data = data
    this.errorCode = errorCode
    this.errorMsg = errorMsg
  }

  static success<T>(data: T): WanResponse<T> {
    return new WanResponse(data, 0, "")
  }

  static error<T>(code: number, message: string): WanResponse<T> {
    return new WanResponse(null, code, message)
  }
}