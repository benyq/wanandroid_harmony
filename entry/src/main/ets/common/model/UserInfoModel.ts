export default class UserInfoModel {
  constructor(readonly coinInfo: CoinInfo, readonly userInfo: UserInfo) {
    this.coinInfo = coinInfo
    this.userInfo = userInfo
  }
}

class CoinInfo{
  constructor(readonly coinCount:number, readonly level: number, readonly rank: string) {
    this.coinCount = coinCount
    this.level = level
    this.rank = rank
  }
}

class UserInfo{
  constructor(readonly collectIds: string[], readonly username: string) {
    this.username = username
    this.collectIds = collectIds
  }
}