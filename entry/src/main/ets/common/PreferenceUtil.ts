import dataPreferences from '@ohos.data.preferences';
import Logger from './utils/Logger';

const TAG = 'PreferenceUtil'

class PreferenceUtil {

  preference: dataPreferences.Preferences = null;

  constructor() {}

  setPreferences(preference: dataPreferences.Preferences) {
    this.preference = preference;
  }

  async putString(key:string, value: string) {
    try {
      await this.preference.put(key, value)
    } catch (err) {
      Logger.error(TAG, `Failed to put value, Cause: ${err}`);
    }
    await this.preference.flush()
  }

  async getString(key:string) {
    let value = ''
    try {
      value = <string> await this.preference.get(key, '')
    } catch (err) {
      Logger.error(TAG, `Failed to get value, Cause: ${err}`);
    }
    return value
  }

}

export default new PreferenceUtil();