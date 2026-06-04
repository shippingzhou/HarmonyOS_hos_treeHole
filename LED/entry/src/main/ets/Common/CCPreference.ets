

import { preferences } from '@kit.ArkData'
import Logger from './Logger'
import Utils from './CCUtils'

let preference: preferences.Preferences | null = null
const preferencesName = 'CCPreferences.db'

const LED_History = 'LED_History'
const LED_Mark = 'LED_Mark'
const LAST_TEXT = 'LAST_TEXT'

export interface LEDTextItem {
  text: string
  time: number
  timeStr: string
  collection: number
}

export class CCPreference {

  // ✅ 统一初始化入口（关键）
  private async init() {
    if (preference) return

    try {
      preference = await preferences.getPreferences(getContext(), preferencesName)
    } catch (err) {
      Logger.error(`init preferences failed: ${err}`)
    }
  }

  // ================== 基础存储 ==================

  public async writeData(key: string, value: string) {
    if (Utils.isEmpty(key)) return

    await this.init()

    try {
      await preference!.put(key, value)
      await preference!.flush()
    } catch (err) {
      Logger.error(`put error: ${err}`)
    }
  }

  public async getData(key: string): Promise<string> {
    if (Utils.isEmpty(key)) return ''

    await this.init()

    try {
      return (await preference!.get(key, '')).toString()
    } catch (err) {
      Logger.error(`get error: ${err}`)
      return ''
    }
  }

  // ================== 列表封装（重点修复） ==================

  public async getList(key: string): Promise<Array<LEDTextItem>> {
    await this.init()

    try {
      let str = await preference!.get(key, '[]') as string

      if (!str) return []

      return JSON.parse(str)
    } catch (e) {
      Logger.error('getList error: ' + e)
      return []
    }
  }

  public async saveList(key: string, list: Array<LEDTextItem>): Promise<void> {
    await this.init()

    try {
      await preference!.put(key, JSON.stringify(list))
      await preference!.flush()
    } catch (e) {
      Logger.error('saveList error: ' + e)
    }
  }

  // ================== 业务封装 ==================

  public async ledHistory(): Promise<Array<LEDTextItem>> {
    return await this.getList(LED_History)
  }

  public async ledSaveHistory(list: Array<LEDTextItem>): Promise<void> {
    await this.saveList(LED_History, list)   // ✅ 必须 await
  }

  public async ledMark(): Promise<Array<LEDTextItem>> {
    return await this.getList(LED_Mark)
  }

  public async ledSaveMark(list: Array<LEDTextItem>): Promise<void> {
    await this.saveList(LED_Mark, list)
  }

  // ================== 最后使用的文字 ==================

  public async saveLastText(text: string) {
    await this.writeData(LAST_TEXT, text)
  }

  public async getLastText(): Promise<string> {
    return await this.getData(LAST_TEXT)
  }

  // ================== 数据创建 ==================

  public createLEDItem(text: string, time?: number): LEDTextItem {
    const t = time ?? Date.now()

    return {
      text: text,
      time: t,
      timeStr: this.formatTime(t),
      collection: 0
    }
  }

  public formatTime(time: number): string {
    try {
      const date = new Date(time)
      if (isNaN(date.getTime())) return ''

      const Y = date.getFullYear()
      const M = (date.getMonth() + 1).toString().padStart(2, '0')
      const D = date.getDate().toString().padStart(2, '0')

      const h = date.getHours().toString().padStart(2, '0')
      const m = date.getMinutes().toString().padStart(2, '0')
      const s = date.getSeconds().toString().padStart(2, '0')

      return `${Y}-${M}-${D} ${h}:${m}:${s}`
    } catch {
      return ''
    }
  }
}

export default new CCPreference()