import router from '@ohos.router'
// import { StorageUtil } from '../utils/StorageUtil'

import { hilog } from '@kit.PerformanceAnalysisKit'
import { ComponentContent } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import { media } from '@kit.MediaKit'
import CCPreference from '../Common/CCPreference'

class ATextItem {
  text: string = '';
  des: string = '';

  constructor(text: string,des?: string) {
    this.text = text;
    if (des != null){
      this.des = des;
    }

  }
}

class AListModel {
  list: Array<object> = [];
  currenIndex: number = -1;
  onItemSelected: (index: number) => void

  constructor(list: Array<ATextItem>,currenIndex: number,onItemSelected: (index: number) => void) {
    this.list = list;
    this.currenIndex = currenIndex
    this.onItemSelected = onItemSelected
  }
}



@Entry
@Component
struct Index {
  @State text: string = '清甜多汁的橘子，1.9元一斤！！！清甜多汁的橘子，1.9元一斤！！！'
  @State isVertical: boolean = false
  @State marqueeKey: number = 0
  @State screenWidth: number = 360  // 写死屏幕宽度
  @State screenHeight: number = 780  // 写死屏幕高度

  @State controlOpacity: number = 1.0
  @State showPrivacyDialog: boolean = false
  @State showFullPrivacy: boolean = false
  // 当前打开类型
  @State panelType: number = 0  //0 fontSize /1 fontColor /2 bgColor /3 speed

  // 当前选中
  @State fontSizeIndex: number = 2
  @State fontSize: number = 100  // 初始字号

  @State fontColorIndex: number = 0
  @State fontColor: string = "#FFFFFF"  // 初始字色

  @State bgColorIndex: number = 0
  @State bgColor: string = "#000000"  // 初始背景色

  @State speedIndex: number = 3
  @State speed: number = 6  // 初始滚动速度

  @State fontSizes: Array<ATextItem> = [
    new ATextItem("50"),
    new ATextItem("80"),
    new ATextItem("100"),
    new ATextItem("120"),
    new ATextItem("150"),
    new ATextItem("200"),
    new ATextItem("250")
  ]
  @State speeds: Array<ATextItem> = [
    new ATextItem("2"),
    new ATextItem("4"),
    new ATextItem("6"),
    new ATextItem("8"),
    new ATextItem("10"),
    new ATextItem("12"),
    new ATextItem("14"),
    new ATextItem("16")
  ]
  @State fontColors: Array<ATextItem> = [
    new ATextItem("黑色","#000000"),
    new ATextItem("红色","#FF0000"),
    new ATextItem("绿色","#00FF00"),
    new ATextItem("蓝色","#0000FF"),
    new ATextItem("橙色","#FFA500"),
    new ATextItem("紫色","#800080"),
    new ATextItem("深天蓝","#00CED1"),
    new ATextItem("金色","#FFD700")
  ]
  @State bgColors: Array<ATextItem> = [
    new ATextItem("白色","#FFFFFF"),
    new ATextItem("黑色","#000000"),
    new ATextItem("灰色","#808080"),
    new ATextItem("银灰色","#C0C0C0"),
    new ATextItem("浅粉色","#FFB6C1"),
    new ATextItem("浅绿色","#90EE90"),
    new ATextItem("天蓝色","#87CEFA"),
    new ATextItem("浅橙色","#FFA07A")
  ]

  @State bgmFiles: Array<ATextItem> = [
    new ATextItem("欢快之夜", "alexzavesa-dance-playful-night-510786.mp3"),
    new ATextItem("夏日之夜", "bransboynd-night-summer-lounge-473222.mp3"),
    new ATextItem("时尚节拍", "fassounds-escape-your-love-upbeat-fashion-pop-dance-412230.mp3"),
    new ATextItem("愉快旋律", "kornevmusic-upbeat-happy-corporate-487426.mp3")
  ]
  @State bgmIndex: number = -1
  @State isPlaying: boolean = false
  avPlayer: media.AVPlayer | null = null

  onItemSelected = (index: number) => {
    hilog.info(0xFF00, 'TAG', 'openBindSheet success:' + index);

    if (this.panelType == 0){
      this.fontSizeIndex = index
      this.fontSize = Number(this.fontSizes[index].text)
      this.marqueeKey++
      CCPreference.writeData('FONT_SIZE', index.toString())
    } else if (this.panelType == 1){
      this.fontColorIndex = index
      this.fontColor = this.fontColors[index].des
      this.marqueeKey++
      CCPreference.writeData('FONT_COLOR', index.toString())
    } else if (this.panelType == 2){
      this.bgColorIndex = index
      this.bgColor = this.bgColors[index].des
      CCPreference.writeData('BG_COLOR', index.toString())
    } else if (this.panelType == 3){
      this.speedIndex = index
      this.speed = Number(this.speeds[index].text)
      this.marqueeKey++
      CCPreference.writeData('SPEED', index.toString())
    }
  };

  async showWindow(title:string, list: Array<ATextItem> ,cIndex:number){




    let contentNode: ComponentContent<AListModel> = new ComponentContent(this.getUIContext(), wrapBuilder(buildActionList),new AListModel(list,cIndex,
      (index: number) => {
        this.onItemSelected(index)
        contentNode.update(new AListModel(list, index, this.onItemSelected))
      }));
    let uiContext = this.getUIContext();
    let uniqueId = this.getUniqueId();
    let frameNode: FrameNode | null = uiContext.getFrameNodeByUniqueId(uniqueId);
    let targetId = frameNode?.getFirstChild()?.getUniqueId();

    uiContext.openBindSheet(contentNode, {
      title: { title: title },
      height: SheetSize.MEDIUM,
      backgroundColor: '#F1F3F5',
      preferType: SheetType.BOTTOM
    }, targetId)
      .then(() => {
        hilog.info(0xFF00, 'TAG',title + 'openBindSheet success');

      })
      .catch((err: BusinessError) => {
        hilog.info(0xFF00, 'TAG',title + 'openBindSheet error: ' + err.code + ' ' + err.message);

      })

  }

  showControls() {
    animateTo({ duration: 300, curve: Curve.FastOutSlowIn }, () => {
      this.controlOpacity = 1.0
    })
    setTimeout(() => {
      animateTo({ duration: 1000, curve: Curve.FastOutSlowIn }, () => {
        this.controlOpacity = 0.0
      })
    }, 5000)
  }
  toggle() {
    this.isVertical = !this.isVertical
    if (!this.isVertical && this.fontSize < 80) {
      this.fontSizeIndex = 1
      this.fontSize = 80
    }
    this.marqueeKey++
  }

  async restoreSettings() {
    const fontSize = await CCPreference.getData('FONT_SIZE')
    if (fontSize) {
      const idx = parseInt(fontSize)
      this.fontSizeIndex = idx
      this.fontSize = Number(this.fontSizes[idx].text)
    }
    const fontColor = await CCPreference.getData('FONT_COLOR')
    if (fontColor) {
      const idx = parseInt(fontColor)
      this.fontColorIndex = idx
      this.fontColor = this.fontColors[idx].des
    }
    const bgColor = await CCPreference.getData('BG_COLOR')
    if (bgColor) {
      const idx = parseInt(bgColor)
      this.bgColorIndex = idx
      this.bgColor = this.bgColors[idx].des
    }
    const speed = await CCPreference.getData('SPEED')
    if (speed) {
      const idx = parseInt(speed)
      this.speedIndex = idx
      this.speed = Number(this.speeds[idx].text)
    }
  }

  async checkPrivacy() {
    const agreed = await CCPreference.getData('PRIVACY_AGREED')
    if (agreed) return
    this.showPrivacyDialog = true
  }

  async onPageShow() {
    await this.checkPrivacy()
    await this.restoreSettings()
    const params = router.getParams() as Record<string, Object>
    if (params && params['newText']) {
      this.text = params['newText'] as string
      this.marqueeKey++
    } else {
      const saved = await CCPreference.getLastText()
      if (saved) {
        this.text = saved
        this.marqueeKey++
      }
    }
    this.controlOpacity = 1.0
    this.showControls()
  }



  marqueeSrc(): string {
    const charWidth = this.fontSize * 0.6
    const textWidth = this.text.length * charWidth
    const targetWidth = this.screenWidth * 2
    if (textWidth < targetWidth) {
      const padChars = Math.ceil((targetWidth - textWidth) / charWidth)
      const leftPad = Math.ceil(padChars / 2)
      const rightPad = Math.floor(padChars / 2)
      return '\u3000'.repeat(leftPad) + this.text + '\u3000'.repeat(rightPad)
    }
    return this.text
  }

  showMusicMenu() {
    let musicList: Array<ATextItem> = [
      new ATextItem("关闭音乐", ""),
      new ATextItem("欢快之夜", "alexzavesa-dance-playful-night-510786.mp3"),
      new ATextItem("夏日之夜", "bransboynd-night-summer-lounge-473222.mp3"),
      new ATextItem("时尚节拍", "fassounds-escape-your-love-upbeat-fashion-pop-dance-412230.mp3"),
      new ATextItem("愉快旋律", "kornevmusic-upbeat-happy-corporate-487426.mp3")
    ]
    let contentNode: ComponentContent<AListModel> = new ComponentContent(this.getUIContext(), wrapBuilder(buildActionList), new AListModel(musicList, this.bgmIndex + 1,
      (index: number) => {
        if (index === 0) {
          this.stopBgm()
        } else {
          this.playBgm(index - 1)
        }
        contentNode.update(new AListModel(musicList, index, this.onItemSelected))
      }))
    let uiContext = this.getUIContext()
    let uniqueId = this.getUniqueId()
    let frameNode: FrameNode | null = uiContext.getFrameNodeByUniqueId(uniqueId)
    let targetId = frameNode?.getFirstChild()?.getUniqueId()
    uiContext.openBindSheet(contentNode, {
      title: { title: "选择背景音乐" },
      height: SheetSize.MEDIUM,
      backgroundColor: '#F1F3F5',
      preferType: SheetType.BOTTOM
    }, targetId)
  }

  async playBgm(index: number) {
    if (this.avPlayer) {
      await this.avPlayer.release()
      this.avPlayer = null
    }
    try {
      let player = await media.createAVPlayer()
      player.on('stateChange', async (state: media.AVPlayerState) => {
        if (state === 'initialized') {
          player.prepare()
        } else if (state === 'prepared') {
          player.play()
          this.avPlayer = player
          this.bgmIndex = index
          this.isPlaying = true
        } else if (state === 'completed') {
          player.seek(0)
          setTimeout(() => {
            player.play()
          }, 100)
        }
      })
      let mgr = getContext().resourceManager
      let rawFd = await mgr.getRawFileDescriptor(this.bgmFiles[index].des)
      player.fdSrc = rawFd
    } catch (err) {
      // 播放失败，静默处理
    }
  }

  async stopBgm() {
    if (this.avPlayer) {
      await this.avPlayer.release()
      this.avPlayer = null
    }
    this.bgmIndex = -1
    this.isPlaying = false
  }

  onPageHide() {
    if (this.isPlaying) {
      this.stopBgm()
    }
  }

  showFontSizeMenu() {
    this.panelType = 0
    this.showWindow("请选择字号",this.fontSizes,this.fontSizeIndex)
  }
  showFontColorMenu() {
    this.panelType = 1
    this.showWindow("请选择字体颜色",this.fontColors,this.fontColorIndex)
  }
  showBGColorMenu() {
    this.panelType = 2
    this.showWindow("请选择背景颜色",this.bgColors,this.bgColorIndex)
  }
  showSpeedMenu() {
    this.panelType = 3
    this.showWindow("请选择滚动速度",this.speeds,this.speedIndex)
  }


  build() {
    Stack() {
      Column() {
        Row(){
        Button('新字幕灯牌')
          .backgroundColor('#FF9900')
          .fontColor('#FFFFFF')
          .fontSize(16)
          .borderRadius(20)
          .padding({ top: 10, bottom: 10, left: 24, right: 24 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/NewLEDPage',
            })
          })
        Blank(2)
        Button('历史')
          .backgroundColor('#FFFFFF')
          .fontColor('#FF9900')
          .fontSize(16)
          .borderRadius(20)
          .border({ width: 1.5, color: '#FF9900' })
          .padding({ top: 10, bottom: 10, left: 24, right: 24 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/MyPage',
            })
          })
        Blank(2)
        Button('隐私协议')
          .backgroundColor('#FFFFFF')
          .fontColor('#666666')
          .fontSize(14)
          .borderRadius(16)
          .border({ width: 1, color: '#CCCCCC' })
          .padding({ top: 8, bottom: 8, left: 14, right: 14 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/PrivacyPage',
            })
          })
        Blank(2)
        Button(this.isPlaying ? '🔊' : '🔇')
          .backgroundColor('#FFFFFF')
          .fontColor('#FF9900')
          .fontSize(18)
          .borderRadius(20)
          .width(40)
          .height(40)
          .padding(0)
          .border({ width: 1.5, color: '#FF9900' })
          .onClick(() => {
            if (this.isPlaying) {
              this.stopBgm()
            } else {
              this.showMusicMenu()
            }
          })

      }
      .opacity(this.controlOpacity)
      .width('100%')
      .padding({ top: 8, bottom: 8, left: 16, right: 16 })
      // 切换按钮
      Row(){
        Button(this.isVertical ? '切横向' : '切竖向')
          .backgroundColor('#F5F5F5')
          .fontColor('#333333')
          .fontSize(14)
          .borderRadius(16)
          .padding({ top: 6, bottom: 6, left: 14, right: 14 })
          .onClick(() => this.toggle())

        // 功能按钮，点击后显示控制面板
        Blank(2)
        Button('字号')
          .backgroundColor('#F5F5F5')
          .fontColor('#333333')
          .fontSize(14)
          .borderRadius(16)
          .padding({ top: 6, bottom: 6, left: 14, right: 14 })
          .onClick(() => this.showFontSizeMenu())
        Blank(2)
        Button('字色')
          .backgroundColor('#F5F5F5')
          .fontColor('#333333')
          .fontSize(14)
          .borderRadius(16)
          .padding({ top: 6, bottom: 6, left: 14, right: 14 })
          .onClick(() => this.showFontColorMenu())
        Blank(2)
        Button('背景色')
          .backgroundColor('#F5F5F5')
          .fontColor('#333333')
          .fontSize(14)
          .borderRadius(16)
          .padding({ top: 6, bottom: 6, left: 14, right: 14 })
          .onClick(() => this.showBGColorMenu())
        Blank(2)
        Button('速度')
          .backgroundColor('#F5F5F5')
          .fontColor('#333333')
          .fontSize(14)
          .borderRadius(16)
          .padding({ top: 6, bottom: 6, left: 14, right: 14 })
          .onClick(() => this.showSpeedMenu())
      }.justifyContent(FlexAlign.Center)
      .opacity(this.controlOpacity)
      .width('100%')
      .borderRadius(8)
      .shadow({
        radius: 8,
        color: '#55000000',
        offsetX: 0,
        offsetY: 6
      })
      .padding({ top: 8, bottom: 8 })
      .margin(8)



      // 滚动容器（这里设置为全屏）
      Stack() {
        Marquee({
          start: true,
          step: this.speed, // 控制滚动的速度
          loop: -1, // 无限循环
          fromStart: true,
          src: this.marqueeSrc()
        })
          .key(this.marqueeKey + "")
          .fontSize(this.fontSize)
          .fontColor(this.fontColor)

          // 横向或竖向滚动控制
          .rotate({
            angle: this.isVertical ? 90 : 0
          })

          // 确保横向滚动能超出屏幕
          .width(this.isVertical ? this.screenHeight : this.screenWidth * 2) // 横向滚动时设置更宽的宽度
          .height(this.isVertical ? this.screenWidth : this.screenHeight) // 竖向滚动时按屏幕高度设置
      }
      .alignContent(this.isVertical ? Alignment.Center : Alignment.Start)
      .width('100%')
      .height('100%')

    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor(this.bgColor)
    .onClick(() => {
      this.showControls()
    })

    if (this.showPrivacyDialog) {
      Column() {
        Scroll() {
          Column() {
            Text('隐私政策')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ bottom: 16 })

            Text('本应用不会收集您的任何个人信息，所有数据仅存储在您的设备本地。')
              .fontSize(15)
              .fontColor('#666666')
              .lineHeight(22)
              .width('100%')
              .textAlign(TextAlign.Start)

            Text('查看完整隐私政策 ›')
              .fontSize(15)
              .fontColor('#FF9900')
              .fontWeight(FontWeight.Medium)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ top: 12, bottom: 12 })
              .onClick(() => {
                this.showFullPrivacy = !this.showFullPrivacy
              })

            if (this.showFullPrivacy) {
              Text('字幕灯牌LED - 隐私政策\n\n' +
                '最后更新日期：2026 年 5 月 27 日\n\n' +
                '感谢您使用「LED 弹幕灯牌」（以下简称"本应用"）。我们非常重视您的隐私。本隐私政策旨在向您说明本应用如何收集、使用和保护您的信息。\n\n' +
                '1. 信息收集\n' +
                '本应用不收集任何个人信息。具体说明如下：\n\n' +
                '无需注册登录：您无需提供任何个人账户信息即可使用本应用的全部功能。\n' +
                '不收集设备信息：本应用不会收集您的设备型号、操作系统版本、唯一设备标识符（如 IMEI、OAID）等信息。\n' +
                '不收集位置信息：本应用不会获取或使用您的地理位置。\n' +
                '不收集使用数据：本应用不会跟踪您的使用行为、操作记录或使用习惯。\n\n' +
                '2. 权限说明\n' +
                '本应用不申请任何敏感权限。正常运行所需的权限仅限于本地数据存储，用于保存您的灯牌文字记录和应用设置偏好（如字体大小、颜色、滚动速度等）。所有数据仅存储在您的设备本地，不会上传至任何服务器。\n\n' +
                '3. 第三方服务\n' +
                '本应用不集成任何第三方分析工具、广告SDK或社交分享SDK，不会向任何第三方传输您的数据。\n\n' +
                '4. 数据安全\n' +
                '由于本应用不收集任何个人信息，因此不存在个人信息泄露的风险。本地存储的数据仅您本人可访问。\n\n' +
                '5. 儿童隐私\n' +
                '本应用不收集任何年龄用户的信息，包括 14 周岁以下的儿童。\n\n' +
                '6. 隐私政策更新\n' +
                '如本隐私政策发生变更，我们会在本页面更新"最后更新日期"。变更后的隐私政策自发布之日起生效。\n\n' +
                '7. 联系我们\n' +
                '如您对本隐私政策有任何疑问，请联系我们。\n\n邮箱：121819555@qq.com')
                .fontSize(14)
                .fontColor('#333333')
                .lineHeight(24)
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({ bottom: 16 })
            }

            Row() {
              Button('拒绝')
                .backgroundColor('#E8E8E8')
                .fontColor('#666666')
                .fontSize(16)
                .borderRadius(8)
                .height(44)
                .layoutWeight(1)
                .onClick(() => {
                  (getContext() as common.UIAbilityContext).terminateSelf()
                })

              Blank(12)

              Button('我同意')
                .backgroundColor('#FF9900')
                .fontColor('#FFFFFF')
                .fontSize(16)
                .borderRadius(8)
                .height(44)
                .layoutWeight(1)
                .onClick(() => {
                  CCPreference.writeData('PRIVACY_AGREED', '1')
                  this.showPrivacyDialog = false
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
          }
          .width('100%')
          .padding(24)
        }
        .width('85%')
        .constraintSize({ maxHeight: '70%' })
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .padding(0)
        .scrollBar(BarState.Off)
        .shadow({ radius: 16, color: '#55000000', offsetY: 8 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#88000000')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .hitTestBehavior(HitTestMode.Transparent)
    }
  }

}

}

@Builder
function buildActionList(model: AListModel) {
  Column() {
    List() {
      ListItemGroup() {
        ForEach(model.list, (item: ATextItem, index: number) => {
          ListItem() {
            Row() {

              // 如果 item.des 是一个颜色值（以 # 开头），则添加一个颜色方块
              if (item.des.startsWith('#')) {
                Column() {
                  Row()
                    .width(30)
                    .height(30)
                    .backgroundColor(item.des)  // 设置背景色
                    .border({ color: Color.Gray, width: 1 })  // 设置边框
                }
              }

              Text(item.text).fontSize(16).textAlign(TextAlign.Center)
                .fontColor(model.currenIndex === index ? '#FFA500' : Color.Gray).width('100%')

            }
            .width('100%')
            .height(50)
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {

              if (model.onItemSelected){
                model.onItemSelected(index)
              }
            })
          }

        }, (item: ATextItem) => JSON.stringify(item))
      }
      .divider({ strokeWidth: 1, color: '#F8F8FF' })
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height('auto')
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 8
    })
    .borderRadius(16)
  }
  .padding(16)
  .width('100%')
}
