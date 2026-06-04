import CCPreference, { LEDTextItem } from '../Common/CCPreference'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct NewLEDPage {

  @State text: string = ''
  maxCount: number = 100

  build() {
    Column() {

      Navigation() {

        Column() {

          // 输入框
          TextArea({
            text: this.text,
            placeholder: '请输入灯牌文字...'
          })
            .onChange((value: string) => {
              if (value.length > this.maxCount) {
                this.text = value.substring(0, this.maxCount)
              } else {
                this.text = value
              }
            })
            .height(200)
            .width('100%')
            .margin({ top: 20 })

          // 字数统计（
          Row() {
            Blank()
            Text(`${this.text.length}/${this.maxCount}`)
              .fontSize(12)
              .fontColor('#999')
          }
          .width('100%')
          .margin({ top: 5 })

          // 确认按钮
          Button('确认')
            .margin({ top: 40 })
            .backgroundColor('#4A90E2')
            .borderRadius(4)
            .fontColor(Color.White)
            .width('100%')
            .onClick(async () => {
              await this.saveAndBack()
            })





        }.padding(20)
        .width('100%')
        .height('100%')



      }
      .title("新增")
      .mode(NavigationMode.Stack)
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(false)
      //.menus(this.NavigationMenus())
      .backgroundColor('0xf4f4f7')





    }
    .width('100%')
    .height('100%')
  }

  async saveAndBack() {
    if (!this.text || this.text.trim().length === 0) {
      return
    }

    // 取历史
    let historys: Array<LEDTextItem> = await CCPreference.getList('LED_History')

    // 创建新数据
    let m: LEDTextItem = CCPreference.createLEDItem(this.text)
    historys = historys.concat([m])

    // 保存
    await CCPreference.ledSaveHistory(historys)

    // 保存为最后使用的文字
    await CCPreference.saveLastText(this.text)

    // 返回
    router.back(1, { newText: this.text })
  }
}