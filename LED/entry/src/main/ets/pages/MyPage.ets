import CCPreference, { LEDTextItem } from '../Common/CCPreference'
import { router, promptAction } from '@kit.ArkUI'

@Entry
@Component
struct MyPage {

  @State currentIndex: number = 0
  @State list: Array<LEDTextItem> = []

  async aboutToAppear() {
    await this.loadData()
  }

  toggleTab(index: number) {
    this.currentIndex = index
    this.loadData()
  }

  async loadData() {
    if (this.currentIndex === 0) {
      this.list = (await CCPreference.ledHistory()).reverse()
    } else {
      this.list = (await CCPreference.ledHistory()).filter(item => item.collection === 1).reverse()
    }
  }

  async toggleCollection(item: LEDTextItem) {
    let all = await CCPreference.ledHistory()
    let target = all.find(i => i.time === item.time)
    if (target) {
      target.collection = target.collection === 1 ? 0 : 1
    }

    await CCPreference.ledSaveHistory(all)
    this.loadData()
  }

  async deleteItem(item: LEDTextItem) {
    const lastText = await CCPreference.getLastText()
    if (lastText === item.text) {
      await CCPreference.saveLastText('清甜多汁的橘子，1.9元一斤！！！清甜多汁的橘子，1.9元一斤！！！')
    }

    let all = await CCPreference.ledHistory()
    all = all.filter(i => i.time !== item.time)
    await CCPreference.ledSaveHistory(all)
    this.loadData()
  }

  async useItem(item: LEDTextItem) {
    await CCPreference.saveLastText(item.text)
    promptAction.showToast({ message: '已使用该字幕', duration: 1500 })
    router.back()
  }

  build() {
    Column() {
      Navigation() {
        Column() {
          Row() {
            Button('历史')
              .onClick(() => this.toggleTab(0))
              .backgroundColor(this.currentIndex === 0 ? '#FF9900' : '#E8E8E8')
              .fontColor(this.currentIndex === 0 ? '#FFFFFF' : '#666666')
              .fontSize(15)
              .borderRadius(6)
              .padding({ top: 8, bottom: 8, left: 24, right: 24 })

            Blank(12)

            Button('收藏')
              .onClick(() => this.toggleTab(1))
              .backgroundColor(this.currentIndex === 1 ? '#FF9900' : '#E8E8E8')
              .fontColor(this.currentIndex === 1 ? '#FFFFFF' : '#666666')
              .fontSize(15)
              .borderRadius(6)
              .padding({ top: 8, bottom: 8, left: 24, right: 24 })
          }
          .width('100%')

          if (this.list.length === 0) {
            Column() {
              Text('暂无数据')
                .fontSize(16)
                .fontColor('#999')
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
          } else {
            List() {
              ForEach(this.list, (item: LEDTextItem) => {
                ListItem() {
                  Column() {
                    Row() {
                      Text(item.timeStr)
                        .fontSize(12)
                        .fontColor('#999')
                        .layoutWeight(1)

                      Text(item.collection === 1 ? '已收藏' : '收藏')
                        .fontSize(14)
                        .fontColor(item.collection === 1 ? '#FFFFFF' : '#666666')
                        .backgroundColor(item.collection === 1 ? '#FF9900' : '#F5F5F5')
                        .borderRadius(4)
                        .padding({ top: 4, bottom: 4, left: 10, right: 10 })
                        .onClick(() => this.toggleCollection(item))

                      if (this.currentIndex === 0) {
                        Blank(4)

                        Text('删除')
                          .fontSize(13)
                          .fontColor('#FF4444')
                          .backgroundColor('#FFF0F0')
                          .borderRadius(4)
                          .padding({ top: 4, bottom: 4, left: 10, right: 10 })
                          .onClick(() => this.deleteItem(item))
                      }
                    }
                    .width('100%')

                    Text(item.text)
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)
                      .lineHeight(28)
                      .textAlign(TextAlign.Start)
                      .width('100%')
                      .margin({ top: 10 })
                      .fontColor('#000000')
                      .onClick(() => this.useItem(item))
                  }
                  .backgroundColor('#FFFFFF')
                  .borderRadius(12)
                  .padding(16)
                  .margin({ bottom: 10 })
                }
              }, (item: LEDTextItem) => item.time + '-' + item.collection)
            }
            .width('100%')
            .backgroundColor('#F4F4F7')
            .margin({ top: 8 })
          }
        }
        .padding(16)
        .width('100%')
        .height('100%')
        .backgroundColor('#F4F4F7')
      }
      .title("历史")
      .mode(NavigationMode.Stack)
      .titleMode(NavigationTitleMode.Mini)
      .hideBackButton(false)
      .backgroundColor('0xf4f4f7')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F4F4F7')
  }
}
